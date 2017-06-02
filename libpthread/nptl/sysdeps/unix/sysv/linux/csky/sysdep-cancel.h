/* Copyright (C) 2002, 2003 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Contributed by Andreas Schwab <schwab@suse.de>, 2002.

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

#include <sysdep.h>
#include <tls.h>
#ifndef __ASSEMBLER__
#include <pthreadP.h>
#endif

#if !defined NOT_IN_libc || defined IS_IN_libpthread || defined IS_IN_librt
/*
 * FIXME: get gb 
 */
# ifdef __PIC__

#define __GET_GB  \
           bsr 1f; 1: lrw gb, 1b@GOTPC; addu gb, lr;

#  define __JSR(symbol)    \
           lrw a2, symbol@PLT; add a2, gb; ld.w a2, (a2); jsr a2;


/*
 *  cannot use jmp a2, when lazy, a2 is point to plt, which
 *        using gb without caculating it
 */
#  define PSEUDO_ERRJMP  \
           subi sp, 8; st.w lr, (sp); st.w gb, (sp, 4);         \
           __GET_GB            \
           lrw a2, __syscall_error@PLT; add a2, gb; ld.w a2, (a2);  \
           jsr a2;                                      \
           ld.w lr, (sp); ld.w gb, (sp, 4); addi sp, 8;         \
           rts;

# else

#  define __GET_GB
#  define PSEUDO_ERRJMP jmpi __syscall_error;
#  define __JSR(symbol) jsri symbol;

# endif

# ifdef __CSKYABIV2__

#  undef PSEUDO
#  define PSEUDO(name, syscall_name, args)                                    \
   .section ".text";                                                          \
   99: PSEUDO_ERRJMP                                                          \
   .type __##syscall_name##_nocancel,@function;                               \
   .globl __##syscall_name##_nocancel;                                        \
   __##syscall_name##_nocancel:                                               \
     DO_CALL (syscall_name, args);                                            \
     btsti   a0, 31;                                                          \
     bt      99b;                                                             \
     rts;                                                                      \
   .size __##syscall_name##_nocancel,.-__##syscall_name##_nocancel;           \
   ENTRY (name);                                                              \
     cfi_startproc;                                                           \
     SINGLE_THREAD_P;                                                         \
     bt .Lpseudo_cancel;                                                      \
     cfi_remember_state;                                                      \
     DO_CALL (syscall_name, args);                                            \
     btsti   a0, 31;                                                          \
     bt      99b;                                                             \
     rts;                                                                      \
     cfi_restore_state;                                                       \
   .Lpseudo_cancel:                                                           \
     DOCARGS_##args; /* save syscall args etc. around CENABLE.  */            \
     __GET_GB                                                                 \
     CENABLE;                                                                 \
     mov t0, a0;       /* put mask in safe place.  */                         \
     UNDOCARGS_##args;   /* restore syscall args.  */                         \
     DO_CALL_2 (syscall_name, args);        /* do the call.  */               \
     mov r7, a0;                                                              \
     mov a0, t0;     /* get mask back.  */                                    \
     CDISABLE;                                                                \
     mov a0, r7;                                                              \
     RESTORE_LR                                                               \
     btsti   a0, 31;                                                          \
     bt      99b;							      \
     rts;                                                                     \
     cfi_endproc

/*
   DOCARGS_x:   save syscall argments and lr/r7, and ajust sp 
   UNDOCARGS_x; restore syscall argments, and ajust sp
   RESTORE_LR:  restore lr/r7, and ajust sp 
 */

#  define _DOCARGS_0(n)		\
	stw r7, (sp, n); .cfi_offset 7, -16;			\
	stw lr, (sp, 4 + n);.cfi_offset 15, -12; 		\
	stw gb, (sp, n + 8);.cfi_offset 28, -8;
#  define _UNDOCARGS_0(n)

#  define RESTORE_LR	ldw r7, (sp); ldw lr, (sp, 4); ldw gb, (sp, 8); addi sp, 16; 

#  define _DOCARGS_2(n)		stw a0, (sp, n); stw a1, (sp, 4 + n);\
     			_DOCARGS_0(8 + n)
