/*
 * Copyright (C) 2011     Hangzhou C-SKY
 *
 * Licensed under the LGPL v2.1, see the file COPYING.LIB in this tarball.
 */

#include <features.h>
#include <endian.h>

#ifdef WANT_WIDE
# define Wmemcpy wmemcpy
#else
# define Wmemcpy memcpy
#endif
	.text
	.align 2
	.global Wmemcpy
	.type   Wmemcpy, @function
Wmemcpy:
    mov     r7, r2
    or      r1, r3, r2
    andi    r6, r1, 3
    jbez    r6, .L23
    jbez    r4, .L5
.L11:
    ld.b    r5, (r3)
    addi    r3, r3, 1
    subi    r4, r4, 1
    st.b    r5, (r7)
    addi    r7, r7, 1
    jbnez   r4, .L11
.L5:
    jmp r15
.L23:
    cmplti  r4, 16
    jbt .L20
.L14:
    ldw     r1, (r3)
    ldw     r5, (r3, 4)
    ldw     r6, (r3, 8)
    stw     r1, (r7)
    ldw     r1, (r3, 12)
    stw     r5, (r7, 4)
    stw     r6, (r7, 8)
    stw     r1, (r7, 12)
    subi    r4, r4, 16
    addi    r3, r3, 16
    addi    r7, r7, 16
    cmplti  r4, 16
    jbf .L14
.L20:
    cmplti  r4, 4
    jbt .L21
.L13:
    ldw     r5, (r3)
    subi    r4, r4, 4
    addi    r3, r3, 4
    stw     r5, (r7)
    addi    r7, r7, 4
    cmplti  r4, 4
    jbf .L13
.L21:
    jbez    r4, .L5
    ld.b    r5, (r3)
    addi    r3, r3, 1
    subi    r4, r4, 1
    st.b    r5, (r7)
    addi    r7, r7, 1
    jbr .L21

    .size   Wmemcpy, .-Wmemcpy

libc_hidden_def(Wmemcpy)
.weak Wmemcpy
