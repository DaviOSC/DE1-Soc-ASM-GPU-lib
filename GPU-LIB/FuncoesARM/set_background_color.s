    .global	set_background_color
    .type	set_background_color, %function
@ void set_background_color(unsigned long vermelho, 
@ unsigned long verde, unsigned long azul)
set_background_color:
    @ dataA = reg [8:4], opcode[3:0]
	@ dataA = 0 (reg = 0 e opcode = 0)
    @ dataB = azul[8:6], verde[5:3], vermelho[2:0]
    push    {lr}    

    lsl r2, r2, #6          @ r2 = azul
    lsl r1, r1, #3          @ r1 = verde

    orr r1, r1, r2          @ r1 = [azul, verde]
    orr r1, r1, r0          @ r1 = [azul, verde, vermelho]
                            @ r1 = dataB
    mov	r0, #0              @ r0 = dataA

    bl send_instruction      @ send_instruction(dataA, dataB)
    pop     {lr}
	bx lr