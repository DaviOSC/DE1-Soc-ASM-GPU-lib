	.arch armv7
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 1
	.eabi_attribute 34, 1
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
	.align	1
	.global	create_mapping_memory
	.syntax unified
	.thumb
	.thumb_func
	.type	create_mapping_memory, %function
create_mapping_memory:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	sub	sp, sp, #8
	movw	r1, #4098
	movt	r1, 16
	movw	r0, #:lower16:.LC0
	movt	r0, #:upper16:.LC0
	bl	open
	mov	r4, r0
	movw	r3, #:lower16:.LANCHOR0
	movt	r3, #:upper16:.LANCHOR0
	str	r0, [r3]
	cmp	r0, #-1
	beq	.L6
	mov	r3, #-67108864
	str	r3, [sp, #4]
	str	r0, [sp]
	movs	r3, #1
	movs	r2, #3
	mov	r1, #67108864
	movs	r0, #0
	bl	mmap
	movw	r3, #:lower16:.LANCHOR0
	movt	r3, #:upper16:.LANCHOR0
	str	r0, [r3, #4]
	cmp	r0, #-1
	beq	.L7
	sub	r0, r0, #58720256
	movw	r3, #:lower16:.LANCHOR0
	movt	r3, #:upper16:.LANCHOR0
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
	adds	r0, r0, #144
	bic	r0, r0, #-67108864
	str	r0, [r3, #28]
	movs	r4, #1
.L1:
	mov	r0, r4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L6:
	movw	r1, #:lower16:.LC1
	movt	r1, #:upper16:.LC1
	movs	r0, #1
	bl	__printf_chk
	b	.L1
.L7:
	movw	r1, #:lower16:.LC2
	movt	r1, #:upper16:.LC2
	movs	r0, #1
	bl	__printf_chk
	movw	r3, #:lower16:.LANCHOR0
	movt	r3, #:upper16:.LANCHOR0
	ldr	r0, [r3]
	bl	close
	mov	r4, #-1
	b	.L1
	.size	create_mapping_memory, .-create_mapping_memory
	.section	.rodata.str1.4
	.align	2
.LC3:
	.ascii	"unmap realizado com sucesso\000"
	.text
	.align	1
	.global	close_mapping_memory
	.syntax unified
	.thumb
	.thumb_func
	.type	close_mapping_memory, %function
close_mapping_memory:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	movw	r3, #:lower16:.LANCHOR0
	movt	r3, #:upper16:.LANCHOR0
	mov	r1, #67108864
	ldr	r0, [r3, #4]
	bl	munmap
	cbnz	r0, .L11
.L8:
	pop	{r3, pc}
.L11:
	movw	r1, #:lower16:.LC3
	movt	r1, #:upper16:.LC3
	movs	r0, #1
	bl	__printf_chk
	movw	r3, #:lower16:.LANCHOR0
	movt	r3, #:upper16:.LANCHOR0
	ldr	r0, [r3]
	bl	close
	b	.L8
	.size	close_mapping_memory, .-close_mapping_memory
	.align	1
	.global	send_instruction
	.syntax unified
	.thumb
	.thumb_func
	.type	send_instruction, %function
send_instruction:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movw	r3, #:lower16:.LANCHOR0
	movt	r3, #:upper16:.LANCHOR0
	ldr	r3, [r3, #20]
	ldr	r3, [r3]
.L13:
	cmp	r3, #0
	bne	.L13
	movw	r3, #:lower16:.LANCHOR0
	movt	r3, #:upper16:.LANCHOR0
	movs	r2, #0
	ldr	ip, [r3, #16]
	str	r2, [ip]
	ldr	ip, [r3, #8]
	str	r0, [ip]
	ldr	r0, [r3, #12]
	str	r1, [r0]
	ldr	r1, [r3, #16]
	movs	r0, #1
	str	r0, [r1]
	ldr	r3, [r3, #16]
	str	r2, [r3]
	bx	lr
	.size	send_instruction, .-send_instruction
	.align	1
	.global	set_polygon
	.syntax unified
	.thumb
	.thumb_func
	.type	set_polygon, %function
set_polygon:
	@ args = 8, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	ip, [sp, #8]
	ldr	lr, [sp, #12]
	orr	ip, ip, lr, lsl #9
	orr	ip, ip, r3, lsl #18
	orr	r1, ip, r1, lsl #22
	lsls	r0, r0, #4
	orr	r1, r1, r2, lsl #31
	orr	r0, r0, #3
	bl	send_instruction
	pop	{r3, pc}
	.size	set_polygon, .-set_polygon
	.align	1
	.global	set_sprite
	.syntax unified
	.thumb
	.thumb_func
	.type	set_sprite, %function
set_sprite:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	ip, [sp, #8]
	orr	r1, r1, ip, lsl #9
	orr	r1, r1, r3, lsl #19
	orr	r1, r1, r2, lsl #29
	lsls	r0, r0, #4
	bl	send_instruction
	pop	{r3, pc}
	.size	set_sprite, .-set_sprite
	.align	1
	.global	set_background_color
	.syntax unified
	.thumb
	.thumb_func
	.type	set_background_color, %function
set_background_color:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	orr	r1, r0, r1, lsl #3
	orr	r1, r1, r2, lsl #6
	movs	r0, #0
	bl	send_instruction
	pop	{r3, pc}
	.size	set_background_color, .-set_background_color
	.align	1
	.global	set_background_block
	.syntax unified
	.thumb
	.thumb_func
	.type	set_background_block, %function
set_background_block:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	mov	ip, #80
	mla	r0, ip, r0, r1
	lsls	r0, r0, #4
	orr	r2, r2, r3, lsl #3
	ldr	r1, [sp, #8]
	orr	r1, r2, r1, lsl #6
	orr	r0, r0, #2
	bl	send_instruction
	pop	{r3, pc}
	.size	set_background_block, .-set_background_block
	.align	1
	.global	waitScreen
	.syntax unified
	.thumb
	.thumb_func
	.type	waitScreen, %function
waitScreen:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r4, r5}
	movs	r2, #0
	movw	ip, #:lower16:.LANCHOR0
	movt	ip, #:upper16:.LANCHOR0
	movs	r5, #1
	mov	r4, r2
.L24:
	ldr	r1, [ip, #24]
.L25:
	cmp	r2, r0
	bgt	.L29
	ldr	r3, [r1]
	cmp	r3, #1
	bne	.L25
	adds	r2, r2, #1
	ldr	r3, [ip, #28]
	str	r5, [r3]
	ldr	r3, [ip, #28]
	str	r4, [r3]
	b	.L24
.L29:
	pop	{r4, r5}
	bx	lr
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
