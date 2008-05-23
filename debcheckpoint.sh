#!/bin/sh
#
# $Id: debcheckpoint.sh,v 1.1 2002/06/27 12:50:28 beck Exp $
#
# Generate a CSV listing of the installed packages
# Create a checkpoint file in $HOME/debtrack/cp
#

d=`date +%Y%m%d%H%M%S`
echo "Creating new packages checkpoint $d"
if [ ! -d $HOME/debtrack/cp ]; then
 mkdir -p $HOME/debtrack/cp
fi

COLUMNS=400 dpkg -l | awk '
p == 1 {printf "%s,%s,%s\n", $1, $2, $3;}
/====/ {p=1;}' > $HOME/debtrack/cp/$d.dcp
