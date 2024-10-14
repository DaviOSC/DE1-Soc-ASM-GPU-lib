.global	setSprite
.type	setSprite, %function
    setSprite:

    @ int x, int registrador, int y, int activation_bit, int offset
	push	{lr}				@ Guardar LR e parametros na memória
	sub	sp, sp, #16             
	str	r0, [sp, #0]			@ x | valor 1 para os parametros de dataA_builder
	str	r1, [sp, #4]			@ registrador
	str	r2, [sp, #8]			@ y | valor 2 para os parametros de dataA_builder
	str	r3, [sp, #12]			@ activation_bit
                                @ #16 - offset

    lsl r3, r3, #10             @ r3 (dataB) = r3 << 10

    orr r3, r3, r0          @ r3 = r3 | r0 (x)
    lsl r3, r3, #10         @ r3 = r3 << 10

    orr r3, r3, r2          @ r3 = r3 | r2 (y)
    lsl r3, r3, #9          @ r3 = r3 << 9
    
    ldr	r0, [sp, #16]	    @ load r1 -> offset
    orr r3, r3, r0          @ r3 = r3 | r0 (offset)

	mov	r0, #0              @ preset r1 em 0
    mov	r2, #0              @ preset r1 em 0
	bl	dataA_builder       @ dataA_builder(opcode,0,address)

    mov r1, r3              @ dataB vai para r1
    bl sendInstruction      @ sendInstruction(dataA, dataB)

	ldr	r0, [sp, #0]       
	ldr	r1, [sp, #4]        
	ldr	r2, [sp, #8]        
    ldr	r3, [sp, #12]        
    add sp, sp, #16

    pop     {lr}
    bx lr

