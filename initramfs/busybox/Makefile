## Check Parameters

ifeq ($(DIR_KERNEL),)
    $(error Error - $$DIR_KERNEL required to generate busybox-based initramfs image)
endif

ifeq ($(DIR_BUSYBOX_BIN),)
    $(error Error - $$DIR_BUSYBOX_BIN required to generate busybox-based initramfs image)
endif

## Configurations

SCRIPT_GEN_INITRAMFS := $(realpath .)/usr/gen_initramfs.sh
BIN_GEN_INIT_CPIO    := $(realpath .)/usr/gen_init_cpio

CPIO_LIST := $(realpath ./cpio_list)

## Rules

gen: getscript test
	@echo $(notdir $(SCRIPT_GEN_INITRAMFS)) -o $(notdir $(IMAGE)) $(notdir $(DIR_BUSYBOX_BIN)) $(notdir $(CPIO_LIST))
	@$(SCRIPT_GEN_INITRAMFS) -o $(IMAGE) $(BUSYBOX) $(CPIO_LIST)

test: test.c
	$(CC) $(CFLAGS) -o test test.c

getscript:
	@echo get linux/usr/$(notdir $(SCRIPT_GEN_INITRAMFS))
	@echo get linux/usr/$(notdir $(BIN_GEN_INIT_CPIO))
	@mkdir -p $(dir $(SCRIPT_GEN_INITRAMFS))
	@cp $(DIR_KERNEL)/usr/$(notdir $(SCRIPT_GEN_INITRAMFS)) $(SCRIPT_GEN_INITRAMFS)
	@cp $(DIR_KERNEL)/usr/$(notdir $(BIN_GEN_INIT_CPIO))    $(BIN_GEN_INIT_CPIO)

clean:
	rm -rf $(dir $(SCRIPT_GEN_INITRAMFS))
	rm -f test

.PHONY: gen getscript clean