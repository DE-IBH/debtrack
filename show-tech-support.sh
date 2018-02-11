#!/bin/sh

cat << EOH

What's inside this host:

Timestamp: $(date -R)
Uptime   :$(uptime)
Hostname : $(hostname -f)
Debian   : $(cat /etc/debian_version)
Kernel   : $(uname -a)
EOH

if [ -x /usr/bin/imvirt ]; then
    echo "Machine  : $(/usr/bin/imvirt 2> /dev/null)"
fi

echo
echo
echo "# CPU"
cat /proc/cpuinfo

echo
echo "# Memory"
cat /proc/meminfo

if [ -d /proc/bus/pci -a -x /usr/bin/lspci ]; then
    echo
    echo
    echo "# PCI Devices"
    lspci
fi

if [ -d /sys/bus/usb -a -x /usr/bin/lsusb ]; then
    echo
    echo
    echo "# USB Devices"
    lsusb
fi

echo
echo
echo "# Block Devices"
lsblk -fit

echo
echo
echo "# FS Mounts"
mount

echo
echo
echo "# FS Usages"
df -h
