#!/bin/sh
#
# $Id$
#
# Generate a CSV listing of the installed packages
# Create a checkpoint file in $HOME/debtrack/cp
#

. /etc/debtrack.conf

d=`date +%Y%m%d%H%M%S`
echo "Creating new packages checkpoint $d"

COLUMNS=400 dpkg -l | awk '
p == 1 {printf "%s,%s,%s\n", $1, $2, $3;}
/====/ {p=1;}' > "$VAR/$d.dcp"
