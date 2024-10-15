	.arch armv5t
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"fpga_gpu.c"
	.text
	.global	pDevMem
	.bss
	.align	2
	.type	pDevMem, %object
	.size	pDevMem, 4
pDevMem:
	.space	4
	.global	pDataA
	.align	2
	.type	pDataA, %object
	.size	pDataA, 4
pDataA:
	.space	4
	.global	pDATAB
	.align	2
	.type	pDATAB, %object
	.size	pDATAB, 4
pDATAB:
	.space	4
	.global	pWrReg
	.align	2
	.type	pWrReg, %object
	.size	pWrReg, 4
pWrReg:
	.space	4
	.global	pWrFull
	.align	2
	.type	pWrFull, %object
	.size	pWrFull, 4
pWrFull:
	.space	4
	.global	pScreen
	.align	2
	.type	pScreen, %object
	.size	pScreen, 4
pScreen:
	.space	4
	.global	pResetPulseCounter
	.align	2
	.type	pResetPulseCounter, %object
	.size	pResetPulseCounter, 4
pResetPulseCounter:
	.space	4
	.global	fd
	.align	2
	.type	fd, %object
	.size	fd, 4
fd:
	.space	4
	.section	.rodata
	.align	2
.LC0:
	.ascii	"/dev/mem\000"
	.align	2
.LC1:
	.ascii	"dev/mem n\303\243o foi aberto\000"
	.align	2
.LC2:
	.ascii	"Mapeamento do dev/mem n\303\243o foi realizado\000"
	.text
	.align	2
	.global	create_mapping_memory
	.syntax unified
	.arm
	.type	create_mapping_memory, %function
create_mapping_memory:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	ldr	r1, .L5
	ldr	r0, .L5+4
	bl	open
	mov	r3, r0
	ldr	r2, .L5+8
	str	r3, [r2]
	ldr	r3, .L5+8
	ldr	r3, [r3]
	cmn	r3, #1
	bne	.L2
	ldr	r0, .L5+12
	bl	printf
	mvn	r3, #0
	b	.L3
