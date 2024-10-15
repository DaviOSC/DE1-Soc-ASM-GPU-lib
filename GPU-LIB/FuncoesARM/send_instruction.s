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