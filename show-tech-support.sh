#!/bin/bash
#
# $Id: show-tech-support.sh,v 1.2 2007/04/19 08:45:17 beck Exp $
#
# Addition to debtrack by keil/IBH
#
# $Log: show-tech-support.sh,v $
# Revision 1.2  2007/04/19 08:45:17  beck
# Moved initial newline here
#
# Revision 1.1  2007/04/19 08:38:06  beck
# Initial revision
#
# 
#
DATE=`date +"%Y-%m-%d"`
#
echo ""
echo "What's inside this host as of $DATE:"
echo ""
echo Hostname: `hostname -f`
echo ""
echo Kernel: `uname -a`
echo ""
echo Debian Version: `cat /etc/debian_version`
echo ""
lspci
echo ""
cat /proc/cpuinfo
cat /proc/meminfo
echo ""
df -k
echo ""
mount
echo ""
