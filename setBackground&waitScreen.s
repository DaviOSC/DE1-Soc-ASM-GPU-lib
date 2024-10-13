@ .align	2
@ .global	set_background_color
@ .thumb
@ .thumb_func
@ .type	set_background_color, %function
@ set_background_color:
@ 	@ args = 0, pretend = 0, frame = 24
@ 	@ frame_needed = 1, uses_anonymous_args = 0

@ 	push	{r7, lr}        @ salvar r7 e lr na stack 
@ 	sub	sp, sp, #24         @ alocar 24 bytes na stack
@ 	add	r7, sp, #0          @ mover sp para r7
@ 	str	r0, [r7, #12]       @ guardar r0(3 bits da cor vermelha)
@ 	str	r1, [r7, #8]        @ guardar r1(3 bits da cor Green)
@ 	str	r2, [r7, #4]        @ guardar r2(3 bits da cor Blue)

@ 	mov	r0, #0              @ r0, r1, r2 = 0
@ 	mov	r1, #0              
@ 	mov	r2, #0        

@ 	bl	dataA_builder       @ dataA_builder(0,0,0)
@   str	r0, [r7, #16]       @ retorno do dataA é salvo em sp+16
@   ldr	r3, [r7, #4]        @ r3 = Blue(3bits)
@   str	r3, [r7, #20]       @ r3 é guardado em sp+20
@   ldr	r3, [r7, #20]       @ r3 = r3 (????)
@   lsl	r3, r3, #3          @ shift left 3 vezes(blue + 000)
@   str	r3, [r7, #20]       @ r3 é guardado em sp+20
@   ldr	r3, [r7, #8]        @ r3 = Green(3bits)
@   ldr	r2, [r7, #20]       @ r2 = Blue + 000
@   orrs	r3, r3, r2      @ r3 = Blue + Green
@   str	r3, [r7, #20]       @ r3 é guardado em sp+20
@   ldr	r3, [r7, #20]       @ r3 = r3 (????)
@   lsl	r3, r3, #3          @ shift left 3 vezes(blue + Green + 000)
@   str	r3, [r7, #20]       @ r3 é guardado em sp+20
@   ldr	r3, [r7, #12]       @ r3 = Red(3bits)
@   ldr	r2, [r7, #20]       @ r2 = Blue + Green + 000
@   orrs	r3, r3, r2      @ r3 = Blue + Green + Red
@   str	r3, [r7, #20]       @ r3(RGB) é guardado em sp+20
@   ldr	r0, [r7, #16]       @ r0 = dataA
@   ldr	r1, [r7, #20]       @ r1 = RGB
@ 	bl	sendInstruction     @ sendInstruction(dataA, RGB)
@ 	add	r7, r7, #24         @ desalocar os 24 bytes de memória da stack
@ 	mov	sp, r7              @ sp = r7
@ 	pop	{r7, pc}            @ r7 e pc são puxados da stack
@ 	.size	set_background_color, .-set_background_color

@ void set_background_color(int R, int G, int B){
@ 	unsigned long dataA = dataA_builder(0,0,0);
@ 	unsigned long color = B;
@ 	color = color << 3;
@ 	color = color | G;
@ 	color = color << 3;
@ 	color = color | R;
@ 	sendInstruction(dataA, color);
@ }


@------------BACKGROUND_COLOR--------

.global	set_background_color
.type	set_background_color, %function
set_background_color:
    push    {lr}            @ salvar lr na stack

    sub	sp, sp, #12         @ Salvar Parametros R, G e B...
	str	r0, [sp, #0]        @ Red 
	str	r1, [sp, #4]        @ Green
	str	r2, [sp, #8]        @ Blue

    lsl r2, r2, #3          @ r2 = 0...00(blue)000
    orr r2, r2, r1          @ r2 = 0...00(blue)(Green)
    lsl r2, r2, #3          @ r2 = 0...00(blue)(Green)000
    orr r1, r2, r0          @ r1 = 0...00(blue)(Green)(Red)
    
    mov	r0, #0              @ valores para os parametros de dataA_builder
	mov	r1, #0
	mov	r2, #0
	bl	dataA_builder       @ dataA_builder(0,0,0)

    bl sendInstruction      @ sendInstruction(dataA, RGB)

	ldr	r0, [sp, #0]        @ Red 
	ldr	r1, [sp, #4]        @ Green
	ldr	r2, [sp, #8]        @ Blue
    add sp, sp, #12

    pop     {lr}
    bx lr

@------------BACKGROUND_COLOR--------

@ 	.align	2
@ 	.global	set_background_block
@ 	.thumb
@ 	.thumb_func
@ 	.type	set_background_block, %function
@ set_background_block:
@ 	@ args = 4, pretend = 0, frame = 32
@ 	@ frame_needed = 1, uses_anonymous_args = 0
@ 	push	{r7, lr}        @ colocar r7 e lr na stack
@ 	sub	sp, sp, #32         @ alocar 32 bytes de memória na stack   
@ 	add	r7, sp, #0          @ r7 = sp
@ 	str	r0, [r7, #12]       @ salvar column em sp+12
@ 	str	r1, [r7, #8]        @ salvar line em sp+8
@ 	str	r2, [r7, #4]        @ salvar Red em sp+4
@ 	str	r3, [r7, #0]        @ salvar green em sp

@ 	ldr	r2, [r7, #8]        @ r2 = line
@ 	mov	r3, r2              @ r3 = r2
@ 	lsl	r3, r3, #2          @ r3 = r3 * 4
@ 	adds	r3, r3, r2      @ r3 = r3 + r2
@ 	lsl	r3, r3, #4          @ r3 = r3 * 16
@ 	mov	r2, r3              @ r2 = r3
@ 	ldr	r3, [r7, #12]		@ r3 = column
@ 	adds	r3, r2, r3		@ r3 = column + r2
@ 	str	r3, [r7, #20]		@ salvar r3 em sp+20 (addres)
@ 	mov	r0, #2				@ r0 = 2
@ 	mov	r1, #0				@ r1 = 0
@ 	ldr	r2, [r7, #20]		@ r2 = addres
@ 	bl	dataA_builder		@ dataA_builder(2, 0, addres)
@ 	str	r0, [r7, #24]		@ guardar retorno em sp+24
@ 	ldr	r3, [r7, #40]		@ r3 = Blue
@ 	str	r3, [r7, #28]
@ 	ldr	r3, [r7, #28]
@ 	lsl	r3, r3, #3
@ 	str	r3, [r7, #28]
@ 	ldr	r3, [r7, #0]
@ 	ldr	r2, [r7, #28]
@ 	orrs	r3, r3, r2
@ 	str	r3, [r7, #28]
@ 	ldr	r3, [r7, #28]
@ 	lsl	r3, r3, #3
@ 	str	r3, [r7, #28]
@ 	ldr	r3, [r7, #4]
@ 	ldr	r2, [r7, #28]
@ 	orrs	r3, r3, r2
@ 	str	r3, [r7, #28]
@ 	ldr	r0, [r7, #24]
@ 	ldr	r1, [r7, #28]
@ 	bl	sendInstruction
@ 	add	r7, r7, #32
@ 	mov	sp, r7
@ 	pop	{r7, pc}
@ 	.size	set_background_block, .-set_background_block

@ void set_background_block(int column, int line, int R, int G, int B){
@ 	int address = (line * 80) + column;
@ 	unsigned long dataA = dataA_builder(2, 0, address);
@ 	unsigned long color = B;
@ 	color = color << 3;
@ 	color = color | G;
@ 	color = color << 3;
@ 	color = color | R;
@ 	sendInstruction(dataA, color);
@ }

@------------BACKGROUND_BLOCK--------

.global	set_background_block
.type	set_background_block, %function
set_background_block:
	@ r0 = column, r1 = line, r2 = Red, r3 = Green, Stack = Blue
	push	{lr}				@ Guardar LR e parametros na memória
	sub	sp, sp, #16
	str	r0, [sp, #0]			@ column
	str	r1, [sp, #4]			@ line
	str	r2, [sp, #8]			@ Red
	str	r3, [sp, #12]			@ Green

	lsl r3, r3, #3				@ r3 = 0...00(Green)000
	orr r3, r3, r2				@ r3 = 0...00(Green)(Red)
	ldr	r2, [sp, #16]			@ r2 = blue
	lsl r2, r2, #6				@ r2 = 0...00(Blue)000000
	orr r3, r3, r2				@ r3 = 0...00(Blue)(Green)(Red)

	mov r2, #80
	mul r2, r1, r2				@ line * 80
	add r2, r0, r2 				@ r2 (address) = (line * 80) + column

	mov	r0, #2
	mov	r1, #0
	bl	dataA_builder			@ r0 = dataA_builder(2, 0, addres) 

	mov r1, r3					@ r1 = RGB

	bl	sendInstruction 		@ sendInstruction(dataA, RGB)

	ldr	r0, [sp, #0]			@ column
	ldr	r1, [sp, #4]			@ line
	ldr	r2, [sp, #8]			@ Red
	ldr	r3, [sp, #12]			@ Green

	add	sp, sp, #16
	pop 	{lr}
    bx lr

@------------BACKGROUND_BLOCK--------

@ 	.global	wait_screen
@ 	.type	wait_screen, %function
@ wait_screen:
@ 	push	{lr}
@ 	sub	sp, sp, #20
@ 	str	r0, [sp, #0] 		@ r0 = limit
@ 	str	r1, [sp, #4]		@ usar r1 como contador de screens
@ 	str r2, [sp, #8]		@ usar r2 para acessar ponteiros 
@	str r3, [sp, #12]		@ usar r3 para valores imediatos

@ 	mov	r1, #0				@ r1 = 0
@ loop_wait_screen:
@ 	cmp	r1, r0				@ screens <= limit
@ 	bgt	end_wait_screen

@ 	movw r2, #:lower16:h2p_lw_screen_addr	
@ 	movt r2, #:upper16:h2p_lw_screen_addr
@ 	ldr	r2, [r2, #0]
@ 	ldr	r2, [r2, #0]
@ 	cmp	r2, #1

@ 	bne	loop_wait_screen

@ 	add	r1, r1, #1
@ 	movw	r2, #:lower16:h2p_lw_result_pulseCounter_addr
@ 	movt	r2, #:upper16:h2p_lw_result_pulseCounter_addr
@ 	ldr	r2, [r2, #0]
@ 	mov	r3, #1
@ 	str	r3, [r2, #0]
@ 	movw	r2, #:lower16:h2p_lw_result_pulseCounter_addr
@ 	movt	r2, #:upper16:h2p_lw_result_pulseCounter_addr
@ 	ldr	r2, [r2, #0]
@ 	mov	r3, #0
@ 	str	r3, [r2, #0]
@  	b loop_wait_screen

@ end_wait_screen:
@ 	ldr	r0, [sp, #0] 		@ r0 = limit
@ 	ldr	r1, [sp, #4]		@ usar r1 como contador de screens
@ 	ldr r2, [sp, #8]		@ usar r2 para acessar ponteiros 
@	ldr r3, [sp, #12]		@ usar r3 para valores imediatos
@ 	add	sp, sp, #20
@ 	pop	{lr}
@ 	bx	lr

@ void waitScreen(int limit){
@ 	int screens = 0;
@  	while(screens <= limit){ // Wait x seconds for restart Game 
@ 		if(*(uint32_t *) h2p_lw_screen_addr == 1){ // Checks if a screen has finished drawing.
@ 			// Structure for counter of screen and set parameters.
@ 			screens++;
@ 			*(uint32_t *) h2p_lw_result_pulseCounter_addr = 1;
@ 			*(uint32_t *) h2p_lw_result_pulseCounter_addr = 0;
@ 		}
@ 	}
@ }

@------------waitScreen--------

	.global	wait_screen
	.type	wait_screen, %function
wait_screen:
	push	{lr}
	sub	sp, sp, #16
	str	r0, [sp, #0] 		@ r0 = limit
	str	r1, [sp, #4]		@ usar r1 como contador de screens
	str r2, [sp, #8]		@ usar r2 para acessar ponteiros 
	str r3, [sp, #12]		@ usar r3 para valores imediatos

	mov	r1, #0				@ r1 = 0

loop_wait_screen:
	cmp	r1, r0				@ screens <= limit
	bgt	end_wait_screen

	movw r2, #:lower16:h2p_lw_screen_addr	
	movt r2, #:upper16:h2p_lw_screen_addr
	ldr	r2, [r2, #0]
	ldr	r2, [r2, #0]
	cmp	r2, #1

	bne	loop_wait_screen

	add	r1, r1, #1
	movw	r2, #:lower16:h2p_lw_result_pulseCounter_addr
	movt	r2, #:upper16:h2p_lw_result_pulseCounter_addr
	ldr	r2, [r2, #0]
	mov	r3, #1
	str	r3, [r2, #0]
	movw	r2, #:lower16:h2p_lw_result_pulseCounter_addr
	movt	r2, #:upper16:h2p_lw_result_pulseCounter_addr
	ldr	r2, [r2, #0]
	mov	r3, #0
	str	r3, [r2, #0]
 	b loop_wait_screen

end_wait_screen:
	ldr	r0, [sp, #0] 		@ r0 = limit
	ldr	r1, [sp, #4]		@ usar r1 como contador de screens
	ldr r2, [sp, #8]		@ usar r2 para acessar ponteiros 
	ldr r3, [sp, #12]		@ usar r3 para valores imediatos
	add	sp, sp, #16
	pop	{lr}
	bx	lr

@------------waitScreen--------
