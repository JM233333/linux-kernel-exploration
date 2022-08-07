## Build and Run a Tiny Kernel on QEMU

Download a longterm 5.x version of linux kernel from [The Linux Kernel Archives](https://www.kernel.org).

sudo apt install libelf-dev dwarves libzstd-dev zstd

...

### Use Native Configuration

cp /boot/config-$(uname -r) .config
make menuconfig
make

### Errors and Solutions

make[1]: *** No rule to make target 'debian/canonical-certs.pem', needed by 'certs/x509_certificate_list'.  Stop.
https://askubuntu.com/questions/1329538/compiling-the-kernel-5-11-11