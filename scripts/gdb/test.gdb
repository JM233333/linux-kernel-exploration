shell echo "run gdbscript test.gdb..."

# breakpoints : the first user process
b start_kernel
b run_init_process
b *ret_from_fork+31
b cpu_startup_entry

# breakpoints : system calls
# b *common_interrupt_return+96
b __do_sys_write
b ksys_write