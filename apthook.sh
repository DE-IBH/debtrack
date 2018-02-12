#!/bin/sh

. /etc/debtrack.conf

if [ "$APTHOOK" = "true" ]; then
    /usr/sbin/debtrack
fi
