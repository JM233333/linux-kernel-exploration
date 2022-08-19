#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>

#define SYS_hello 500

int main(void) {
	printf("hello, world!\n");
	int ret = syscall(SYS_hello, 12, 24);
	printf("syscall #500 ret = %d\n", ret);
	fflush(stdout);
	return 0;
}
