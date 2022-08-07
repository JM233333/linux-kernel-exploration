# Build and Run a Tiny Linux Kernel on QEMU

*Authored by JM233333 (not finished)*

---

### Environment

My development environment (for reference) :

- Ubuntu 20.04, 5.15.0-41-generic, x86_64 GNU/Linux

- gcc 9.4.0

Archive version I used (for reference) :

- Linux Kernel 5.15.57

- BusyBox 1.35.0

Make sure your development environment meets the requirements below :

- available disk storage : >4 GB for tiny build, >10 GB for full build

---

### Preparation

Download appropriate version of linux kernel and busybox :

| Package | Link |
| :---    | :--- |
| Linux Kernel | [The Linux Kernel Archives](https://www.kernel.org/) |
| BusyBox | [BusyBox](https://www.busybox.net/) |

Download packages required to build the linux kernel (Ubuntu) :

```
sudo apt install libelf-dev dwarves libzstd-dev zstd
```

---

### Build a Tiny Linux Kernel

Unzip the downloaded archive, enter the directory and start to build (use 5.15.57 as example):

```
tar -xvf linux-5.15.57.tar.xz
cd linux-5.15.57
```

Generate an initial config that represents a minimal kernel (see [Linux Kernel Tinification](https://tiny.wiki.kernel.org/)) :

```
make tinyconfig
```

Now we can run `make` and get a minimal kernel image, but this is not what we want. We shall enable several configurations through `menuconfig` :

```
make menuconfig
```

For below-mentioned configurations, there positions in `menuconfig` GUI (5.15.57) is given, which might be different in other versions of kernel.

Required extra configurations are listed below :

- ;

Recommended extra configurations are listed below :

- ;

---

### Setup a Minimal initramfs

---

### Setup a initramfs with BusyBox

---

### Appendix

#### Use Native Configuration

cp /boot/config-$(uname -r) .config
make menuconfig
make

#### Errors and Solutions

```
make[1]: *** No rule to make target 'debian/canonical-certs.pem', needed by 'certs/x509_certificate_list'.  Stop.
```

https://askubuntu.com/questions/1329538/compiling-the-kernel-5-11-11

---

### References

- [Building a tiny Linux kernel - by Anuradha Weeraman](https://weeraman.com/building-a-tiny-linux-kernel-8c07579ae79d)

- [Build the Linux Kernel and Busybox and run them on QEMU](https://www.centennialsoftwaresolutions.com/post/build-the-linux-kernel-and-busybox-and-run-them-on-qemu)

- [Linux Kernel Tinification](https://tiny.wiki.kernel.org/)
