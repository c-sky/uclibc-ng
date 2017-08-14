.globl __longjmp;
.type  __longjmp,@function
.align 4;

__longjmp:
	ldw    r4, (a0, 8)
	ldw    r5, (a0, 12)
	ldw    r6, (a0, 16)
	ldw    r7, (a0, 20)
	ldw    r8, (a0, 24)
	ldw    r9, (a0, 28)
	ldw    r10, (a0, 32)
	ldw    r11, (a0, 36)

	/* r15 = pc before call __setjmp */
	ldw    r15, (a0, 4)

#ifndef __ck802__
	ldw    r16, (a0, 40)
	ldw    r17, (a0, 44)

	ldw    r26, (a0, 48)
	ldw    r27, (a0, 52)
	ldw    r28, (a0, 56)
	ldw    r29, (a0, 60)
	ldw    r30, (a0, 64)
	ldw    r31, (a0, 68)
#endif

        ldw    sp, (a0, 0)
	mov    a0, a1
	cmpnei a1, 0
	bt     1f
	movi   a0, 1
1:
	rts

libc_hidden_def(__longjmp)
