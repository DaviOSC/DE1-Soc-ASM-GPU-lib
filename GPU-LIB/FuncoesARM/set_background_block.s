.global	set_background_block
.type	set_background_block, %function
set_background_block:
	@ r0 = column, r1 = line, r2 = Red, r3 = Green, Stack = Blue
	push	{lr}				@ Guardar LR e parametros na memória

	lsl r3, r3, #3				@ r3 = 0...00(Green)000
	orr r3, r3, r2				@ r3 = 0...00(Green)(Red)
	ldr	r2, [sp, #4]			@ r2 = blue
	lsl r2, r2, #6				@ r2 = 0...00(Blue)000000
	orr r3, r3, r2				@ r3 = 0...00(Blue)(Green)(Red)

	mov r2, #80
	mul r2, r1, r2				@ line * 80
	add r2, r0, r2 				@ r2 (address) = (line * 80) + column

	lsl r2, #4
	add r0, r2, #2

	mov r1, r3					@ r1 = RGB

	bl	sendInstruction 		@ sendInstruction(dataA, RGB)

	pop 	{lr}
    bx lr