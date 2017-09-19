	.arch armv6
	.eabi_attribute 27, 3
	.eabi_attribute 28, 1
	.fpu vfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 4
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"aesenc.c"
	.text
	.align	2
	.global	gf_mul2
	.type	gf_mul2, %function
gf_mul2:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L2
	mov	r2, #27
	and	r3, r3, r0
	eor	r0, r0, r3
	mov	r1, r3, lsr #7
	mul	r2, r2, r1
	eor	r0, r2, r0, asl #1
	bx	lr
.L3:
	.align	2
.L2:
	.word	-2139062144
	.size	gf_mul2, .-gf_mul2
	.align	2
	.global	sub_byte
	.type	sub_byte, %function
sub_byte:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r4, r5, r6, lr}
	subs	r4, r0, #0
	beq	.L5
	mov	r6, #1
	mov	r5, r6
.L7:
	mov	r0, r6
	bl	gf_mul2
	eor	r0, r0, r6
	uxtb	r6, r0
	cmp	r6, r4
	beq	.L6
	add	r5, r5, #1
	ands	r5, r5, #255
	bne	.L7
.L6:
	mvn	r5, r5
	mov	r4, #1
	uxtb	r5, r5
	mov	r6, #0
.L8:
	cmp	r6, r5
	beq	.L5
	mov	r0, r4
	bl	gf_mul2
	add	r6, r6, #1
	uxtb	r6, r6
	eor	r0, r0, r4
	uxtb	r4, r0
	b	.L8
.L5:
	mov	r1, r4, lsr #7
	orr	r1, r1, r4, asl #1
	eor	r0, r4, #99
	uxtb	r1, r1
	eor	r4, r1, r0
	mov	r2, r1, lsr #7
	orr	r2, r2, r1, asl #1
	uxtb	r2, r2
	eor	r4, r4, r2
	mov	r3, r2, lsr #7
	orr	r3, r3, r2, asl #1
	uxtb	r3, r3
	eor	r4, r4, r3
	mov	r0, r3, lsr #7
	orr	r0, r0, r3, asl #1
	eor	r0, r0, r4
	uxtb	r0, r0
	ldmfd	sp!, {r4, r5, r6, pc}
	.size	sub_byte, .-sub_byte
	.align	2
	.global	aesenc
	.type	aesenc, %function
aesenc:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, lr}
	mov	r6, r0
	mov	r7, r1
	mov	r4, r2
	mov	r5, #0
.L17:
	rsb	r8, r5, r5, lsr #2
	and	r8, r8, #3
	and	r3, r5, #3
	ldrb	r0, [r6, r5]	@ zero_extendqisi2
	add	r8, r3, r8, asl #2
	bl	sub_byte
	add	r3, sp, #16
	add	r8, r3, r8
	add	r5, r5, #1
	cmp	r5, #16
	strb	r0, [r8, #-16]
	bne	.L17
	cmp	r4, #0
	beq	.L18
.L20:
	mov	r3, #0
	b	.L19
.L18:
	ldr	r8, [sp, r4, asl #2]
	mov	r0, r8, ror #8
	eor	r5, r0, r8, ror #16
	eor	r0, r0, r8
	bl	gf_mul2
	eor	r0, r0, r5
	eor	r5, r0, r8, ror #24
	str	r5, [sp, r4, asl #2]
	add	r4, r4, #1
	cmp	r4, #4
	bne	.L18
	b	.L20
.L19:
	ldr	r1, [r7, r3, asl #2]
	ldr	r2, [sp, r3, asl #2]
	eor	r2, r2, r1
	str	r2, [r6, r3, asl #2]
	add	r3, r3, #1
	cmp	r3, #4
	bne	.L19
	add	sp, sp, #16
	@ sp needed
	ldmfd	sp!, {r4, r5, r6, r7, r8, pc}
	.size	aesenc, .-aesenc
	.ident	"GCC: (Raspbian 4.9.2-10) 4.9.2"
	.section	.note.GNU-stack,"",%progbits
