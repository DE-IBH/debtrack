#!/bin/sh
#
# $Id: debdiff.sh,v 1.1 2002/06/27 12:51:49 beck Exp $
#
# Generate a CSV listing of the installed packages and diff it
# against the latest known checkpoint
#

if [ -d $HOME/debtrack/cp ]; then
 lcp=`ls $HOME/debtrack/cp/*.dcp | tail -1`
fi

if [ -z "$lcp" ]; then
 echo "No previous checkpoint found - bailing out."
 exit 1
fi

d=`date +%Y%m%d%H%M%S`
ld=`basename $lcp .dcp`

echo "Debian package changes as of $d - last checkpoint $ld"
echo ""
 
COLUMNS=400 dpkg -l | gawk -v lcp=$lcp '
p == 1 {
 newstatus[$2] = $1;
 newversion[$2] = $3;
}
/====/ {p=1;}
END {
 # Read the latest checkpoint
 FS = ",";
 while((rc = getline < lcp)) {
  if(rc == -1) {
   exit 1;
  }
  oldstatus[$2] = $1;
  oldversion[$2] = $3;
 }

 # Get all purged
 for(pkg in oldstatus) {
  if(newstatus[pkg] == "") {
   printf "%-32.32s PURGED  (%s)\n", pkg, oldversion[pkg];
  }
 }

 # Get all added
 for(pkg in newstatus) {
  if(oldstatus[pkg] == "") {
   printf "%-32.32s ADDED   (%s)\n", pkg, newversion[pkg];
  }
 }

 # Get all changed
 for(pkg in newstatus) {
  if(oldstatus[pkg] != "" && oldstatus[pkg] != newstatus[pkg] && newstatus[pkg] != "") {
   printf "%-32.32s STATUS  %s --> %s\n", pkg, oldstatus[pkg], newstatus[pkg];
  }
  if(oldversion[pkg] != "" && oldversion[pkg] != newversion[pkg] && newversion[pkg] != "") {
   printf "%-32.32s VERSION %s --> %s\n", pkg, oldversion[pkg], newversion[pkg];
  }
 }
}
'
