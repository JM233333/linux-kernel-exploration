#!/bin/sh

/bin/echo -e "\nhello, busybox!\n"
 
# /bin/mount -t proc none /proc
# /bin/mount -t sysfs none /sys
# /bin/mount -t debugfs none /sys/kernel/debug
 
/bin/echo -e "\nBoot took $(cut -d' ' -f1 /proc/uptime) seconds\n"
 
/bin/sh
