%include "prologue.asm"
%include "syscalls.asm"

global _start
        
_start:
        mov rbp, rsp
.exit:
        mov rax, __NR_exit
        syscall