#  define _UNDOCARGS_2(n)	_UNDOCARGS_0(8 + n)    \
     			ldw a0, (sp, n); ldw a1, (sp, 4 + n);

#  define _DOCARGS_4(n)		stw a2, (sp, n); stw a3, (sp, 4 + n);\
     			_DOCARGS_2(8 + n)
#  define _UNDOCARGS_4(n)	_UNDOCARGS_2(8 + n)    \
     			ldw a2, (sp, n); ldw a3, (sp, 4 + n);

#  define _DOCARGS_6(n)		stw l0, (sp, n); stw l1, (sp, 4 + n);\
     			_DOCARGS_4(8 + n)
#  define _UNDOCARGS_6(n)	_UNDOCARGS_4(8 + n)    \
     			ldw l0, (sp, n); ldw l1, (sp, 4 + n);

#  define DOCARGS_0     subi sp, 16; .cfi_def_cfa_offset 16; _DOCARGS_0(0)
#  define UNDOCARGS_0	_UNDOCARGS_0(0);

#  define DOCARGS_1     subi sp, (8 + 16);.cfi_def_cfa_offset 24;	\
			stw a0, (sp);  _DOCARGS_0(8)
#  define UNDOCARGS_1	_UNDOCARGS_0(8)    \
                         ldw a0, (sp); addi sp, 8;.cfi_adjust_cfa_offset -8;

#  define DOCARGS_2     subi sp, (8 + 16);.cfi_def_cfa_offset 24;       \
			 _DOCARGS_2(0)
#  define UNDOCARGS_2	_UNDOCARGS_2(0); addi sp, 8;.cfi_adjust_cfa_offset -8;

#  define DOCARGS_3     subi sp, (16 + 16);.cfi_def_cfa_offset 32;       \
			 stw a2, (sp); _DOCARGS_2 (8)
#  define UNDOCARGS_3	_UNDOCARGS_2(8); ldw a2 , (sp); addi sp, 16;	\
			.cfi_adjust_cfa_offset -16;

#  define DOCARGS_4     subi sp, (16 + 16);.cfi_def_cfa_offset 32;       \
			  _DOCARGS_4 (0)
#  define UNDOCARGS_4	_UNDOCARGS_4(0); addi sp, 16;.cfi_adjust_cfa_offset -16;

#  define DOCARGS_5     subi sp, 24;.cfi_def_cfa_offset 24;             \
                        subi sp, 16;.cfi_adjust_cfa_offset 16;             \
			stw l0, (sp); _DOCARGS_4 (8)
#  define UNDOCARGS_5	_UNDOCARGS_4(8); ldw l0 , (sp); addi sp, 24;    \
			.cfi_adjust_cfa_offset -24;

#  define DOCARGS_6	subi sp, 24;.cfi_def_cfa_offset 24;             \
                        subi sp, 16;.cfi_adjust_cfa_offset 16;             \
			_DOCARGS_6 (0)
#  define UNDOCARGS_6	_UNDOCARGS_6(0); addi sp, 24;.cfi_adjust_cfa_offset -24;

# else  /* __CSKYABIV2__: abiv1 */

