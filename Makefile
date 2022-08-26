# Makefile for Linux-Kernel-Exploration

.DEFAULT_GOAL = run

# used by chown to remove root privilege caused by `sudo mount rootdisk.img`
export USER := jm233333

## Configurations

### path of tools

QEMU := qemu-system-x86_64

### path of archives

#### include ./scripts/build/archives.mk

KERNEL_VERSION  := 5.15.57
BUSYBOX_VERSION := 1.35.0

export DIR_KERNEL      := $(realpath linux-$(KERNEL_VERSION))
export DIR_BUSYBOX     := $(realpath busybox-$(BUSYBOX_VERSION))

export KERNEL_IMAGE    := $(DIR_KERNEL)/arch/x86/boot/bzImage
export DIR_BUSYBOX_BIN := $(DIR_BUSYBOX)/_install
export BUSYBOX_IMAGE   := $(DIR_BUSYBOX_BIN)/linuxrc

ifneq ($(DEFCMP),)
export KERNEL_IMAGE    := $(realpath ../linux-$(KERNEL_VERSION))/arch/x86/boot/bzImage
endif

### path of directories, executables and images

DIR_SCRIPTS              := $(realpath ./scripts)

DIR_SCRIPTS_BUILD        := $(DIR_SCRIPTS)/build
DIR_SCRIPTS_BUILD_CONFIG := $(DIR_SCRIPTS_BUILD)/config

DIR_SCRIPTS_GDB          := $(DIR_SCRIPTS)/gdb

# DIR_SCRIPTS_INITRAMFS    := $(DIR_SCRIPTS)/initramfs

DIR_INITRAMFS         := $(realpath ./initramfs)
DIR_ROOTDISK          := $(realpath ./rootdisk)

INITRAMFS_IMAGE       := $(DIR_INITRAMFS)/initramfs.img
ROOTDISK_IMAGE        := $(DIR_ROOTDISK)/rootdisk.img

### configurations

GDB_SCRIPT := $(DIR_SCRIPTS_GDB)/test.gdb
GDB_PORT   := 1234

IMGTYPE_INITRAMFS := busybox
IMGTYPE_ROOTDISK  := empty

INITBIN := /init
# INITBIN := /linuxrc

## Rules : Use Preset Kernel Configuration

config-default: config-tiny

config-tiny:
ifeq ($(wildcard $(DIR_KERNEL)/.config),)
	cp $(DIR_SCRIPTS_BUILD_CONFIG)/kernel/tiny.config $(DIR_KERNEL)/.config
else
	@echo tinyconfig failed : .config file already exists in kernel archive.
endif

config-min-hd:
ifeq ($(wildcard $(DIR_KERNEL)/.config),)
	cp $(DIR_SCRIPTS_BUILD_CONFIG)/kernel/min-hd-support.config $(DIR_KERNEL)/.config
else
	@echo tinyconfig failed : .config file already exists in kernel archive.
endif

.PHONY: config-default config-tiny config-min-hd

removeconfig:
	rm -f $(DIR_KERNEL)/.config

.PHONY: removeconfig

## Rules : Default

run: run-initramfs
gdb: gdb-initramfs
.PHONY: run gdb

## Rules : Run & Debug

QEMUFLAGS_GENERAL   := -kernel $(KERNEL_IMAGE) -smp 1 -serial mon:stdio -nographic
QEMUFLAGS_GDB       := -S -gdb tcp::$(GDB_PORT)

### run/debug with initramfs

QEMUFLAGS_INITRAMFS := -initrd $(INITRAMFS_IMAGE) \
                       -append "console=ttyS0 root=/dev/ram init=$(INITBIN)"

run-initramfs: $(KERNEL_IMAGE) gen-initramfs
	$(QEMU) $(QEMUFLAGS_GENERAL) $(QEMUFLAGS_INITRAMFS)

gdb-initramfs: $(KERNEL_IMAGE) gen-initramfs
	$(QEMU) $(QEMUFLAGS_GENERAL) $(QEMUFLAGS_INITRAMFS) $(QEMUFLAGS_GDB)

.PHONY: run-initramfs gdb-initramfs

### run/debug with rootdisk

# QEMUFLAGS_ROOTDISK  := -drive file=$(ROOTDISK_IMAGE),index=0,media=disk \

QEMUFLAGS_ROOTDISK  := -hda $(ROOTDISK_IMAGE) -hdb ./disk.img \
                       -append "console=ttyS0 root=/dev/sda init=$(INITBIN) rw"

run-rootdisk: $(KERNEL_IMAGE) gen-rootdisk
	$(QEMU) $(QEMUFLAGS_GENERAL) $(QEMUFLAGS_ROOTDISK)

gdb-rootdisk: $(KERNEL_IMAGE) gen-rootdisk
	$(QEMU) $(QEMUFLAGS_GENERAL) $(QEMUFLAGS_ROOTDISK) $(QEMUFLAGS_GDB)

.PHONY: run-rootdisk gdb-rootdisk

## Rules : Remote Debug

gdb-attach:
	gdb $(DIR_KERNEL)/vmlinux -x $(GDB_SCRIPT) -ex "target remote localhost:$(GDB_PORT)"

.PHONY: gdb-attach

## Rules : Build

build: build-kernel build-busybox

build-kernel: $(DIR_KERNEL)/.config
	@echo + Building Linux Kernel
	@make -C $(DIR_KERNEL) -j4

build-busybox: $(DIR_BUSYBOX)/.config
	@echo + Building BusyBox
	@make -C $(DIR_BUSYBOX)
	@make -C $(DIR_BUSYBOX) install

$(DIR_BUSYBOX)/.config:
	cp $(DIR_SCRIPTS_BUILD_CONFIG)/busybox/.config $(DIR_BUSYBOX)/.config

.PHONY: build build-kernel build-busybox

## Rules : Generate initramfs

gen-initramfs:
	@echo + Generating initramfs $(IMGTYPE_INITRAMFS)
	@make -s -C $(DIR_INITRAMFS) IMAGE=$(notdir $(INITRAMFS_IMAGE)) IMGTYPE=$(IMGTYPE_INITRAMFS)

.PHONY: gen-initramfs

## Rules : Generate Hard Disk

gen-rootdisk:
	@echo + Generating rootdisk $(IMGTYPE_ROOTDISK)
	@make -s -C $(DIR_ROOTDISK) IMAGE=$(notdir $(ROOTDISK_IMAGE)) IMGTYPE=$(IMGTYPE_ROOTDISK)

.PHONY: gen-rootdisk

## Rules : Clean

# CLEAN_FILES       := 
# CLEAN_DIRECTORIES := 

clean:
#	rm -f $(CLEAN_FILES)
#	rm -rf $(CLEAN_DIRECTORIES)
.PHONY: clean

clean-kernel:
	make -C $(DIR_KERNEL) clean
clean-busybox:
	make -C $(DIR_BUSYBOX) clean
clean-initramfs:
	make -s -C $(DIR_INITRAMFS) clean IMAGE=$(INITRAMFS_IMAGE)
clean-rootdisk:
	make -s -C $(DIR_ROOTDISK) clean IMAGE=$(ROOTDISK_IMAGE)

.PHONY: clean-kernel clean-busybox clean-initramfs clean-rootdisk

clean-all: clean clean-kernel clean-busybox clean-initramfs clean-rootdisk
.PHONY: clean-all
