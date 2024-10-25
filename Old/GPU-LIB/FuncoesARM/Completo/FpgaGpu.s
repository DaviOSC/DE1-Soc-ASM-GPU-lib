	.global	pDevMem
	.type	pDevMem, %object
pDevMem:
	.space	4
    
	.global	pDataA
	.type	pDataA, %object
pDataA:
	.space	4

	.global	pDATAB
	.type	pDATAB, %object
pDATAB:
	.space	4

	.global	pWrReg
	.type	pWrReg, %object
pWrReg:
	.space	4

	.global	pWrFull
	.type	pWrFull, %object
pWrFull:
	.space	4

	.global	pScreen
	.type	pScreen, %object
pScreen:
	.space	4

	.global	pResetPulseCounter
	.type	pResetPulseCounter, %object
pResetPulseCounter:
	.space	4

	.global	fd
	.type	fd, %object
fd:
	.space	4

.global	create_mapping_memory
.type	create_mapping_memory, %function
@ int create_mapping_memory()
create_mapping_memory:
	@ r3
	push	{r4-r7, lr}
	movw	r0, #:lower16:nomeArquivo
	movt	r0, #:upper16:nomeArquivo		@ open("/dev/mem", ...
	mov r1, #1052674						@ ...(O_RDWR | O_SYNC))
	mov r7, #5								@ syscall: open
	swi #0

	cmp	r0, #-1								@ if(fd == -1) ...
	bne	mmap_dev_mem						@ ... encerra o programa
	pop 	{r4-r7, lr}
	bx lr
mmap_dev_mem:
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	str	r0, [r3]							@ guardar fd

	mov r4, r0								@ r4 = fd
	mov r0, #0								@ mmap(0,
	mov r1, 0x04000000						@ HW_REGS_SPON,
	mov r2, #3								@ (PROT_READ | PROT_WRITE),
	mov r3, #1								@ MAP_SHARED, r4 = fd,
	mov r5, 0xfc000000						@ HW_REGS_BASE)
	mov r7, 192
	swi #0

	cmp r0, #-1
	bne mmap_concluido
	pop 	{r4-r7, lr}
	bx lr
mmap_concluido:
	movw	r1, #:lower16:pDevMem
	movt	r1, #:upper16:pDevMem
	str	r0, [r1]							@ salvar pDevMem

	add r0, r0, 0xff200000					@ base = pDevMem + ALT_LWFPGASLVS_OFST
	
	add r2, r0, 0x70
	movw	r3, #:lower16:pDataB
	movt	r3, #:upper16:pDataB
	str	r2, [r3]

	add r2, r0, 0x80
	movw	r3, #:lower16:pDataA
	movt	r3, #:upper16:pDataA
	str	r2, [r3]

	add r2, r0, 0x90
	movw	r3, #:lower16:pResetPulseCounter
	movt	r3, #:upper16:pResetPulseCounter
	str	r2, [r3]

	add r2, r0, 0xA0
	movw	r3, #:lower16:pScreen
	movt	r3, #:upper16:pScreen
	str	r2, [r3]

	add r2, r0, 0xB0
	movw	r3, #:lower16:pWrFull
	movt	r3, #:upper16:pWrFull
	str	r2, [r3]

	add r2, r0, 0xC0
	movw	r3, #:lower16:pWrReg
	movt	r3, #:upper16:pWrReg
	str	r2, [r3]

	mov r0, #1
	pop 	{r4-r7, lr}
	bx lr

.global closeMappingMemory  
closeMappingMemory:
    pop {r7, lr}

    movw	r0, #:lower16:pDevMem
	movt	r0, #:upper16:pDevMem
	ldr	r0, [r0]

    mov r1, #0x04000000     
    mov r7, #91                
    swi 0                      

    cmp r0, #0           
    bne end_close_mapping

    movw	r0, #:lower16:fd
	movt	r0, #:upper16:fd
	ldr	r0, [r0]

    mov r7, #6 
    swi 0  
end_close_mapping:
    pop {r7, lr}
    bx lr                 

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

	.global	wait_screen
	.type	wait_screen, %function
@ void waitScreen(int limit)
wait_screen:
	push	{r4, lr}
	@ r0 = limit
	@ r1 como contador de screens
	@ r2 para valores imediatos
	@ r3 para pScreen
	@ r4 para pResetPulse Couter

	mov	r1, #0									@ r1 = 0

	movw r3, #:lower16:pScreen					
	movt r3, #:upper16:pScreen					
	ldr	r3, [r3]								@ r3 = endereco apontado por pScreen

	movw r4, #:lower16:pResetPulseCounter		
	movt r4, #:upper16:pResetPulseCounter
	ldr	r4, [r4]								@ r4 = endereco do pulse counter

loop_wait_screen:
	cmp	r1, r0
	bgt	end_wait_screen							@ while (screens <= limit)

	
	ldr	r2, [r3]								@ r2 = valor do endereco de pScreen
	cmp	r2, #1									@ if (*pScreen == 1)

	bne	loop_wait_screen

	add	r1, r1, #1								@ screens++

	mov	r2, #1
	str	r2, [r4]

	mov	r2, #0
	str	r2, [r4]

 	b loop_wait_screen

end_wait_screen:
	pop	{r4, lr}
	bx	lr

