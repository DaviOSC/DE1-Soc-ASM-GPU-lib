	.arch armv5t
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 1
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
	push	{r4, lr}
	sub	sp, sp, #8
	ldr	r1, .L8
	ldr	r0, .L8+4
	bl	open
	mov	r4, r0
	ldr	r3, .L8+8
	str	r0, [r3]
	cmn	r0, #1
	beq	.L6
	mov	r3, #-67108864
	str	r3, [sp, #4]
	str	r0, [sp]
	mov	r3, #1
	mov	r2, #3
	mov	r1, #67108864
	mov	r0, #0
	bl	mmap
	ldr	r3, .L8+8
	str	r0, [r3, #4]
	cmn	r0, #1
	beq	.L7
	sub	r0, r0, #58720256
	ldr	r3, .L8+8
	add	r2, r0, #112
	bic	r2, r2, #-67108864
	str	r2, [r3, #8]
	add	r2, r0, #128
	bic	r2, r2, #-67108864
	str	r2, [r3, #12]
	add	r2, r0, #192
	bic	r2, r2, #-67108864
	str	r2, [r3, #16]
	add	r2, r0, #176
	bic	r2, r2, #-67108864
	str	r2, [r3, #20]
	add	r2, r0, #160
	bic	r2, r2, #-67108864
	str	r2, [r3, #24]
	add	r0, r0, #144
	bic	r0, r0, #-67108864
	str	r0, [r3, #28]
	mov	r4, #1
.L1:
	mov	r0, r4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L6:
	ldr	r1, .L8+12
	mov	r0, #1
	bl	__printf_chk
	b	.L1
.L7:
	ldr	r1, .L8+16
	mov	r0, #1
	bl	__printf_chk
	ldr	r3, .L8+8
	ldr	r0, [r3]
	bl	close
	mvn	r4, #0
	b	.L1
.L9:
	.align	2
.L8:
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
	mov	r1, #67108864
	ldr	r3, .L13
	ldr	r0, [r3, #4]
	bl	munmap
	cmp	r0, #0
	popeq	{r4, pc}
	ldr	r1, .L13+4
	mov	r0, #1
	bl	__printf_chk
	ldr	r3, .L13
	ldr	r0, [r3]
	bl	close
	pop	{r4, pc}
.L14:
	.align	2
.L13:
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
	@ link register save eliminated.
	ldr	r3, .L18
	ldr	r3, [r3, #20]
	ldr	r3, [r3]
.L16:
	cmp	r3, #0
	bne	.L16
	ldr	r3, .L18
	ldr	ip, [r3, #16]
	mov	r2, #0
	str	r2, [ip]
	ldr	ip, [r3, #8]
	str	r0, [ip]
	ldr	r0, [r3, #12]
	str	r1, [r0]
	ldr	r1, [r3, #16]
	mov	r0, #1
	str	r0, [r1]
	ldr	r3, [r3, #16]
	str	r2, [r3]
	bx	lr
.L19:
	.align	2
.L18:
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
	ldr	lr, [sp, #12]
	orr	ip, ip, lr, lsl #9
	orr	ip, ip, r3, lsl #18
	orr	r1, ip, r1, lsl #22
	lsl	r0, r0, #4
	orr	r1, r1, r2, lsl #31
	orr	r0, r0, #3
	bl	send_instruction
	pop	{r4, pc}
	.size	set_polygon, .-set_polygon
	.align	2
	.global	set_sprite
	.syntax unified
	.arm
	.type	set_sprite, %function
set_sprite:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	ip, [sp, #8]
	orr	r1, r1, ip, lsl #9
	orr	r1, r1, r3, lsl #19
	lsl	r0, r0, #4
	orr	r1, r1, r2, lsl #29
	orr	r0, r0, #3
	bl	send_instruction
	pop	{r4, pc}
	.size	set_sprite, .-set_sprite
	.align	2
	.global	set_background_color
	.syntax unified
	.arm
	.type	set_background_color, %function
set_background_color:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	orr	r1, r0, r1, lsl #3
	orr	r1, r1, r2, lsl #6
	mov	r0, #0
	bl	send_instruction
	pop	{r4, pc}
	.size	set_background_color, .-set_background_color
	.align	2
	.global	set_background_block
	.syntax unified
	.arm
	.type	set_background_block, %function
set_background_block:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	add	r0, r0, r0, lsl #2
	add	r0, r1, r0, lsl #4
	lsl	r0, r0, #4
	orr	r2, r2, r3, lsl #3
	ldr	r1, [sp, #8]
	orr	r1, r2, r1, lsl #6
	orr	r0, r0, #2
	bl	send_instruction
	pop	{r4, pc}
	.size	set_background_block, .-set_background_block
	.align	2
	.global	waitScreen
	.syntax unified
	.arm
	.type	waitScreen, %function
waitScreen:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r2, #0
	ldr	ip, .L35
	mov	r4, #1
	mov	lr, r2
.L29:
	ldr	r1, [ip, #24]
.L30:
	cmp	r2, r0
	popgt	{r4, pc}
	ldr	r3, [r1]
	cmp	r3, #1
	bne	.L30
	add	r2, r2, #1
	ldr	r3, [ip, #28]
	str	r4, [r3]
	ldr	r3, [ip, #28]
	str	lr, [r3]
	b	.L29
.L36:
	.align	2
.L35:
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
