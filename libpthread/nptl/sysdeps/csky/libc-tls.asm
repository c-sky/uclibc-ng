
libc-tls.o:     file format elf32-csky-little


Disassembly of section .text:

00000000 <init_slotinfo>:
TLS_INIT_HELPER
#endif

static inline void
init_slotinfo (void)
{
   0:	2470      	subi	r0, r0, 8
   2:	9800      	st	r8, (r0, 0)
   4:	1208      	mov	r8, r0
  /* Create the slotinfo list.  */
  static_slotinfo.si.len = (((char *) (&static_slotinfo + 1)
   6:	7707      	lrw	r7, 0x0	// from address pool at 0x24
   8:	6406      	movi	r6, 64
   a:	9607      	st	r6, (r7, 0)
			    / sizeof static_slotinfo.si.slotinfo[0]);
  // static_slotinfo.si.next = NULL;	already zero

  /* The slotinfo list.  Will be extended by the code doing dynamic
     linking.  */
  GL(dl_tls_max_dtv_idx) = 1;
   c:	7707      	lrw	r7, 0x0	// from address pool at 0x28
   e:	6016      	movi	r6, 1
  10:	9607      	st	r6, (r7, 0)
  GL(dl_tls_dtv_slotinfo_list) = &static_slotinfo.si;
  12:	7706      	lrw	r7, 0x0	// from address pool at 0x2c
  14:	7604      	lrw	r6, 0x0	// from address pool at 0x24
  16:	9607      	st	r6, (r7, 0)
}
  18:	1280      	mov	r0, r8
  1a:	8800      	ld	r8, (r0, 0)
  1c:	2070      	addi	r0, r0, 8
  1e:	00cf      	jmp	r15
  20:	f7ff      	br	0x20
  22:	f7ff      	br	0x22
	...

00000030 <init_static_tls>:

static inline void
init_static_tls (size_t memsz, size_t align)
{
  30:	24f0      	subi	r0, r0, 16
  32:	9820      	st	r8, (r0, 8)
  34:	1208      	mov	r8, r0
  36:	9208      	st	r2, (r8, 0)
  38:	9318      	st	r3, (r8, 4)
  /* That is the size of the TLS memory for this object.  The initialized
     value of _dl_tls_static_size is provided by dl-open.c to request some
     surplus that permits dynamic loading of modules with IE-model TLS.  */
  GL(dl_tls_static_size) = roundup (memsz + GL(dl_tls_static_size),
  3a:	770d      	lrw	r7, 0x0	// from address pool at 0x70
  3c:	8607      	ld	r6, (r7, 0)
  3e:	8708      	ld	r7, (r8, 0)
  40:	1c67      	addu	r7, r7, r6
  42:	20e7      	addi	r7, r7, 15
  44:	60f6      	movi	r6, 15
  46:	1275      	mov	r5, r7
  48:	1f65      	andn	r5, r5, r6
  4a:	1256      	mov	r6, r5
  4c:	7709      	lrw	r7, 0x0	// from address pool at 0x70
  4e:	9607      	st	r6, (r7, 0)
				    TLS_TCB_ALIGN);
  GL(dl_tls_static_used) = memsz;
  50:	7709      	lrw	r7, 0x0	// from address pool at 0x74
  52:	8608      	ld	r6, (r8, 0)
  54:	9607      	st	r6, (r7, 0)
  /* The alignment requirement for the static TLS block.  */
  GL(dl_tls_static_align) = align;
  56:	7708      	lrw	r7, 0x0	// from address pool at 0x78
  58:	8618      	ld	r6, (r8, 4)
  5a:	9607      	st	r6, (r7, 0)
  /* Number of elements in the static TLS block.  */
  GL(dl_tls_static_nelem) = GL(dl_tls_max_dtv_idx);
  5c:	7708      	lrw	r7, 0x0	// from address pool at 0x7c
  5e:	8607      	ld	r6, (r7, 0)
  60:	7708      	lrw	r7, 0x0	// from address pool at 0x80
  62:	9607      	st	r6, (r7, 0)
}
  64:	1280      	mov	r0, r8
  66:	8820      	ld	r8, (r0, 8)
  68:	20f0      	addi	r0, r0, 16
  6a:	00cf      	jmp	r15
  6c:	f7ff      	br	0x6c
  6e:	f7ff      	br	0x6e
	...

00000084 <__libc_setup_tls>:

void __libc_setup_tls (size_t tcbsize, size_t tcbalign);
void
__libc_setup_tls (size_t tcbsize, size_t tcbalign)
{
  84:	25f0      	subi	r0, r0, 32
  86:	9f60      	st	r15, (r0, 24)
  88:	9870      	st	r8, (r0, 28)
  8a:	25f0      	subi	r0, r0, 32
  8c:	1208      	mov	r8, r0
  8e:	92c8      	st	r2, (r8, 48)
  90:	93d8      	st	r3, (r8, 52)
  void *tlsblock;
  size_t memsz = 0;
  92:	6007      	movi	r7, 0
  94:	9708      	st	r7, (r8, 0)
  size_t filesz = 0;
  96:	6007      	movi	r7, 0
  98:	9718      	st	r7, (r8, 4)
  void *initimage = NULL;
  9a:	6007      	movi	r7, 0
  9c:	9728      	st	r7, (r8, 8)
  size_t align = 0;
  9e:	6007      	movi	r7, 0
  a0:	9738      	st	r7, (r8, 12)
  size_t max_align = tcbalign;
  a2:	87d8      	ld	r7, (r8, 52)
  a4:	9748      	st	r7, (r8, 16)
  size_t tcb_offset;
  ElfW(Phdr) *phdr;

  /* Look through the TLS segment if there is any.  */
  if (_dl_phdr != NULL)
  a6:	7766      	lrw	r7, 0x0	// from address pool at 0x240
  a8:	8707      	ld	r7, (r7, 0)
  aa:	2a07      	cmpnei	r7, 0
  ac:	e82b      	bf	0x104
    for (phdr = _dl_phdr; phdr < &_dl_phdr[_dl_phnum]; ++phdr)
  ae:	7764      	lrw	r7, 0x0	// from address pool at 0x240
  b0:	8707      	ld	r7, (r7, 0)
  b2:	9758      	st	r7, (r8, 20)
  b4:	f01c      	br	0xee
      if (phdr->p_type == PT_TLS)
  b6:	8758      	ld	r7, (r8, 20)
  b8:	8707      	ld	r7, (r7, 0)
  ba:	2a77      	cmpnei	r7, 7
  bc:	e015      	bt	0xe8
	{
	  /* Remember the values we need.  */
	  memsz = phdr->p_memsz;
  be:	8758      	ld	r7, (r8, 20)
  c0:	8757      	ld	r7, (r7, 20)
  c2:	9708      	st	r7, (r8, 0)
	  filesz = phdr->p_filesz;
  c4:	8758      	ld	r7, (r8, 20)
  c6:	8747      	ld	r7, (r7, 16)
  c8:	9718      	st	r7, (r8, 4)
	  initimage = (void *) phdr->p_vaddr;
  ca:	8758      	ld	r7, (r8, 20)
  cc:	8727      	ld	r7, (r7, 8)
  ce:	9728      	st	r7, (r8, 8)
	  align = phdr->p_align;
  d0:	8758      	ld	r7, (r8, 20)
  d2:	8777      	ld	r7, (r7, 28)
  d4:	9738      	st	r7, (r8, 12)
	  if (phdr->p_align > max_align)
  d6:	8758      	ld	r7, (r8, 20)
  d8:	8677      	ld	r6, (r7, 28)
  da:	8748      	ld	r7, (r8, 16)
  dc:	0c67      	cmphs	r7, r6
  de:	e011      	bt	0x102
	    max_align = phdr->p_align;
  e0:	8758      	ld	r7, (r8, 20)
  e2:	8777      	ld	r7, (r7, 28)
  e4:	9748      	st	r7, (r8, 16)
	  break;
  e6:	f00e      	br	0x104
  size_t tcb_offset;
  ElfW(Phdr) *phdr;

  /* Look through the TLS segment if there is any.  */
  if (_dl_phdr != NULL)
    for (phdr = _dl_phdr; phdr < &_dl_phdr[_dl_phnum]; ++phdr)
  e8:	8758      	ld	r7, (r8, 20)
  ea:	21f7      	addi	r7, r7, 32
  ec:	9758      	st	r7, (r8, 20)
  ee:	7754      	lrw	r7, 0x0	// from address pool at 0x240
  f0:	8607      	ld	r6, (r7, 0)
  f2:	7754      	lrw	r7, 0x0	// from address pool at 0x244
  f4:	8707      	ld	r7, (r7, 0)
  f6:	3c57      	lsli	r7, r7, 5
  f8:	1c76      	addu	r6, r6, r7
  fa:	8758      	ld	r7, (r8, 20)
  fc:	0c67      	cmphs	r7, r6
  fe:	efdb      	bf	0xb6
 100:	f001      	br	0x104
	  filesz = phdr->p_filesz;
	  initimage = (void *) phdr->p_vaddr;
	  align = phdr->p_align;
	  if (phdr->p_align > max_align)
	    max_align = phdr->p_align;
	  break;
 102:	1e00      	or	r0, r0, r0
     IE-model TLS.  */
# if defined(TLS_TCB_AT_TP)
  tcb_offset = roundup (memsz + GL(dl_tls_static_size), tcbalign);
  tlsblock = sbrk (tcb_offset + tcbsize + max_align);
# elif defined(TLS_DTV_AT_TP)
  tcb_offset = roundup (tcbsize, align ?: 1);
 104:	8738      	ld	r7, (r8, 12)
 106:	2a07      	cmpnei	r7, 0
 108:	e802      	bf	0x10e
 10a:	2407      	subi	r7, r7, 1
 10c:	f001      	br	0x110
 10e:	6007      	movi	r7, 0
 110:	86c8      	ld	r6, (r8, 48)
 112:	1c76      	addu	r6, r6, r7
 114:	8738      	ld	r7, (r8, 12)
 116:	2a07      	cmpnei	r7, 0
 118:	e801      	bf	0x11c
 11a:	f001      	br	0x11e
 11c:	6017      	movi	r7, 1
 11e:	1271      	mov	r1, r7
 120:	2c16      	divu	r6, r6, r1
 122:	8738      	ld	r7, (r8, 12)
 124:	2a07      	cmpnei	r7, 0
 126:	e801      	bf	0x12a
 128:	f001      	br	0x12c
 12a:	6017      	movi	r7, 1
 12c:	0367      	mult	r7, r7, r6
 12e:	9768      	st	r7, (r8, 24)
  tlsblock = sbrk (tcb_offset + memsz + max_align
 130:	8668      	ld	r6, (r8, 24)
 132:	8708      	ld	r7, (r8, 0)
 134:	1c76      	addu	r6, r6, r7
 136:	8748      	ld	r7, (r8, 16)
 138:	1c76      	addu	r6, r6, r7
		     + TLS_PRE_TCB_SIZE + GL(dl_tls_static_size));
 13a:	7743      	lrw	r7, 0x0	// from address pool at 0x248
 13c:	8707      	ld	r7, (r7, 0)
 13e:	1c67      	addu	r7, r7, r6
 140:	6506      	movi	r6, 80
 142:	34a6      	bseti	r6, r6, 10
 144:	1c67      	addu	r7, r7, r6
# if defined(TLS_TCB_AT_TP)
  tcb_offset = roundup (memsz + GL(dl_tls_static_size), tcbalign);
  tlsblock = sbrk (tcb_offset + tcbsize + max_align);
# elif defined(TLS_DTV_AT_TP)
  tcb_offset = roundup (tcbsize, align ?: 1);
  tlsblock = sbrk (tcb_offset + memsz + max_align
 146:	1272      	mov	r2, r7
 148:	7f41      	jsri	0x0	// from address pool at 0x24c
 14a:	9278      	st	r2, (r8, 28)
		     + TLS_PRE_TCB_SIZE + GL(dl_tls_static_size));
  tlsblock += TLS_PRE_TCB_SIZE;
 14c:	8778      	ld	r7, (r8, 28)
 14e:	6501      	movi	r1, 80
 150:	34a1      	bseti	r1, r1, 10
 152:	1c17      	addu	r7, r7, r1
 154:	9778      	st	r7, (r8, 28)
     is defined add another #elif here and in the following #ifs.  */
#  error "Either TLS_TCB_AT_TP or TLS_DTV_AT_TP must be defined"
# endif

  /* Align the TLS block.  */
  tlsblock = (void *) (((uintptr_t) tlsblock + max_align - 1)
 156:	8678      	ld	r6, (r8, 28)
 158:	8748      	ld	r7, (r8, 16)
 15a:	1c67      	addu	r7, r7, r6
 15c:	1276      	mov	r6, r7
 15e:	2406      	subi	r6, r6, 1
		       & ~(max_align - 1));
 160:	8748      	ld	r7, (r8, 16)
 162:	2807      	rsubi	r7, r7, 0
 164:	1667      	and	r7, r7, r6
     is defined add another #elif here and in the following #ifs.  */
#  error "Either TLS_TCB_AT_TP or TLS_DTV_AT_TP must be defined"
# endif

  /* Align the TLS block.  */
  tlsblock = (void *) (((uintptr_t) tlsblock + max_align - 1)
 166:	9778      	st	r7, (r8, 28)
		       & ~(max_align - 1));

  /* Initialize the dtv.  [0] is the length, [1] the generation counter.  */
  static_dtv[0].counter = (sizeof (static_dtv) / sizeof (static_dtv[0])) - 2;
 168:	773a      	lrw	r7, 0x0	// from address pool at 0x250
 16a:	63e6      	movi	r6, 62
 16c:	9607      	st	r6, (r7, 0)
# if defined(TLS_TCB_AT_TP)
  static_dtv[2].pointer.val = ((char *) tlsblock + tcb_offset
			       - roundup (memsz, align ?: 1));
  static_map.l_tls_offset = roundup (memsz, align ?: 1);
# elif defined(TLS_DTV_AT_TP)
  static_dtv[2].pointer.val = (char *) tlsblock + tcb_offset;
 16e:	8678      	ld	r6, (r8, 28)
 170:	8768      	ld	r7, (r8, 24)
 172:	1c76      	addu	r6, r6, r7
 174:	7737      	lrw	r7, 0x0	// from address pool at 0x250
 176:	9647      	st	r6, (r7, 16)
  static_map.l_tls_offset = tcb_offset;
 178:	8668      	ld	r6, (r8, 24)
 17a:	7736      	lrw	r7, 0x0	// from address pool at 0x254
 17c:	96a7      	st	r6, (r7, 40)
# else
#  error "Either TLS_TCB_AT_TP or TLS_DTV_AT_TP must be defined"
# endif
  static_dtv[2].pointer.is_static = true;
 17e:	7734      	lrw	r7, 0x0	// from address pool at 0x250
 180:	2137      	addi	r7, r7, 20
 182:	6016      	movi	r6, 1
 184:	b607      	stb	r6, (r7, 0)
  /* sbrk gives us zero'd memory, so we don't need to clear the remainder.  */
  memcpy (static_dtv[2].pointer.val, initimage, filesz);
 186:	7732      	lrw	r7, 0x0	// from address pool at 0x250
 188:	8747      	ld	r7, (r7, 16)
 18a:	1272      	mov	r2, r7
 18c:	8328      	ld	r3, (r8, 8)
 18e:	8418      	ld	r4, (r8, 4)
 190:	7f32      	jsri	0x0	// from address pool at 0x258
# if defined(TLS_TCB_AT_TP)
  INSTALL_DTV ((char *) tlsblock + tcb_offset, static_dtv);

  const char *lossage = TLS_INIT_TP ((char *) tlsblock + tcb_offset, 0);
# elif defined(TLS_DTV_AT_TP)
  INSTALL_DTV (tlsblock, static_dtv);
 192:	8778      	ld	r7, (r8, 28)
 194:	7632      	lrw	r6, 0x0	// from address pool at 0x25c
 196:	9607      	st	r6, (r7, 0)
  const char *lossage = (char *)TLS_INIT_TP (tlsblock, 0);
 198:	8778      	ld	r7, (r8, 28)
 19a:	1272      	mov	r2, r7
 19c:	65a1      	movi	r1, 90
 19e:	3471      	bseti	r1, r1, 7
 1a0:	0008      	trap	0
 1a2:	1227      	mov	r7, r2
 1a4:	9788      	st	r7, (r8, 32)
 1a6:	8788      	ld	r7, (r8, 32)
 1a8:	9798      	st	r7, (r8, 36)
 1aa:	8698      	ld	r6, (r8, 36)
 1ac:	2cc7      	bmaski	r7, 12
 1ae:	01f7      	not	r7, r7
 1b0:	0c67      	cmphs	r7, r6
 1b2:	e002      	bt	0x1b8
 1b4:	772b      	lrw	r7, 0x0	// from address pool at 0x260
 1b6:	f001      	br	0x1ba
 1b8:	6007      	movi	r7, 0
 1ba:	97a8      	st	r7, (r8, 40)
# else
#  error "Either TLS_TCB_AT_TP or TLS_DTV_AT_TP must be defined"
# endif
  if (__builtin_expect (lossage != NULL, 0))
 1bc:	87a8      	ld	r7, (r8, 40)
 1be:	2a07      	cmpnei	r7, 0
 1c0:	0027      	mvc	r7
 1c2:	2a07      	cmpnei	r7, 0
 1c4:	e801      	bf	0x1c8
    abort();
 1c6:	7f27      	jsri	0x0	// from address pool at 0x264

  /* We have to create a fake link map which normally would be created
     by the dynamic linker.  It just has to have enough information to
     make the TLS routines happy.  */
  static_map.l_tls_align = align;
 1c8:	7723      	lrw	r7, 0x0	// from address pool at 0x254
 1ca:	8638      	ld	r6, (r8, 12)
 1cc:	9687      	st	r6, (r7, 32)
  static_map.l_tls_blocksize = memsz;
 1ce:	7721      	lrw	r7, 0x0	// from address pool at 0x254
 1d0:	8608      	ld	r6, (r8, 0)
 1d2:	9677      	st	r6, (r7, 28)
  static_map.l_tls_initimage = initimage;
 1d4:	7720      	lrw	r7, 0x0	// from address pool at 0x254
 1d6:	8628      	ld	r6, (r8, 8)
 1d8:	9657      	st	r6, (r7, 20)
  static_map.l_tls_initimage_size = filesz;
 1da:	771e      	lrw	r7, 0x0	// from address pool at 0x254
 1dc:	8618      	ld	r6, (r8, 4)
 1de:	9667      	st	r6, (r7, 24)
  static_map.l_tls_modid = 1;
 1e0:	771d      	lrw	r7, 0x0	// from address pool at 0x254
 1e2:	6016      	movi	r6, 1
 1e4:	96b7      	st	r6, (r7, 44)

  init_slotinfo ();
 1e6:	ff0c      	bsr	0x0
  // static_slotinfo.si.slotinfo[1].gen = 0; already zero
  static_slotinfo.si.slotinfo[1].map = &static_map;
 1e8:	7721      	lrw	r7, 0x0	// from address pool at 0x26c
 1ea:	761a      	lrw	r6, 0x0	// from address pool at 0x254
 1ec:	9677      	st	r6, (r7, 28)

  memsz = roundup (memsz, align ?: 1);
 1ee:	8738      	ld	r7, (r8, 12)
 1f0:	2a07      	cmpnei	r7, 0
 1f2:	e802      	bf	0x1f8
 1f4:	2407      	subi	r7, r7, 1
 1f6:	f001      	br	0x1fa
 1f8:	6007      	movi	r7, 0
 1fa:	8608      	ld	r6, (r8, 0)
 1fc:	1c76      	addu	r6, r6, r7
 1fe:	8738      	ld	r7, (r8, 12)
 200:	2a07      	cmpnei	r7, 0
 202:	e801      	bf	0x206
 204:	f001      	br	0x208
 206:	6017      	movi	r7, 1
 208:	1271      	mov	r1, r7
 20a:	2c16      	divu	r6, r6, r1
 20c:	8738      	ld	r7, (r8, 12)
 20e:	2a07      	cmpnei	r7, 0
 210:	e801      	bf	0x214
 212:	f001      	br	0x216
 214:	6017      	movi	r7, 1
 216:	0367      	mult	r7, r7, r6
 218:	9708      	st	r7, (r8, 0)

# if defined(TLS_TCB_AT_TP)
  memsz += tcbsize;
# elif defined(TLS_DTV_AT_TP)
  memsz += tcb_offset;
 21a:	8608      	ld	r6, (r8, 0)
 21c:	8768      	ld	r7, (r8, 24)
 21e:	1c67      	addu	r7, r7, r6
 220:	9708      	st	r7, (r8, 0)
# endif

  init_static_tls (memsz, MAX (TLS_TCB_ALIGN, max_align));
 222:	8748      	ld	r7, (r8, 16)
 224:	6106      	movi	r6, 16
 226:	0c67      	cmphs	r7, r6
 228:	0a67      	movf	r7, r6
 22a:	8208      	ld	r2, (r8, 0)
 22c:	1273      	mov	r3, r7
 22e:	ff00      	bsr	0x30	// 30 <init_static_tls>
}
 230:	1280      	mov	r0, r8
 232:	21f0      	addi	r0, r0, 32
 234:	8f60      	ld	r15, (r0, 24)
 236:	8870      	ld	r8, (r0, 28)
 238:	21f0      	addi	r0, r0, 32
 23a:	00cf      	jmp	r15
 23c:	f7ff      	br	0x23c
 23e:	f7ff      	br	0x23e
	...

00000274 <_dl_tls_setup>:
   when there was no need for it then.  Now we have dynamically loaded
   something needing TLS, or libpthread needs it.  */
int
internal_function
_dl_tls_setup (void)
{
 274:	2470      	subi	r0, r0, 8
 276:	9f00      	st	r15, (r0, 0)
 278:	9810      	st	r8, (r0, 4)
 27a:	1208      	mov	r8, r0
  init_slotinfo ();
 27c:	fec1      	bsr	0x0
  init_static_tls (
 27e:	6002      	movi	r2, 0
 280:	6103      	movi	r3, 16
 282:	fed6      	bsr	0x30	// 30 <init_static_tls>
		   TLS_TCB_SIZE,
# else
		   0,
# endif
		   TLS_TCB_ALIGN);
  return 0;
 284:	6007      	movi	r7, 0
}
 286:	1272      	mov	r2, r7
 288:	1280      	mov	r0, r8
 28a:	8f00      	ld	r15, (r0, 0)
 28c:	8810      	ld	r8, (r0, 4)
 28e:	2070      	addi	r0, r0, 8
 290:	00cf      	jmp	r15
 292:	f7ff      	br	0x292
 294:	f7ff      	br	0x294
 296:	1200      	mov	r0, r0
	...

000002a0 <__pthread_initialize_minimal>:
/* This is the minimal initialization function used when libpthread is
   not used.  */
void
__attribute__ ((weak))
__pthread_initialize_minimal (void)
{
 2a0:	2470      	subi	r0, r0, 8
 2a2:	9f00      	st	r15, (r0, 0)
 2a4:	9810      	st	r8, (r0, 4)
 2a6:	1208      	mov	r8, r0
  __libc_setup_tls (TLS_INIT_TCB_SIZE, TLS_INIT_TCB_ALIGN);
 2a8:	6082      	movi	r2, 8
 2aa:	6103      	movi	r3, 16
 2ac:	feeb      	bsr	0x84	// 84 <__libc_setup_tls>
}
 2ae:	1280      	mov	r0, r8
 2b0:	8f00      	ld	r15, (r0, 0)
 2b2:	8810      	ld	r8, (r0, 4)
 2b4:	2070      	addi	r0, r0, 8
 2b6:	00cf      	jmp	r15
 2b8:	f7ff      	br	0x2b8
 2ba:	f7ff      	br	0x2ba
 2bc:	0000      	bkpt
	...

000002c0 <__tls_get_addr>:
   must be always 1 and PT_TLS segment exist in the binary, otherwise it
   would not link.  */

void *
__tls_get_addr (tls_index *ti)
{
 2c0:	2570      	subi	r0, r0, 24
 2c2:	9840      	st	r8, (r0, 16)
 2c4:	1208      	mov	r8, r0
 2c6:	9228      	st	r2, (r8, 8)
  dtv_t *dtv = THREAD_DTV ();
 2c8:	000b      	trap	3
 2ca:	1227      	mov	r7, r2
 2cc:	8707      	ld	r7, (r7, 0)
 2ce:	9708      	st	r7, (r8, 0)
  return (char *) dtv[1].pointer.val + ti->ti_offset;
 2d0:	8708      	ld	r7, (r8, 0)
 2d2:	2077      	addi	r7, r7, 8
 2d4:	8607      	ld	r6, (r7, 0)
 2d6:	8728      	ld	r7, (r8, 8)
 2d8:	8717      	ld	r7, (r7, 4)
 2da:	1c67      	addu	r7, r7, r6
}
 2dc:	1272      	mov	r2, r7
 2de:	1280      	mov	r0, r8
 2e0:	8840      	ld	r8, (r0, 16)
 2e2:	2170      	addi	r0, r0, 24
 2e4:	00cf      	jmp	r15
