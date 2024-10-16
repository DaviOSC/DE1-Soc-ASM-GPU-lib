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
