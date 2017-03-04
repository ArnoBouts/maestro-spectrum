#!/bin/bash

spectrum2_manager start
tail -f /var/log/spectrum2/*/* 2>/dev/null
sleep 2
