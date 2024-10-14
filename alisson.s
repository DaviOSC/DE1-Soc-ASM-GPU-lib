.global createMappingMemory    // Exporta a função para ser usada em outros lugares
createMappingMemory:

    // Abre o arquivo "/dev/mem" usando a syscall 'open'
    LDR R0, =filename          // Passa o endereço do string "/dev/mem" em R0
    MOV R1, #02                // O_RDWR (abre o arquivo para leitura e escrita)
    MOV R2, #010000            // O_SYNC (sincroniza as operações de I/O)
    MOV R7, #5                 // Número da syscall para 'open'
    SWI 0                      // Faz a chamada de sistema (open("/dev/mem", O_RDWR | O_SYNC))

    CMP R0, #-1                // Verifica se a chamada 'open' falhou (retorna -1)
    BEQ error_open             // Se R0 for -1, vai para a função de erro

    // Salva o descritor de arquivo (fd)
    MOV R4, R0                 // Armazena o valor do fd em R4 para uso posterior

    // Mapeamento de memória: chama a syscall mmap
    MOV R0, #0                 // NULL, deixa o kernel decidir o endereço virtual
    MOV R1, #0x04000000        // Tamanho do mapeamento (HW_REGS_SPAN)
    MOV R2, #3                 // PROT_READ | PROT_WRITE (proteções de leitura/escrita)
    MOV R3, #1                 // MAP_SHARED (compartilhado entre processos)
    MOV R5, R4                 // Passa o fd para R5 (descritor de arquivo)
    MOV R6, #0xfc000000        // HW_REGS_BASE
    MOV R7, #192               // Syscall mmap (número 192)
    SWI 0                      // Faz a chamada de sistema (mmap)

    CMP R0, #-1                // Verifica se mmap falhou (retorna -1)
    BEQ error_mmap             // Se falhar, vai para erro

    // Salva o endereço base mapeado em R4
    MOV R4, R0                 // R4 agora contém o virtual_base

    // Cálculo dos endereços mapeados
    LDR R1, =0xff200000        // ALT_LWFPGASLVS_OFST
    LDR R2, =0x70              // DATA_A_BASE
    ADD R3, R1, R2             // ALT_LWFPGASLVS_OFST + DATA_A_BASE
    LDR R5, =0x3FFFFFF         // HW_REGS_MASK
    AND R3, R3, R5             // Mascarando com HW_REGS_MASK
    ADD R6, R4, R3             // virtual_base + offset calculado (h2p_lw_dataA_addr)

    // Repete para outros endereços
    LDR R2, =0x80              // DATA_B_BASE
    ADD R3, R1, R2             
    AND R3, R3, R5             
    ADD R7, R4, R3             // h2p_lw_dataB_addr

    // O processo se repete para WRREG, WRFULL, SCREEN e RESET_PULSECOUNTER

    // Retorna sucesso
    MOV R0, #1                 // Retorna 1 como sucesso
    BX LR                      // Retorna da função

error_open:
    MOV R0, #-1                // Retorna -1 em caso de erro
    BX LR                      // Retorna da função

error_mmap:
    MOV R0, #-1                // Retorna -1 em caso de erro
    BX LR                      // Retorna da função

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
