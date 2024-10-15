.global	set_polygon
.type	set_polygon, %function
set_polygon:

    @int color, int address, int form, int mult, int ref_point_x, int ref_point_y
	push	{lr}				@ Guardar LR e parametros na memória
                                @#0 - ref_point_X | #4 - red_point_y

    lsl r2, r2, #9          @ r2 = r2 << 9
    orr r2, r2, r0          @ r3 = r3 | r1 (color)
    
    lsl r2, r2, #4          @ r3 = r3 << 4
    orr r2, r2, r3          @ r3 = r3 | r1 (mult)

    ldr	r0, [sp, #8]	        @ load r1 -> ref_point_x
    lsl r2, r2, #9          @ r3 = r3 << 9
    orr r2, r2, r0          @ r3 = r3 | r1 (ref_point_x)
    
    ldr	r0, [sp,#4]	    @ load r1 -> ref_point_yz
    lsl r2, r2, #9          @ r3 = r3 << 9
    orr r2, r2, r0          @ r3 = r3 | r1 (ref_point_yz)

    mov r0, r1
    lsl r0, r0, #4
    orr r0, r0, #3

    mov r1, r2

    bl sendInstruction      @ sendInstruction(dataA, dataB)

    pop     {lr}
    bx lr

