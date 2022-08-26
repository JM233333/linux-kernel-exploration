img-init: img-clean
	dd if=/dev/zero of=$(IMAGE).tmp bs=1024 count=$(shell expr $(DISK_SIZE_MB) \* 1024)
#	qemu-img create -f raw $(IMAGE) $(DISK_SIZE_MB)M
	mkdir -p $(DIR_MOUNT)
	mkfs.ext4 $(IMAGE).tmp

img-clean:
	-sudo umount $(DIR_MOUNT)
	rm -rf $(DIR_MOUNT)
	rm -f $(IMAGE) $(IMAGE).tmp

.PHONY: img-init img-clean