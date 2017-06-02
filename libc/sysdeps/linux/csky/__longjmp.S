
/* Copyright (C) 2002, David McCullough <davidm@snapgear.com> */
/* This file is released under the LGPL, any version you like */
#ifdef __CSKYABIV2__
#include <abiv2__longjmp.S>
#else

#define _ASM
#define _SETJMP_H
#include <bits/setjmp.h>

.globl __longjmp;
.type  __longjmp,@function
.align 4;

__longjmp:
	ldw	r8,  (r2, 8)
	ldw	r9,  (r2, 12)
	ldw	r10, (r2, 16)
	ldw	r11, (r2, 20)
	ldw	r12, (r2, 24)
	ldw	r13, (r2, 28)
	ldw	r14, (r2, 32)
	/* r15 = pc before call __setjmp */
	ldw	r15, (r2, 4)

#if defined(__ck803__) || defined(__ck810__)
	ldw	r16, (r2, 36)
	ldw	r17, (r2, 40)
	ldw	r18, (r2, 44)
	ldw	r19, (r2, 48)

	ldw	r26, (r2, 52)
	ldw	r27, (r2, 56)
	ldw	r28, (r2, 60)
	ldw	r29, (r2, 64)
	ldw	r30, (r2, 68)
	ldw	r31, (r2, 72)
#endif

	ldw	r0, (r2, 0)
	mov 	r2, r3
	cmpnei	r3, 0
	bt	1f
	movi	r2, 1
1:
	rts
libc_hidden_def(__longjmp)
#endif
