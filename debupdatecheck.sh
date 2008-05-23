#!/bin/sh
#
# $Id$
#
# Silently and automatically
# * Do an apt-get update
# * Collect any packages that would be upgraded
# * Optionally download them
# * Send a mail if there is anything new
#

. /etc/debtrack.conf

LOG="$LIB/debupdchk.$$.log"
UPG="$LIB/debupdchk.$$.dat"

exec > "$LOG" 2>&1

# First update package information
apt-get -qq update

# Now check for upgraded packages
apt-get -qq -s upgrade > "$UPG"

if grep "Inst" "$UPG" > /dev/null ; then
 echo "Upgraded Packages:"
 awk '$1 ~ /Inst/ {printf " %-20s %20s --> %s)\n", $2, $3, $4}' < $UPG

 if [ "$DOWNLOAD" = "yes" ]; then
  echo ""
  echo "Starting background download at `date +'%Y-%m-%d %H:%M:%S'`"
  apt-get -qq -y -d upgrade
  echo "Finished background download at `date +'%Y-%m-%d %H:%M:%S'`"
 fi
fi

# Aything to send?
if [ -s "$LOG" ] ; then
 (
  echo "DebTrack AutoUpdate Notification for $HOST $DATE"
  echo ""
  echo "`grep "Inst" $UPG | wc -l` upgrades pending:"
  echo ""
  cat "$LOG"
  echo ""
 ) | mail -s "NOTIFY: $HOST updates pending" "$MDST"
fi

rm -f "$LOG"
rm -f "$UPG"

exit 0
