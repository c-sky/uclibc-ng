/* Assembler macros for CSKY.
   Copyright (C) 1997, 1998, 2003 Free Software Foundation, Inc.
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
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#ifndef _LINUX_CSKY_SYSDEP_H
#define _LINUX_CSKY_SYSDEP_H 1

#include <common/sysdep.h>
#include <sys/syscall.h>

/* For Linux we can use the system call table in the header file
	/usr/include/asm/unistd.h
   of the kernel.  But these symbols do not follow the SYS_* syntax
   so we have to redefine the `SYS_ify' macro here.  */
#undef SYS_ify
#define SYS_ify(syscall_name)	(__NR_##syscall_name)

#ifdef __ASSEMBLER__

/* Define an entry point visible from C.  */
#define ENTRY(name)                     \
  .globl name;                      \
  .type name, @function;                \
  .text;                              \
  .align 2;                     \
  name##:

#undef END
#define END(function)                   \
        .size   function,.-function

#define ret rts

#undef PSEUDO_END
#define PSEUDO_END(sym) .size sym,.-sym

#define PSEUDO_NOERRNO(name, syscall_name, args)    \
  .text;                              \
  .align 2;                     \
  ENTRY(name)                       \
  DO_CALL (syscall_name, args);

#undef PSEUDO_END_NOERRNO
#define PSEUDO_END_NOERRNO(sym) .size sym,.-sym

#define ret_NOERRNO ret

#define PSEUDO_ERRVAL(name, syscall_name, args)     \
  .text                              \
  .align 2;                     \
  ENTRY(name)                       \
  DO_CALL (syscall_name, args);

#undef PSEUDO_END_ERRVAL
#define PSEUDO_END_ERRVAL(sym) .size sym,.-sym

#define ret_ERRVAL ret

/* Linux takes system call args in registers:
    syscall number  in the trap instruction
    arg 1       r0
    arg 2       r1
    arg 3       r2
    arg 4       r3
    arg 5       r4  (this is different from the APCS convention)
    arg 6       r5
    arg 7       r6

   The compiler is going to form a call by coming here, through PSEUDO, with
   arguments
    syscall number  in the DO_CALL macro
    arg 1       r0
    arg 2       r1
    arg 3       r2
    arg 4       r3
    arg 5       [sp]
    arg 6       [sp+4]
    arg 7       [sp+8]

   We need to shuffle values between R4..R6 and the stack so that the
   caller's v1..v3 and stack frame are not corrupted, and the kernel
   sees the right arguments.

*/

#undef  DO_CALL

#ifdef __CSKYABIV2__
#define DO_CALL(syscall_name, args)     \
    DOARGS_##args               \
    subi sp, 4;                 \
    st.w r7, (sp, 0);               \
    lrw  r7, SYS_ify (syscall_name); \
    trap 0;                    \
    ld.w r7, (sp, 0);               \
    addi sp, 4;                 \
    UNDOARGS_##args 

#define DOARGS_0 /* nothing */
#define DOARGS_1 /* nothing */
#define DOARGS_2 /* nothing */
#define DOARGS_3 /* nothing */
#define DOARGS_4 /* nothing */
#define DOARGS_5 subi sp, 4;  st.w r4, (sp, 0); ld.w r4, (sp, 4);
#define DOARGS_6 subi sp, 8;  stm r4-r5, (sp);  ld.w r4, (sp, 8);  ld.w r5, (sp, 12);
#define DOARGS_7 subi sp, 12; stm r4-r6, (sp);  ld.w r4, (sp, 12); ld.w r5, (sp, 16); ld.w r6, (sp, 20);

#define UNDOARGS_0 /* nothing */
#define UNDOARGS_1 /* nothing */
#define UNDOARGS_2 /* nothing */
#define UNDOARGS_3 /* nothing */
#define UNDOARGS_4 /* nothing */
#define UNDOARGS_5 ld.w r4, (sp, 0); addi sp, 4;
#define UNDOARGS_6 ldm r4-r5, (sp);  addi sp, 8;
#define UNDOARGS_7 ldm r4-r6, (sp);  addi sp, 12;

#else  /* abiv1 */

#define DO_CALL(syscall_name, args)     \
    DOARGS_##args               \
    lrw  r1, SYS_ify (syscall_name); \
    trap 0;                    \
    UNDOARGS_##args

#define DOARGS_0 /* nothing */
#define DOARGS_1 /* nothing */
#define DOARGS_2 /* nothing */
#define DOARGS_3 /* nothing */
#define DOARGS_4 /* nothing */
#define DOARGS_5 /* nothing */
#define DOARGS_6 /* nothing */
#define DOARGS_7 subi sp, 8; st.w r8, (sp);  ld.w r8, (sp, 16); 

#define UNDOARGS_0 /* nothing */
#define UNDOARGS_1 /* nothing */
#define UNDOARGS_2 /* nothing */
#define UNDOARGS_3 /* nothing */
#define UNDOARGS_4 /* nothing */
#define UNDOARGS_5 /* nothing */
#define UNDOARGS_6 /* nothing */
#define UNDOARGS_7 ld r8, (sp);  addi sp, 8;

#endif
/* define DO_CALL_2, only ABIV2 need DO_CALL_2 */
#ifdef __CSKYABIV2__

