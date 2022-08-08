## Check Parameters

ifeq ($(IMAGE),)
    IMAGE := $(realpath ../initramfs.img)
    # $(error Error - $$IMAGE required to generate initramfs image)
endif

## Compilers and Compile Flags

CC := gcc

CFLAGS := -O0 -g -ggdb -static

## Rules

gen: compile
	echo init | cpio -ov --format=newc > $(IMAGE)

compile: init

init: init.c
	$(CC) $(CFLAGS) -o init init.c

clean:
	rm init

.PHONY: gen compile clean