shell echo "run gdbscript test.gdb..."

# set breakpoints
b start_kernel
b run_init_process
b *ret_from_fork+31
b *common_interrupt_return+96
b cpu_startup_entry
b ksys_write