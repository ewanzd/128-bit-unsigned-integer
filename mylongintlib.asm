;  Executable name : mylongintlib
;  Version         : 1.0
;  Created date    : 18/11/2016
;  Last update     : 23/12/2016
;  Author          : Danilo Wanzenried
;  Description     : A school project to create a lib for manage a unsigned 128bit number.
; 
; offer calls
; addition
; subtraction
; multiplication
; readlonglong
; writelonglong
; copylonglong

section .data                               ; Initialize variables (constants)

        HEXCHARS    db "0123456789ABCDEF"   ; Hex chars
        NEW_LINE    db 0xA                  ; Enter
        SYS_READ    equ 0
        SYS_WRITE   equ 1
        STD_IN      equ 1
        STD_OUT     equ 1
        
section .bss                                ; Uninitialize variables
        
        IO_LEN      equ 32                  ; For Input/Output
        IO_BUFFER   resb IO_LEN
        
; rax(64), eax(32), ax(16), ah(8), al(8)
; r8(64), r8d(32), r8w(16), r8b(8)
; qword(64), dword(32), word(16), byte(8)
; DQ(64), DD(32), DW(16), DB(8)

section .text                   ; Code

; file offer follow longint functions
global addition, subtraction, multiplication, readlonglong, writelonglong, copylonglong

; macro to write char string
%macro _sysWrite 2
        mov rax, SYS_WRITE                  ; 1
        mov rdi, STD_OUT                    ; 1
        mov rsi, %1                         ; output message
        mov rdx, %2                         ; len of message
        syscall                             ; kernel call
%endmacro

; macro to read char string
%macro _sysRead 2
        mov rax, SYS_READ                   ; 0
        mov rdi, STD_IN                     ; 1
        mov rsi, %1                         ; input message
        mov rdx, %2                         ; len of message
        syscall                             ; get user input
%endmacro

; macro to set all bit to 0 (clear)
%macro _clearBuffer 0
        and qword[IO_BUFFER], 0x0
        and qword[IO_BUFFER + 8], 0x0
        and qword[IO_BUFFER + 16], 0x0
        and qword[IO_BUFFER + 24], 0x0
%endmacro

; ==========================================
; A procedure addition, that implements the addition of two long long integers.
; arg1: rdi -> reference to 128bit longinteger
; arg2: rsi -> reference to 128bit longinteger to add
; return rdi: addition of both values
addition:
        push rax                            ; save rax
        
        mov rax, qword[rsi]                 ; copy first 64 bit of reference to rax
        add qword[rdi], rax                 ; add rax to first 64 bit from reference of rdi
        
        mov rax, qword[rsi + 8]             ; copy second 64 bit of reference to rax
        adc qword[rdi + 8], rax             ; add rax to second 64 bit from reference of rdi with flag
        
        pop rax                             ; load rax
        ret                                 ; return to caller

; ==========================================
; A procedure subtraction, that implements the subtraction of two long long integers. 
; If the second number is larger than the first, the result is 0.
; arg1: rdi -> reference to 128bit longinteger
; arg2: rsi -> reference to 128bit longinteger to sub
; return rdi: subtraction of both values
subtraction:
        push rax
        
        mov rax, qword[rsi]                 ; copy first 64 bit of reference to rax
        sub qword[rdi], rax                 ; sub rax to first 64 bit from reference of rdi
        
        mov rax, qword[rsi + 8]             ; copy second 64 bit of reference to rax
        sbb qword[rdi + 8], rax             ; sub rax to second 64 bit from reference of rdi with flag
        
        pop rax
        ret
        
; ==========================================
; A procedure multiplication, that implements the multiplication of two long long integers.
; If the size of the output should be larger than 128 bits, you will only use the 128-bits 
; (lowest weight) and set the overflow flag (OF).
; arg1: rdi -> reference to 128bit longinteger
; arg2: rsi -> reference to 128bit longinteger to mul
; return rdi: multiplication of both values
multiplication:
        push rax
        push rdx
        push r8
        push r9
        push r10
        
        mov r8, qword[rdi]                  ; save rdi first 8 bytes
        mov r9, qword[rdi + 8]              ; save rdi second 8 bytes
        
        mov rax, r8                         ; get first value for mul
        mul qword[rsi]                      ; get second value for mul
        mov qword[rdi], rax                 ; to result 
        mov qword[rdi + 8], rdx             ; overflow to result
        
        mov rax, r9                         ; load second 8 bytes of rdi
        mul qword[rsi]                      ; multiplication with first 8 bytes of rsi
        add qword[rdi + 8], rax             ; to result
        
        mov r10, rdx                        ; save overflow for flag
        
        mov rax, r8                         ; load first 8 bytes of rdi
        mul qword[rsi + 8]                  ; multiplication with second 8 bytes of rsi
        add qword[rdi + 8], rax             ; to result
        
        jc .setOverFlowFlag                 ; jump if carry flag is set from last addition
        or r10, rdx                         ; check if multiplication have a overflow
        jg .setOverFlowFlag                 ; jump if overflow from multiplication

        jmp .continue                       ; no overflow
    .setOverFlowFlag:                       ; set overflow
        mov al, 0x7f                        ; max number of al
        add al, 1                           ; add 1 over the max
    .continue:
        
        pop r10
        pop r9
        pop r8
        pop rdx
        pop rax
        ret
        
