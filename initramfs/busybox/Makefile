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

## Rules

gen:
	@echo $(notdir $(SCRIPT)) -o $(notdir $(IMAGE)) $(notdir $(BUSYBOX)) $(notdir $(CPIO_LIST))
	@$(SCRIPT) -o $(IMAGE) $(BUSYBOX) $(CPIO_LIST)

clean:
	rm -r usr

.PHONY: gen clean