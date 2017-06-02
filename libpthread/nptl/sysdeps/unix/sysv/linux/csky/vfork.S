/* Copyright (C) 2005, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library.  If not, see
   <http://www.gnu.org/licenses/>.  */

#include <tcb-offsets.h>
#include <tls.h>

/* Save the PID value.  */
#define SAVE_PID \
	READ_THREAD_POINTER()						\
	lrw	a3, PID_OFFSET;		/* PID_OFFSET is less then 0 */	\
	add	a3, a0;							\
	ldw	a2, (a3);		/* Load the saved PID */	\
	movi	a1, 0;			/* Negate it */			\
	sub	a1, a2;							\
	cmpnei	a1, 0;							\
	lrw	a0, 0x80000000;						\
	movf	a1, a0;			/* use 0x80000000 if it was 0*/	\
	stw	a1, (a3);		/* Store the temporary PID */	\

/* Restore the old PID value in the parent.  */				
#define RESTORE_PID \
	cmpnei	a0, 0;			/* If we are the parent... */	\
	bf	1f;							\
	stw	a2, (a3);		/* ... restore the saved PID */	\
1:

#include <../../../../../../../libc/sysdeps/linux/csky/vfork.S>
