	.global	set_background_block
	.type	set_background_block, %function
@ void set_background_block(unsigned long linha, unsigned long coluna, 
@ unsigned long vermelho, unsigned long verde, unsigned long azul)
set_background_block:
	push	{lr}				
	@ dataA = endereco[17:4], opcode[3:0]
	@ endereco = (linha * 80) + coluna
	@ opcode = 2
	@ dataB = azul[8:6], verde[5:3], vermelho[2:0]
	lsl r3, r3, #3		@ r3 = verde	
	orr r3, r3, r2		@ r3 = [verde, vermelho]

	ldr	r2, [sp, #4]	@ r2 = azul
	lsl r2, r2, #6			
	orr r3, r3, r2		@ r3 = [azul, verde, vermelho]	

	mov r2, #80			
	mul r0, r0, r2		@ r0 = linha * 80		
	add r0, r0, r1 		@ r0 = endereco

	lsl r0, #4			
	add r0, r0, #2		@ r0 = dataA

	mov r1, r3			@ r1 = dataB

	bl	sendInstruction 		

	pop 	{lr}
    bx lr