.global closeMappingMemory    // Exporta a função para ser usada externamente
closeMappingMemory:

    // Chama a syscall munmap para desfazer o mapeamento de memória
    MOV R0, R4                 // R0 = virtual_base (endereço mapeado salvo anteriormente em R4)
    MOV R1, #0x04000000        // R1 = HW_REGS_SPAN (tamanho do mapeamento)
    MOV R7, #91                // Número da syscall para 'munmap' (syscall 91)
    SWI 0                      // Faz a chamada de sistema (munmap)

    CMP R0, #0                 // Verifica se munmap falhou (retorna -1 em caso de erro)
    BNE error_munmap           // Se falhar, vai para o erro

    // Chama a syscall close para fechar o arquivo de /dev/mem
    MOV R0, R4                 // R0 = fd (descritor de arquivo salvo anteriormente em R4)
    MOV R7, #6                 // Número da syscall para 'close' (syscall 6)
    SWI 0                      // Faz a chamada de sistema (close)

    BX LR                      // Retorna da função

error_munmap:
    MOV R0, #-1                // Retorna -1 em caso de erro
    BX LR                      // Retorna da função

.section .data
filename: .asciz "/dev/mem"

@ --------------------NOVA

    .global closeMappingMemory  
	.type	closeMappingMemory, %function
close_mapping_memory:
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