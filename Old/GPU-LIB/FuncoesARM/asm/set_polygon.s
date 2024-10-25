    .global	set_polygon
    .type	set_polygon, %function
@ void set_polygon(unsigned long id, unsigned long cor, unsigned long forma,
@   unsigned long tamanho, unsigned long x, unsigned long y)
set_polygon:
	push	{lr}		
    @ dataA = id[7:4], opcode[3:0]
    @ dataB = Forma[31], BGR[30:22], Tamanho[21:18], y[17:9], x[8:0]

    lsl r0, r0, #4      @ r0 = dataA
    orr r0, r0, #3      @ opcode = 3

    lsl r1, r1, #22     @ r1 = cor(BGR)
    lsl r2, r2, #31     @ r2 = forma
    lsl r3, r3, #18     @ r3 = tamanho
      
    orr r1, r1, r2      @ r1 = dataB
    orr r1, r1, r3      @ dataB faltando x e y  
    
    ldr	r2, [sp, #8]    @ r2 = x        
    ldr	r3, [sp,#4]	    @ r3 = y

    lsl r3, r3, #9      

    orr r1, r1, r2          
    orr r1, r1, r3      @ dataB completo

    bl sendInstruction      @ sendInstruction(dataA, dataB)

    pop     {lr}
    bx lr

