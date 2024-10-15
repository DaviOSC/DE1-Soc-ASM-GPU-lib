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
