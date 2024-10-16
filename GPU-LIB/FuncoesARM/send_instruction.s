    .global sendInstruction
sendInstruction:
    push {lr}                  @ Salva o registrador de link (lr) na pilha

    mov r2, r0                 @ armazena o valor de dataA de r0 em outro registrador temporario(preserva dataA)
    mov r3, r1                 @ armazena o valor de dataB de r1 em outro registrador temporario(preserva dataB)

    bl isFull                  @ Chama isFull, retorno no r0
    cmp r0, #0                 @ Compara retorno de isFull com 0
    bne fim_sendInstruction     @ Se r0 != 0, sai da função

    ldr r0, =h2p_lw_wrReg_addr  @ Carrega o endereço de wrReg
    mov r1, #0                  @ r1 = 1
    str r1, [r0]                @ 0 em wrReg

    ldr r0, =h2p_lw_dataA_addr  @ Carrega o endereço de dataA
    str r2, [r0]                @ valor de dataA (em r2) no endereço de dataA

    ldr r0, =h2p_lw_dataB_addr  @ Carrega o endereço de dataB
    str r3, [r0]                @ valor de dataB (em r3) no endereço de dataB

    ldr r0, =h2p_lw_wrReg_addr   @ Carrega o endereço de wrReg
    mov r1, #1                   @  r1 = 1
    str r1, [r0]                 @ 1 em wrReg

    mov r1, #0                   @ r1 como 0
    str r1, [r0]                 @ 0 em wrReg

fim_sendInstruction:
    pop {lr}
    bx lr

@ ---------------- NOVA --------------

	.global	send_instruction
	.type	send_instruction, %function
@ void send_instruction(unsigned int dataA, unsigned int dataB)
send_instruction:
    @ r0 = dataA
    @ r1 = dataB
	push	{lr}
while_send_instruction:
	movw	r2, #:lower16:pWrFull   
	movt	r2, #:upper16:pWrFull
	ldr	r2, [r2]                    @ r2 = valor de pWrFull(um endereco)
	ldr	r2, [r2]                    @ r2 = valor indicado pelo endereco
	cmp	r2, #0                      @ if (*pWrFull == 0)
	bne	while_send_instruction      @ while (1)

	movw	r2, #:lower16:pWrReg
	movt	r2, #:upper16:pWrReg
	ldr	r2, [r2]                    @ r2 = pWrReg
	mov	r3, #0
	str	r3, [r2]                    @ *pWrReg = 0

	movw	r3, #:lower16:pDataA
	movt	r3, #:upper16:pDataA
	ldr	r3, [r3]                    @ r3 = pDataA
	str	r0, [r3]                    @ *pDataA = dataA

	movw	r3, #:lower16:pDATAB
	movt	r3, #:upper16:pDATAB
	ldr	r3, [r3]                    @ r3 = pDataB
	str	r1, [r3]                    @ *pDATAB = dataB

	mov	r3, #1
	str	r3, [r2]                    @ *pWrReg = 1

	mov	r3, #0
	str	r3, [r2]                    @ *pWrReg = 0

	pop	{lr}
	bx	lr