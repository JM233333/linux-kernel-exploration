# versions

export KERNEL_VERSION  := 5.15.57
export BUSYBOX_VERSION := 1.35.0

# paths

export DIR_KERNEL      := $(realpath linux-$(KERNEL_VERSION))
export DIR_BUSYBOX     := $(realpath busybox-$(BUSYBOX_VERSION))

export KERNEL_IMAGE    := $(realpath $(DIR_KERNEL)/arch/x86/boot/bzImage)
export BUSYBOX_OUT_DIR := $(realpath $(DIR_BUSYBOX)/_install)

# tbd.

DIR_RAMFS=./initramfs-busybox
IMG_INITRAMFS=./initramfs.img
PATH_SCRIPT_GEN=$PATH_LINUX_KERNEL/usr/gen_initramfs.sh