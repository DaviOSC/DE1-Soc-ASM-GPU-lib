    .global	set_sprite
    .type	set_sprite, %function
@void set_sprite(unsigned long id, unsigned long sprite_image,
@   unsigned long ativado, unsigned long x, unsigned long y)
set_sprite:
	push	{lr}				

    @ dataA = id[8:4], opcode[3:0]
    @ dataB = ativado[29], x[28:19], y[18:9], sprite_image[8:0]
    @ opcode = 0

    lsl r0, r0, #4      @ r0 = dataA  

    lsl r2, r2, #29     @ r2 = ativado
    lsl r3, r3, #19     @ r3 = x

    orr r1, r1, r2      @ r1 = sprite_image
    orr r1, r1, r3      @ dataB falta y

    ldr	r2, [sp, #4]	@ r2 = y
    lsl r2,r2, #9  
    orr r1, r1, r2      @ r1 = dataB
          
    bl sendInstruction      

    pop     {lr}
    bx lr