#  undef PSEUDO
#  define PSEUDO(name, syscall_name, args)                                    \
   .section ".text";                                                          \
   99: PSEUDO_ERRJMP                                                          \
   .type __##syscall_name##_nocancel,@function;                               \
   .globl __##syscall_name##_nocancel;                                        \
   __##syscall_name##_nocancel:                                               \
     DO_CALL (syscall_name, args);                                            \
     btsti   a0, 31;                                                          \
     bt      99b;                                                             \
     rts;                                                                      \
   .size __##syscall_name##_nocancel,.-__##syscall_name##_nocancel;           \
   ENTRY (name);                                                              \
     cfi_startproc							      \
     DOARGS_##args;                                                           \
     SINGLE_THREAD_P;                                                         \
     bt  .Lpseudo_cancel;                                                     \
     cfi_remember_state;                                                      \
     DO_CALL (syscall_name, 0);                                               \
     UNDOARGS_##args;                                                         \
     btsti   a0, 31;                                                          \
     bt      99b;                                                             \
     rts;                                                                      \
     cfi_restore_state;                                                       \
   .Lpseudo_cancel:                                                           \
     DOCARGS_##args; /* save syscall args etc. around CENABLE.  */            \
     __GET_GB                                                                 \
     CENABLE;                                                                 \
     mov r9, a0;         /* put mask in safe place.  */                       \
     UNDOCARGS_##args;   /* restore syscall args.  */                         \
     lrw r1, SYS_ify (syscall_name);                                          \
     trap 0;          /* do the call.  */                                     \
     mov r1, a0;                                                              \
     mov a0, r9;      /* get mask back.  */                                   \
     mov r9, r1;                                                              \
     CDISABLE;                                                                \
     mov a0, r9;                                                              \
     RESTORE_LR                                                               \
     UNDOARGS_##args;                                                         \
     btsti   a0, 31;                                                          \
     bt      99b;							      \
     rts;                                                                      \
     cfi_endproc

/*
   DOCARGS_x:   save syscall argments and lr, and ajust sp 
   UNDOCARGS_x; restore syscall argments, and ajust sp
   RESTORE_LR:  restore lr, and ajust sp
 */

#  define RESTORE_LR	 ldw lr, (sp, 0); ldw r9, (sp, 4); ldw gb, (sp, 8); addi sp, 16;

#  define _DOCARGS_0(n)   stw lr, (sp, n); .cfi_offset 15, -16;      	\
			  stw r9, (sp, n + 4);.cfi_offset 9, -12;       \
			  stw gb, (sp, n + 8);.cfi_offset 14, -8;  
#  define _UNDOCARGS_0(n)   

#  define _DOCARGS_2(n)		stw a0, (sp, n); stw a1, (sp, 4 + n);\
     			_DOCARGS_0(8 + n)
#  define _UNDOCARGS_2(n)	_UNDOCARGS_0(8 + n)    \
     			ldw a0, (sp, n); ldw a1, (sp, 4 + n);

#  define _DOCARGS_4(n)		stw a2, (sp, n); stw a3, (sp, 4 + n);\
     			_DOCARGS_2(8 + n)
#  define _UNDOCARGS_4(n)	_UNDOCARGS_2(8 + n)    \
     			ldw a2, (sp, n); ldw a3, (sp, 4 + n);

#  define _DOCARGS_6(n)		stw a4, (sp, n); stw a5, (sp, 4 + n);\
     			_DOCARGS_4(8 + n)
#  define _UNDOCARGS_6(n)	_UNDOCARGS_4(8 + n)    \
     			ldw a4, (sp, n); ldw a5, (sp, 4 + n);

#  define DOCARGS_0     subi sp, (0 + 16);.cfi_def_cfa_offset 16; _DOCARGS_0(0)
#  define UNDOCARGS_0	_UNDOCARGS_0(0)

#  define DOCARGS_1     subi sp, (8 + 16);.cfi_def_cfa_offset 24;	\
			 stw a0, (sp); _DOCARGS_0(8)
#  define UNDOCARGS_1	_UNDOCARGS_0(8)    \
                         ldw a0, (sp); addi sp, 8;

#  define DOCARGS_2     subi sp, (8 + 16);.cfi_def_cfa_offset 24;       \
			 _DOCARGS_2(0)
#  define UNDOCARGS_2	_UNDOCARGS_2(0); addi sp, 8;.cfi_adjust_cfa_offset -8;

#  define DOCARGS_3     subi sp, (16 + 16);.cfi_def_cfa_offset 32;      \
			stw a2, (sp); _DOCARGS_2 (8)
#  define UNDOCARGS_3	_UNDOCARGS_2(8); ldw a2 , (sp); 		\
			addi sp, 16;.cfi_adjust_cfa_offset -16;

#  define DOCARGS_4     subi sp, (16 + 16);.cfi_def_cfa_offset 32;       \
			  _DOCARGS_4 (0)
#  define UNDOCARGS_4	_UNDOCARGS_4(0); addi sp, 16;.cfi_adjust_cfa_offset -16;

