#!/bin/sh
#
# $Id$
#
# Debian package installation tracking - framework
#

. /etc/debtrack.conf

echo "ABPSoft Debian Package Tracker v0.05"
echo ""

if [ ! -d "$BIN" ]; then
 echo "No debtrack directory $BIN - bailing out."
 exit 1
fi

if [ ! -d "$VAR" ]; then
 echo "No debtrack directory $VAR - bailing out."
 exit 1
fi

echo "What debdiff thinks about this system:"
echo "-------------------------------------------------------------------------"

"$BIN/debdiff.sh" || exit

echo "-------------------------------------------------------------------------"
echo -n "Post a report? [Y/n]: "
read yn

if [ -z "$yn" -o "$yn" = "y" -o "$yn" = "Y" ]; then
 echo -n "Maintainer name? [$MAINTAINER]: "
 read mname
 if [ -z "mname" ]; then
  mname="$MAINTAINER"
 fi
 echo -n "Statement? [Regular security update]: "
 read stmt
 if [ -z "$stmt" ]; then
  stmt="Regular security update"
 fi
 echo -n "Mail destination? [$MDST]: "
 read mdst
 if [ -z "$mdst" ]; then
  mdst="$MDST"
 fi
 echo "Posting report from $mname to $mdst..."
 (
  echo "Host: $HOST"
  echo -n "Date: "
  date +"%Y-%m-%d %H:%M:%S"
  echo "Maintainer: $mname"
  echo "Statement: $stmt"
  echo ""
  "$BIN/debdiff.sh"
  if [ -x "$BIN/show-tech-support.sh" ]; then
   "$BIN/show-tech-support.sh"
  fi
 ) | mail -s "debtrack report for $HOST" $mdst
fi

echo -n "Update checkpoint now? [Y/n]: "
read yn

if [ -z "$yn" -o "$yn" = "y" -o "$yn" = "Y" ]; then
 "$BIN/debcheckpoint.sh"
fi
