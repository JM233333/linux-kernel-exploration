## Check Parameters

ifeq ($(IMAGE),)
    $(error Error - $$IMAGE required to generate rootdisk image)
endif

ifeq ($(DIR_MOUNT),)
    $(error Error - $$DIR_MOUNT required to generate rootdisk image)
endif

## Check Optional Parameters

ifeq ($(DISK_SIZE_MB),)
    DISK_SIZE_MB := 16
endif

## Compilers and Compile Flags

CC := gcc

CFLAGS := -O0 -g -ggdb -static

## Rules

include $(realpath ../rootdisk.mk)

gen: $(IMAGE)

$(IMAGE): init
	make img-init
	sudo mount -t ext4 -o loop $(IMAGE).tmp $(DIR_MOUNT)
	sudo chown $(USER) $(DIR_MOUNT)
	cp init $(DIR_MOUNT)
	sudo umount $(DIR_MOUNT)
	mv $(IMAGE).tmp $(IMAGE)

.PHONY: gen

## Rules : Compile

init: init.c
	echo + $(CC) $(CFLAGS) -o init init.c
	$(CC) $(CFLAGS) -o init init.c

## Rules : Clean

clean: img-clean
	rm -f init

.PHONY: clean