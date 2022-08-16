# Makefile for Linux-Kernel-Exploration

.DEFAULT_GOAL = run

## Configurations

### path of tools

QEMU := qemu-system-x86_64

### path of archives

#### include ./scripts/build/archives.mk

KERNEL_VERSION  := 5.15.57
BUSYBOX_VERSION := 1.35.0

DIR_KERNEL      := $(realpath linux-$(KERNEL_VERSION))
DIR_BUSYBOX     := $(realpath busybox-$(BUSYBOX_VERSION))

KERNEL_IMAGE    := $(DIR_KERNEL)/arch/x86/boot/bzImage
BUSYBOX_OUT_DIR := $(DIR_BUSYBOX)/_install
BUSYBOX_IMAGE   := $(BUSYBOX_OUT_DIR)/linuxrc

### path of directories, executables and images

DIR_SCRIPTS              := $(realpath ./scripts)

DIR_SCRIPTS_BUILD        := $(DIR_SCRIPTS)/build
DIR_SCRIPTS_BUILD_CONFIG := $(DIR_SCRIPTS_BUILD)/config

DIR_SCRIPTS_GDB          := $(DIR_SCRIPTS)/gdb

# DIR_SCRIPTS_INITRAMFS    := $(DIR_SCRIPTS)/initramfs

DIR_INITRAMFS         := $(realpath ./initramfs)
DIR_INITRAMFS_EMPTY   := $(DIR_INITRAMFS)/empty
DIR_INITRAMFS_BUSYBOX := $(DIR_INITRAMFS)/busybox

INITRAMFS_IMAGE       := $(DIR_INITRAMFS)/initramfs.img

### path of scripts

SCRIPT_GEN_INITRAMFS := $(DIR_INITRAMFS_BUSYBOX)/usr/gen_initramfs.sh
BIN_GEN_INIT_CPIO    := $(DIR_INITRAMFS_BUSYBOX)/usr/gen_init_cpio

### build parameters

ifeq ($(INITRAMFS),)
    INITRAMFS := busybox
endif

## Rules : Config

defaultconfig: tinyconfig

tinyconfig:
ifeq ($(wildcard $(DIR_KERNEL)/.config),)
	cp $(DIR_SCRIPTS_BUILD_CONFIG)/tiny/kernel.config $(DIR_KERNEL)/.config
else
	@echo tinyconfig failed : .config file already exists in kernel archive.
endif
ifeq ($(wildcard $(DIR_BUSYBOX)/.config),)
	cp $(DIR_SCRIPTS_BUILD_CONFIG)/tiny/busybox.config $(DIR_BUSYBOX)/.config
else
	@echo tinyconfig failed : .config file already exists in busybox archive.
endif

.PHONY: defaultconfig tinyconfig

## Configurations of Run

### gdb

GDB_PORT := 1234

GDB_SCRIPT := $(DIR_SCRIPTS_GDB)/test.gdb

### qemu

QEMUFLAGS      := -serial mon:stdio -nographic
QEMUAPPENDARGS := console=ttyS0

QEMUFLAGS_GDB  := -S -gdb tcp::$(GDB_PORT)

## Rules : Run

run: $(KERNEL_IMAGE) gen-initramfs
	$(QEMU) -kernel $(KERNEL_IMAGE) -initrd $(INITRAMFS_IMAGE) $(QEMUFLAGS) \
        -append "$(QEMUAPPENDARGS) root=/dev/ram init=/init"

## Rules : Debug

gdb: $(KERNEL_IMAGE) gen-initramfs
	$(QEMU) -kernel $(KERNEL_IMAGE) -initrd $(INITRAMFS_IMAGE) $(QEMUFLAGS) \
        -append "$(QEMUAPPENDARGS) root=/dev/ram init=/init" \
        $(QEMUFLAGS_GDB)

gdb-attach:
	gdb $(DIR_KERNEL)/vmlinux -x $(GDB_SCRIPT) -ex "target remote localhost:$(GDB_PORT)"
#	cd $(DIR_KERNEL); gdb ./vmlinux -ex "target remote localhost:$(GDB_PORT)"

## Rules : Build

build: build-kernel build-busybox

build-kernel:
	@echo + Building Linux Kernel
	@make -C $(DIR_KERNEL) -j4
	@mkdir -p $(dir $(SCRIPT_GEN_INITRAMFS))
	@cp $(DIR_KERNEL)/usr/$(notdir $(SCRIPT_GEN_INITRAMFS)) $(SCRIPT_GEN_INITRAMFS)
	@cp $(DIR_KERNEL)/usr/$(notdir $(BIN_GEN_INIT_CPIO))    $(BIN_GEN_INIT_CPIO)

build-busybox:
	@echo + Building BusyBox
	@make -C $(DIR_BUSYBOX)
	@make -C $(DIR_BUSYBOX) install

.PHONY: build build-kernel build-busybox

## Rules : Generate initramfs

gen-initramfs: gen-initramfs-busybox

gen-initramfs-empty:
	@echo + Generating initramfs empty
	@make -C $(DIR_INITRAMFS_EMPTY) IMAGE=$(INITRAMFS_IMAGE)

gen-initramfs-busybox: $(KERNEL_IMAGE) $(BUSYBOX_IMAGE)
	@echo + Generating initramfs busybox
	@make -C $(DIR_INITRAMFS_BUSYBOX) \
        IMAGE=$(INITRAMFS_IMAGE) \
        SCRIPT=$(SCRIPT_GEN_INITRAMFS) \
		BUSYBOX=$(BUSYBOX_OUT_DIR)

.PHONY: gen-initramfs gen-initramfs-empty gen-initramfs-busybox

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

.PHONY: clean-kernel clean-busybox

clean-all: clean clean-kernel clean-busybox
.PHONY: clean-all