#ifdef __CSKYABIV2__
#include <abiv2_vfork.S>
#else
#include <asm/unistd.h>

#ifndef SAVE_PID
#define SAVE_PID
#endif

#ifndef RESTORE_PID
#define RESTORE_PID
#endif

#ifndef __NR_vfork
#define __NR_vfork __NR_fork /* uClinux-2.0 only has fork which is vfork */
#endif

#define IMM #

	.text
	.align 2
//	.globl errno
//	.globl vfork
	.globl __vfork
//#if defined __HAVE_ELF__
//	.type	 vfork,@function
	.type	 __vfork,@function
//#endif
//vfork:
__vfork:
	/* You should save r15, if you call a function. */
	SAVE_PID
	lrw     r1, __NR_vfork          /* Set syscall number */
	trap	0
	RESTORE_PID
	movi	r7, 125
	not     r7
	cmphs 	r2, r7
	bt      fix_errno
	rts
fix_errno:
	subi	sp, 16
	stw	gb, (sp, 0x0)
	stw	lr, (sp, 0x4)
	stw	r2, (sp, 0x8)
#ifdef __PIC__
	bsr     1f
1:
	lrw	gb, 1b@GOTPC
	add	gb, lr
	lrw	r7, __errno_location@PLT
	add	r7, gb
	jsr	r7
#else
	jsri	__errno_location
#endif
	ldw	r6, (sp, 0x8)
	rsubi	r6, 0
	stw	r6, (r2)
	bmaski	r2, 0
	ldw     lr, (sp, 0x4)
	ldw     gb, (sp, 0x0)
	addi	sp, 8
	rts

//.size __vfork,.-__vfork
weak_alias(__vfork,vfork)
libc_hidden_weak(vfork)
#endif
