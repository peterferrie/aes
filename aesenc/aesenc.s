	.arch armv8-a
	.file	"aesenc.c"
	.text
	.align	2
	.global	gf_mul2
	.type	gf_mul2, %function
gf_mul2:
	and	w1, w0, -2139062144
	mov	w2, 27
	and	w0, w0, 2139062143
	lsr	w1, w1, 7
	mul	w1, w1, w2
	eor	w0, w1, w0, lsl 1
	ret
	.size	gf_mul2, .-gf_mul2
	.align	2
	.global	sub_byte
	.type	sub_byte, %function
sub_byte:
	stp	x29, x30, [sp, -16]!
	uxtb	w3, w0
	add	x29, sp, 0
	cbz	w3, .L3
	mov	w5, 1
	mov	w4, w5
.L5:
	mov	w0, w5
	bl	gf_mul2
	eor	w0, w5, w0
	uxtb	w5, w0
	cmp	w3, w5
	beq	.L4
	add	w4, w4, 1
	uxtb	w4, w4
	cbnz	w4, .L5
.L4:
	mvn	w4, w4
	mov	w3, 1
	mov	w5, 0
	uxtb	w4, w4
.L6:
	cmp	w5, w4
	beq	.L3
	mov	w0, w3
	bl	gf_mul2
	eor	w0, w3, w0
	add	w5, w5, 1
	uxtb	w3, w0
	uxtb	w5, w5
	b	.L6
.L3:
	lsr	w1, w3, 7
	mov	w4, 99
	ldp	x29, x30, [sp], 16
	orr	w1, w1, w3, lsl 1
	eor	w3, w3, w4
	uxtb	w0, w1
	lsr	w1, w0, 7
	orr	w1, w1, w0, lsl 1
	uxtb	w1, w1
	lsr	w2, w1, 7
	orr	w2, w2, w1, lsl 1
	eor	w1, w0, w1
	eor	w1, w3, w1
	uxtb	w2, w2
	lsr	w0, w2, 7
	orr	w0, w0, w2, lsl 1
	eor	w0, w2, w0
	eor	w0, w1, w0
	ret
	.size	sub_byte, .-sub_byte
	.align	2
	.global	aesenc
	.type	aesenc, %function
aesenc:
	mov	x8, x0
	mov	x9, x1
	mov	w10, w2
	stp	x29, x30, [sp, -32]!
	mov	x6, 0
	add	x29, sp, 0
.L15:
	lsr	w7, w6, 2
	sub	w7, w7, w6
	ubfiz	w0, w7, 2, 2
	and	w7, w6, 3
	add	w7, w0, w7
	ldrb	w0, [x8, x6]
	bl	sub_byte
	add	x6, x6, 1
	sub	x1, x29, #4064
	cmp	x6, 16
	add	x7, x1, x7
	strb	w0, [x7, 4080]
	bne	.L15
	add	x5, x29, 16
	cbz	w10, .L16
.L19:
	mov	x0, 0
	b	.L17
.L16:
	mov	x4, 0
.L18:
	ldr	w3, [x5, x4]
	ror	w0, w3, 8
	eor	w6, w0, w3, ror (32 - 16)
	eor	w0, w3, w0
	bl	gf_mul2
	eor	w0, w0, w3, ror (32 - 8)
	eor	w0, w0, w6
	str	w0, [x5, x4]
	add	x4, x4, 4
	cmp	x4, 16
	bne	.L18
	b	.L19
.L17:
	ldr	w1, [x9, x0]
	ldr	w2, [x5, x0]
	eor	w1, w2, w1
	str	w1, [x8, x0]
	add	x0, x0, 4
	cmp	x0, 16
	bne	.L17
	ldp	x29, x30, [sp], 32
	ret
	.size	aesenc, .-aesenc
	.ident	"GCC: (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
