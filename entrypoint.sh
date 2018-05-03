#!/bin/bash
set -e

# if first start, init conf
sed -i "s/{{DOMAIN}}/${DOMAIN}/1" /etc/spectrum2/transports/hangouts.cfg
sed -i "s/{{DOMAIN}}/${DOMAIN}/1" /etc/spectrum2/transports/facebook.cfg

exec "$@"
