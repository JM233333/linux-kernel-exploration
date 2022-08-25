## Check Parameters

ifeq ($(DIR_KERNEL),)
    $(error Error - $$DIR_KERNEL required to generate busybox-based rootdisk image)
endif

ifeq ($(DIR_BUSYBOX_BIN),)
    $(error Error - $$DIR_BUSYBOX_BIN required to generate busybox-based rootdisk image)
endif

ifeq ($(DIR_MOUNT),)
    $(error Error - $$DIR_MOUNT required to generate busybox-based rootdisk image)
endif

ifeq ($(IMAGE),)
    $(error Error - $$IMAGE required to generate busybox-based rootdisk image)
endif

## Check Optional Parameters

ifeq ($(DISK_SIZE_MB),)
    DISK_SIZE_MB := 16
endif

## Configurations

CREATE_DIRS := proc sys dev
CREATE_DIRS := $(addprefix $(DIR_MOUNT)/, $(CREATE_DIRS))

## Rules

gen: $(IMAGE)

$(IMAGE): $(DIR_BUSYBOX_BIN)
	make init
	sudo mount -t ext4 -o loop $(IMAGE).tmp $(DIR_MOUNT)
	sudo chown $(USER) $(DIR_MOUNT)
	cp -r etc $(DIR_MOUNT)
	mkdir $(CREATE_DIRS)
	make -C $(dir $(DIR_BUSYBOX_BIN)) install CONFIG_PREFIX=$(DIR_MOUNT)
	sudo umount $(DIR_MOUNT)
	mv $(IMAGE).tmp $(IMAGE)

init: clean
	dd if=/dev/zero of=$(IMAGE).tmp bs=1024 count=$(shell expr $(DISK_SIZE_MB) \* 1024)
#	qemu-img create -f raw $(IMAGE) $(DISK_SIZE_MB)M
	mkdir -p $(DIR_MOUNT)
	mkfs.ext4 $(IMAGE).tmp

clean:
	-sudo umount $(DIR_MOUNT)
	rm -rf $(DIR_MOUNT)
	rm -f $(IMAGE) $(IMAGE).tmp

.PHONY: gen init clean
