	.section .rodata
	.align 2
pathDevMem:
	.ascii	"/dev/mem\000"
	.align 2
lw_alt:
	.word 0xff200				@ ALT_LWFPGASLVS_OFST / 4

	.data
	.align 2
pDevMem:						@ ponteiro para saida do mapeamento
	.zero 4						
	.align 2
fd:								@ file descriptor
	.zero 4

	.text
	.align 2
	.global	create_mapping_memory
	.type	create_mapping_memory, %function
@ int create_mapping_memory()
create_mapping_memory:
	push	{r4-r7, lr}
	ldr r0, =pathDevMem						@ open("/dev/mem" ...
	movw r1, #4098
	movt r1, #16							@ ...(O_RDWR | O_SYNC))
	mov r7, #5								@ syscall: open
	svc #0

	ldr r3, =fd
	str	r0, [r3]							@ guardar fd

	mov r4, r0								@ r4 = fd
	mov r0, #0								@ mmap2(0,
	mov r1, #4096							@ 4096,
	mov r2, #3								@ (PROT_READ | PROT_WRITE),
	mov r3, #1								@ MAP_SHARED, r4 = fd,
	ldr r5, =lw_alt							@ 0xff200)
	ldr r5, [r5]							
	mov r7, #192							@ syscall: mmap2
	svc #0

	ldr r1, =pDevMem
	str r0, [r1]							@ guardar ponteiro

	pop {r4-r7, lr}
	bx lr

	.align 2
	.global close_mapping_memory  
	.type	close_mapping_memory, %function
