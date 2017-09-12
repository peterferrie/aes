	.file	"aesenc.c"
	.section	".text"
	.align 4
	.global gf_mul2
	.type	gf_mul2, #function
	.proc	016
gf_mul2:
	.register	%g2, #scratch
	sethi	%hi(16842752), %g2
	or	%g2, 257, %g2
	srl	%o0, 7, %g1
	add	%o0, %o0, %o0
	and	%g1, %g2, %g1
	sethi	%hi(-16843776), %g2
	mulx	%g1, 27, %g1
	or	%g2, 766, %g2
	and	%o0, %g2, %o0
	xor	%o0, %g1, %o0
	jmp	%o7+8
	 srl	%o0, 0, %o0
	.size	gf_mul2, .-gf_mul2
	.align 4
	.global sub_byte
	.type	sub_byte, #function
	.proc	014
sub_byte:
	.register	%g3, #scratch
	save	%sp, -176, %sp
	brz,pt	%i0, .L3
	 mov	0, %i5
	mov	1, %i4
	mov	1, %i5
.L5:
	call	gf_mul2, 0
	 and	%i4, 0xff, %o0
	xor	%o0, %i4, %o0
	mov	%o0, %i4
	and	%o0, 0xff, %o0
	cmp	%o0, %i0
	be,pn	%icc, .L4
	 add	%i5, 1, %g1
	andcc	%g1, 0xff, %g0
	bne,pt	%icc, .L5
	 mov	%g1, %i5
.L4:
	xnor	%g0, %i5, %i5
	mov	0, %i3
	and	%i5, 0xff, %i4
	mov	1, %i5
.L6:
	and	%i3, 0xff, %g1
	cmp	%g1, %i4
	bne,pt	%icc, .L7
	 and	%i5, 0xff, %o0
.L3:
	and	%i5, 0xff, %g1
	srl	%g1, 7, %g2
	add	%i5, %i5, %i0
	or	%i0, %g2, %i0
	xor	%i5, 99, %g2
	srl	%g1, 6, %g3
	xor	%i0, %g2, %i0
	sll	%i5, 2, %g2
	or	%g2, %g3, %g2
	srl	%g1, 5, %g3
	xor	%i0, %g2, %i0
	srl	%g1, 4, %g1
	sll	%i5, 3, %g2
	sll	%i5, 4, %i5
	or	%g2, %g3, %g2
	or	%i5, %g1, %i5
	xor	%i0, %g2, %i0
	xor	%i0, %i5, %i0
	return	%i7+8
	 and	%o0, 0xff, %o0
.L7:
	call	gf_mul2, 0
	 add	%i3, 1, %i3
	ba,pt	%xcc, .L6
	 xor	%o0, %i5, %i5
	.size	sub_byte, .-sub_byte
	.align 4
	.global aesenc
	.type	aesenc, #function
	.proc	020
aesenc:
	save	%sp, -192, %sp
	sethi	%hi(_GLOBAL_OFFSET_TABLE_-4), %l7
	call	__sparc_get_pc_thunk.l7
	 add	%l7, %lo(_GLOBAL_OFFSET_TABLE_+4), %l7
	mov	0, %i4
.L12:
	and	%i4, 3, %g1
	srl	%i4, 2, %i5
	ldub	[%i0+%i4], %o0
	sub	%i5, %i4, %i5
	and	%i5, 3, %i5
	sll	%i5, 2, %i5
	call	sub_byte, 0
	 add	%i5, %g1, %i5
	srl	%i5, 0, %i5
	add	%fp, 2047, %g1
	add	%g1, %i5, %i5
	add	%i4, 1, %i4
	cmp	%i4, 16
	bne,pt	%xcc, .L12
	 stb	%o0, [%i5-16]
	brz,pt	%i2, .L13
	 add	%fp, 2031, %l0
	mov	0, %g1
.L14:
	lduw	[%i1+%g1], %g3
.L20:
	lduw	[%l0+%g1], %g2
	xor	%g2, %g3, %g2
	st	%g2, [%i0+%g1]
	add	%g1, 4, %g1
	cmp	%g1, 16
	bne,a,pt %xcc, .L20
	 lduw	[%i1+%g1], %g3
	return	%i7+8
	 nop
.L13:
	mov	0, %i3
	lduw	[%l0+%i3], %i5
.L21:
	srl	%i5, 8, %g1
	sll	%i5, 24, %o0
	or	%o0, %g1, %o0
	srl	%i5, 16, %g1
	sll	%i5, 16, %i4
	or	%i4, %g1, %i4
	xor	%i4, %o0, %i4
	xor	%i5, %o0, %o0
	call	gf_mul2, 0
	 srl	%o0, 0, %o0
	xor	%i4, %o0, %o0
	sll	%i5, 8, %g1
	srl	%i5, 24, %i5
	or	%g1, %i5, %i5
	xor	%i5, %o0, %i5
	st	%i5, [%l0+%i3]
	add	%i3, 4, %i3
	cmp	%i3, 16
	bne,a,pt %xcc, .L21
	 lduw	[%l0+%i3], %i5
	ba,pt	%xcc, .L14
	 mov	0, %g1
	.size	aesenc, .-aesenc
	.ident	"GCC: (Debian 6.3.0-19) 6.3.0 20170618"
	.section	.text.__sparc_get_pc_thunk.l7,"axG",@progbits,__sparc_get_pc_thunk.l7,comdat
	.align 4
	.weak	__sparc_get_pc_thunk.l7
	.hidden	__sparc_get_pc_thunk.l7
	.type	__sparc_get_pc_thunk.l7, #function
	.proc	020
__sparc_get_pc_thunk.l7:
	jmp	%o7+8
	 add	%o7, %l7, %l7
	.section	.note.GNU-stack,"",@progbits
