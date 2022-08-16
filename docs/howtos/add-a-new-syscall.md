Add a New System Call

*Authored by JM233333 (not finished)*

---

### Syscall Definition

#### Syscall Handling

#### Syscall Table

The syscall table is defined in `arch/x86/entry/syscall_64.c` :

```c
#include <asm/syscall.h>

#define __SYSCALL(nr, sym) extern long __x64_##sym(const struct pt_regs *);
#include <asm/syscalls_64.h>
#undef __SYSCALL

#define __SYSCALL(nr, sym) __x64_##sym,

asmlinkage const sys_call_ptr_t sys_call_table[] = {
#include <asm/syscalls_64.h>
};
```

Element type `sys_call_ptr_t` represents a pointer to a system call table. It is defined as `typedef` in `asm/syscall.h` which indicates `arch/x86/include/asm/syscall.h` :

```c
typedef long (* sys_call_ptr_t)(const struct pt_regs *);
```

- Parameter type `struct pt_regs` is used for ptrace to save register context if necessary (see `arch/x86/include/asm/ptrace.h`) .

`asm/syscalls_64.h` indicates `arch/x86/include/generated/asm/syscalls_64.h` , which is generated through the script `tools/perf/arch/x86/entry/syscalls/syscalltbl.sh` .

```c
__SYSCALL(0, sys_read)
__SYSCALL(335, sys_ni_syscall)
```

`sys_ni_syscall` represents not-implemented system calls, which is simply-implemented in `kernel/sys_ni.c` :

```c
asmlinkage long sys_ni_syscall(void) {
    return -ENOSYS;
}
```

The `-ENOSYS` error indicates not-implemented function under the POSIX standard.

`tools/perf/arch/x86/entry/syscalls/syscall_64.tbl`
`arch/x86/entry/syscalls/syscall_64.tbl`

After macro expandation of `__SYSCALL` , the aforementioned file `syscall_64.c` takes the following form:

```c
extern long __x64_sys_read(const struct pt_regs *);
extern long __x64_sys_write(const struct pt_regs *);
...
extern long __x64_sys_ni_syscall(const struct pt_regs *);
...

asmlinkage const sys_call_ptr_t sys_call_table[] = {
    sys_read,
    sys_write,
    ...
    sys_ni_syscall,
    ...
};
```

---

### Adding a New System Call

As mentioned above, we need to implement the new system call in the form of `SYSCALL_DEFINEn(name)` somewhere in the kernel source code. The easiest way is to arbitrarily implement it anywhere (e.g. in `fs/read_write.c` together with syscall #0 `sys_read`). However, using a new source directory is a more elegant option.

#### Using a New Source Directory (Optional)

Assume that we create a new source directory named `custom` . One of the easiest way to make the kernel compile this directory is as follows.

**Step 1.** Modify line 663 of `Makefile` (for linux-5.15.57) :

```makefile
core-y := init/ usr/ arch/$(SRCARCH)/ custom/
```

Or add anywhere after line 663 :

```makefile
core-y += custom/
```

**Step 2.** Assign the list of object files to `obj-y` in `custom/Makefile` . For example :

```makefile
obj-y := hello.o world.o
```

---

### References

- [Linux Kernel Documentation - Adding a New System Call](https://docs.kernel.org/process/adding-syscalls.html)

- [linux-insides - System calls in the Linux kernel](https://0xax.gitbooks.io/linux-insides/content/SysCall/linux-syscall-1.html)

---

### Appendix

#### Difference to Older Kernel Version

In older versions of linux kernel (e.g. 5.0.x), the syscall table is implemented in the form of designated initializers (e.g. [0] = sys_read, [1] = sys_write, ...). In 5.15.57, unused syscall entries is pre-filled with `sys_ni_syscall` in the generated file `syscalls_64.h` , then filled into the definition of `sys_call_table` .

In `include/generated/asm-offsets.h` :

```c
#define __NR_syscall_max 547
```

In `arch/x86/entry/syscall_64.c` :

```c
asmlinkage const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
    [0 ... __NR_syscall_max] = &sys_ni_syscall,
    [0] = sys_read,
    [1] = sys_write,
    ...
};
```

In `arch/x86/entry/syscalls/syscall_64.tbl` :

```c
typedef void (* sys_call_ptr_t)(void);
```