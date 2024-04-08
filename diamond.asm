%include "prologue.asm"
        
section .text

global ircd_strlen
global ircd_stoi
global ircd_draw_row
global ircd_memset
        
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


ircd_stoi:
        ; arguments
        ;    parameters -> char*, (out) int*
        ;    return -> int
        PROLOGUE
        mov rax, 0
        mov r8, 0

.loop:
        mov r8b, [rdi]
        inc rdi
        cmp r8b, 0
        je .return

        sub r8, '0'
        cmp r8, 9
        ja .error
        imul rax, 10
        add rax, r8
        jmp .loop
        
.error:
        mov DWORD [rsi], 1
        
.return:
        EPILOGUE

ircd_draw_row:
        ; arguments
        ;    parameters -> int size, int row, char* str
        PROLOGUE        
        ; mid point
        push rdx
        mov rdx, 0
        mov rax, rdi
        mov r8, 2
        idiv r8
        pop rdx
        
        ; calculate left side
        mov r8, rax
        sub r8, rsi
        ; right half
        mov r9, rax
        add r9, rsi
        add r9, 1

        ; loop to fill in left..=right
        mov rcx, r8
.loop:
        cmp rcx, r9
        jge .loop_end
        lea r10, [rdx + rcx]
        mov BYTE [r10], '*'
        inc rcx
        jmp .loop
.loop_end:

        ; fill in the mid point for row 0
        lea r10, [rdx + rax]
        mov BYTE [r10], '*'
        EPILOGUE


ircd_memset:
        ; parameters
        ;     arguments -> pointer, byte, length
        PROLOGUE
        mov rcx, 0

.loop:        
        cmp rcx, rdx
        je .return

        lea r8, [rdi + rcx]
        mov [r8], si
        inc rcx
        jmp .loop
        
.return:
        EPILOGUE
        
; Local Variables:
; mode: nasm
; End:
