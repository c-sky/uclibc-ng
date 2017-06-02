
/* Copyright (C) 2002, David McCullough <davidm@snapgear.com> */
/* This file is released under the LGPL, any version you like */

#ifndef _BITS_SETJMP_H
#define _BITS_SETJMP_H	1

#if !defined _SETJMP_H  && !defined _PTHREAD_H
# error "Never include <bits/setjmp.h> directly; use <setjmp.h> instead."
#endif

#ifndef	_ASM

typedef struct
  {
    unsigned long __sp;       	/* the return stack address */
    unsigned long __pc;       	/* pc: r15, is the return address */
    /*
     * ABIV1,CPUV1 is r8~r14
     * ABIV1,CPUV2 is r8~r14, r16~r19, r26~r31
     * ABIV2,CPUV2 is r4~r11, r16~r17, r26~r31
     */
    unsigned long __regs[16];
  } __jmp_buf[1];

#endif /* _ASM */

#define JB_REGS   0
#define JB_PC     4 

#define JB_SIZE   72

/* Test if longjmp to JMPBUF would unwind the frame
   containing a local variable at ADDRESS.  */
#define _JMPBUF_UNWINDS(jmpbuf, address) \
  ((void *) (address) < (void *) (jmpbuf)[0].__sp)


#endif /* _BITS_SETJMP_H */
