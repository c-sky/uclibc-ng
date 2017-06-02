/* Copyright (C) 1991, 1992 Free Software Foundation, Inc.

This file is part of the GNU C Library.

The GNU C Library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public License as
published by the Free Software Foundation; either version 2 of the
License, or (at your option) any later version.

The GNU C Library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with the GNU C Library; see the file COPYING.LIB.  If
not, write to the Free Software Foundation, Inc., 675 Mass Ave,
Cambridge, MA 02139, USA.  */

/*
 *	NOTE: this file works for PIC and non-PIC code.  Be very careful how
 *	you modify it !
 */

#include <features.h>
 .text
.global	_start
.type   _start,%function
.global __exit
.global atexit

#if defined(__UCLIBC_CTOR_DTOR__)
.global   _init
.global   _fini
#endif

.global   main
.global   __uClibc_main


	
/* put here so that references to _start work with elf-PIC */
_start:
        /*
         *	argc, argv and envp are on the stack,  just call to main
         */
#ifdef __PIC__
        grs     gb, .Lgetpc
.Lgetpc:
        lrw     a0, .Lgetpc@GOTPC
        addu    gb, gb, a0 
        lrw     a0, main@GOT
        ldr.w   a0, (gb, a0 << 0)
        ldw     a1, (sp)
        mov     a2, sp
        addi    a2, 4

	mov	a3, sp
        subi    sp, sp, 0x10
	stw	a3, (sp, 0x8)
#if defined(__UCLIBC_CTOR_DTOR__)
        lrw     a3, _init@GOT
        ldr.w   a3, (gb, a3 << 0)
        lrw     t0, _fini@GOT
        ldr.w   t0, (gb, t0 << 0)
        stw     t0, (sp)
        stw     r7, (sp, 4)
#else
        movi    a3, 0
        stw     a3, (sp)
        stw     a3, (sp, 4)
#endif
        lrw     t1,  __uClibc_main@PLT
        ldr.w   t1, (gb, t1 << 0)
        jsr     t1

        bsr     __exit
#else   // __PIC__
        lrw	a0, main
        ldw     a1, (sp)
#ifdef __ARCH_USE_MMU__
        mov     a2, sp
        addi	a2, 4
#else
        /*
         * uClinux/csky stacks look a little different from normal
         * MMU-full Linux/csky stacks (for no good reason)
         */
        /* pull argv off the stack. */
        ldw     a2, (sp, 4)	
#endif

	mov	a3, sp
	subi	sp, sp, 0x10
	stw	a3, (sp, 0x8)
#if defined(__UCLIBC_CTOR_DTOR__)
	lrw	a3, _init
        lrw	l0, _fini
        stw     l0, (sp)
        stw     r7, (sp, 4)
#else
	movi    a3, 0
        stw     a3, (sp)
        stw     a3, (sp, 4)
#endif
        jsri    __uClibc_main

        jsri __exit
	/* If that didn't kill us, ... */
#endif
__exit:
        movi l3, 1   /* __NR_exit */
        trap 0

/*
 *	this was needed for gcc/g++-builds,  atexit was not getting included
 *	for some stupid reason,  this gets us a compiler
 */
/*empty_func:
	rts
#if defined(__HAVE_ELF__)
	.weak atexit
	atexit = empty_func
#else
	.set atexit,empty_func
#endif
*/  /* we need not use this function, because atexit define in other file! */
