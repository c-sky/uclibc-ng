
/* Copyright (C) 2002, David McCullough <davidm@snapgear.com> */
/* This file is released under the LGPL, any version you like */

#define _ASM
#define _SETJMP_H
#include <bits/setjmp.h>

.globl setjmp;
.type  setjmp,@function
.align 4;

setjmp:
        /* r14 = sp before call __sigsetjmp,
         * so we need save sp */
        stw    r14, (a0, 0)

        push   r15
        /*  r15 = pc before call __sigsetjmp,
         * so we need save pc */
        stw    r15, (a0, 4)

        stw    r4, (a0, 8)
        stw    r5, (a0, 12)
        stw    r6, (a0, 16)
        stw    r7, (a0, 20)
        stw    r8, (a0, 24)
        stw    r9, (a0, 28)
        stw    r10, (a0, 32)
        stw    r11, (a0, 36)

#ifndef __ck802__
        stw    r16, (a0, 40)
        stw    r17, (a0, 44)

        stw    r26, (a0, 48)
        stw    r27, (a0, 52)
        stw    r28, (a0, 56)
        stw    r29, (a0, 60)
        stw    r30, (a0, 64)
        stw    r31, (a0, 68)
#endif

#ifdef __PIC__
        /* Use a3 instead gb to avoid save gb in this function */
        grs     a3, .Lgetpc
.Lgetpc:
        lrw     a2, .Lgetpc@GOTPC
        addu    a3, a3, a2   
        lrw     a2, __sigjmp_save@PLT
        ldr.w   a2, (a3, a2 << 0)
        jsr     a2
#else
        jbsr    __sigjmp_save
#endif
        pop    r15
