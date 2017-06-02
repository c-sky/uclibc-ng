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

	subi	a1, 8
	stw	a0, (a1, 0)            /* insert the args onto the new stack */
	stw	a3, (a1, 4)            /* insert the args onto the new stack */

#ifdef RESET_PID
	subi	a1, 8                  /* save a2(flags) */
        stw	a2, (a1, 0x0)
#endif
	mov	t1, r7                 /* save r7 */
	mov	t2, r4                 /* save r4 (has t2 ?)*/

	mov	a0, a2                 /* arg1 = flags */
	ldw	a2, (sp, 0)            /* arg3 = ptid */
	ldw	a3, (sp, 8)            /* arg4 = ctid */
	ldw	r4, (sp, 4)            /* arg5 = tls */
	lrw	r7, __NR_clone
	trap	0
        mov     r7, t1                 /* restore r7 */
	mov	r4, t2                 /* restore r4 */
        btsti   a0, 31                 /* a0 less than zero */
        bt	__syscall_error
        cmpnei  a0, 0
        bf	thread_start           /* a0 equals to zero */
        rts

__error_arg:
        lrw     a0, -EINVAL
__syscall_error:
        not     a0                   /* invert a0 */
        addi    a0, 1
        subi    sp, 16
	stw	a0, (sp, 0x8)
        stw     lr, (sp, 0x0)
        stw     gb, (sp, 0x4)
#ifdef __PIC__
        grs     gb, .Lgetpc
.Lgetpc:
        lrw     t0, .Lgetpc@GOTPC
        addu    gb, gb, t0
        lrw     t0, __errno_location@PLT
        ldr.w   t0, (gb, t0 << 0)   
        jsr     t0                      /* t0 Will be used */
#else
        jsri    __errno_location
#endif
	ldw	lr, (sp, 0x8)
	stw	lr, (a0)
        bmaski  a0, 0
        ldw     lr, (sp, 0x0)
        ldw     gb, (sp, 0x4)
        addi    sp, 16
        rts

thread_start:
#ifdef RESET_PID
        ld.w    a1, (sp, 0x0)
        btsti   a1, CLONE_THREAD_BIT
        bt      .donepid
        bmaski  a2, 0
        btsti   a1, CLONE_VM_BIT
        bt      .gotpid
        lrw     r1, __NR_getpid
        trap    0
        mov     a2, a0

.gotpid:
        READ_THREAD_POINTER()
        lrw     a3, PID_OFFSET         /* PID_OFFSET is less then 0 */
        add     a3, a0
        stw     a2, (a3, 0x0)
        lrw     a3, TID_OFFSET         /* TID_OFFSET is less then 0 */
        add     a3, a0
        stw     a2, (a3, 0x0)
.donepid:
        addi    sp, 8
#endif
        ldw     a0, (sp, 0x4)           /* restore arguments in newsp */
        ldw     t0, (sp, 0x0)           /* restore function in newsp */
        addi    sp, 8
        jsr     t0                      /* Call thread function */
        lrw     r7, __NR_exit           /* Set system call number */ 
        trap    0

/*
#if defined(__HAVE_ELF__)
        .weak clone
        clone = __clone
#else
        .set clone, __clone
#endif
*/

weak_alias (__clone, clone)
