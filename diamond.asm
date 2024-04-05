%define SYS_WRITE 1
%define SYS_EXIT 60
%define STDOUT 1
%define NEWLINE 0xa

%macro PROLOGUE 0
        push rbp
        mov rbp, rsp
%endmacro

%macro EPILOGUE 0
        mov rsp, rbp
        pop rbp
        ret
%endmacro

section .text

global ircd_strlen
global ircd_ctoi
global ircd_stoi
        
ircd_strlen:
        ; arguments:
        ;    parameters -> pointer to string
        ;    return -> length
        PROLOGUE
        mov rax, 0
.loop:
        cmp BYTE [rdi], 0
        je .return
        inc rax
        inc rdi
        jmp .loop
.return:
        EPILOGUE

ircd_ctoi:
        ; arguments:
        ;    parameters -> ASCII char, out int
        ;    return -> int
        PROLOGUE
        mov rax, rdi
        sub rax, '0'
        cmp rax, 9
        jle .return
        mov BYTE [rsi], 1
.return:
        EPILOGUE

ircd_stoi:
        ; arguments
        ;    parameters -> char*, (out) int*
        ;    return -> int
        PROLOGUE
        mov rax, 0

.loop:
        mov BYTE r8, [rdi]
        inc rdi
        cmp r8, 0
        je .return

        ; save registers
        push rax
        push rdi
        push rsi

        mov rdi, r8
        sub rsp, 16
        lea rsi, [rsp + 16]        
        call ircd_ctoi

        cmp BYTE [rsp + 16], 1
        je .error
        
        mov r8, rax
        add rsp, 16
        pop rsi
        pop rdi
        pop rax

        imul rax, 10
        add rax, r8
        jmp .loop
        
.error:
        mov BYTE [rsi], 1
        
.return:
        EPILOGUE
        
; Local Variables:
; mode: nasm
; End:
