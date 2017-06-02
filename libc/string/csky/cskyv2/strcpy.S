/*
 * Copyright (C) 2011     Hangzhou C-SKY
 *
 * Licensed under the LGPL v2.1, see the file COPYING.LIB in this tarball.
 */


#include <features.h>
#include <endian.h>

#ifdef WANT_WIDE
# define Wstrcpy wcscpy
#else
# define Wstrcpy strcpy
#endif

	.align 2
	.global Wstrcpy
	.type   Wstrcpy, @function
Wstrcpy:


        mov     r6, r2
        or      r5, r3, r6
        andi    r7, r5, 3
        jbez    r7, 2f
        movi    r7, 0
       1:
        ldr.b   r5, (r3, r7<<0)
        str.b   r5, (r6, r7<<0)
        addi    r7, r7, 1
        jbnez   r5, 1b

        jmp     r15

       2:
        ldw     r5, (r3)
        tstnbz  r5
        bf      11f
        stw     r5, (r6)

        ldw     r5, (r3, 4)
        tstnbz  r5
        bf      4f
        stw     r5, (r6, 4)

        ldw     r5, (r3, 8)
        tstnbz  r5
        bf      5f
        stw     r5, (r6, 8)

        ldw     r5, (r3, 12)
        tstnbz  r5
        bf      6f
        stw     r5, (r6, 12)

        ldw     r5, (r3, 16)
        tstnbz  r5
        bf      7f
        stw     r5, (r6, 16)

        ldw     r5, (r3, 20)
        tstnbz  r5
        bf      8f
        stw     r5, (r6, 20)

        ldw     r5, (r3, 24)
        tstnbz  r5
        bf      9f
        stw     r5, (r6, 24)

        ldw     r5, (r3, 28)
        tstnbz  r5
        bf      10f
        stw     r5, (r6, 28)

        addi     r6, 32
        addi     r3, 32
        br       2b


       4:
        addi    r6, 4
        br      11f

       5:
        addi    r6, 8
        br      11f

       6:
        addi    r6, 12
        br      11f

       7:
        addi    r6, 16
        br      11f

       8:
        addi    r6, 20
        br      11f

       9:
        addi    r6, 24
        br      11f

       10:
        addi    r6, 28

       11:
#ifdef __CSKYBE__
        xtrb0   r1, r5
        st.b    r1, (r6)
        jbez    r1, 5f
        xtrb1   r1, r5
        st.b    r1, (r6, 1)
        jbez    r1, 5f
        xtrb2   r1, r5
        st.b    r1, (r6, 2 )
        jbez    r1, 5f
        stw     r5, (r6)
#else
        xtrb3   r1, r5
        st.b    r1, (r6)
        jbez    r1, 5f
        xtrb2   r1, r5
        st.b    r1, (r6, 1)
        jbez    r1, 5f
        xtrb1   r1, r5
        st.b    r1, (r6, 2)
        jbez    r1, 5f
        stw     r5, (r6)
#endif
       5:
        jmp     r15    


libc_hidden_def(Wstrcpy)
.weak Wstrcpy
