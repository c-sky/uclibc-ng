/* syscall for csky/uClibc
 *
 * Copyright (C) 2002 by Erik Andersen <andersen@uclibc.org>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Library General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

#ifdef __CSKYABIV2__
#include "abiv2_syscall.c"
#else

#include <features.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/syscall.h>


long syscall(long sysnum, long a, long b, long c, long d, long e, long f)
{
    register long _r1 __asm__("r1")=(long)(sysnum);
    register long _r7 __asm__("r7")=(long)(f);
    register long _r6 __asm__("r6")=(long)(e);
    register long _r5 __asm__("r5")=(long)(d);
    register long _r4 __asm__("r4")=(long)(c);
    register long _r3 __asm__("r3")=(long)(b);
    register long _r2 __asm__("r2")=(long)(a);
    __asm__ volatile(
	    "trap 0"
	    : "=r"(_r2)
	    : "r"(_r1), "r"(_r2), "r"(_r3), "r"(_r4), 
              "r"(_r5), "r"(_r6), "r"(_r7)
	    : "memory");
    if(_r2 >=(unsigned long) -4095) {
        register long __err = _r2;
        (*__errno_location()) = (-__err);
        _r2 = (unsigned long) -1;
    }
    return (long) _r2;
}

#endif
