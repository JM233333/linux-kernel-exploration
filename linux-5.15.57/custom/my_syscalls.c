#include <linux/syscalls.h>

SYSCALL_DEFINE0(hello) {
	return 233;
}