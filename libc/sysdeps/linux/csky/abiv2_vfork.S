
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
	SAVE_PID
        /* You should save r15, if you call a function. */
	mov     t0, l3
	lrw     l3, __NR_vfork          /* Set syscall number */
	trap    0
	RESTORE_PID
	mov     l3, t0
	btsti	a0, 31
	bt      fix_errno
	rts
fix_errno:
	subi	sp, 16
	stw	gb, (sp, 0x0)
	stw	lr, (sp, 0x4)
	stw	a0, (sp, 0x8)
#ifdef __PIC__
	grs     t1, .Lgetpc
.Lgetpc:
	lrw     gb, .Lgetpc@GOTPC
	addu    t1, t1, gb
	lrw     t0, __errno_location@PLT
	addu	t0, t1
	jsr	r7
#else
	jsri	__errno_location
#endif
	ldw	a1, (sp, 0x8)
	not	a1                    /* invert a1 */
	addi	a1, 1
	stw	a1, (a0)
	bmaski	a0, 0
	ldw	lr, (sp, 0x4)
	ldw	gb, (sp, 0x0)
	addi	sp, 16
	rts

//.size __vfork,.-__vfork
weak_alias(__vfork,vfork)
libc_hidden_weak(vfork)

