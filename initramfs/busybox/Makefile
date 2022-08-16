## Check Parameters

ifeq ($(IMAGE),)
    IMAGE := $(realpath ../initramfs.img)
endif

ifeq ($(SCRIPT),)
    $(error Error - $$SCRIPT required to generate initramfs image)
endif

ifeq ($(BUSYBOX),)
    $(error Error - $$BUSYBOX required to generate initramfs image)
endif

CPIO_LIST = $(realpath ./cpio_list)

## Compilers and Compile Flags

CC := gcc

CFLAGS := -O0 -g -ggdb -static

## Rules

gen: test
	@echo $(notdir $(SCRIPT)) -o $(notdir $(IMAGE)) $(notdir $(BUSYBOX)) $(notdir $(CPIO_LIST))
	@$(SCRIPT) -o $(IMAGE) $(BUSYBOX) $(CPIO_LIST)

test: test.c
	$(CC) $(CFLAGS) -o test test.c

clean:
	rm -rf usr
	rm -f test

.PHONY: gen clean