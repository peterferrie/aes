	.file	1 "aesenc.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	fp=xx
	.module	nooddspreg
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
	sll	$4,$4,1
	and	$2,$2,$3
	li	$3,27			# 0x1b
	mul	$2,$2,$3
	li	$3,-16908288			# 0xfffffffffefe0000
	ori	$3,$3,0xfefe
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
	.frame	$sp,32,$31		# vars= 0, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	nomacro
	addiu	$sp,$sp,-32
	.cprestore	16
	sw	$31,28($sp)
	beq	$4,$0,$L3
	move	$5,$4

	lw	$25,%got(gf_mul2)($28)
	li	$7,1			# 0x1
	li	$6,1			# 0x1
	move	$8,$25
$L5:
	.reloc	1f,R_MIPS_JALR,gf_mul2
1:	jalr	$25
	move	$4,$7

	xor	$7,$7,$2
	andi	$7,$7,0x00ff
	beql	$5,$7,$L13
	nor	$6,$0,$6

	addiu	$6,$6,1
	andi	$6,$6,0x00ff
	bne	$6,$0,$L5
	nop

	nor	$6,$0,$6
$L13:
	li	$5,1			# 0x1
	move	$7,$0
	andi	$6,$6,0x00ff
$L6:
	bnel	$7,$6,$L7
	move	$25,$8

$L3:
	srl	$3,$5,7
	lw	$31,28($sp)
	sll	$2,$5,1
	srl	$4,$5,6
	or	$2,$2,$3
	xori	$3,$5,0x63
	xor	$2,$2,$3
	sll	$3,$5,2
	addiu	$sp,$sp,32
	or	$3,$3,$4
	xor	$2,$2,$3
	srl	$4,$5,5
	sll	$3,$5,3
	or	$3,$3,$4
	xor	$2,$2,$3
	sll	$3,$5,4
	srl	$5,$5,4
	or	$5,$3,$5
	xor	$2,$2,$5
	jr	$31
	andi	$2,$2,0x00ff

$L7:
	.reloc	1f,R_MIPS_JALR,gf_mul2
1:	jalr	$25
	move	$4,$5

	addiu	$7,$7,1
	xor	$5,$5,$2
	andi	$5,$5,0x00ff
	b	$L6
	andi	$7,$7,0x00ff

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
	.frame	$sp,48,$31		# vars= 16, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	nomacro
	addiu	$sp,$sp,-48
	lw	$24,%got(sub_byte)($28)
	move	$12,$0
	addiu	$11,$sp,24
	li	$15,16			# 0x10
	.cprestore	16
	sw	$31,44($sp)
	move	$13,$4
	move	$10,$5
	move	$14,$6
$L15:
	srl	$9,$12,2
	andi	$2,$12,0x3
	subu	$9,$9,$12
	move	$25,$24
	andi	$9,$9,0x3
	sll	$9,$9,2
	addu	$9,$9,$2
	addu	$2,$13,$12
	.reloc	1f,R_MIPS_JALR,sub_byte
1:	jalr	$25
	lbu	$4,0($2)

	addu	$9,$11,$9
	lw	$28,16($sp)
	addiu	$12,$12,1
	bne	$12,$15,$L15
	sb	$2,0($9)

	beq	$14,$0,$L16
	lw	$25,%got(gf_mul2)($28)

	addiu	$3,$10,16
$L24:
	move	$5,$10
	move	$4,$13
$L17:
	lw	$6,0($5)
	addiu	$5,$5,4
	lw	$2,0($11)
	addiu	$4,$4,4
	addiu	$11,$11,4
	xor	$2,$2,$6
	bne	$3,$5,$L17
	sw	$2,-4($4)

	lw	$31,44($sp)
	jr	$31
	addiu	$sp,$sp,48

$L16:
	move	$8,$0
	li	$9,4			# 0x4
	move	$7,$11
$L18:
	lw	$5,0($7)
	ror	$4,$5,8
	ror	$6,$5,16
	xor	$6,$6,$4
	.reloc	1f,R_MIPS_JALR,gf_mul2
1:	jalr	$25
	xor	$4,$5,$4

	ror	$5,$5,24
	xor	$2,$6,$2
	addiu	$8,$8,1
	xor	$5,$5,$2
	sw	$5,0($7)
	bne	$8,$9,$L18
	addiu	$7,$7,4

	b	$L24
	addiu	$3,$10,16

	.set	macro
	.set	reorder
	.end	aesenc
	.size	aesenc, .-aesenc
	.ident	"GCC: (Debian 6.3.0-18) 6.3.0 20170516"
