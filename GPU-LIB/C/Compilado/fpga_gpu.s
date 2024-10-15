	.arch armv7
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
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
	.align	1
	.global	create_mapping_memory
	.syntax unified
	.thumb
	.thumb_func
	.type	create_mapping_memory, %function
create_mapping_memory:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #16
	add	r7, sp, #8
	movw	r1, #4098
	movt	r1, 16
	movw	r0, #:lower16:.LC0
	movt	r0, #:upper16:.LC0
	bl	open
	mov	r2, r0
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	str	r2, [r3]
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3]
	cmp	r3, #-1
	bne	.L2
	movw	r0, #:lower16:.LC1
	movt	r0, #:upper16:.LC1
	bl	printf
	mov	r3, #-1
	b	.L3
.L2:
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3]
	mov	r2, #-67108864
	str	r2, [sp, #4]
	str	r3, [sp]
	movs	r3, #1
	movs	r2, #3
	mov	r1, #67108864
	movs	r0, #0
	bl	mmap
	mov	r2, r0
	movw	r3, #:lower16:pDevMem
	movt	r3, #:upper16:pDevMem
	str	r2, [r3]
	movw	r3, #:lower16:pDevMem
	movt	r3, #:upper16:pDevMem
	ldr	r3, [r3]
	cmp	r3, #-1
	bne	.L4
	movw	r0, #:lower16:.LC2
	movt	r0, #:upper16:.LC2
	bl	printf
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3]
	mov	r0, r3
	bl	close
	mov	r3, #-1
	b	.L3
