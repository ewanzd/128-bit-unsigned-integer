;  Executable name : testlongint
;  Version         : 1.0
;  Created date    : 02/12/2016
;  Last update     : 02/12/2016
;  Author          : Danilo Wanzenried
;  Description     : Test mylongintlib.
;
;  Build using these commands:
; nasm -f elf64 mylongintlib.asm -g -F dwarf
; nasm -f elf64 testlongint.asm -g -F dwarf
; gcc -o testlongint testlongint.o mylongintlib.o

section .data                   ; Initialize variables

        TXT_IN      db "Enter a number:", 0
        TXT_ADDXY   db "Result addition (X = X + Y):", 0
        TXT_SUBXY   db "Result subtraction (X = X - Y): ", 0
        TXT_SUBRS   db "Result subtraction (R = R - S): ", 0
        TXT_MULTZ   db "Result multiplication (T = T * Z): ", 0

section .bss

        LILEN equ 16
        X resb LILEN
        Y resb LILEN
        Z resb LILEN
        R resb LILEN
        S resb LILEN
        T resb LILEN

section .text                   ; Code

extern puts, addition, subtraction, multiplication, readlonglong, writelonglong, copylonglong
global main

main:
        nop

        ; read values
        mov rdi, TXT_IN
        call _printText
        mov rdi, X
        call readlonglong
        
        mov rdi, TXT_IN
        call _printText
        mov rdi, Y
        call readlonglong
        
        mov rdi, TXT_IN
        call _printText
        mov rdi, Z
        call readlonglong
        
        ; copy values
        mov rdi, X
        mov rsi, R
        call copylonglong
        
        mov rdi, Y
        mov rsi, S
        call copylonglong
        
        mov rdi, Z
        mov rsi, T
        call copylonglong
        
        ; X = X + Y
        mov rdi, X
        mov rsi, Y
        call addition
        
        mov rdi, TXT_ADDXY
        call _printText
        
        mov rdi, X
        call writelonglong
        
        mov rdi, Y
        call writelonglong
        
        ; X = X - Y
        mov rdi, X
        mov rsi, Y
        call subtraction
        
        mov rdi, TXT_SUBXY
        call _printText
        
        mov rdi, X
        call writelonglong
        
        mov rdi, Y
        call writelonglong
        
        ; R = R - S
        mov rdi, R
        mov rsi, S
        call subtraction
        
        mov rdi, TXT_SUBRS
        call _printText
        
        mov rdi, R
        call writelonglong
        
        mov rdi, S
        call writelonglong
        
        ; T = T * Z
        mov rdi, T
        mov rsi, Z
        call multiplication
        
        mov rdi, TXT_MULTZ
        call _printText
        
        mov rdi, T
        call writelonglong
        
        mov rdi, Z
        call writelonglong
        
        ret
       
; ==========================================
; Print a text over C function
; arg1: rdi -> reference to message
_printText:
        xor rax, rax                ; reset of RAX before the call
        call puts                   ; Call lib function
        ret