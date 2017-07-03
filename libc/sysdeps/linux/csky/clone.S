#define _ERRNO_H	1
#include <bits/errno.h>
#include <asm/unistd.h>

#define CLONE_THREAD_BIT  16 /* CLONE_THREAD = 0x00010000 */
#define CLONE_VM_BIT      8  /* CLONE_VM = 0x00000100 */

/* int _clone(int (*fn)(void *arg), void *child_stack, int flags, void *arg); */

#ifdef __CSKYABIV2__
#include <abiv2_clone.S>
#else

.text
.align 4
//.type	clone,@function
//.globl	clone;
//clone:
.type	__clone,@function
.globl	__clone;
__clone:
        /* You should save r15, if you call a function. */
        /* Sanity check arguments.  */
        cmpnei  a0, 0                   /* no NULL function pointers */
        bf      __error_arg
        cmpnei  a1, 0                  /* no NULL function pointers */
        bf      __error_arg

        subi    a1, 8                  /* adjust newsp for save fun_ptr & arguments */
        st.w    a0, (a1, 0x0)          /* save function in newsp */
        st.w    a3, (a1, 0x4)          /* save arguments in newsp */

        mov     a0, a2                 /* get flags */
        mov     a2, a4                 /* get p_pid */
        ld.w    a3, (sp, 0x0)          /* get c_pid */
        mov     a4, a5                 /* get tls */
        lrw     r1, __NR_clone         /* set syscall number */
        trap	0		       /* Do the system call */
        btsti	a0, 31                 /* r2 less than zero */
        bt   ___syscall_error
        cmpnei  a0, 0
        bf   thread_start               /* r2 equals to zero */
        rts

__error_arg:
        lrw	a0, -EINVAL
___syscall_error:
        rsubi   a0, 0                   /* invert a0 */
        subi    sp, 16
        st.w	lr, (sp, 0x0)           /* store lr */
        st.w    a0, (sp, 0x4)           /* store a0 */
        st.w    gb, (sp, 0x8)           /* store gb */
#ifdef __PIC__
        bsr .Lgetpc
.Lgetpc:
        lrw     gb, .Lgetpc@GOTPC
        addu    gb, r15
        lrw     r7, __errno_location@PLT
        addu    r7, gb
        ldw     r7, (r7)   
        jsr     r7                      /* r2 Will be used */
#else
        jsri    __errno_location
#endif
        ld.w    a1, (sp, 0x4)           /* restore a0 */
        ld.w    gb, (sp, 0x8)           /* restore gb */
        stw     a1, (a0)                /* store errno */
        bmaski  a0, 0
        ld.w	lr, (sp, 0x0)           /* restore lr */
        addi    sp, 16
        rts

thread_start:
        ld.w    a0, (sp, 0x4)          /* save arguments in newsp */
        ld.w    a5, (sp, 0x0)          /* save function in newsp */
        addi    sp, 8
        jsr     a5                      /* Call thread function */
        lrw     r1, __NR_exit           /* Set system call number */
        trap	0

weak_alias (__clone, clone)
#endif
