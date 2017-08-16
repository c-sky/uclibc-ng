.file  "initfini.c"

.section .init
.globl _init
.type _init, @function
.align 2
  ldw  lr, (sp, 4)
  addi sp, 8
  rts

.section .fini
.align 2
.globl _fini
.type _fini, @function
  ldw lr, (sp, 4)
  addi    sp, 8
  rts
  
