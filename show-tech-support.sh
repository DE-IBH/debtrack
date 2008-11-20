#!/bin/bash
#
# $Id$
#
# Addition to debtrack by keil/IBH
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
echo Uptime: `uptime`
echo ""
if [ -x /usr/bin/imvirt ]; then
echo Machine: `/usr/bin/imvirt`
echo ""
fi
if [ -d /proc/bus/pci && -x /usr/bin/lspci ]; then
lspci
echo ""
fi
cat /proc/cpuinfo
cat /proc/meminfo
echo ""
df -k
echo ""
mount
echo ""
