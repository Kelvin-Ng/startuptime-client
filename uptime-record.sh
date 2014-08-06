#!/bin/bash

cat /proc/uptime | cut -d' ' -f1 > /tmp/startuptime_temp
