    .section .data
msg:
    .asciz "Hello, Syscall!\n"

    .section .text
    .global _start

_start:
    mov r7, #4          @ Syscall para "write"
    mov r0, #1          @ File descriptor 1 (stdout)
    ldr r1, =msg        @ Endereço da mensagem
    mov r2, #15   @ Comprimento da mensagem (número de bytes)
    svc #0              @ Faz a syscall

    mov r7, #1          @ Syscall para "exit"
    mov r0, #0          @ Código de saída 0
    svc #0

