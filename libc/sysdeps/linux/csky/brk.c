#include <unistd.h>
#include <sys/syscall.h>
#include <errno.h>

void * __curbrk = 0;

int brk (void *addr)
{
  void *newbrk;

  newbrk = (void *) INTERNAL_SYSCALL_NCS(__NR_brk,, 1, addr);

  __curbrk = newbrk;

  if (newbrk < addr)
  {
      __set_errno (ENOMEM);
      return -1;
  }

  return 0;
}

libc_hidden_def(brk)

