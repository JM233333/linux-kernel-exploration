# Makefile for Linux-Kernel-Exploration

.DEFAULT_GOAL = image

## Configurations

include ./scripts/build/archives.mk

DIR_SCRIPTS := $(realpath ./scripts)
DIR_SCRIPTS_DEFAULTCONFIG := $(realpath $(DIR_SCRIPTS)/defaultconfig)

## Rules



## Rules : Config & Build

defaultconfig:
ifeq ($(wildcard $(DIR_KERNEL)/.config),)
	cp $(DIR_SCRIPTS_DEFAULTCONFIG)/kernel.config $(DIR_KERNEL)/.config
else
	echo defaultconfig failed : .config file already exists in kernel archive.
endif
ifeq ($(wildcard $(DIR_BUSYBOX)/.config),)
	cp $(DIR_SCRIPTS_DEFAULTCONFIG)/busybox.config $(DIR_BUSYBOX)/.config
else
	echo defaultconfig failed : .config file already exists in busybox archive.
endif

.PHONY: defaultconfig

## Rules : Build

build: build-kernel build-busybox

build-kernel:
	echo + Building Linux Kernel
	make -s -C $(RELPATH_KERNEL)

build-busybox:
	echo + Building BusyBox
	make -s -C $(RELPATH_BUSYBOX)
	make -s -C $(RELPATH_BUSYBOX) install

.PHONY: build build-kernel build-busybox

## Rules : Clean

# CLEAN_FILES       := 
# CLEAN_DIRECTORIES := 

clean:
#	rm -f $(CLEAN_FILES)
#	rm -rf $(CLEAN_DIRECTORIES)
.PHONY: clean

clean-kernel:
	make -s -C $(RELPATH_KERNEL) clean
clean-busybox:
	make -s -C $(RELPATH_BUSYBOX) clean

.PHONY: clean-kernel clean-busybox

clean-all: clean clean-kernel clean-busybox
.PHONY: clean-all