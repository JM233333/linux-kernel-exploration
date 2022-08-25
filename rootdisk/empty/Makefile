## Check Parameters

ifeq ($(DIR_KERNEL),)
    $(error Error - $$DIR_KERNEL required to generate rootdisk image)
endif

## Rules

# disk size (in MB)
DISK_SIZE := 16

gen: clean compile
#	dd if=/dev/zero of=$(IMAGE) bs=1024 count=$(shell expr $(DISK_SIZE) \* 1024)
	qemu-img create -f raw $(IMAGE) 16M
	mkfs.ext4 $(IMAGE)
	mkdir -p $(MOUNT_DIR)
	sudo mount -o loop $(IMAGE) $(MOUNT_DIR)
#	sudo make -C $(DIR_KERNEL) modules_install INSTALL_MOD_PATH=$(MOUNT_DIR)
	sudo cp init $(MOUNT_DIR)

compile: init

init: init.c
	$(CC) $(CFLAGS) -o init init.c

clean:
	-sudo umount $(MOUNT_DIR)
	rm -f $(IMAGE)
	rm -f init

.PHONY: gen compile clean