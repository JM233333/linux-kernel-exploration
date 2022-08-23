## Check Parameters

ifeq ($(DIR_KERNEL),)
    $(error Error - $$DIR_KERNEL required to generate busybox-based rootdisk image)
endif

ifeq ($(DIR_BUSYBOX_BIN),)
    $(error Error - $$DIR_BUSYBOX_BIN required to generate busybox-based rootdisk image)
endif

## Check Optional Parameters

ifeq ($(DISK_SIZE_MB),)
    DISK_SIZE_MB := 16
endif

## Configurations

CREATE_DIRS := proc sys dev
CREATE_DIRS := $(addprefix $(MOUNT_DIR)/, $(CREATE_DIRS))

## Rules

gen: $(IMAGE)

$(IMAGE): $(DIR_BUSYBOX_BIN)
	dd if=/dev/zero of=$(IMAGE) bs=1024 count=$(shell expr $(DISK_SIZE_MB) \* 1024)
#	qemu-img create -f raw $(IMAGE) $(DISK_SIZE_MB)M
	mkdir -p $(DIR_MOUNT)
	mkfs.ext4 $(IMAGE)
	mkdir -p $(MOUNT_DIR)
	mount -t ext4 -o loop $(IMAGE) $(MOUNT_DIR)
	cp -r etc $(MOUNT_DIR)
	mkdir $(CREATE_DIRS)
	make -C $(dir $(BUSYBOX)) install CONFIG_PREFIX=$(MOUNT_DIR)
	chown $(USER) $(IMAGE)

init:
	echo + init
cons:
	echo + cons

clean:
	-sudo umount $(MOUNT_DIR)

.PHONY: init cons gen clean
