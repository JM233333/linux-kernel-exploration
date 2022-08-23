shell echo "run gdbscript test.gdb..."

# breakpoints : the first user process
# b start_kernel
# b run_init_process
# b *ret_from_fork+31
# b cpu_startup_entry

# breakpoints : system calls
# b *common_interrupt_return+96
b __do_sys_write
b ksys_write

b mount_block_root

# b bprm_execve
# b do_open_execat
# b do_filp_open
# b path_openat
# b exec_binprm