.global	setPolygon
.type	setPolygon, %function
    setPolygon:

    @ int address, int opcode, int color, int form, int mult, int ref_point_x, int ref_point_yz
	push	{lr}				@ Guardar LR e parametros na memória
	sub	sp, sp, #28             
	str	r0, [sp, #0]			@ opcode | valor 1 para os parametros de dataA_builder
	str	r1, [sp, #4]			@ color
	str	r2, [sp, #8]			@ address | valor 2 para os parametros de dataA_builder
	str	r3, [sp, #12]			@ form
                                @ #16 - mult | #20 - ref_point_X | #24 - red_point_yz

    add r3, rzr, #0         @ dataB = r3 (form)
    lsl r3, r3, #9          @ r3 = r3 << 9
    orr r3, r3, r1          @ r3 = r3 | r1 (color)
    
    ldr	r1, [sp, #16]	    @ load r1 -> mult
    lsl r3, r3, #4          @ r3 = r3 << 4
    orr r3, r3, r1          @ r3 = r3 | r1 (mult)

    ldr	r1, [sp, #20]	    @ load r1 -> ref_point_x
    lsl r3, r3, #9          @ r3 = r3 << 9
    orr r3, r3, r1          @ r3 = r3 | r1 (ref_point_x)
    
    ldr	r1, [sp, #24]	    @ load r1 -> ref_point_yz
    lsl r3, r3, #9          @ r3 = r3 << 9
    orr r3, r3, r1          @ r3 = r3 | r1 (ref_point_yz)

	mov	r1, #0              @ preset r1 em 0
	bl	dataA_builder       @ dataA_builder(opcode,0,address)
    bl sendInstruction      @ sendInstruction(dataA, dataB)

	ldr	r0, [sp, #0]        @ Red 
	ldr	r1, [sp, #4]        @ Green
	ldr	r2, [sp, #8]        @ Blue
    ldr	r3, [sp, #12]        @ Blue
    add sp, sp, #28

    pop     {lr}
    bx lr

