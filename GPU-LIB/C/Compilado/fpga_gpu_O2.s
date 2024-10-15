	.arch armv7
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
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
	.p2align 2,,3
	.global	create_mapping_memory
	.syntax unified
	.thumb
	.thumb_func
	.type	create_mapping_memory, %function
create_mapping_memory:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, lr}
	movw	r4, #:lower16:.LANCHOR0
	movt	r4, #:upper16:.LANCHOR0
	sub	sp, sp, #12
	movw	r1, #4098
	movt	r1, 16
	movw	r0, #:lower16:.LC0
	movt	r0, #:upper16:.LC0
	bl	open
	mov	r5, r0
	str	r0, [r4]
	adds	r0, r0, #1
	beq	.L7
	mov	r3, #-67108864
	movs	r2, #3
	strd	r5, r3, [sp]
	mov	r1, #67108864
	movs	r3, #1
	movs	r0, #0
	bl	mmap
	mov	r3, r0
	adds	r2, r0, #1
	str	r0, [r4, #4]
	beq	.L8
	sub	r3, r0, #58720256
	movs	r5, #1
	add	r1, r3, #112
	add	r2, r3, #128
	bic	r1, r1, #-67108864
	bic	r2, r2, #-67108864
	strd	r1, r2, [r4, #8]
	add	r1, r3, #192
	add	r2, r3, #176
	bic	r1, r1, #-67108864
	bic	r2, r2, #-67108864
	strd	r1, r2, [r4, #16]
	add	r2, r3, #160
	adds	r3, r3, #144
	bic	r2, r2, #-67108864
	bic	r3, r3, #-67108864
	strd	r2, r3, [r4, #24]
.L1:
	mov	r0, r5
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, pc}
.L7:
	movw	r1, #:lower16:.LC1
	movt	r1, #:upper16:.LC1
	movs	r0, #1
	bl	__printf_chk
	mov	r0, r5
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, pc}
.L8:
	movw	r1, #:lower16:.LC2
	movt	r1, #:upper16:.LC2
	movs	r0, #1
	mov	r5, r3
	bl	__printf_chk
	ldr	r0, [r4]
	bl	close
	b	.L1
	.size	create_mapping_memory, .-create_mapping_memory
	.section	.rodata.str1.4
	.align	2
.LC3:
	.ascii	"unmap realizado com sucesso\000"
	.text
	.align	1
	.p2align 2,,3
	.global	close_mapping_memory
	.syntax unified
	.thumb
	.thumb_func
	.type	close_mapping_memory, %function
close_mapping_memory:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	movw	r4, #:lower16:.LANCHOR0
	movt	r4, #:upper16:.LANCHOR0
	mov	r1, #67108864
	ldr	r0, [r4, #4]
	bl	munmap
	cbnz	r0, .L12
	pop	{r4, pc}
.L12:
	movw	r1, #:lower16:.LC3
	movt	r1, #:upper16:.LC3
	movs	r0, #1
	bl	__printf_chk
	ldr	r0, [r4]
	pop	{r4, lr}
	b	close
	.size	close_mapping_memory, .-close_mapping_memory
	.align	1
	.p2align 2,,3
	.global	send_instruction
	.syntax unified
	.thumb
	.thumb_func
	.type	send_instruction, %function
send_instruction:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movw	r2, #:lower16:.LANCHOR0
	movt	r2, #:upper16:.LANCHOR0
	push	{r4}
	ldr	r3, [r2, #20]
	ldr	r3, [r3]
.L14:
	cmp	r3, #0
	bne	.L14
	ldr	r4, [r2, #16]
	ldr	ip, [r2, #8]
	ldr	r2, [r2, #12]
	str	r0, [ip]
	str	r1, [r2]
	str	r3, [r4]
	pop	{r4}
	bx	lr
	.size	send_instruction, .-send_instruction
	.align	1
	.p2align 2,,3
	.global	set_polygon
	.syntax unified
	.thumb
	.thumb_func
	.type	set_polygon, %function
set_polygon:
	@ args = 8, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	lsls	r0, r0, #4
	orr	r4, r0, #3
	ldrd	lr, r0, [sp, #8]
	movw	ip, #:lower16:.LANCHOR0
	movt	ip, #:upper16:.LANCHOR0
	orr	r0, lr, r0, lsl #9
	orr	r0, r0, r3, lsl #18
	ldr	r3, [ip, #20]
	orr	r0, r0, r1, lsl #22
	orr	r0, r0, r2, lsl #31
	ldr	r3, [r3]
.L18:
	cmp	r3, #0
	bne	.L18
	ldr	r1, [ip, #8]
	ldr	r2, [ip, #16]
	str	r4, [r1]
	ldr	r1, [ip, #12]
	str	r0, [r1]
	str	r3, [r2]
	pop	{r4, pc}
	.size	set_polygon, .-set_polygon
	.align	1
	.p2align 2,,3
	.global	set_sprite
	.syntax unified
	.thumb
	.thumb_func
	.type	set_sprite, %function
set_sprite:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
	lsls	r0, r0, #4
	ldr	ip, [sp, #4]
	orr	r1, r1, ip, lsl #9
	movw	ip, #:lower16:.LANCHOR0
	movt	ip, #:upper16:.LANCHOR0
	orr	r1, r1, r3, lsl #19
	orr	r1, r1, r2, lsl #29
	ldr	r3, [ip, #20]
	ldr	r3, [r3]
.L22:
	cmp	r3, #0
	bne	.L22
	ldr	lr, [ip, #8]
	ldr	r2, [ip, #16]
	str	r0, [lr]
	ldr	r0, [ip, #12]
	str	r1, [r0]
	str	r3, [r2]
	ldr	pc, [sp], #4
	.size	set_sprite, .-set_sprite
	.align	1
	.p2align 2,,3
	.global	set_background_color
	.syntax unified
	.thumb
	.thumb_func
	.type	set_background_color, %function
set_background_color:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movw	ip, #:lower16:.LANCHOR0
	movt	ip, #:upper16:.LANCHOR0
	orr	r0, r0, r1, lsl #3
	push	{r4}
	orr	r0, r0, r2, lsl #6
	ldr	r3, [ip, #20]
	ldr	r3, [r3]
.L26:
	cmp	r3, #0
	bne	.L26
	ldrd	r4, r1, [ip, #8]
	ldr	r2, [ip, #16]
	str	r3, [r4]
	str	r0, [r1]
	pop	{r4}
	str	r3, [r2]
	bx	lr
	.size	set_background_color, .-set_background_color
	.align	1
	.p2align 2,,3
	.global	set_background_block
	.syntax unified
	.thumb
	.thumb_func
	.type	set_background_block, %function
set_background_block:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
	orr	r2, r2, r3, lsl #3
	ldr	r3, [sp, #4]
	movw	ip, #:lower16:.LANCHOR0
	movt	ip, #:upper16:.LANCHOR0
	orr	r2, r2, r3, lsl #6
	movs	r3, #80
	mla	r1, r3, r0, r1
	ldr	r3, [ip, #20]
	lsls	r1, r1, #4
	ldr	r3, [r3]
	orr	r1, r1, #2
.L30:
	cmp	r3, #0
	bne	.L30
	ldr	lr, [ip, #8]
	ldr	r0, [ip, #16]
	str	r1, [lr]
	ldr	r1, [ip, #12]
	str	r2, [r1]
	str	r3, [r0]
	ldr	pc, [sp], #4
	.size	set_background_block, .-set_background_block
	.align	1
	.p2align 2,,3
	.global	waitScreen
	.syntax unified
	.thumb
	.thumb_func
	.type	waitScreen, %function
waitScreen:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movw	r3, #:lower16:.LANCHOR0
	movt	r3, #:upper16:.LANCHOR0
	push	{r4, r5}
	movs	r2, #0
	mov	r5, r2
	ldrd	r1, r4, [r3, #24]
	b	.L35
.L36:
	ldr	r3, [r1]
	cmp	r3, #1
	itt	eq
	streq	r5, [r4]
	addeq	r2, r2, #1
.L35:
	cmp	r2, r0
	ble	.L36
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
