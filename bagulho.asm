	.section .rodata
	.align 2
pathDevMem:
	.ascii	"/dev/mem\000"
	.align 2
lw_alt:
	.word 0xff200

	.data
	.align 2
pDevMem:
	.zero 4
	.align 2
fd:
	.zero 4

	.text
	.align 2
	.global	_start
	.type	_start, %function
@ int _start()
_start:
	push	{r4-r7, lr}
	ldr r0, =pathDevMem
	@ ldr r0, [r0]
	movw r1, #4098
	movt r1, #16						@ ...(O_RDWR | O_SYNC))
	mov r7, #5								@ syscall: open
	svc #0

	ldr r3, =fd
	str	r0, [r3]							@ guardar fd

	mov r0, #5

	ldr r3, =fd
	ldr r0, [r3]

	mov r7, #1
	swi #0

	mov r4, r0								@ r4 = fd
	mov r0, #0								@ mmap(0,
	mov r1, #4096				@ HW_REGS_SPAN,
	mov r2, #3								@ (PROT_READ | PROT_WRITE),
	mov r3, #1								@ MAP_SHARED, r4 = fd,
	ldr r5, =lw_alt			@ HW_REGS_BASE)
	ldr r5, [r5]
	mov r7, #192
	svc #0

	mov	r3, #0
	str	r3, [r0, #0xc0]                    @ *pWrReg = 0
 
	mov r3, #0
	str	r3, [r0, #0x80]                    @ *pDataA = dataA

	mov r3, #0b000111111
	str	r3, [r0, #0x70] 				@ *pDATAB = dataB          

	mov	r3, #1
	str	r3, [r0, #0xc0]                    @ *pWrReg = 1

	mov	r3, #0
	str	r3, [r0, #0xc0]                    @ *pWrReg = 0	


@ 	ldr r1, =pDevMem
@ 	str	r0, [r1]							@ salvar pDevMem

@ send_instruction: 
@    	@ r0 = dataA
@     @ r1 = dataB
@ 	push	{lr}
@ while_send_instruction:
@ 	ldr	r2, =pDevMem                    @ r2 = valor de pWrFull(um endereco)
@ 	ldr	r2, [r2, #0xb0]                    @ r2 = valor indicado pelo endereco
@ 	cmp	r2, #0                      @ if (*pWrFull == 0)
@ 	bne	while_send_instruction      @ while (1)

@ 	ldr r2, =pDevMem
@ 	ldr	r2, [r2,#0xc0]                    @ r2 = pWrReg
@ 	mov	r3, #0
@ 	str	r3, [r2]                    @ *pWrReg = 0

@ 	ldr r3, =pDevMem
@ 	ldr	r3, [r3,#0x80]   
@ 	str	r0, [r3]                    @ *pDataA = dataA

@ 	ldr r3, =pDevMem
@ 	ldr	r3, [r3,#0x70] 
@ 	str	r1, [r3]                    @ *pDATAB = dataB

@ 	mov	r3, #1
@ 	str	r3, [r2]                    @ *pWrReg = 1

@ 	mov	r3, #0
@ 	str	r3, [r2]                    @ *pWrReg = 0

@ 	pop	{lr}
@ 	bx	lr
