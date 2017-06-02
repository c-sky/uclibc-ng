/* consider this code LGPL - davidm */

#include <unistd.h>
#include <sys/syscall.h>
#include <errno.h>

libc_hidden_proto(brk)

/* This must be initialized data because commons can't have aliases.  */
void * __curbrk = 0;

int brk (void *addr)
{
    void *newbrk;

    {
      register long int res __asm__("a0") = (long int)addr;

      __asm__ volatile ("lrw  l3, %1\n\t"
                        "trap 0     \n\t"			
                        :"+r" (res)
                        :"i" (__NR_brk)
                        :"l3");
      newbrk = (void *) res;
    }
    __curbrk = newbrk;

    if (newbrk < addr)
    {
        __set_errno (ENOMEM);
	return -1;
    }

    return 0;
}

libc_hidden_def(brk)