close_mapping_memory:						
    pop {lr}

    ldr r0, =pDevMem						@ munmap(pDevMem, 

    mov r1, #4096    						@ 4096)
    mov r7, #91                				@ syscall: munmap
    swi #0                      

	cmp r0, #0								@ if(munmap == 0)
	beq munmap_sucesso

	ldr r0, =fd								@ else ...

    mov r7, #6 								@ close(fd)
    swi #0  

munmap_sucesso:
    pop {lr}
    bx lr                 

	.align 2
	.global	send_instruction
	.type	send_instruction, %function
@ void send_instruction(unsigned int dataA, unsigned int dataB)
send_instruction: 
    @ r0 = dataA
    @ r1 = dataB
	push	{lr}
	ldr r3, =pDevMem				@ r3 = endereço do label
	ldr	r3, [r3]                    @ r3 = ponteiro do mapeamento
while_send_instruction:
	ldr	r2, [r3, #0xb0]             @ r2 = valor em WrFull
	cmp	r2, #0                     	@ if (*pWrFull == 0)
	bne	while_send_instruction      @ while (1)
	
	mov	r2, #0
	str	r2, [r3, #0xc0]             @ *pWrReg = 0

	str	r0, [r3, #0x80]             @ *pDataA = dataA

	str	r1, [r3, #0x70]             @ *pDATAB = dataB

	mov	r2, #1
	str	r2, [r3, #0xc0]             @ *pWrReg = 1

	mov	r2, #0
	str	r2, [r3, #0xc0]             @ *pWrReg = 0

	pop	{lr}
	bx	lr
	
	.align 2
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

	.align 2
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
	mul r0, r2, r0		@ r0 = linha * 80		
	add r0, r0, r1 		@ r0 = endereco

	lsl r0, #4			
	add r0, r0, #2		@ r0 = dataA

	mov r1, r3			@ r1 = dataB

	bl	send_instruction 		

	pop 	{lr}
    bx lr

	.align 2
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
          
    bl send_instruction      

    pop     {lr}
    bx lr

	.align 2
    .global	clear_sprite
    .type	clear_sprite, %function
/* Id : id do poligono a ser desativado. -1 desativa todos os poligonos
void clear_sprite(unsigned long id);*/
clear_sprite:
	push	{r4, lr}		
	@ r0 = id
	@ r4 = contador

	mov r4, #1					@ i = 1

	cmp r0, #-1					@ if(id == -1)
	beq clear_all_sprite		
								@ else
	mov r1, #0					@ set_sprite(id = r0, sprite_image = 0,
	mov r2, #0					@ ativado = 0,
	mov r3, #0					@ x = 0,
	push	{r2}				@ y =0)
	bl set_sprite
	pop 	{r2}

	bl exit_sprite

clear_all_sprite:				@ then
	mov r0, r4

	mov r1, #0					@ set_sprite(id = r0, sprite_image = 0,
	mov r2, #0					@ ativado = 0,
	mov r3, #0					@ x = 0,
	push	{r2}				@ x = 0, y =0)
	bl set_sprite
	pop 	{r2}

	add r4, #1

	cmp r4, #32					@ if(id == 15)
	bne clear_all_sprite		@ break;

exit_sprite:
    pop     {r4, lr}
    bx lr


	.align 2
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

    bl send_instruction      @ sendInstruction(dataA, dataB)

    pop     {lr}
    bx lr

	.align 2
    .global	clear_polygon
    .type	clear_polygon, %function
/* Id : id do poligono a ser desativado. -1 desativa todos os poligonos
void clear_polygon(unsigned long id);*/
clear_polygon:
	push	{r4, lr}		
	@ r0 = id
	@ r4 = contador

	mov r4, #0

	cmp r0, #-1					@ if(id == -1)
	beq clear_all_polygon		
								@ else
	mov r1, #0					@ set_polygon(id = r0, cor = 0,
	mov r2, #0					@ forma = 0,
	mov r3, #0					@ tamanho = 0,
	push	{r2, r3}			@ x = 0, y =0)
	bl set_polygon
	pop 	{r2, r3}

	bl exit_polygon

clear_all_polygon:				@ then
	mov r0, r4

	mov r1, #0					@ set_polygon(id = r0, cor = 0,
	mov r2, #0					@ forma = 0,
	mov r3, #0					@ tamanho = 0,
	push	{r2, r3}			@ x = 0, y =0)
	bl set_polygon
	pop 	{r2, r3}

	add r4, #1

	cmp r4, #15					@ if(id == 15)
	bne clear_all_polygon		@ break;

exit_polygon:
    pop     {r4, lr}
    bx lr

	.align 2
    .global	read_keys
    .type	read_keys, %function
read_keys:
	ldr r1, =pDevMem
	ldr r1, [r1]
	ldr r0, [r1, #0x0]
	mvn r0, r0;
	add r0, r0, #16
	bx lr

@ 	.align 2
@ 	.global	wait_screen
@ 	.type	wait_screen, %function
@ @ void waitScreen(int limit)
@ wait_screen:
@ 	push	{r4, lr}
@ 	@ r0 = limit
@ 	@ r1 como contador de screens
@ 	@ r2 para valores imediatos
@ 	@ r3 para pScreen
@ 	@ r4 para pResetPulse Couter

@ 	mov	r1, #0									@ r1 = 0

@ 	movw r3, #:lower16:pScreen					
@ 	movt r3, #:upper16:pScreen					
@ 	ldr	r3, [r3]								@ r3 = endereco apontado por pScreen

@ 	movw r4, #:lower16:pResetPulseCounter		
@ 	movt r4, #:upper16:pResetPulseCounter
@ 	ldr	r4, [r4]								@ r4 = endereco do pulse counter

@ loop_wait_screen:
@ 	cmp	r1, r0
@ 	bgt	end_wait_screen							@ while (screens <= limit)

	
@ 	ldr	r2, [r3]								@ r2 = valor do endereco de pScreen
@ 	cmp	r2, #1									@ if (*pScreen == 1)

@ 	bne	loop_wait_screen

@ 	add	r1, r1, #1								@ screens++

@ 	mov	r2, #1
@ 	str	r2, [r4]

@ 	mov	r2, #0
@ 	str	r2, [r4]

@  	b loop_wait_screen

@ end_wait_screen:
@ 	pop	{r4, lr}
@ 	bx	lr