.L4:
	movw	r3, #:lower16:pDevMem
	movt	r3, #:upper16:pDevMem
	ldr	r3, [r3]
	sub	r3, r3, #58720256
	str	r3, [r7, #4]
	ldr	r3, [r7, #4]
	adds	r3, r3, #112
	bic	r3, r3, #-67108864
	mov	r2, r3
	movw	r3, #:lower16:pDataA
	movt	r3, #:upper16:pDataA
	str	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r3, r3, #128
	bic	r3, r3, #-67108864
	mov	r2, r3
	movw	r3, #:lower16:pDATAB
	movt	r3, #:upper16:pDATAB
	str	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r3, r3, #192
	bic	r3, r3, #-67108864
	mov	r2, r3
	movw	r3, #:lower16:pWrReg
	movt	r3, #:upper16:pWrReg
	str	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r3, r3, #176
	bic	r3, r3, #-67108864
	mov	r2, r3
	movw	r3, #:lower16:pWrFull
	movt	r3, #:upper16:pWrFull
	str	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r3, r3, #160
	bic	r3, r3, #-67108864
	mov	r2, r3
	movw	r3, #:lower16:pScreen
	movt	r3, #:upper16:pScreen
	str	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r3, r3, #144
	bic	r3, r3, #-67108864
	mov	r2, r3
	movw	r3, #:lower16:pResetPulseCounter
	movt	r3, #:upper16:pResetPulseCounter
	str	r2, [r3]
	movs	r3, #1
.L3:
	mov	r0, r3
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	create_mapping_memory, .-create_mapping_memory
	.section	.rodata
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
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	movw	r3, #:lower16:pDevMem
	movt	r3, #:upper16:pDevMem
	ldr	r3, [r3]
	mov	r1, #67108864
	mov	r0, r3
	bl	munmap
	mov	r3, r0
	cmp	r3, #0
	beq	.L7
	movw	r0, #:lower16:.LC3
	movt	r0, #:upper16:.LC3
	bl	printf
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3]
	mov	r0, r3
	bl	close
.L7:
	nop
	pop	{r7, pc}
	.size	close_mapping_memory, .-close_mapping_memory
	.align	1
	.global	send_instruction
	.syntax unified
	.thumb
	.thumb_func
	.type	send_instruction, %function
send_instruction:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7]
.L11:
	movw	r3, #:lower16:pWrFull
	movt	r3, #:upper16:pWrFull
	ldr	r3, [r3]
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L11
	movw	r3, #:lower16:pWrReg
	movt	r3, #:upper16:pWrReg
	ldr	r3, [r3]
	movs	r2, #0
	str	r2, [r3]
	movw	r3, #:lower16:pDataA
	movt	r3, #:upper16:pDataA
	ldr	r3, [r3]
	ldr	r2, [r7, #4]
	str	r2, [r3]
	movw	r3, #:lower16:pDATAB
	movt	r3, #:upper16:pDATAB
	ldr	r3, [r3]
	ldr	r2, [r7]
	str	r2, [r3]
	movw	r3, #:lower16:pWrReg
	movt	r3, #:upper16:pWrReg
	ldr	r3, [r3]
	movs	r2, #1
	str	r2, [r3]
	movw	r3, #:lower16:pWrReg
	movt	r3, #:upper16:pWrReg
	ldr	r3, [r3]
	movs	r2, #0
	str	r2, [r3]
	nop
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
	.size	send_instruction, .-send_instruction
	.align	1
	.global	set_polygon
	.syntax unified
	.thumb
	.thumb_func
	.type	set_polygon, %function
set_polygon:
	@ args = 8, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #24
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	str	r3, [r7]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #4
	orr	r3, r3, #3
	str	r3, [r7, #16]
	ldr	r3, [r7, #4]
	lsls	r2, r3, #31
	ldr	r3, [r7, #8]
	lsls	r3, r3, #22
	orrs	r2, r2, r3
	ldr	r3, [r7]
	lsls	r3, r3, #18
	orrs	r2, r2, r3
	ldr	r3, [r7, #36]
	lsls	r3, r3, #9
	orrs	r3, r3, r2
	ldr	r2, [r7, #32]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r1, [r7, #20]
	ldr	r0, [r7, #16]
	bl	send_instruction
	nop
	adds	r7, r7, #24
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	set_polygon, .-set_polygon
	.align	1
	.global	set_sprite
	.syntax unified
	.thumb
	.thumb_func
	.type	set_sprite, %function
set_sprite:
	@ args = 4, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #24
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	str	r3, [r7]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #4
	str	r3, [r7, #16]
	ldr	r3, [r7, #4]
	lsls	r2, r3, #29
	ldr	r3, [r7]
	lsls	r3, r3, #19
	orrs	r2, r2, r3
	ldr	r3, [r7, #32]
	lsls	r3, r3, #9
	orrs	r3, r3, r2
	ldr	r2, [r7, #8]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r1, [r7, #20]
	ldr	r0, [r7, #16]
	bl	send_instruction
	nop
	adds	r7, r7, #24
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	set_sprite, .-set_sprite
	.align	1
	.global	set_background_color
	.syntax unified
	.thumb
	.thumb_func
	.type	set_background_color, %function
set_background_color:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #24
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	movs	r3, #0
	str	r3, [r7, #16]
	ldr	r3, [r7, #4]
	lsls	r2, r3, #6
	ldr	r3, [r7, #8]
	lsls	r3, r3, #3
	orrs	r3, r3, r2
	ldr	r2, [r7, #12]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r1, [r7, #20]
	ldr	r0, [r7, #16]
	bl	send_instruction
	nop
	adds	r7, r7, #24
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	set_background_color, .-set_background_color
	.align	1
	.global	set_background_block
	.syntax unified
	.thumb
	.thumb_func
	.type	set_background_block, %function
set_background_block:
	@ args = 4, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #24
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	str	r3, [r7]
	ldr	r3, [r7, #12]
	movs	r2, #80
	mul	r3, r2, r3
	ldr	r2, [r7, #8]
	add	r3, r3, r2
	str	r3, [r7, #16]
	ldr	r3, [r7, #16]
	lsls	r3, r3, #4
	orr	r3, r3, #2
	str	r3, [r7, #16]
	ldr	r3, [r7, #32]
	lsls	r2, r3, #6
	ldr	r3, [r7]
	lsls	r3, r3, #3
	orrs	r3, r3, r2
	ldr	r2, [r7, #4]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r1, [r7, #20]
	ldr	r0, [r7, #16]
	bl	send_instruction
	nop
	adds	r7, r7, #24
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	set_background_block, .-set_background_block
	.align	1
	.global	waitScreen
	.syntax unified
	.thumb
	.thumb_func
	.type	waitScreen, %function
waitScreen:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #20
	add	r7, sp, #0
	str	r0, [r7, #4]
	movs	r3, #0
	str	r3, [r7, #12]
	b	.L18
.L19:
	movw	r3, #:lower16:pScreen
	movt	r3, #:upper16:pScreen
	ldr	r3, [r3]
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L18
	ldr	r3, [r7, #12]
	adds	r3, r3, #1
	str	r3, [r7, #12]
	movw	r3, #:lower16:pResetPulseCounter
	movt	r3, #:upper16:pResetPulseCounter
	ldr	r3, [r3]
	movs	r2, #1
	str	r2, [r3]
	movw	r3, #:lower16:pResetPulseCounter
	movt	r3, #:upper16:pResetPulseCounter
	ldr	r3, [r3]
	movs	r2, #0
	str	r2, [r3]
.L18:
	ldr	r2, [r7, #12]
	ldr	r3, [r7, #4]
	cmp	r2, r3
	ble	.L19
	nop
	nop
	adds	r7, r7, #20
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
	.size	waitScreen, .-waitScreen
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",%progbits