; ==========================================
; A procedure readlonglong that reads on the standard input (stdin) an hexadecimal number 
; and writes it inside the memory.
; arg1: rdi -> reference to copy the input (must be 16 byte)
; return rdi: reference to input value
readlonglong:
        push rax
        push rbx
        push rcx
        push rdx
        push rsi     
        push r8
        push rdi
        
        xor rbx, rbx                        ; clear rbx
        _clearBuffer                        ; clear buffer
        _sysRead IO_BUFFER, IO_LEN          ; read hex input from user

        pop rdi
        mov r8, 0                           ; init return reference counter
        mov rcx, IO_LEN                     ; init IO_BUFFER counter
    .nextByte:
        mov al, byte[rsi + rcx]             ; get first byte
        cmp al, 0                           ; check if byte have value (optimizing)
        je .preNextByte                     ; if not go to next byte
        
        mov rdx, 0                          ; init HEXCHARS counter
    .nextHex:
        mov bl, byte[HEXCHARS + rdx]        ; get next hex char
        cmp bl, al                          ; if char available 
        je .continue                        ; then copy to reference
        cmp rdx, 15                         ; if char not available, next byte (ignore)
        jge .preNextByte
        inc rdx                             ; increment counter
        jmp .nextHex                        ; next hex char
    .continue:
    
        push r8                             ; save r8
        shr r8, 1                           ; shift r8 1 to right side(divide 2)
        jnc .toDestRef                      ; if carry flag(odd)... 
        shl dl, 4                           ; ...then shift dl 4 bit to left
    .toDestRef:
        or byte[rdi + r8], dl               ; save to destination reference
        pop r8                              ; load r8
        inc r8                              ; increment destination counter
        
    .preNextByte:
        dec rcx                             ; next byte
        jge .nextByte                       ; finished?
        
        pop r8
        pop rsi
        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret
        
; ==========================================
; A procedure writelonglong writes a long long number on the standard output in hexadecimal form.
; arg1: rdi -> reference to number
writelonglong:
        push rax
        push rcx
        push rdx
        
        xor rax, rax                        ; clear rax
        mov rdx, 0                          ; init byte counter
        mov rcx, IO_LEN                     ; init hex counter
        
    .nextByte:
        mov al, byte[rdi + rdx]             ; get next byte from reference
        and rax, 0x0f                       ; get first hex
        mov al, byte[HEXCHARS + rax]        ; get ascii representation from hex
        mov byte[IO_BUFFER + rcx - 1], al   ; Write to output-buffer
        dec rcx                             ; to next hex
        
        mov al, byte[rdi + rdx]             ; get again byte from reference
        shr al, 4                           ; shift 4 to right
        mov al, byte[HEXCHARS + rax]        ; get ascii representation from hex
        mov byte[IO_BUFFER + rcx - 1], al   ; Write to output-buffer
        
        inc rdx                             ; to next byte
        dec rcx                             ; to next hex
        jne .nextByte                       ; check rcx is equal or greater 0 then next byte
        
        _sysWrite IO_BUFFER, IO_LEN         ; write message
        _sysWrite NEW_LINE, 1               ; make a new line

        pop rdx
        pop rcx
        pop rax
        ret
        
; ==========================================
; A procedure copylonglong that copies a long long number into another place in memory.
; arg1: rdi -> reference with value to copy
; arg2: rsi -> target reference
copylonglong:
        push rax
        
        mov rax, qword[rdi]                 ; get first 8 bytes
        mov qword[rsi], rax                 ; copy to rsi
        
        mov rax, qword[rdi + 8]             ; get second 8 bytes
        mov qword[rsi + 8], rax             ; copy to rsi
        
        pop rax
        ret