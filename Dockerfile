FROM debian:jessie
# FROM_DIGEST sha256:2ed9cfd2541c103f81ba4ba78c2cf1e2ea69f4ce2bd9886637a5b3506aa4fce9

EXPOSE 5222 8080
VOLUME ["/etc/spectrum2/transports", "/var/lib/spectrum2"]

ENV SPECTRUM_VERSION 9f073ba
ENV TELEGRAM_VERSION b101bbb
ENV HANGOUTS_VERSION message

RUN apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
		ca-certificates \
                cmake \
		curl \
                debhelper \
                git \
		g++ \
                libavahi-client3 \
                libavahi-client-dev \
                libavahi-common-dev \
                libboost-all-dev \
                libcurl3 \
                libcurl4-openssl-dev \
                libdbus-glib-1-2 \
                libdbus-glib-1-dev \
                libevent-2.0-5 \
                libevent-dev \
                libgcrypt20 \
                libgcrypt20-dev \
                libidn11 \
                libidn11-dev \
                libjson-glib-1.0-0 \
                libjson-glib-dev \
                liblog4cxx10 \
                liblog4cxx10-dev \
                libmysqlclient18 \
                libmysqlclient-dev \
                libpopt0 \
                libpopt-dev \
                libpqxx-4.0 \
                libpqxx3-dev \
                libprotobuf-c1 \
                libprotobuf-c-dev \
                libprotobuf9 \
                libprotobuf-dev \
                libpurple0 \
                libpurple-dev \
                libqt4-dev \
                libsqlite3-0 \
                libsqlite3-dev \
                libswiften2 \
                libswiften-dev \
                libwebp5 \
                libwebp-dev \
                libxml2 \
                libxml2-dev \
                mercurial \
                protobuf-c-compiler \
                protobuf-compiler \
                qt5-qmake \
		vim-common \
&& echo "---> Installing libCommuni" \
        && git clone https://github.com/communi/libcommuni.git \
        && cd libcommuni \
        && qmake \
        && make \
        && make install \
	&& cd .. \
	&& rm -rf libcommuni \
&& echo "---> Installing Spectrum 2" \
        && git clone git://github.com/hanzz/spectrum2.git \
        && cd spectrum2 \
        && git checkout ${SPECTRUM_VERSION} \
	&& cmake . -DENABLE_PQXX=Off -DENABLE_DOCS=Off -DCMAKE_BUILD_TYPE=Debug  \
	&& make \
	&& make install \
	&& cd .. \
	&& rm -rf spectrum2 \
&& echo "---> Installing purple-facebook" \
	&& curl -Ls https://github.com/jgeboski/purple-facebook/releases/download/6a0a79182ebc/purple-facebook-6a0a79182ebc.tar.gz | tar -xz \
	&& cd purple-facebook-6a0a79182ebc \
	&& ./configure \
	&& make \
	&& make install \
	&& cd .. \
	&& rm -rf purple-facebook* \
&& echo "---> Installing skype4pidgin" \
	&& git clone git://github.com/EionRobb/skype4pidgin.git \
	&& cd skype4pidgin/skypeweb \
	&& make CFLAGS=-DFEDORA=1 \
	&& make install \
	&& cd ../.. \
	&& rm -rf skype4pidgin \
# RUN apt-get install -y python-pip
# RUN        echo "---> Installing transwhat" && \
#                 pip install --pre e4u protobuf python-dateutil yowsup2 Pillow==2.9.0 &&\
#                 git clone git://github.com/stv0g/transwhat.git &&\
#                 git clone git://github.com/tgalal/yowsup.git &&\
#                 cd transwhat &&\
#                 git worktree add /opt/transwhat &&\
#                 cd .. &&\
#                 cd yowsup &&\
#                 cp -R yowsup /opt/transwhat/yowsup &&\
#                 cd .. &&\
#                 rm -r transwhat &&\
#                 rm -r yowsup &&\
#                 rm -rf /opt/transwhat/.git &&\
#                 rm -rf /opt/transwhat/.gitignore
&& echo "---> Installing Telegram" \
	&& git clone --recursive https://github.com/majn/telegram-purple \
	&& cd telegram-purple \
	&& git checkout ${TELEGRAM_VERSION} \
	&& ./configure \
	&& make \
	&& make install \
	&& cd .. \
	&& rm -rf telegram-purple \
&& echo "---> Installing Hangout" \
	#&& hg clone https://bitbucket.org/EionRobb/purple-hangouts/ \
	&& hg clone https://St0ub@bitbucket.org/St0ub/purple-hangouts \
	&& cd purple-hangouts \
	&& hg update ${HANGOUTS_VERSION} \
	&& make \
	&& make install \
	&& cd .. \
	&& rm -r purple-hangouts \
&& echo "---> Cleaning" \
	&& apt-get purge -y --auto-remove \
		ca-certificates \
                cmake \
                debhelper \
                git \
		g++ \
                libavahi-client-dev \
                libavahi-common-dev \
                libboost-all-dev \
                libcurl4-openssl-dev \
                libdbus-glib-1-dev \
                libevent-dev \
                libgcrypt20-dev \
                libidn11-dev \
                libjson-glib-dev \
                liblog4cxx10-dev \
                libmysqlclient-dev \
                libmysqlclient-dev \
                libpopt-dev \
                libpqxx3-dev \
                libprotobuf-c-dev \
                libprotobuf-dev \
                libpurple-dev \
                libqt4-dev \
                libsqlite3-dev \
                libswiften-dev \
                libwebp-dev \
                libxml2-dev \
                mercurial \
                protobuf-c-compiler \
                protobuf-compiler \
                qt5-qmake \
                vim-common \
	&& rm -rf /var/lib/apt/lists/*

ADD run.sh /bin/run.sh
RUN chmod +x /bin/run.sh

CMD "/bin/run.sh"
