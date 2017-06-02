#if defined ( __ck802__ )
.macro M_BEZ rx, label
       cmpnei \rx, 0
       bf     \label
.endm
.macro M_BNEZ rx, label
      cmpnei \rx, 0
      bt     \label 
.endm
#else
.macro M_BEZ rx, label
      bez  \rx, \label
.endm
.macro M_BNEZ rx, label
      bnez \rx, \label
.endm
#endif

.macro M_BNE rx, ry, label
      cmpne \rx, \ry
      bt    \label
.endm


