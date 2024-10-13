@ typedef unsigned		uint32_t;
@ void *h2p_lw_dataA_addr;
@ void *h2p_lw_dataB_addr;
@ void *h2p_lw_wrReg_addr;
@ void *h2p_lw_wrFull_addr;

@ int isFull(){
@ 	return *(uint32_t *) h2p_lw_wrFull_addr;
@ }

@ void sendInstruction(unsigned long dataA, unsigned long dataB){
@ 	if(isFull() == 0){
@ 		*(uint32_t *) h2p_lw_wrReg_addr = 0;
@ 		*(uint32_t *) h2p_lw_dataA_addr = dataA;
@ 		*(uint32_t *) h2p_lw_dataB_addr = dataB;
@ 		*(uint32_t *) h2p_lw_wrReg_addr = 1;
@ 		*(uint32_t *) h2p_lw_wrReg_addr = 0;	
@ 	}
@ }

@ static unsigned long dataA_builder(int opcode, int reg, int memory_address){
@ 	unsigned long data = 0;
@ 	switch(opcode){
@ 		case(0):
@ 			data = data | reg;                  
@ 			data = data << 4;                   
@ 			data = data | opcode;               
@ 			break;
@ 		case(1):
@ 		case(2):
@ 		case(3):
@ 			data = data | memory_address;   
@ 			data = data << 4;      
@ 			data = data | opcode;
@ 			break;
@ 	}
@ 	return data;
@ }

    .section .data
h2p_lw_dataA_addr:   .word 0  
h2p_lw_dataB_addr:   .word 0  
h2p_lw_wrReg_addr:   .word 0  
h2p_lw_wrFull_addr:  .word 0  

    .section .text
    .global sendInstruction
sendInstruction:
    push {lr}                  @ Salva o registrador de link (lr) na pilha

    mov r2, r0                 @ armazena o valor de dataA de r0 em outro registrador temporario(preserva dataA)
    mov r3, r1                 @ armazena o valor de dataB de r1 em outro registrador temporario(preserva dataB)

    bl isFull                  @ Chama isFull, retorno no r0
    cmp r0, #0                 @ Compara retorno de isFull com 0
    bne fim_sendInstruction     @ Se r0 != 0, sai da função

    ldr r0, =h2p_lw_wrReg_addr  @ Carrega o endereço de wrReg
    mov r1, #0                  @ r1 = 1
    str r1, [r0]                @ 0 em wrReg

    ldr r0, =h2p_lw_dataA_addr  @ Carrega o endereço de dataA
    str r2, [r0]                @ valor de dataA (em r2) no endereço de dataA

    ldr r0, =h2p_lw_dataB_addr  @ Carrega o endereço de dataB
    str r3, [r0]                @ valor de dataB (em r3) no endereço de dataB

    ldr r0, =h2p_lw_wrReg_addr   @ Carrega o endereço de wrReg
    mov r1, #1                   @  r1 = 1
    str r1, [r0]                 @ 1 em wrReg

    mov r1, #0                   @ r1 como 0
    str r1, [r0]                 @ 0 em wrReg

fim_sendInstruction:
    pop {lr}
    bx lr

.data
    .align 2
    .global dataA_builder
dataA_builder:
    push {lr}                  @ Salva o registrador de link (lr) na pilha
    mov r3, #0                 @ data = 0 (r3)

    mov r4, r0                 @ opcode em r4
    mov r5, r1                 @ reg em r5
    mov r6, r2                 @ memory_address em r6

    cmp r4, #0                 @ opcode
    beq case_0                 @ opcode == 0, vai para case_0

    cmp r4, #3                 @ opcode com 3
    bgt fim_dataA_builder      @ Se opcode > 3, sai da func
@opcode sendo 1, 2 ou 3
    orr r3, r3, r6             @ data = data(0) | memory_address(em r6)
    lsl r3, r3, #4             @ data = data << 4
    orr r3, r3, r4             @ data = data | opcode(r4)
    b fim_dataA_builder
case_0:
    orr r3, r3, r5             @ data = data(0) | reg(r5)
    lsl r3, r3, #4             @ data = data << 4
    orr r3, r3, r4             @ data = data | opcode

fim_dataA_builder:
    mov r0, r3                 @ resultado em r0
    pop {lr}
    bx lr


