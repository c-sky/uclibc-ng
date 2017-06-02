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

#include <features.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/syscall.h>


long syscall(long sysnum, long a, long b, long c, long d, long e, long f)
{
    register long _l3 __asm__("l3")=(long)(sysnum);
    register long _l1 __asm__("l1")=(long)(f);
    register long _l0 __asm__("l0")=(long)(e);
    register long _a3 __asm__("a3")=(long)(d);
    register long _a2 __asm__("a2")=(long)(c);
    register long _a1 __asm__("a1")=(long)(b);
    register long _a0 __asm__("a0")=(long)(a);
    __asm__ volatile(
	    "trap 0"
	    : "=r"(_a0)
	    : "r"(_l3), "r"(_a0), "r"(_a1), "r"(_a2), 
              "r"(_a3), "r"(_l0), "r"(_l1)
	    : "memory");
    if(_a0 >=(unsigned long) -4095) {
        register long __err = _a0;
        (*__errno_location()) = (-__err);
        _a0 = (unsigned long) -1;
    }
    return (long) _a0;
}

