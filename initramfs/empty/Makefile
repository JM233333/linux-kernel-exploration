## Rules

gen: compile
	echo init | cpio -ov --format=newc > $(IMAGE)

compile: init

init: init.c
	$(CC) $(CFLAGS) -o init init.c

clean:
	rm -f init

.PHONY: gen compile clean