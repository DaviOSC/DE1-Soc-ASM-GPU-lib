.global	set_sprite
.type	set_sprite, %function
    set_sprite:

    @ int x, int registrador, int y, int activation_bit, int offset
	push	{lr}				@ Guardar LR e parametros na memória   
                                @ #16 - offset

    lsl r3, r3, #10             @ r3 (dataB) = r3 << 10

    orr r3, r3, r0          @ r3 = r3 | r0 (x)
    lsl r3, r3, #10         @ r3 = r3 << 10

    orr r3, r3, r2          @ r3 = r3 | r2 (y)
    lsl r3, r3, #9          @ r3 = r3 << 9
    
    ldr	r0, [sp, #4]	    @ load r1 -> offset
    orr r3, r3, r0          @ r3 = r3 | r0 (offset)

	mov	r0, r1
    lsl r0, r0, #4

    mov r1, r3              @ dataB vai para r1
    bl sendInstruction      @ sendInstruction(dataA, dataB)

    pop     {lr}
    bx lr