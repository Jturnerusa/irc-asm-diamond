%include "prologue.asm"
%include "syscalls.asm"
%include "mmap.asm"
        
section .text
        
global _start
extern ircd_stoi
extern ircd_draw_row
        
_start:
        mov rax, __NR_write
        mov rdi, 0
        syscall

