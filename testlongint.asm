;  Executable name : testlongint
;  Version         : 1.0
;  Created date    : 02/12/2016
;  Last update     : 02/12/2016
;  Author          : Danilo Wanzenried
;  Description     : Test mylongintlib.
; 
;  Build using these commands:
;   nasm -f elf64 -g -F dwarf testlongint.asm
;   gcc -o testlongint testlongint.o mylongintlib.o

section .data                   ; Initialize variables

        msg_in db "Enter a number: ",16
        msg_in_len equ $-msg_in

        msg_out db "Result: ",16
        msg_out_len equ $-msg_out

section .bss

        LILEN equ 16
        X resb LILEN
        Y resb LILEN
        Z resb LILEN
        R resb LILEN
        S resb LILEN
        T resb LILEN

section .text                   ; Code

extern printf, addition, subtraction, multiplication, readlonglong, writelonglong, copylonglong
global main

main:
        nop

        ; read values
        mov rdi, X
        call readlonglong
        
        mov rdi, Y
        call readlonglong
        
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
        
        ; math
        mov rdi, X
        mov rsi, Y
        call addition
        
        mov rdi, X
        call writelonglong
        
        mov rdi, Y
        call writelonglong
        
        mov rdi, X
        mov rsi, Y
        call subtraction
        
        mov rdi, X
        call writelonglong
        
        mov rdi, Y
        call writelonglong
        
        mov rdi, R
        mov rsi, S
        call subtraction
        
        mov rdi, R
        call writelonglong
        
        mov rdi, S
        call writelonglong
        
        mov rdi, T
        mov rsi, Z
        call multiplication
        
        mov rdi, T
        call writelonglong
        
        mov rdi, Z
        call writelonglong
        
        ret