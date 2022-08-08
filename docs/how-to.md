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

#### Use tinyconfig

Unzip the downloaded archive, enter the directory and start to build (use 5.15.57 as example):

```
tar -xvf linux-5.15.57.tar.xz
cd linux-5.15.57
```

Generate an initial config that represents a minimal kernel (see [Linux Kernel Tinification](https://tiny.wiki.kernel.org/)) :

```
make tinyconfig
```

#### Additional Options

With `tinyconfig` we can run `make` and get a minimal kernel image, but this is not what we want - we can't even execute any programs on it. To get a minimal but meaningful kernel image, we shall enable several additional options through `menuconfig` :

```
make menuconfig
```

*Notice : For below-mentioned options, there positions in `menuconfig` GUI (5.15.57) is given, which might be different in other versions of kernel.*

Required and highly-recommanded additional options are listed below :

- [*] 64-bit kernel

- General setup --->

    - [*] Initial RAM filesystem and RAM disk (initramfs/initrd) support

    - Configure standard kernel features (expert users) --->

        - [*] Enable support for printk

- Executable file formats --->

    - [*] Kernel support for ELF binaries

    - [*] Kernel support for scripts starting with #!

- Device Drivers ---> Character devices --->

    - [*] Enable TTY

    - Serial drivers --->

        - [*] 8250/16550 and compatible serial support

        - [*] Console on 8250/16550 and compatible serial port

- File systems ---> Pseudo filesystems --->

    - [*] /proc file system support

    - [*] sysfs file system support

- Kernel hacking --->

    - Compile-time checks and compiler options --->

        - [*] Compile the kernel with debug info

        - [*] Provide GDB scripts for kernel debugging
    
    - Generic Kernel Debugging Instruments --->

        - [*] Debug filesystem

        - [*] KGDB: kernel debugger
    
    - x86 Debugging --->

        - [*] Early printk

#### Build

Now we can run `make` and get the minimal kernel image we want :

```
make -j4
```

After `make` , a series of images will be generated, and we are concerned about the following (for more details about all generated images, see [Difference between images in Linux kernel](https://ineclabs.com/image-zimage-uimage-vmlinuz-linux-kernel/)) :

- `bzImage` : The generic linux kernel binary image file, which is used to boot the kernel on qemu. It is located at `linux-5.15.57/arch/x86/boot/bzImage` by default.

- `vmlinux` : This is the linux kernel in a statically linked executable file format, which contains useful information for debugging purposes, and is used to debug the kernel through gdb or other debug engines. It is located at `linux-5.15.57/vmlinux` by default, generated together with `vmlinux-gdb.py` in modern-version linux kernel.

---

### Generate initramfs

#### Generate a Minimal initramfs

TBD

#### Generate a initramfs with BusyBox

TBD

---

### Debug the Linux Kernel

#### Debug with GDB

TBD

#### Debug with VSCode

Create the file `linux-5.15.57/.vscode/launch.json` and fill in the following code :

```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "kernel-debug",
            "type": "cppdbg",
            "request": "launch",
            "miDebuggerServerAddress": ":1234", // fill in the port corresponding to gdb
            "program": "${workspaceFolder}/vmlinux",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "logging": {
                "engineLogging": false
            },
            "MIMode": "gdb",
        }
    ]
}
```

---

### Configure VSCode for Linux Kernel Sources

https://github.com/amezin/vscode-linux-kernel

---

### Appendix

#### Use Native Configuration

```
cp /boot/config-$(uname -r) .config
make menuconfig
make -J4
```

#### List of Error-and-Solution Pairs

```
make[1]: *** No rule to make target 'debian/canonical-certs.pem', needed by 'certs/x509_certificate_list'.  Stop.
```

https://askubuntu.com/questions/1329538/compiling-the-kernel-5-11-11

---

### References

- [Building a tiny Linux kernel - by Anuradha Weeraman](https://weeraman.com/building-a-tiny-linux-kernel-8c07579ae79d)

- [Build the Linux Kernel and Busybox and run them on QEMU](https://www.centennialsoftwaresolutions.com/post/build-the-linux-kernel-and-busybox-and-run-them-on-qemu)

- [Linux Kernel Tinification](https://tiny.wiki.kernel.org/)

- [Linux Kernel Documentation - Debugging kernel and modules via gdb](https://docs.kernel.org/dev-tools/gdb-kernel-debugging.html)

- [Teach you how to debug Linux kernel with VSCode + Qemu + GDB](https://programming.vip/docs/teach-you-how-to-debug-linux-kernel-with-vs-code-qemu-gdb.html)