.L2:
	ldr	r3, .L5+8
	ldr	r3, [r3]
	mov	r2, #-67108864
	str	r2, [sp, #4]
	str	r3, [sp]
	mov	r3, #1
	mov	r2, #3
	mov	r1, #67108864
	mov	r0, #0
	bl	mmap
	mov	r3, r0
	ldr	r2, .L5+16
	str	r3, [r2]
	ldr	r3, .L5+16
	ldr	r3, [r3]
	cmn	r3, #1
	bne	.L4
	ldr	r0, .L5+20
	bl	printf
	ldr	r3, .L5+8
	ldr	r3, [r3]
	mov	r0, r3
	bl	close
	mvn	r3, #0
	b	.L3
.L4:
	ldr	r3, .L5+16
	ldr	r3, [r3]
	sub	r3, r3, #58720256
	str	r3, [fp, #-8]
	ldr	r3, [fp, #-8]
	add	r3, r3, #112
	bic	r3, r3, #-67108864
	mov	r2, r3
	ldr	r3, .L5+24
	str	r2, [r3]
	ldr	r3, [fp, #-8]
	add	r3, r3, #128
	bic	r3, r3, #-67108864
	mov	r2, r3
	ldr	r3, .L5+28
	str	r2, [r3]
	ldr	r3, [fp, #-8]
	add	r3, r3, #192
	bic	r3, r3, #-67108864
	mov	r2, r3
	ldr	r3, .L5+32
	str	r2, [r3]
	ldr	r3, [fp, #-8]
	add	r3, r3, #176
	bic	r3, r3, #-67108864
	mov	r2, r3
	ldr	r3, .L5+36
	str	r2, [r3]
	ldr	r3, [fp, #-8]
	add	r3, r3, #160
	bic	r3, r3, #-67108864
	mov	r2, r3
	ldr	r3, .L5+40
	str	r2, [r3]
	ldr	r3, [fp, #-8]
	add	r3, r3, #144
	bic	r3, r3, #-67108864
	mov	r2, r3
	ldr	r3, .L5+44
	str	r2, [r3]
	mov	r3, #1
.L3:
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L6:
	.align	2
.L5:
	.word	1052674
	.word	.LC0
	.word	fd
	.word	.LC1
	.word	pDevMem
	.word	.LC2
	.word	pDataA
	.word	pDATAB
	.word	pWrReg
	.word	pWrFull
	.word	pScreen
	.word	pResetPulseCounter
	.size	create_mapping_memory, .-create_mapping_memory
	.section	.rodata
	.align	2
.LC3:
	.ascii	"unmap realizado com sucesso\000"
	.text
	.align	2
	.global	close_mapping_memory
	.syntax unified
	.arm
	.type	close_mapping_memory, %function
close_mapping_memory:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	ldr	r3, .L10
	ldr	r3, [r3]
	mov	r1, #67108864
	mov	r0, r3
	bl	munmap
	mov	r3, r0
	cmp	r3, #0
	beq	.L9
	ldr	r0, .L10+4
	bl	printf
	ldr	r3, .L10+8
	ldr	r3, [r3]
	mov	r0, r3
	bl	close
.L9:
	nop
	pop	{fp, pc}
.L11:
	.align	2
.L10:
	.word	pDevMem
	.word	.LC3
	.word	fd
	.size	close_mapping_memory, .-close_mapping_memory
	.align	2
	.global	send_instruction
	.syntax unified
	.arm
	.type	send_instruction, %function
send_instruction:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #12
	str	r0, [fp, #-8]
	str	r1, [fp, #-12]
.L15:
	ldr	r3, .L17
	ldr	r3, [r3]
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L15
	ldr	r3, .L17+4
	ldr	r3, [r3]
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .L17+8
	ldr	r3, [r3]
	ldr	r2, [fp, #-8]
	str	r2, [r3]
	ldr	r3, .L17+12
	ldr	r3, [r3]
	ldr	r2, [fp, #-12]
	str	r2, [r3]
	ldr	r3, .L17+4
	ldr	r3, [r3]
	mov	r2, #1
	str	r2, [r3]
	ldr	r3, .L17+4
	ldr	r3, [r3]
	mov	r2, #0
	str	r2, [r3]
	nop
	nop
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
.L18:
	.align	2
.L17:
	.word	pWrFull
	.word	pWrReg
	.word	pDataA
	.word	pDATAB
	.size	send_instruction, .-send_instruction
	.align	2
	.global	set_polygon
	.syntax unified
	.arm
	.type	set_polygon, %function
set_polygon:
	@ args = 8, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	str	r2, [fp, #-24]
	str	r3, [fp, #-28]
	ldr	r3, [fp, #-16]
	lsl	r3, r3, #4
	orr	r3, r3, #3
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-24]
	lsl	r2, r3, #31
	ldr	r3, [fp, #-20]
	lsl	r3, r3, #22
	orr	r2, r2, r3
	ldr	r3, [fp, #-28]
	lsl	r3, r3, #18
	orr	r2, r2, r3
	ldr	r3, [fp, #8]
	lsl	r3, r3, #9
	orr	r3, r2, r3
	ldr	r2, [fp, #4]
	orr	r3, r2, r3
	str	r3, [fp, #-8]
	ldr	r1, [fp, #-8]
	ldr	r0, [fp, #-12]
	bl	send_instruction
	nop
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	set_polygon, .-set_polygon
	.align	2
	.global	set_sprite
	.syntax unified
	.arm
	.type	set_sprite, %function
set_sprite:
	@ args = 4, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	str	r2, [fp, #-24]
	str	r3, [fp, #-28]
	ldr	r3, [fp, #-16]
	lsl	r3, r3, #4
	orr	r3, r3, #3
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-24]
	lsl	r2, r3, #29
	ldr	r3, [fp, #-28]
	lsl	r3, r3, #19
	orr	r2, r2, r3
	ldr	r3, [fp, #4]
	lsl	r3, r3, #9
	orr	r3, r2, r3
	ldr	r2, [fp, #-20]
	orr	r3, r2, r3
	str	r3, [fp, #-8]
	ldr	r1, [fp, #-8]
	ldr	r0, [fp, #-12]
	bl	send_instruction
	nop
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	set_sprite, .-set_sprite
	.align	2
	.global	set_background_color
	.syntax unified
	.arm
	.type	set_background_color, %function
set_background_color:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	str	r2, [fp, #-24]
	mov	r3, #0
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-24]
	lsl	r2, r3, #6
	ldr	r3, [fp, #-20]
	lsl	r3, r3, #3
	orr	r3, r2, r3
	ldr	r2, [fp, #-16]
	orr	r3, r2, r3
	str	r3, [fp, #-8]
	ldr	r1, [fp, #-8]
	ldr	r0, [fp, #-12]
	bl	send_instruction
	nop
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	set_background_color, .-set_background_color
	.align	2
	.global	set_background_block
	.syntax unified
	.arm
	.type	set_background_block, %function
set_background_block:
	@ args = 4, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	str	r2, [fp, #-24]
	str	r3, [fp, #-28]
	ldr	r2, [fp, #-16]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [fp, #-20]
	add	r3, r3, r2
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-12]
	lsl	r3, r3, #4
	orr	r3, r3, #2
	str	r3, [fp, #-12]
	ldr	r3, [fp, #4]
	lsl	r2, r3, #6
	ldr	r3, [fp, #-28]
	lsl	r3, r3, #3
	orr	r3, r2, r3
	ldr	r2, [fp, #-24]
	orr	r3, r2, r3
	str	r3, [fp, #-8]
	ldr	r1, [fp, #-8]
	ldr	r0, [fp, #-12]
	bl	send_instruction
	nop
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	set_background_block, .-set_background_block
	.align	2
	.global	waitScreen
	.syntax unified
	.arm
	.type	waitScreen, %function
waitScreen:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #20
	str	r0, [fp, #-16]
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L24
.L25:
	ldr	r3, .L26
	ldr	r3, [r3]
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L24
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
	ldr	r3, .L26+4
	ldr	r3, [r3]
	mov	r2, #1
	str	r2, [r3]
	ldr	r3, .L26+4
	ldr	r3, [r3]
	mov	r2, #0
	str	r2, [r3]
.L24:
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-16]
	cmp	r2, r3
	ble	.L25
	nop
	nop
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
.L27:
	.align	2
.L26:
	.word	pScreen
	.word	pResetPulseCounter
	.size	waitScreen, .-waitScreen
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",%progbits
