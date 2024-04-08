%include "prologue.asm"
%include "syscalls.asm"
%include "mmap.asm"
        
section .text
        
global _start
extern ircd_stoi
extern ircd_draw_row
extern ircd_memset
        
_start:
        mov rbp, rsp

        ; locals
        ; 4 dw diamond size
        ; 8 dw diamond size / 2
        ; 16 qw row buffer
        ; 20 dw row buffer size
        ; 24 dw fd
        ; 28 dw error
        sub rsp, 28

        ; exit if argc <= 1
        cmp QWORD [rbp], 1
        je .exit_failure

        ; get diamond size
        mov rdi, [rbp + 16]
        lea rsi, [rsp]
        call ircd_stoi
        cmp DWORD [rsp], 1
        je .exit_failure
        mov [rbp - 4], eax

        ; get diamond size / 2
        mov eax, [rbp - 4]
        mov rdx, 0
        mov r8, 2
        idiv r8
        mov [rbp - 8], eax

        ; calculate row size
        mov eax, [rbp - 4]
        inc eax ; room for trailing newline
        mov [rbp - 20], eax

        ; mmap row
        mov rax, __NR_mmap
        mov esi, [rbp - 20]
        mov rdx, PROT_READ | PROT_WRITE
        mov r10, MAP_ANON | MAP_PRIVATE
        mov r8, -1
        mov r9, 0
        syscall
        mov [rbp - 16], rax

        mov rcx, 0
.first_half_loop:
        cmp ecx, [rbp - 8]
        je .first_half_done

        ; clear row
        mov rdi, [rbp - 16]
        mov rsi, ' '
        mov edx, [rbp - 20]
        push rcx
        call ircd_memset
        pop rcx

        ; set newline at end of row
        mov r8, [rbp - 16]
        mov r9d, [rbp - 20] 
        lea r10, [r8 + r9 - 1]
        mov BYTE [r10], 0xa ; newline

        ; draw row
        mov edi, [rbp - 4]
        mov rsi, rcx
        mov rdx, [rbp - 16]
        push rcx
        call ircd_draw_row
        pop rcx

        inc rcx
        
        mov rax, __NR_write
        mov rdi, 0
        mov rsi, [rbp - 16]
        mov edx, [rbp - 20]
        push rcx
        syscall
        pop rcx

        jmp .first_half_loop
.first_half_done:

        mov ecx, [rbp - 8]
        dec ecx
.second_half_loop:
        cmp ecx, -1
        je .second_half_done

        ; clear row
        mov rdi, [rbp - 16]
        mov rsi, ' '
        mov edx, [rbp - 20]
        push rcx
        call ircd_memset
        pop rcx

        ; set newline at end of row
        mov r8, [rbp - 16]
        mov r9d, [rbp - 20] 
        lea r10, [r8 + r9 - 1]
        mov BYTE [r10], 0xa ; newline

        ; draw row
        mov edi, [rbp - 4]
        mov rsi, rcx
        mov rdx, [rbp - 16]
        push rcx
        call ircd_draw_row
        pop rcx

        dec rcx
        
        mov rax, __NR_write
        mov rdi, 0
        mov rsi, [rbp - 16]
        mov edx, [rbp - 20]
        push rcx
        syscall
        pop rcx

        jmp .second_half_loop
.second_half_done:
        
.exit_success:
        mov rax, __NR_exit
        mov rdi, 0
        syscall
        
.exit_failure:
        mov rax, __NR_exit
        mov rdi, 1
        syscall
