#ifdef __CSKYABIV2__
#include <abiv2_bsd-_setjmp.S>
#else

.globl _setjmp;
.type  _setjmp,@function
.align 4;

_setjmp:
	/* r14 = sp before call __sigsetjmp,
	 * so we need save sp */
	stw     r0,  (r2, 0)

	subi    r0, 8
	stw     r15, (r0, 0)
	/*  r15 = pc before call __sigsetjmp,
	 * so we need save pc */
	stw     r15, (a0, 4)
	
	stw     r8,  (r2, 8)
	stw     r9,  (r2, 12)
	stw     r10, (r2, 16)
	stw     r11, (r2, 20)
	stw     r12, (r2, 24)
	stw     r13, (r2, 28)
	stw     r14, (r2, 32)

#if defined(__ck803__) || defined(__ck810__)
	stw     r16, (r2, 36)
	stw     r17, (r2, 40)
	stw     r18, (r2, 44)
	stw     r19, (r2, 48) 
	
	stw     r26, (r2, 52)
	stw     r27, (r2, 56)
	stw     r28, (r2, 60)
	stw     r29, (r2, 64)
	stw     r30, (r2, 68)
	stw     r31, (r2, 72)
#endif

#ifdef __PIC__
	bsr     .Lgetpc
.Lgetpc:
	lrw     r7, .Lgetpc@GOTPC
	addu    r7, r15   
	lrw     r6, __sigjmp_save@PLT
	addu    r6, r7
	ldw     r6, (r6)
	jsr     r6
#else
	jsri    __sigjmp_save
#endif
	ldw     r15, (r0, 0)
	addi    r0, 8
	rts

#endif
