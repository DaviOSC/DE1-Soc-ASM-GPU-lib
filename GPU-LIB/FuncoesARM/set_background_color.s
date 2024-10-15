.global	set_background_color
.type	set_background_color, %function
set_background_color:
	@r0 = red, r1 = green, r2 = blue
    push    {lr}            @ salvar lr na stack

    lsl r2, r2, #6          @ r2 = 0...00(blue)000000
    lsl r1, r1, #3          @ r2 = 0...00(Green)000
    orr r3, r1, r2          @ r2 = 0...00(blue)(Green)
    orr r3, r3, r0          @ r1 = 0...00(blue)(Green)(Red)
    
    mov	r0, #0              @ dataA

	mov r1, r3
    bl sendInstruction      @ sendInstruction(dataA, RGB)
    pop     {lr}
	bx lr