#undef  DO_CALL_2
#define DO_CALL_2(syscall_name, args)           \
    DOARGS2_##args;                             \
    lrw  r7, SYS_ify(syscall_name);             \
    trap 0;                                     \
    UNDOARGS2_##args

/*
 * to be quite different with DO_CALL, DO_CALL_2 need not save r7.
 */
#undef  DOARGS2_0
#define DOARGS2_0    

#undef  DOARGS2_1
#define DOARGS2_1 DOARGS2_0
#undef  DOARGS2_2
#define DOARGS2_2 DOARGS2_0
#undef  DOARGS2_3
#define DOARGS2_3 DOARGS2_0
#undef  DOARGS2_4
#define DOARGS2_4 DOARGS2_0
#undef  DOARGS2_5
#define DOARGS2_5   \
  subi sp, 8;       \
  cfi_adjust_cfa_offset (8); \
  stw  r4, (sp, 0); \
  ldw  r4, (sp, 24)
#undef  DOARGS2_6
#define DOARGS2_6    \
  subi sp, 8;       \
  cfi_adjust_cfa_offset (8); \
  stw  r4, (sp, 0); \
  stw  r5, (sp, 4); \
  ldw  r4, (sp, 24); \
  ldw  r5, (sp, 28)

#undef  UNDOARGS2_0
#define UNDOARGS2_0 

#undef  UNDOARGS2_1
#define UNDOARGS2_1 UNDOARGS2_0
#undef  UNDOARGS2_2
#define UNDOARGS2_2 UNDOARGS2_0
#undef  UNDOARGS2_3
#define UNDOARGS2_3 UNDOARGS2_0
#undef  UNDOARGS2_4
#define UNDOARGS2_4 UNDOARGS2_0
#undef  UNDOARGS2_5
#define UNDOARGS2_5  \
  ldw  r4, (sp, 0); \
  addi sp, 8

#undef  UNDOARGS2_6
#define UNDOARGS2_6 \
  ldw  r4, (sp, 0); \
  ldw  r5, (sp, 4); \
  addi sp, 8

#endif  /* DO_CALL_2 */

#define SYSCALL_ERROR_LABEL __syscall_error

#else /* not __ASSEMBLER__ */

/* Define a macro which expands into the inline wrapper code for a system
   call.  */
#undef INLINE_SYSCALL
#define INLINE_SYSCALL(name, nr, args...)					\
  ({ unsigned int _inline_sys_result = INTERNAL_SYSCALL (name, , nr, args);	\
     if (__builtin_expect (INTERNAL_SYSCALL_ERROR_P (_inline_sys_result, ), 0))	\
       {									\
	 __set_errno (INTERNAL_SYSCALL_ERRNO (_inline_sys_result, ));		\
	 _inline_sys_result = (unsigned int) -1;				\
       }									\
     (int) _inline_sys_result; })

#undef INTERNAL_SYSCALL_DECL
#define INTERNAL_SYSCALL_DECL(err) do { } while (0)

#undef INTERNAL_SYSCALL_RAW
#ifndef __cskyabiv2__
#define INTERNAL_SYSCALL_RAW(name, err, nr, args...)                        \
  ({unsigned int __sys_result;                                          \
     {                                                                  \
       register int _a1 __asm__ ("a0"), _nr __asm__ ("r1");             \
       LOAD_ARGS_##nr (args)                                            \
       _nr = SYS_ify(name);                                             \
       __asm__ __volatile__ ("trap  0 \n\t"                             \
                             : "=r" (_a1)                               \
                             : "r" (_nr) ASM_ARGS_##nr                  \
                             : "memory");                               \
               __sys_result = _a1;                                      \
     }                                                                  \
     (int) __sys_result; })

#else /* __cskyabiv2__ */
#define INTERNAL_SYSCALL_RAW(name, err, nr, args...)                        \
  ({unsigned int __sys_result;                                          \
     {                                                                  \
       register int _a1 __asm__ ("a0"), _nr __asm__ ("r7");             \
       LOAD_ARGS_##nr (args)                                            \
       _nr = SYS_ify(name);                                             \
       __asm__ __volatile__ ("trap  0    \n\t"                          \
                             : "=r" (_a1)                               \
                             : "r" (_nr) ASM_ARGS_##nr                  \
                             : "memory");                               \
               __sys_result = _a1;                                      \
     }                                                                  \
     (int) __sys_result; })
#endif /* __ABI_CSKY_V2__ */

#undef INTERNAL_SYSCALL
#define INTERNAL_SYSCALL(name, err, nr, args...)		\
	INTERNAL_SYSCALL_RAW(name, err, nr, args)

#undef INTERNAL_SYSCALL_ERROR_P
#define INTERNAL_SYSCALL_ERROR_P(val, err) \
  ((unsigned int) (val) >= 0xfffff001u)

#undef INTERNAL_SYSCALL_ERRNO
#define INTERNAL_SYSCALL_ERRNO(val, err)	(-(val))

#endif  /* __ASSEMBLER__ */

/* Pointer mangling is not yet supported for CSKY.  */
#define PTR_MANGLE(var) (void) (var)
#define PTR_DEMANGLE(var) (void) (var)

#endif /* linux/csky/sysdep.h */
