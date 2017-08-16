.file  "initfini.c"
  
.section .init
.globl _init
.type _init, @function
.align 2
_init:
  subi sp, 8
  stw  lr, (sp, 4)

.section .fini
.globl  _fini
.type _fini, @function
.align  2
_fini:
  subi sp, 8
  stw  lr, (sp, 4)

