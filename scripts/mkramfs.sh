#!/bin/bash

DIR_RAMFS=./initramfs-busybox
DIR_BUSYBOX_BIN=./busybox-1.35.0/_install

IMG_INITRAMFS=./initramfs.img

PATH_LINUX_KERNEL=./linux-5.15.57
PATH_SCRIPT_GEN=$PATH_LINUX_KERNEL/usr/gen_initramfs.sh

rm -rf $DIR_RAMFS
mkdir -pv $DIR_RAMFS

$PATH_SCRIPT_GEN -o ./initramfs.img $DIR_BUSYBOX_BIN ./cpio_list

#mkdir -pv $DIR_RAMFS/{bin,dev,sbin,etc,proc,sys/kernel/debug,usr/{bin,sbin},lib,lib64,mnt/root,root}
#cp -av $DIR_BUSYBOX_BIN/* $DIR_RAMFS
#sudo cp -av /dev/{null,console,tty,sda1} $DIR_RAMFS/dev/

#cp -v ./init.sh $DIR_RAMFS/init

#find $DIR_RAMFS | cpio -o --format=newc | gzip > $IMG_INITRAMFS
