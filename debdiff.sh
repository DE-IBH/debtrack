#!/bin/sh
#
# $Id$
#
# Generate a CSV listing of the installed packages and diff it
# against the latest known checkpoint
#

. /etc/debtrack.conf

if [ -d "$VAR" ]; then
 lcp=`ls -1 "$VAR/"*.dcp | sort | tail -1`
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
BEGIN {
 installed = 0;
}
p == 1 {
 newstatus[$2] = $1;
 newversion[$2] = $3;

 if($1 == "ii") {
  installed++;
 }
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
 purged = 0;
 for(pkg in oldstatus) {
  if(newstatus[pkg] == "") {
   purged++;
   printf "%-32.32s PURGED  (%s)\n", pkg, oldversion[pkg];
  }
 }

 # Get all added
 added = 0;
 for(pkg in newstatus) {
  if(oldstatus[pkg] == "") {
   added++;
   printf "%-32.32s ADDED   (%s)\n", pkg, newversion[pkg];
  }
 }

 # Get all changed
 state = 0;
 version = 0;
 for(pkg in newstatus) {
  if(oldstatus[pkg] != "" && oldstatus[pkg] != newstatus[pkg] && newstatus[pkg] != "") {
   state++;
   printf "%-32.32s STATUS  %s --> %s\n", pkg, oldstatus[pkg], newstatus[pkg];
  }
  if(oldversion[pkg] != "" && oldversion[pkg] != newversion[pkg] && newversion[pkg] != "") {
   version++;
   printf "%-32.32s VERSION %s --> %s\n", pkg, oldversion[pkg], newversion[pkg];
  }
 }
 
 printf "\nPackage statistic:\n\t%d installed\n\t%d purged\n\t%d added\n\t%d changed state\n\t%d changed version\n\n", installed, purged, added, state, version;
 
 if (purged == 0 && added == 0 && state == 0 && version == 0)
    exit 255

 exit 0
}
'