#  define DOCARGS_5     subi sp, 24;.cfi_def_cfa_offset 24;       	\
			subi sp, 16;.cfi_adjust_cfa_offset 16;		\
			stw a4, (sp); _DOCARGS_4 (8)
#  define UNDOCARGS_5	_UNDOCARGS_4(8); ldw a4 , (sp);			\
			 addi sp, 24;.cfi_adjust_cfa_offset -24;

#  define DOCARGS_6     subi sp, 24;.cfi_def_cfa_offset 24;             \
                        subi sp, 16;.cfi_adjust_cfa_offset 16;             \
			  _DOCARGS_6 (0)
#  define UNDOCARGS_6	_UNDOCARGS_6(0); addi sp, 24;.cfi_adjust_cfa_offset -24;

# endif /* __CSKYABIV2__ */

# ifdef IS_IN_libpthread
#  ifdef PIC
#   define CENABLE	__JSR( __pthread_enable_asynccancel )
#   define CDISABLE	__JSR( __pthread_disable_asynccancel )
#  else
#   define CENABLE	__JSR( __pthread_enable_asynccancel )
#   define CDISABLE	__JSR( __pthread_disable_asynccancel )
#  endif
# elif !defined NOT_IN_libc
#  ifdef PIC
#   define CENABLE	__JSR( __libc_enable_asynccancel )
#   define CDISABLE	__JSR( __libc_disable_asynccancel )
#  else
#   define CENABLE	__JSR( __libc_enable_asynccancel )
#   define CDISABLE	__JSR( __libc_disable_asynccancel )
#  endif
# else
#  ifdef PIC
#   define CENABLE	__JSR( __librt_enable_asynccancel )
#   define CDISABLE	__JSR( __librt_disable_asynccancel )
#  else 
#   define CENABLE	__JSR( __librt_enable_asynccancel )
#   define CDISABLE	__JSR( __librt_disable_asynccancel )
#  endif
# endif

# ifdef IS_IN_libpthread
#  define __local_multiple_threads __pthread_multiple_threads
# elif !defined NOT_IN_libc
#  define __local_multiple_threads __libc_multiple_threads
# elif defined IS_IN_librt
#  define __local_multiple_threads __librt_multiple_threads
# else
#  error Unsupported library
# endif

#  ifndef __ASSEMBLER__
# if defined IS_IN_libpthread || !defined NOT_IN_libc
extern int __local_multiple_threads attribute_hidden;
#    define SINGLE_THREAD_P __builtin_expect (__local_multiple_threads == 0, 1)
#  else
#   define SINGLE_THREAD_P                      \
     __builtin_expect (THREAD_GETMEM (THREAD_SELF,             \
                   header.multiple_threads) == 0, 1)
#  endif
# else
#  ifdef __CSKYABIV2__
#    define SINGLE_THREAD_P                \
        subi  sp, 8;                           \
        st.w  a0, (sp, 0);                           \
        st.w  a1, (sp, 4);                           \
        READ_THREAD_POINTER();                   \
        lrw   a1, MULTIPLE_THREADS_OFFSET;       \
        ldr.w a0, (a0, a1<<0);                          \
        cmpnei a0, 0;                            \
        ld.w a0, (sp, 0);                           \
        ld.w a1, (sp, 4);                           \
        addi sp, 8;   
#  else                        
#    define SINGLE_THREAD_P                \
        subi sp, 8;                           \
        st.w a0, (sp, 0);                           \
        st.w a1, (sp, 4);                           \
        READ_THREAD_POINTER();                   \
        lrw  a1, MULTIPLE_THREADS_OFFSET;       \
        addu a0, a1;                          \
        ld.w a0, (a0, 0);                          \
        cmpnei a0, 0;                            \
        ld.w a0, (sp, 0);                           \
        ld.w a1, (sp, 4);                           \
        addi sp, 8;                           
#  endif
# endif

#elif !defined __ASSEMBLER__

/* This code should never be used but we define it anyhow.  */
# define SINGLE_THREAD_P (1)

#endif
