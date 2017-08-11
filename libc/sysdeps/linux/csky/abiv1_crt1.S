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
        bsr .Lgetpc
.Lgetpc:
        lrw     gb, .Lgetpc@GOTPC
        addu    gb, r15
        lrw     r2, main@GOT
        addu    r2, gb
        ldw     r2, (r2)
        ldw     r3, (r0)
        mov     r4, r0
        addi    r4, 4

        mov	    r6, r0     /* push stack_end */
        subi    r0, 8
        st.w    r6, (r0)

#if defined(__UCLIBC_CTOR_DTOR__)
        lrw     r5, _init@GOT
        addu    r5, gb
        ldw     r5, (r5)
        lrw     r6, _fini@GOT
        addu    r6, gb
        ldw     r6, (r6)
#else
        movi    r5, 0
        movi    r6, 0
        movi    r7, 0
#endif
        lrw     r13,  __uClibc_main@PLT
        addu    r13, gb
        ldw     r13, (r13)
        jsr     r13

        bsr     __exit
#else  /* ! __PIC__ */
        lrw	r2, main
        ldw     r3, (r0)

        mov     r4, r0
        addi	r4, 4

        mov	    r6, r0     /* push stack_end */
        subi    r0, 8
        st.w	r6, (r0)

#if defined(__UCLIBC_CTOR_DTOR__)
        lrw	r5, _init
        lrw	r6, _fini
#else
        movi	r5, 0
        movi	r6, 0
        movi	r7, 0
#endif
        jsri    __uClibc_main

        jsri __exit
	/* If that didn't kill us, ... */
#endif
__exit:
        movi r1, 1   /* __NR_exit */
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
