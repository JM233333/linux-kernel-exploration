#!/bin/bash

IMG_INITRAMFS=./initramfs.img

PATH_LINUX_KERNEL=./linux-5.15.57
BZIMAGE=$PATH_LINUX_KERNEL/arch/x86/boot/bzImage

#qemu-system-x86_64 -kernel $BZIMAGE -initrd $IMG_INITRAMFS \
#    -append "earlyprintk=serial,ttyS0 console=ttyS0"

qemu-system-x86_64 -kernel $BZIMAGE -initrd $IMG_INITRAMFS --append "root=/dev/ram init=/init"
