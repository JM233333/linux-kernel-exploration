shell echo "run gdbscript test.gdb..."

# set breakpoints
b start_kernel
b cpu_startup_entry
c