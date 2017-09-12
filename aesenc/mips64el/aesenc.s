	.file	1 "aesenc.c"
	.section .mdebug.abi64
	.previous
	.nan	legacy
	.module	fp=64
	.module	oddspreg
	.abicalls
	.text
	.align	2
	.globl	gf_mul2
	.set	nomips16
	.set	nomicromips
	.ent	gf_mul2
	.type	gf_mul2, @function
gf_mul2:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	li	$3,16842752			# 0x1010000
	srl	$2,$4,7
	addiu	$3,$3,257
	and	$2,$2,$3
	li	$3,27			# 0x1b
	mul	$2,$2,$3
	li	$3,-16908288			# 0xfffffffffefe0000
	ori	$3,$3,0xfefe
	sll	$4,$4,1
	and	$4,$4,$3
	jr	$31
	xor	$2,$2,$4

	.set	macro
	.set	reorder
	.end	gf_mul2
	.size	gf_mul2, .-gf_mul2
	.align	2
	.globl	sub_byte
	.set	nomips16
	.set	nomicromips
	.ent	sub_byte
	.type	sub_byte, @function
sub_byte:
	.frame	$sp,16,$31		# vars= 0, regs= 2/0, args= 0, gp= 0
	.mask	0x90000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	daddiu	$sp,$sp,-16
	sd	$28,0($sp)
	lui	$28,%hi(%neg(%gp_rel(sub_byte)))
	daddu	$28,$28,$25
	sd	$31,8($sp)
	daddiu	$28,$28,%lo(%neg(%gp_rel(sub_byte)))
	beq	$4,$0,.L4
	move	$6,$4

	ld	$25,%got_disp(gf_mul2)($28)
	li	$8,1			# 0x1
	li	$7,1			# 0x1
	move	$9,$25
.L6:
	.reloc	1f,R_MIPS_JALR,gf_mul2
1:	jalr	$25
	move	$4,$8

	xor	$8,$2,$8
	andi	$8,$8,0x00ff
	beql	$6,$8,.L14
	nor	$7,$0,$7

	addiu	$7,$7,1
	andi	$7,$7,0x00ff
	bne	$7,$0,.L6
	nop

	nor	$7,$0,$7
.L14:
	li	$6,1			# 0x1
	move	$8,$0
	andi	$7,$7,0x00ff
.L7:
	bnel	$8,$7,.L8
	move	$25,$9

.L4:
	srl	$3,$6,7
	sll	$2,$6,1
	or	$2,$2,$3
	xori	$3,$6,0x63
	srl	$4,$6,6
	xor	$2,$2,$3
	sll	$3,$6,2
	or	$3,$3,$4
	xor	$2,$2,$3
	srl	$4,$6,5
	sll	$3,$6,3
	or	$3,$3,$4
	xor	$2,$2,$3
	ld	$31,8($sp)
	sll	$3,$6,4
	srl	$6,$6,4
	or	$6,$3,$6
	xor	$2,$2,$6
	ld	$28,0($sp)
	andi	$2,$2,0x00ff
	jr	$31
	daddiu	$sp,$sp,16

.L8:
	.reloc	1f,R_MIPS_JALR,gf_mul2
1:	jalr	$25
	move	$4,$6

	xor	$6,$2,$6
	addiu	$8,$8,1
	andi	$6,$6,0x00ff
	b	.L7
	andi	$8,$8,0x00ff

	.set	macro
	.set	reorder
	.end	sub_byte
	.size	sub_byte, .-sub_byte
	.align	2
	.globl	aesenc
	.set	nomips16
	.set	nomicromips
	.ent	aesenc
	.type	aesenc, @function
aesenc:
	.frame	$sp,48,$31		# vars= 16, regs= 3/0, args= 0, gp= 0
	.mask	0x90010000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	daddiu	$sp,$sp,-48
	sd	$28,32($sp)
	lui	$28,%hi(%neg(%gp_rel(aesenc)))
	daddu	$28,$28,$25
	daddiu	$28,$28,%lo(%neg(%gp_rel(aesenc)))
	sd	$16,24($sp)
	ld	$16,%got_disp(sub_byte)($28)
	sd	$31,40($sp)
	move	$11,$5
	move	$15,$6
	move	$13,$4
	move	$14,$4
	move	$12,$0
	li	$24,16			# 0x10
.L16:
	srl	$10,$12,2
	subu	$10,$10,$12
	lbu	$4,0($14)
	andi	$10,$10,0x3
	move	$25,$16
	andi	$2,$12,0x3
	sll	$10,$10,2
	.reloc	1f,R_MIPS_JALR,sub_byte
1:	jalr	$25
	addu	$10,$10,$2

	dext	$10,$10,0,32
	daddu	$10,$sp,$10
	addiu	$12,$12,1
	sb	$2,0($10)
	bne	$12,$24,.L16
	daddiu	$14,$14,1

	beq	$15,$0,.L17
	ld	$25,%got_disp(gf_mul2)($28)

	move	$2,$sp
.L25:
	move	$5,$11
	daddiu	$4,$11,16
.L18:
	lw	$6,0($5)
	lw	$3,0($2)
	daddiu	$5,$5,4
	xor	$3,$3,$6
	sw	$3,0($13)
	daddiu	$2,$2,4
	bne	$4,$5,.L18
	daddiu	$13,$13,4

	ld	$31,40($sp)
	ld	$28,32($sp)
	ld	$16,24($sp)
	jr	$31
	daddiu	$sp,$sp,48

.L17:
	move	$8,$sp
	daddiu	$9,$sp,16
	lw	$6,0($8)
.L26:
	ror	$4,$6,8
	ror	$7,$6,16
	xor	$7,$7,$4
	.reloc	1f,R_MIPS_JALR,gf_mul2
1:	jalr	$25
	xor	$4,$6,$4

	ror	$6,$6,24
	xor	$2,$2,$7
	xor	$6,$6,$2
	sw	$6,0($8)
	daddiu	$8,$8,4
	bnel	$9,$8,.L26
	lw	$6,0($8)

	b	.L25
	move	$2,$sp

	.set	macro
	.set	reorder
	.end	aesenc
	.size	aesenc, .-aesenc
	.ident	"GCC: (Debian 6.3.0-18) 6.3.0 20170516"
