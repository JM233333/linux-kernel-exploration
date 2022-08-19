#include <linux/syscalls.h>

SYSCALL_DEFINE2(hello, int, x, int, y) {
	return x + y;
}