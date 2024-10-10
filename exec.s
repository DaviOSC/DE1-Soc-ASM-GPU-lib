	.syntax unified
	.arch armv7-a
	.eabi_attribute 27, 3
	.eabi_attribute 28, 1
	.fpu vfpv3-d16
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.thumb
	.file	"testNewSprites.c"
	.comm	virtual_base,4,4
	.comm	h2p_lw_dataA_addr,4,4
	.comm	h2p_lw_dataB_addr,4,4
	.comm	h2p_lw_wrReg_addr,4,4
	.comm	h2p_lw_wrFull_addr,4,4
	.comm	h2p_lw_screen_addr,4,4
	.comm	h2p_lw_result_pulseCounter_addr,4,4
	.comm	fd,4,4
	.section	.rodata
	.align	2
.LC0:
	.ascii	"/dev/mem\000"
	.align	2
.LC1:
	.ascii	"[ERROR]: could not open \"/dev/mem\"...\000"
	.align	2
.LC2:
	.ascii	"[ERROR]: mmap() failed...\000"
	.text
	.align	2
	.global	createMappingMemory
	.thumb
	.thumb_func
	.type	createMappingMemory, %function
createMappingMemory:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #8
	movw	r0, #:lower16:.LC0
	movt	r0, #:upper16:.LC0
	movw	r1, #4098
	movt	r1, 16
	bl	open
	mov	r2, r0
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	str	r2, [r3, #0]
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	cmp	r3, #-1
	bne	.L2
	movw	r0, #:lower16:.LC1
	movt	r0, #:upper16:.LC1
	bl	puts
	mov	r3, #-1
	b	.L3
.L2:
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	str	r3, [sp, #0]
	mov	r3, #-67108864
	str	r3, [sp, #4]
	mov	r0, #0
	mov	r1, #67108864
	mov	r2, #3
	mov	r3, #1
	bl	mmap
	mov	r2, r0
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	str	r2, [r3, #0]
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	cmp	r3, #-1
	bne	.L4
	movw	r0, #:lower16:.LC2
	movt	r0, #:upper16:.LC2
	bl	puts
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	mov	r0, r3
	bl	close
	mov	r3, #-1
	b	.L3
.L4:
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #128
	movw	r3, #:lower16:h2p_lw_dataA_addr
	movt	r3, #:upper16:h2p_lw_dataA_addr
	str	r2, [r3, #0]
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #112
	movw	r3, #:lower16:h2p_lw_dataB_addr
	movt	r3, #:upper16:h2p_lw_dataB_addr
	str	r2, [r3, #0]
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #192
	movw	r3, #:lower16:h2p_lw_wrReg_addr
	movt	r3, #:upper16:h2p_lw_wrReg_addr
	str	r2, [r3, #0]
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #176
	movw	r3, #:lower16:h2p_lw_wrFull_addr
	movt	r3, #:upper16:h2p_lw_wrFull_addr
	str	r2, [r3, #0]
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #160
	movw	r3, #:lower16:h2p_lw_screen_addr
	movt	r3, #:upper16:h2p_lw_screen_addr
	str	r2, [r3, #0]
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #144
	movw	r3, #:lower16:h2p_lw_result_pulseCounter_addr
	movt	r3, #:upper16:h2p_lw_result_pulseCounter_addr
	str	r2, [r3, #0]
	mov	r3, #1
.L3:
	mov	r0, r3
	mov	sp, r7
	pop	{r7, pc}
	.size	createMappingMemory, .-createMappingMemory
	.section	.rodata
	.align	2
.LC3:
	.ascii	"[ERROR]: munmap() failed...\000"
	.text
	.align	2
	.global	closeMappingMemory
	.thumb
	.thumb_func
	.type	closeMappingMemory, %function
closeMappingMemory:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	mov	r0, r3
	mov	r1, #67108864
	bl	munmap
	mov	r3, r0
	cmp	r3, #0
	beq	.L5
	movw	r0, #:lower16:.LC3
	movt	r0, #:upper16:.LC3
	bl	puts
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	mov	r0, r3
	bl	close
.L5:
	pop	{r7, pc}
	.size	closeMappingMemory, .-closeMappingMemory
	.align	2
	.global	isFull
	.thumb
	.thumb_func
	.type	isFull, %function
isFull:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
	movw	r3, #:lower16:h2p_lw_wrFull_addr
	movt	r3, #:upper16:h2p_lw_wrFull_addr
	ldr	r3, [r3, #0]
	ldr	r3, [r3, #0]
	mov	r0, r3
	mov	sp, r7
	pop	{r7}
	bx	lr
	.size	isFull, .-isFull
	.align	2
	.global	sendInstruction
	.thumb
	.thumb_func
	.type	sendInstruction, %function
sendInstruction:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7, #0]
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L8
	movw	r3, #:lower16:h2p_lw_wrReg_addr
	movt	r3, #:upper16:h2p_lw_wrReg_addr
	ldr	r3, [r3, #0]
	mov	r2, #0
	str	r2, [r3, #0]
	movw	r3, #:lower16:h2p_lw_dataA_addr
	movt	r3, #:upper16:h2p_lw_dataA_addr
	ldr	r3, [r3, #0]
	ldr	r2, [r7, #4]
	str	r2, [r3, #0]
	movw	r3, #:lower16:h2p_lw_dataB_addr
	movt	r3, #:upper16:h2p_lw_dataB_addr
	ldr	r3, [r3, #0]
	ldr	r2, [r7, #0]
	str	r2, [r3, #0]
	movw	r3, #:lower16:h2p_lw_wrReg_addr
	movt	r3, #:upper16:h2p_lw_wrReg_addr
	ldr	r3, [r3, #0]
	mov	r2, #1
	str	r2, [r3, #0]
	movw	r3, #:lower16:h2p_lw_wrReg_addr
	movt	r3, #:upper16:h2p_lw_wrReg_addr
	ldr	r3, [r3, #0]
	mov	r2, #0
	str	r2, [r3, #0]
.L8:
	add	r7, r7, #8
	mov	sp, r7
	pop	{r7, pc}
	.size	sendInstruction, .-sendInstruction
	.align	2
	.thumb
	.thumb_func
	.type	dataA_builder, %function
dataA_builder:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #28
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	mov	r3, #0
	str	r3, [r7, #20]
	ldr	r3, [r7, #12]
	cmp	r3, #0
	beq	.L12
	cmp	r3, #0
	blt	.L11
	cmp	r3, #3
	bgt	.L11
	b	.L14
.L12:
	ldr	r3, [r7, #8]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #4
	str	r3, [r7, #20]
	ldr	r3, [r7, #12]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	b	.L11
.L14:
	ldr	r3, [r7, #4]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #4
	str	r3, [r7, #20]
	ldr	r3, [r7, #12]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	nop
.L11:
	ldr	r3, [r7, #20]
	mov	r0, r3
	add	r7, r7, #28
	mov	sp, r7
	pop	{r7}
	bx	lr
	.size	dataA_builder, .-dataA_builder
	.align	2
	.global	setPolygon
	.thumb
	.thumb_func
	.type	setPolygon, %function
setPolygon:
	@ args = 12, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #24
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	str	r3, [r7, #0]
	ldr	r0, [r7, #8]
	mov	r1, #0
	ldr	r2, [r7, #12]
	bl	dataA_builder
	str	r0, [r7, #16]
	mov	r3, #0
	str	r3, [r7, #20]
	ldr	r3, [r7, #0]
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #9
	str	r3, [r7, #20]
	ldr	r3, [r7, #4]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #4
	str	r3, [r7, #20]
	ldr	r3, [r7, #32]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #9
	str	r3, [r7, #20]
	ldr	r3, [r7, #40]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #9
	str	r3, [r7, #20]
	ldr	r3, [r7, #36]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r0, [r7, #16]
	ldr	r1, [r7, #20]
	bl	sendInstruction
	add	r7, r7, #24
	mov	sp, r7
	pop	{r7, pc}
	.size	setPolygon, .-setPolygon
	.align	2
	.global	set_sprite
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
	str	r3, [r7, #0]
	mov	r0, #0
	ldr	r1, [r7, #12]
	mov	r2, #0
	bl	dataA_builder
	str	r0, [r7, #16]
	mov	r3, #0
	str	r3, [r7, #20]
	ldr	r3, [r7, #32]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #10
	str	r3, [r7, #20]
	ldr	r3, [r7, #8]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #10
	str	r3, [r7, #20]
	ldr	r3, [r7, #4]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #9
	str	r3, [r7, #20]
	ldr	r3, [r7, #0]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r0, [r7, #16]
	ldr	r1, [r7, #20]
	bl	sendInstruction
	add	r7, r7, #24
	mov	sp, r7
	pop	{r7, pc}
	.size	set_sprite, .-set_sprite
	.align	2
	.global	set_background_color
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
	mov	r0, #0
	mov	r1, #0
	mov	r2, #0
	bl	dataA_builder
	str	r0, [r7, #16]
	ldr	r3, [r7, #4]
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #3
	str	r3, [r7, #20]
	ldr	r3, [r7, #8]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	lsl	r3, r3, #3
	str	r3, [r7, #20]
	ldr	r3, [r7, #12]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r0, [r7, #16]
	ldr	r1, [r7, #20]
	bl	sendInstruction
	add	r7, r7, #24
	mov	sp, r7
	pop	{r7, pc}
	.size	set_background_color, .-set_background_color
	.align	2
	.global	set_background_block
	.thumb
	.thumb_func
	.type	set_background_block, %function
set_background_block:
	@ args = 4, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #32
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	str	r3, [r7, #0]
	ldr	r2, [r7, #8]
	mov	r3, r2
	lsl	r3, r3, #2
	adds	r3, r3, r2
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [r7, #12]
	adds	r3, r2, r3
	str	r3, [r7, #20]
	mov	r0, #2
	mov	r1, #0
	ldr	r2, [r7, #20]
	bl	dataA_builder
	str	r0, [r7, #24]
	ldr	r3, [r7, #40]
	str	r3, [r7, #28]
	ldr	r3, [r7, #28]
	lsl	r3, r3, #3
	str	r3, [r7, #28]
	ldr	r3, [r7, #0]
	ldr	r2, [r7, #28]
	orrs	r3, r3, r2
	str	r3, [r7, #28]
	ldr	r3, [r7, #28]
	lsl	r3, r3, #3
	str	r3, [r7, #28]
	ldr	r3, [r7, #4]
	ldr	r2, [r7, #28]
	orrs	r3, r3, r2
	str	r3, [r7, #28]
	ldr	r0, [r7, #24]
	ldr	r1, [r7, #28]
	bl	sendInstruction
	add	r7, r7, #32
	mov	sp, r7
	pop	{r7, pc}
	.size	set_background_block, .-set_background_block
	.align	2
	.global	waitScreen
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
	mov	r3, #0
	str	r3, [r7, #12]
	b	.L20
.L21:
	movw	r3, #:lower16:h2p_lw_screen_addr
	movt	r3, #:upper16:h2p_lw_screen_addr
	ldr	r3, [r3, #0]
	ldr	r3, [r3, #0]
	cmp	r3, #1
	bne	.L20
	ldr	r3, [r7, #12]
	add	r3, r3, #1
	str	r3, [r7, #12]
	movw	r3, #:lower16:h2p_lw_result_pulseCounter_addr
	movt	r3, #:upper16:h2p_lw_result_pulseCounter_addr
	ldr	r3, [r3, #0]
	mov	r2, #1
	str	r2, [r3, #0]
	movw	r3, #:lower16:h2p_lw_result_pulseCounter_addr
	movt	r3, #:upper16:h2p_lw_result_pulseCounter_addr
	ldr	r3, [r3, #0]
	mov	r2, #0
	str	r2, [r3, #0]
.L20:
	ldr	r2, [r7, #12]
	ldr	r3, [r7, #4]
	cmp	r2, r3
	ble	.L21
	add	r7, r7, #20
	mov	sp, r7
	pop	{r7}
	bx	lr
	.size	waitScreen, .-waitScreen
	.align	2
	.global	increase_coordinate
	.thumb
	.thumb_func
	.type	increase_coordinate, %function
increase_coordinate:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #8]
	cmp	r3, #7
	bhi	.L22
	adr	r2, .L32
	ldr	pc, [r2, r3, lsl #2]
	.align	2
.L32:
	.word	.L24+1
	.word	.L25+1
	.word	.L26+1
	.word	.L27+1
	.word	.L28+1
	.word	.L29+1
	.word	.L30+1
	.word	.L31+1
.L24:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	subs	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #0]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L33
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bgt	.L57
	ldr	r3, [r7, #4]
	mov	r2, #640
	str	r2, [r3, #0]
	b	.L57
.L33:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bgt	.L57
	ldr	r3, [r7, #4]
	mov	r2, #1
	str	r2, [r3, #0]
	b	.L57
.L25:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	adds	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	subs	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #4]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L35
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L36
	ldr	r3, [r7, #4]
	mov	r2, #480
	str	r2, [r3, #4]
	b	.L58
.L36:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #640
	ble	.L58
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #0]
	b	.L58
.L35:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L38
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #4]
	b	.L58
.L38:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #640
	ble	.L58
	ldr	r3, [r7, #4]
	mov	r2, #640
	str	r2, [r3, #0]
	b	.L58
.L26:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	subs	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #4]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L39
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L59
	ldr	r3, [r7, #4]
	mov	r2, #480
	str	r2, [r3, #4]
	b	.L59
.L39:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L59
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #4]
	b	.L59
.L27:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	subs	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	subs	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #4]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L41
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L42
	ldr	r3, [r7, #4]
	mov	r2, #480
	str	r2, [r3, #4]
	b	.L60
.L42:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bgt	.L60
	ldr	r3, [r7, #4]
	mov	r2, #640
	str	r2, [r3, #0]
	b	.L60
.L41:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L44
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #4]
	b	.L60
.L44:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bgt	.L60
	ldr	r3, [r7, #4]
	mov	r2, #1
	str	r2, [r3, #0]
	b	.L60
.L28:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	adds	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #0]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L45
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #640
	ble	.L61
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #0]
	b	.L61
.L45:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #620
	ble	.L61
	ldr	r3, [r7, #4]
	mov	r2, #620
	str	r2, [r3, #0]
	b	.L61
.L29:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	subs	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	adds	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #4]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L47
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #480
	ble	.L48
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #4]
	b	.L62
.L48:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bgt	.L62
	ldr	r3, [r7, #4]
	mov	r2, #640
	str	r2, [r3, #0]
	b	.L62
.L47:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #480
	ble	.L50
	ldr	r3, [r7, #4]
	mov	r2, #480
	str	r2, [r3, #4]
	b	.L62
.L50:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bgt	.L62
	ldr	r3, [r7, #4]
	mov	r2, #1
	str	r2, [r3, #0]
	b	.L62
.L30:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	adds	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #4]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L51
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #480
	ble	.L63
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #4]
	b	.L63
.L51:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #480
	ble	.L63
	ldr	r3, [r7, #4]
	mov	r2, #480
	str	r2, [r3, #4]
	b	.L63
.L31:
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	adds	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #0]
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	adds	r2, r2, r3
	ldr	r3, [r7, #4]
	str	r2, [r3, #4]
	ldr	r3, [r7, #0]
	cmp	r3, #1
	bne	.L53
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #480
	ble	.L54
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #4]
	b	.L64
.L54:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #640
	ble	.L64
	ldr	r3, [r7, #4]
	mov	r2, #0
	str	r2, [r3, #0]
	b	.L64
.L53:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	cmp	r3, #480
	ble	.L56
	ldr	r3, [r7, #4]
	mov	r2, #480
	str	r2, [r3, #4]
	b	.L64
.L56:
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #640
	ble	.L64
	ldr	r3, [r7, #4]
	mov	r2, #640
	str	r2, [r3, #0]
	b	.L64
.L57:
	nop
	b	.L22
.L58:
	nop
	b	.L22
.L59:
	nop
	b	.L22
.L60:
	nop
	b	.L22
.L61:
	nop
	b	.L22
.L62:
	nop
	b	.L22
.L63:
	nop
	b	.L22
.L64:
	nop
.L22:
	add	r7, r7, #12
	mov	sp, r7
	pop	{r7}
	bx	lr
	.size	increase_coordinate, .-increase_coordinate
	.align	2
	.global	collision
	.thumb
	.thumb_func
	.type	collision, %function
collision:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #36
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7, #0]
	mov	r3, #15
	str	r3, [r7, #12]
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #12]
	adds	r3, r2, r3
	str	r3, [r7, #16]
	ldr	r3, [r7, #0]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #12]
	adds	r3, r2, r3
	str	r3, [r7, #20]
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #12]
	adds	r3, r2, r3
	str	r3, [r7, #24]
	ldr	r3, [r7, #0]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #12]
	adds	r3, r2, r3
	str	r3, [r7, #28]
	ldr	r3, [r7, #0]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #16]
	cmp	r2, r3
	bge	.L66
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #4]
	ldr	r3, [r7, #20]
	cmp	r2, r3
	bge	.L66
	ldr	r3, [r7, #0]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #24]
	cmp	r2, r3
	bge	.L67
	ldr	r2, [r7, #24]
	ldr	r3, [r7, #28]
	cmp	r2, r3
	bge	.L67
	mov	r3, #1
	b	.L68
.L67:
	ldr	r2, [r7, #24]
	ldr	r3, [r7, #28]
	cmp	r2, r3
	bge	.L69
	ldr	r3, [r7, #0]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #24]
	cmp	r2, r3
	bge	.L69
	mov	r3, #1
	b	.L68
.L69:
	ldr	r2, [r7, #24]
	ldr	r3, [r7, #28]
	cmp	r2, r3
	ble	.L70
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #28]
	cmp	r2, r3
	bge	.L70
	mov	r3, #1
	b	.L68
.L70:
	ldr	r2, [r7, #24]
	ldr	r3, [r7, #28]
	cmp	r2, r3
	ble	.L66
	ldr	r3, [r7, #4]
	ldr	r2, [r3, #0]
	ldr	r3, [r7, #28]
	cmp	r2, r3
	bge	.L66
	mov	r3, #1
	b	.L68
.L66:
	mov	r3, #0
.L68:
	mov	r0, r3
	add	r7, r7, #36
	mov	sp, r7
	pop	{r7}
	bx	lr
	.size	collision, .-collision
	.align	2
	.global	main
	.thumb
	.thumb_func
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 904
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r7, lr}
	sub	sp, sp, #916
	add	r7, sp, #8
	add	r3, r7, #4
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #4
	mov	r2, #1
	str	r2, [r3, #16]
	add	r3, r7, #4
	mov	r2, #220
	str	r2, [r3, #0]
	add	r3, r7, #4
	mov	r2, #100
	str	r2, [r3, #4]
	add	r3, r7, #4
	mov	r2, #0
	str	r2, [r3, #12]
	add	r3, r7, #40
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #40
	mov	r2, #2
	str	r2, [r3, #16]
	add	r3, r7, #40
	mov	r2, #250
	str	r2, [r3, #0]
	add	r3, r7, #40
	mov	r2, #100
	str	r2, [r3, #4]
	add	r3, r7, #40
	mov	r2, #1
	str	r2, [r3, #12]
	add	r3, r7, #76
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #76
	mov	r2, #3
	str	r2, [r3, #16]
	add	r3, r7, #76
	mov	r2, #280
	str	r2, [r3, #0]
	add	r3, r7, #76
	mov	r2, #100
	str	r2, [r3, #4]
	add	r3, r7, #76
	mov	r2, #2
	str	r2, [r3, #12]
	add	r3, r7, #112
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #112
	mov	r2, #4
	str	r2, [r3, #16]
	add	r3, r7, #112
	mov	r2, #310
	str	r2, [r3, #0]
	add	r3, r7, #112
	mov	r2, #100
	str	r2, [r3, #4]
	add	r3, r7, #112
	mov	r2, #3
	str	r2, [r3, #12]
	add	r3, r7, #148
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #148
	mov	r2, #5
	str	r2, [r3, #16]
	add	r3, r7, #148
	mov	r2, #340
	str	r2, [r3, #0]
	add	r3, r7, #148
	mov	r2, #100
	str	r2, [r3, #4]
	add	r3, r7, #148
	mov	r2, #4
	str	r2, [r3, #12]
	add	r3, r7, #184
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #184
	mov	r2, #6
	str	r2, [r3, #16]
	add	r3, r7, #184
	mov	r2, #370
	str	r2, [r3, #0]
	add	r3, r7, #184
	mov	r2, #100
	str	r2, [r3, #4]
	add	r3, r7, #184
	mov	r2, #5
	str	r2, [r3, #12]
	add	r3, r7, #220
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #220
	mov	r2, #7
	str	r2, [r3, #16]
	add	r3, r7, #220
	mov	r2, #220
	str	r2, [r3, #0]
	add	r3, r7, #220
	mov	r2, #130
	str	r2, [r3, #4]
	add	r3, r7, #220
	mov	r2, #6
	str	r2, [r3, #12]
	add	r3, r7, #256
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #256
	mov	r2, #8
	str	r2, [r3, #16]
	add	r3, r7, #256
	mov	r2, #250
	str	r2, [r3, #0]
	add	r3, r7, #256
	mov	r2, #130
	str	r2, [r3, #4]
	add	r3, r7, #256
	mov	r2, #7
	str	r2, [r3, #12]
	add	r3, r7, #292
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #292
	mov	r2, #9
	str	r2, [r3, #16]
	add	r3, r7, #292
	mov	r2, #280
	str	r2, [r3, #0]
	add	r3, r7, #292
	mov	r2, #130
	str	r2, [r3, #4]
	add	r3, r7, #292
	mov	r2, #8
	str	r2, [r3, #12]
	add	r3, r7, #328
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #328
	mov	r2, #10
	str	r2, [r3, #16]
	add	r3, r7, #328
	mov	r2, #310
	str	r2, [r3, #0]
	add	r3, r7, #328
	mov	r2, #130
	str	r2, [r3, #4]
	add	r3, r7, #328
	mov	r2, #9
	str	r2, [r3, #12]
	add	r3, r7, #364
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #364
	mov	r2, #11
	str	r2, [r3, #16]
	add	r3, r7, #364
	mov	r2, #340
	str	r2, [r3, #0]
	add	r3, r7, #364
	mov	r2, #130
	str	r2, [r3, #4]
	add	r3, r7, #364
	mov	r2, #10
	str	r2, [r3, #12]
	add	r3, r7, #400
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #400
	mov	r2, #12
	str	r2, [r3, #16]
	add	r3, r7, #400
	mov	r2, #370
	str	r2, [r3, #0]
	add	r3, r7, #400
	mov	r2, #130
	str	r2, [r3, #4]
	add	r3, r7, #400
	mov	r2, #11
	str	r2, [r3, #12]
	add	r3, r7, #436
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #436
	mov	r2, #13
	str	r2, [r3, #16]
	add	r3, r7, #436
	mov	r2, #220
	str	r2, [r3, #0]
	add	r3, r7, #436
	mov	r2, #160
	str	r2, [r3, #4]
	add	r3, r7, #436
	mov	r2, #12
	str	r2, [r3, #12]
	add	r3, r7, #472
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #472
	mov	r2, #14
	str	r2, [r3, #16]
	add	r3, r7, #472
	mov	r2, #250
	str	r2, [r3, #0]
	add	r3, r7, #472
	mov	r2, #160
	str	r2, [r3, #4]
	add	r3, r7, #472
	mov	r2, #13
	str	r2, [r3, #12]
	add	r3, r7, #508
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #508
	mov	r2, #15
	str	r2, [r3, #16]
	add	r3, r7, #508
	mov	r2, #280
	str	r2, [r3, #0]
	add	r3, r7, #508
	mov	r2, #160
	str	r2, [r3, #4]
	add	r3, r7, #508
	mov	r2, #14
	str	r2, [r3, #12]
	add	r3, r7, #544
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #544
	mov	r2, #16
	str	r2, [r3, #16]
	add	r3, r7, #544
	mov	r2, #310
	str	r2, [r3, #0]
	add	r3, r7, #544
	mov	r2, #160
	str	r2, [r3, #4]
	add	r3, r7, #544
	mov	r2, #15
	str	r2, [r3, #12]
	add	r3, r7, #580
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #580
	mov	r2, #17
	str	r2, [r3, #16]
	add	r3, r7, #580
	mov	r2, #340
	str	r2, [r3, #0]
	add	r3, r7, #580
	mov	r2, #160
	str	r2, [r3, #4]
	add	r3, r7, #580
	mov	r2, #16
	str	r2, [r3, #12]
	add	r3, r7, #616
	mov	r2, #1
	str	r2, [r3, #28]
	add	r3, r7, #616
	mov	r2, #18
	str	r2, [r3, #16]
	add	r3, r7, #616
	mov	r2, #370
	str	r2, [r3, #0]
	add	r3, r7, #616
	mov	r2, #160
	str	r2, [r3, #4]
	add	r3, r7, #616
	mov	r2, #17
	str	r2, [r3, #12]
	mov	r3, #1
	str	r3, [r7, #680]
	mov	r3, #19
	str	r3, [r7, #668]
	mov	r3, #220
	str	r3, [r7, #652]
	mov	r3, #190
	str	r3, [r7, #656]
	mov	r3, #18
	str	r3, [r7, #664]
	mov	r3, #1
	str	r3, [r7, #716]
	mov	r3, #20
	str	r3, [r7, #704]
	mov	r3, #250
	str	r3, [r7, #688]
	mov	r3, #190
	str	r3, [r7, #692]
	mov	r3, #19
	str	r3, [r7, #700]
	mov	r3, #1
	str	r3, [r7, #752]
	mov	r3, #21
	str	r3, [r7, #740]
	mov	r3, #280
	str	r3, [r7, #724]
	mov	r3, #190
	str	r3, [r7, #728]
	mov	r3, #20
	str	r3, [r7, #736]
	mov	r3, #1
	str	r3, [r7, #788]
	mov	r3, #22
	str	r3, [r7, #776]
	mov	r3, #310
	str	r3, [r7, #760]
	mov	r3, #190
	str	r3, [r7, #764]
	mov	r3, #21
	str	r3, [r7, #772]
	mov	r3, #1
	str	r3, [r7, #824]
	mov	r3, #23
	str	r3, [r7, #812]
	mov	r3, #340
	str	r3, [r7, #796]
	mov	r3, #190
	str	r3, [r7, #800]
	mov	r3, #22
	str	r3, [r7, #808]
	mov	r3, #1
	str	r3, [r7, #860]
	mov	r3, #24
	str	r3, [r7, #848]
	mov	r3, #370
	str	r3, [r7, #832]
	mov	r3, #190
	str	r3, [r7, #836]
	mov	r3, #23
	str	r3, [r7, #844]
	mov	r3, #1
	str	r3, [r7, #896]
	mov	r3, #25
	str	r3, [r7, #884]
	mov	r3, #220
	str	r3, [r7, #868]
	mov	r3, #220
	str	r3, [r7, #872]
	mov	r3, #24
	str	r3, [r7, #880]
	bl	createMappingMemory
	mov	r0, #0
	mov	r1, #0
	mov	r2, #7
	bl	set_background_color
	b	.L74
.L123:
	nop
.L74:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L123
	add	r3, r7, #4
	ldr	r0, [r3, #16]
	add	r3, r7, #4
	ldr	r1, [r3, #0]
	add	r3, r7, #4
	ldr	r2, [r3, #4]
	add	r3, r7, #4
	ldr	r3, [r3, #12]
	add	r4, r7, #4
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L73
.L124:
	nop
.L73:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L124
	add	r3, r7, #40
	ldr	r0, [r3, #16]
	add	r3, r7, #40
	ldr	r1, [r3, #0]
	add	r3, r7, #40
	ldr	r2, [r3, #4]
	add	r3, r7, #40
	ldr	r3, [r3, #12]
	add	r4, r7, #40
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L76
.L125:
	nop
.L76:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L125
	add	r3, r7, #76
	ldr	r0, [r3, #16]
	add	r3, r7, #76
	ldr	r1, [r3, #0]
	add	r3, r7, #76
	ldr	r2, [r3, #4]
	add	r3, r7, #76
	ldr	r3, [r3, #12]
	add	r4, r7, #76
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L78
.L126:
	nop
.L78:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L126
	add	r3, r7, #112
	ldr	r0, [r3, #16]
	add	r3, r7, #112
	ldr	r1, [r3, #0]
	add	r3, r7, #112
	ldr	r2, [r3, #4]
	add	r3, r7, #112
	ldr	r3, [r3, #12]
	add	r4, r7, #112
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L80
.L127:
	nop
.L80:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L127
	add	r3, r7, #148
	ldr	r0, [r3, #16]
	add	r3, r7, #148
	ldr	r1, [r3, #0]
	add	r3, r7, #148
	ldr	r2, [r3, #4]
	add	r3, r7, #148
	ldr	r3, [r3, #12]
	add	r4, r7, #148
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L82
.L128:
	nop
.L82:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L128
	add	r3, r7, #184
	ldr	r0, [r3, #16]
	add	r3, r7, #184
	ldr	r1, [r3, #0]
	add	r3, r7, #184
	ldr	r2, [r3, #4]
	add	r3, r7, #184
	ldr	r3, [r3, #12]
	add	r4, r7, #184
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L84
.L129:
	nop
.L84:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L129
	add	r3, r7, #220
	ldr	r0, [r3, #16]
	add	r3, r7, #220
	ldr	r1, [r3, #0]
	add	r3, r7, #220
	ldr	r2, [r3, #4]
	add	r3, r7, #220
	ldr	r3, [r3, #12]
	add	r4, r7, #220
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L86
.L130:
	nop
.L86:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L130
	add	r3, r7, #256
	ldr	r0, [r3, #16]
	add	r3, r7, #256
	ldr	r1, [r3, #0]
	add	r3, r7, #256
	ldr	r2, [r3, #4]
	add	r3, r7, #256
	ldr	r3, [r3, #12]
	add	r4, r7, #256
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L88
.L131:
	nop
.L88:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L131
	add	r3, r7, #292
	ldr	r0, [r3, #16]
	add	r3, r7, #292
	ldr	r1, [r3, #0]
	add	r3, r7, #292
	ldr	r2, [r3, #4]
	add	r3, r7, #292
	ldr	r3, [r3, #12]
	add	r4, r7, #292
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L90
.L132:
	nop
.L90:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L132
	add	r3, r7, #328
	ldr	r0, [r3, #16]
	add	r3, r7, #328
	ldr	r1, [r3, #0]
	add	r3, r7, #328
	ldr	r2, [r3, #4]
	add	r3, r7, #328
	ldr	r3, [r3, #12]
	add	r4, r7, #328
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L92
.L133:
	nop
.L92:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L133
	add	r3, r7, #364
	ldr	r0, [r3, #16]
	add	r3, r7, #364
	ldr	r1, [r3, #0]
	add	r3, r7, #364
	ldr	r2, [r3, #4]
	add	r3, r7, #364
	ldr	r3, [r3, #12]
	add	r4, r7, #364
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L94
.L134:
	nop
.L94:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L134
	add	r3, r7, #400
	ldr	r0, [r3, #16]
	add	r3, r7, #400
	ldr	r1, [r3, #0]
	add	r3, r7, #400
	ldr	r2, [r3, #4]
	add	r3, r7, #400
	ldr	r3, [r3, #12]
	add	r4, r7, #400
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L96
.L135:
	nop
.L96:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L135
	add	r3, r7, #436
	ldr	r0, [r3, #16]
	add	r3, r7, #436
	ldr	r1, [r3, #0]
	add	r3, r7, #436
	ldr	r2, [r3, #4]
	add	r3, r7, #436
	ldr	r3, [r3, #12]
	add	r4, r7, #436
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L98
.L136:
	nop
.L98:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L136
	add	r3, r7, #472
	ldr	r0, [r3, #16]
	add	r3, r7, #472
	ldr	r1, [r3, #0]
	add	r3, r7, #472
	ldr	r2, [r3, #4]
	add	r3, r7, #472
	ldr	r3, [r3, #12]
	add	r4, r7, #472
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L100
.L137:
	nop
.L100:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L137
	add	r3, r7, #508
	ldr	r0, [r3, #16]
	add	r3, r7, #508
	ldr	r1, [r3, #0]
	add	r3, r7, #508
	ldr	r2, [r3, #4]
	add	r3, r7, #508
	ldr	r3, [r3, #12]
	add	r4, r7, #508
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L102
.L138:
	nop
.L102:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L138
	add	r3, r7, #544
	ldr	r0, [r3, #16]
	add	r3, r7, #544
	ldr	r1, [r3, #0]
	add	r3, r7, #544
	ldr	r2, [r3, #4]
	add	r3, r7, #544
	ldr	r3, [r3, #12]
	add	r4, r7, #544
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L104
.L139:
	nop
.L104:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L139
	add	r3, r7, #580
	ldr	r0, [r3, #16]
	add	r3, r7, #580
	ldr	r1, [r3, #0]
	add	r3, r7, #580
	ldr	r2, [r3, #4]
	add	r3, r7, #580
	ldr	r3, [r3, #12]
	add	r4, r7, #580
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L106
.L140:
	nop
.L106:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L140
	add	r3, r7, #616
	ldr	r0, [r3, #16]
	add	r3, r7, #616
	ldr	r1, [r3, #0]
	add	r3, r7, #616
	ldr	r2, [r3, #4]
	add	r3, r7, #616
	ldr	r3, [r3, #12]
	add	r4, r7, #616
	ldr	r4, [r4, #28]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L108
.L141:
	nop
.L108:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L141
	ldr	r0, [r7, #668]
	ldr	r1, [r7, #652]
	ldr	r2, [r7, #656]
	ldr	r3, [r7, #664]
	ldr	r4, [r7, #680]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L110
.L142:
	nop
.L110:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L142
	ldr	r0, [r7, #704]
	ldr	r1, [r7, #688]
	ldr	r2, [r7, #692]
	ldr	r3, [r7, #700]
	ldr	r4, [r7, #716]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L112
.L143:
	nop
.L112:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L143
	ldr	r0, [r7, #740]
	ldr	r1, [r7, #724]
	ldr	r2, [r7, #728]
	ldr	r3, [r7, #736]
	ldr	r4, [r7, #752]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L114
.L144:
	nop
.L114:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L144
	ldr	r0, [r7, #776]
	ldr	r1, [r7, #760]
	ldr	r2, [r7, #764]
	ldr	r3, [r7, #772]
	ldr	r4, [r7, #788]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L116
.L145:
	nop
.L116:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L145
	ldr	r0, [r7, #812]
	ldr	r1, [r7, #796]
	ldr	r2, [r7, #800]
	ldr	r3, [r7, #808]
	ldr	r4, [r7, #824]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L118
.L146:
	nop
.L118:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L146
	ldr	r0, [r7, #848]
	ldr	r1, [r7, #832]
	ldr	r2, [r7, #836]
	ldr	r3, [r7, #844]
	ldr	r4, [r7, #860]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	b	.L120
.L147:
	nop
.L120:
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L147
	ldr	r0, [r7, #884]
	ldr	r1, [r7, #868]
	ldr	r2, [r7, #872]
	ldr	r3, [r7, #880]
	ldr	r4, [r7, #896]
	str	r4, [sp, #0]
	bl	set_sprite
	nop
	bl	closeMappingMemory
	mov	r0, r3
	add	r7, r7, #908
	mov	sp, r7
	pop	{r4, r7, pc}
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section	.note.GNU-stack,"",%progbits
