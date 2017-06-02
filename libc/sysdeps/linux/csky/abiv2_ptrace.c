
#include <errno.h>
#include <asm/ptrace.h>
#include <sys/syscall.h>

int ptrace(int request, int pid, int addr, int data)
{
    long ret;
  
    if (request > 0 && request < 4)  
    {	
        data =(int) &ret;
    }

    {
        register long __res  __asm__("a0") = (long) request;
        register long __b    __asm__("a1") = (long) pid;
        register long __c    __asm__("a2") = (long) addr;
        register long __d    __asm__("a3") = (long) data;
        __asm__ volatile ("lrw  l3, %4\n\t"
                          "trap 0     \n\t"
                          :"+r"(__res), "+r"(__b), "+r"(__c), "+r"(__d)
                          :"i" (__NR_ptrace)
                          :"l3");

       if (__res >= 0) {
           if (request > 0 && request < 4) {
                   __set_errno(0);
                   return (ret);
           }
           return (int) __res;
       }
       __set_errno(-__res);
    }
    return -1;
}
