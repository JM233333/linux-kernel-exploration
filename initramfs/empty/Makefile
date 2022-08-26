## Check Parameters

ifeq ($(IMAGE),)
    $(error Error - $$IMAGE required to generate initramfs image)
endif

## Includes

include $(realpath ../initramfs.mk)

## Rules

gen: init
	echo init | cpio -ov --format=newc > $(IMAGE)

init: init.c
	$(CC) $(CFLAGS) -o init init.c

clean:
	rm -f $(IMAGE)
	rm -f init

.PHONY: gen clean