	.file	"aesenc.c"
	.abiversion 2
	.section	".toc","aw"
	.section	".text"
	.align 2
	.globl gf_mul2
	.type	gf_mul2, @function
gf_mul2:
	lis 9,0x8080
	ori 9,9,32896
	and 9,3,9
	srwi 10,9,7
	xor 3,9,3
	mulli 10,10,27
	slwi 3,3,1
	xor 3,10,3
	rldicl 3,3,0,32
	blr
	.long 0
	.byte 0,0,0,0,0,0,0,0
	.size	gf_mul2,.-gf_mul2
	.align 2
	.globl sub_byte
	.type	sub_byte, @function
sub_byte:
0:	addis 2,12,.TOC.-0b@ha
	addi 2,2,.TOC.-0b@l
	.localentry	sub_byte,.-sub_byte
	mflr 0
	bl _savegpr0_29
	mr. 31,3
	stdu 1,-64(1)
	beq 0,.L3
	li 29,1
	li 30,1
.L5:
	mr 3,29
	bl gf_mul2
	xor 3,3,29
	rldicl 29,3,0,56
	cmpw 7,29,31
	beq 7,.L4
	addi 30,30,1
	rldicl. 30,30,0,56
	bne 0,.L5
.L4:
	nor 30,30,30
	li 31,1
	rldicl 30,30,0,56
	li 29,0
.L6:
	cmpw 7,29,30
	beq 7,.L3
	mr 3,31
	addi 29,29,1
	bl gf_mul2
	rldicl 29,29,0,56
	xor 3,3,31
	rldicl 31,3,0,56
	b .L6
.L3:
	srwi 9,31,7
	slwi 3,31,1
	or 3,3,9
	xori 31,31,99
	rldicl 3,3,0,56
	addi 1,1,64
	srwi 9,3,7
	slwi 10,3,1
	or 10,10,9
	xor 31,31,3
	rldicl 10,10,0,56
	slwi 8,10,1
	srwi 9,10,7
	or 9,8,9
	xor 10,31,10
	rldicl 9,9,0,56
	slwi 3,9,1
	xor 10,10,9
	srwi 9,9,7
	or 9,3,9
	xor 3,10,9
	rldicl 3,3,0,56
	b _restgpr0_29
	.long 0
	.byte 0,0,0,1,128,3,0,0
	.size	sub_byte,.-sub_byte
	.align 2
	.globl aesenc
	.type	aesenc, @function
aesenc:
0:	addis 2,12,.TOC.-0b@ha
	addi 2,2,.TOC.-0b@l
	.localentry	aesenc,.-aesenc
	mflr 0
	bl _savegpr0_26
	stdu 1,-96(1)
	mr 28,3
	mr 27,4
	mr 29,5
	li 30,0
.L15:
	rldicl 9,30,0,32
	lbzx 3,28,30
	addi 30,30,1
	srwi 31,9,2
	subf 31,9,31
	rlwinm 9,9,0,30,31
	rlwinm 31,31,2,28,29
	add 9,31,9
	rldicl 31,9,0,32
	bl sub_byte
	cmpldi 7,30,16
	add 9,1,31
	stb 3,32(9)
	bne 7,.L15
	cmpdi 7,29,0
	addi 26,1,32
	beq 7,.L19
.L18:
	li 10,4
	li 9,0
	mtctr 10
	b .L17
.L19:
	li 30,0
.L16:
	lwzx 31,26,30
	rlwinm 3,31,24,0xffffffff
	rlwinm 29,31,16,0xffffffff
	xor 29,29,3
	xor 3,3,31
	rldicl 3,3,0,32
	rlwinm 31,31,8,0xffffffff
	bl gf_mul2
	xor 3,29,3
	xor 31,3,31
	stwx 31,26,30
	addi 30,30,4
	cmpldi 7,30,16
	bne 7,.L16
	b .L18
.L17:
	lwzx 8,27,9
	lwzx 10,26,9
	xor 10,8,10
	stwx 10,28,9
	addi 9,9,4
	bdnz .L17
	addi 1,1,96
	b _restgpr0_26
	.long 0
	.byte 0,0,0,1,128,6,0,0
	.size	aesenc,.-aesenc
	.ident	"GCC: (Debian 4.9.2-10) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
