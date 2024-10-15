	.arch armv5t
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"fpga_gpu.c"
	.text
	.section	.rodata.str1.4,"aMS",%progbits,1
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
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	ldr	r1, .L9
	ldr	r0, .L9+4
	sub	sp, sp, #8
	bl	open
	ldr	r6, .L9+8
	cmn	r0, #1
	mov	r5, r0
	str	r0, [r6]
	beq	.L7
	mov	ip, #-67108864
	str	r0, [sp]
	mov	r3, #1
	mov	r2, #3
	mov	r1, #67108864
	mov	r0, #0
	str	ip, [sp, #4]
	bl	mmap
	cmn	r0, #1
	mov	r4, r0
	str	r0, [r6, #4]
	beq	.L8
	mov	r5, #1
	sub	r3, r0, #58720256
	add	r2, r3, #128
	bic	r2, r2, #-67108864
	add	r1, r3, #112
	str	r2, [r6, #12]
	add	r2, r3, #176
	bic	r1, r1, #-67108864
	bic	r2, r2, #-67108864
	str	r1, [r6, #8]
	str	r2, [r6, #20]
	add	r1, r3, #192
	add	r2, r3, #160
	add	r3, r3, #144
	bic	r1, r1, #-67108864
	bic	r2, r2, #-67108864
	bic	r3, r3, #-67108864
	str	r1, [r6, #16]
	str	r2, [r6, #24]
	str	r3, [r6, #28]
.L1:
	mov	r0, r5
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, pc}
.L7:
	ldr	r1, .L9+12
	mov	r0, #1
	bl	__printf_chk
	mov	r0, r5
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, pc}
.L8:
	ldr	r1, .L9+16
	mov	r0, #1
	bl	__printf_chk
	ldr	r0, [r6]
	bl	close
	mov	r5, r4
	b	.L1
.L10:
	.align	2
.L9:
	.word	1052674
	.word	.LC0
	.word	.LANCHOR0
	.word	.LC1
	.word	.LC2
	.size	create_mapping_memory, .-create_mapping_memory
	.section	.rodata.str1.4
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
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	r4, .L14
	mov	r1, #67108864
	ldr	r0, [r4, #4]
	bl	munmap
	cmp	r0, #0
	popeq	{r4, pc}
	mov	r0, #1
	ldr	r1, .L14+4
	bl	__printf_chk
	ldr	r0, [r4]
	pop	{r4, lr}
	b	close
.L15:
	.align	2
.L14:
	.word	.LANCHOR0
	.word	.LC3
	.size	close_mapping_memory, .-close_mapping_memory
	.align	2
	.global	send_instruction
	.syntax unified
	.arm
	.type	send_instruction, %function
send_instruction:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L21
	ldr	r2, [r3, #20]
	ldr	r2, [r2]
	cmp	r2, #0
	beq	.L17
.L18:
	b	.L18
.L17:
	str	lr, [sp, #-4]!
	ldr	ip, [r3, #16]
	ldr	lr, [r3, #8]
	ldr	r3, [r3, #12]
	str	r0, [lr]
	str	r1, [r3]
	str	r2, [ip]
	ldr	pc, [sp], #4
.L22:
	.align	2
.L21:
	.word	.LANCHOR0
	.size	send_instruction, .-send_instruction
	.align	2
	.global	set_polygon
	.syntax unified
	.arm
	.type	set_polygon, %function
set_polygon:
	@ args = 8, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	ip, [sp, #8]
	ldr	r4, [sp, #12]
	ldr	lr, .L27
	orr	ip, ip, r4, lsl #9
	orr	ip, ip, r3, lsl #18
	ldr	r3, [lr, #20]
	orr	ip, ip, r1, lsl #22
	ldr	r3, [r3]
	orr	ip, ip, r2, lsl #31
	cmp	r3, #0
	beq	.L24
.L25:
	b	.L25
.L24:
	ldr	r1, [lr, #8]
	lsl	r0, r0, #4
	orr	r0, r0, #3
	ldr	r2, [lr, #16]
	str	r0, [r1]
	ldr	r1, [lr, #12]
	str	ip, [r1]
	str	r3, [r2]
	pop	{r4, pc}
.L28:
	.align	2
.L27:
	.word	.LANCHOR0
	.size	set_polygon, .-set_polygon
	.align	2
	.global	set_sprite
	.syntax unified
	.arm
	.type	set_sprite, %function
set_sprite:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	ip, .L33
	push	{r4, lr}
	ldr	lr, [ip, #20]
	ldr	r4, [sp, #8]
	ldr	lr, [lr]
	orr	r1, r1, r4, lsl #9
	orr	r1, r1, r3, lsl #19
	cmp	lr, #0
	orr	r1, r1, r2, lsl #29
	beq	.L30
.L31:
	b	.L31
.L30:
	ldr	r2, [ip, #8]
	lsl	r0, r0, #4
	orr	r0, r0, #3
	ldr	r3, [ip, #16]
	str	r0, [r2]
	ldr	r2, [ip, #12]
	str	r1, [r2]
	str	lr, [r3]
	pop	{r4, pc}
.L34:
	.align	2
.L33:
	.word	.LANCHOR0
	.size	set_sprite, .-set_sprite
	.align	2
	.global	set_background_color
	.syntax unified
	.arm
	.type	set_background_color, %function
set_background_color:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L38
	orr	r0, r0, r1, lsl #3
	ldr	ip, [r3, #20]
	orr	r0, r0, r2, lsl #6
	ldr	ip, [ip]
	cmp	ip, #0
	beq	.L36
.L37:
	b	.L37
.L36:
	ldr	r2, [r3, #16]
	ldr	r1, [r3, #8]
	ldr	r3, [r3, #12]
	str	ip, [r1]
	str	r0, [r3]
	str	ip, [r2]
	bx	lr
.L39:
	.align	2
.L38:
	.word	.LANCHOR0
	.size	set_background_color, .-set_background_color
	.align	2
	.global	set_background_block
	.syntax unified
	.arm
	.type	set_background_block, %function
set_background_block:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	ip, .L44
	str	lr, [sp, #-4]!
	ldr	lr, [ip, #20]
	orr	r2, r2, r3, lsl #3
	ldr	lr, [lr]
	ldr	r3, [sp, #4]
	add	r0, r0, r0, lsl #2
	cmp	lr, #0
	add	r1, r1, r0, lsl #4
	orr	r2, r2, r3, lsl #6
	beq	.L41
.L42:
	b	.L42
.L41:
	ldr	r0, [ip, #8]
	lsl	r1, r1, #4
	orr	r1, r1, #2
	ldr	r3, [ip, #16]
	str	r1, [r0]
	ldr	r1, [ip, #12]
	str	r2, [r1]
	str	lr, [r3]
	ldr	pc, [sp], #4
.L45:
	.align	2
.L44:
	.word	.LANCHOR0
	.size	set_background_block, .-set_background_block
	.align	2
	.global	waitScreen
	.syntax unified
	.arm
	.type	waitScreen, %function
waitScreen:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L55
	cmp	r0, #0
	ldr	r1, [r3, #24]
	ldr	ip, [r3, #28]
	bxlt	lr
	mov	r2, #0
	str	lr, [sp, #-4]!
	mov	lr, r2
	add	r0, r0, #1
.L48:
	ldr	r3, [r1]
.L50:
	cmp	r3, #1
	bne	.L50
	add	r2, r2, #1
	cmp	r0, r2
	str	lr, [ip]
	bne	.L48
	ldr	pc, [sp], #4
.L56:
	.align	2
.L55:
	.word	.LANCHOR0
	.size	waitScreen, .-waitScreen
	.global	fd
	.global	pResetPulseCounter
	.global	pScreen
	.global	pWrFull
	.global	pWrReg
	.global	pDATAB
	.global	pDataA
	.global	pDevMem
	.bss
	.align	2
	.set	.LANCHOR0,. + 0
	.type	fd, %object
	.size	fd, 4
fd:
	.space	4
	.type	pDevMem, %object
	.size	pDevMem, 4
pDevMem:
	.space	4
	.type	pDataA, %object
	.size	pDataA, 4
pDataA:
	.space	4
	.type	pDATAB, %object
	.size	pDATAB, 4
pDATAB:
	.space	4
	.type	pWrReg, %object
	.size	pWrReg, 4
pWrReg:
	.space	4
	.type	pWrFull, %object
	.size	pWrFull, 4
pWrFull:
	.space	4
	.type	pScreen, %object
	.size	pScreen, 4
pScreen:
	.space	4
	.type	pResetPulseCounter, %object
	.size	pResetPulseCounter, 4
pResetPulseCounter:
	.space	4
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",%progbits
