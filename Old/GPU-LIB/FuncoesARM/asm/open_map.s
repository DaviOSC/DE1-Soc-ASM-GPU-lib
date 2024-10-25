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

.section .data
filename: .asciz "/dev/mem"

@ ------------------ NOVA
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
