%macro PROLOGUE 0
        push rbp
        mov rbp, rsp
%endmacro

%macro EPILOGUE 0
        mov rsp, rbp
        pop rbp
        ret
%endmacro
