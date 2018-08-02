/*
 * Copyright (C) 2017 Hangzhou C-SKY Microsystems co.,ltd.
 *
 * Licensed under the LGPL v2.1 or later, see the file COPYING.LIB
 * in this tarball.
 */
 
 #include "macro.S"
 
.text
.global memmove
.type memmove,%function
.align 4

memmove:
  M_BEZ	a2, .L5
	mov 	a5, a0
	cmplt	a5, a1
	bf	.L2
.L0:
	mov	a4, a1
	or  	a4, a5

	andi	a4, 3
	M_BEZ	a4, .L23
.L1:					//not aligend 
	ld.b	r1, (a1)
	st.b	r1, (a5)
	addi	a1, 1
	addi	a5, 1
	subi	a2, 1
	M_BNEZ	a2, .L1
	rts
.L2:					//d > s

	mov	a3, a5
	subu	a3, a1

	cmplt	a3, a2
	bf	.L0			//d - s > n		
					//d - s < n, d += n, s += n
	addu	a5, a2
	subi	a5, 1
	addu	a1, a2
	subi	a1, 1
.L3:
	ld.b	r1, (a1)
	st.b	r1, (a5)
	subi	a1, 1
	subi	a5, 1
	subi	a2, 1
	M_BNEZ	a2, .L3
.L5:
	rts
.L23:					//if aligned, load word each time
	cmplti  a2, 16
	bt 	.L20
.L14:					//out of order
	ld.w 	r1, (a1)
	ld.w 	a3, (a1, 4)
	ld.w 	a4, (a1, 8)
	st.w 	r1, (a5)
	ld.w 	r1, (a1, 12)
	st.w 	a3, (a5, 4)
	st.w 	a4, (a5, 8)
	st.w 	r1, (a5, 12)
	addi	a1, 16
	addi	a5, 16
	subi	a2, 16
	cmplti  a2, 16
	bf	.L14
.L20:
	cmplti  a2, 4
	bt	.L21
.L13:
	ld.w	a4, (a1)
	subi	a2, 4
	addi	a1, 4
	st.w 	a4, (a5)
	addi	a5, 4
	cmplti  a2, 4
	bf	.L13
.L21:
        M_BEZ   a2, .L5                  //must be needed, when n % 4 == 0
        ld.b    a3, (a1)
        st.b    a3, (a5)
        subi    a2, 1
        M_BEZ   a2, .L5

        ld.b    a3, (a1, 1)
        st.b    a3, (a5, 1)
        subi    a2, 1
        M_BEZ   a2, .L5

        ld.b    a3, (a1, 2)
        st.b    a3, (a5, 2)
        rts
        
.size memmove,.-memmove

libc_hidden_def(memmove)
