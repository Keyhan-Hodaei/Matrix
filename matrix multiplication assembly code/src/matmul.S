; Student:      Keyhan Hodaei
; Instructor:   Dr. Jahangir
; Calculating the multiplication of two matrices
; Inputs: number of rows and columns of two matrices (mat1 and mat2 defined as 'n'), getting two matrices as inputs after getting n
section .data align=64                                          ;data section
    n:                                                          ;number of rows and columns
                        dq  0
    mat1:                                                       ;first matrix
                        dd  0x40000 DUP(0.0)
    mat2:                                                       ;second matrix
                        dd  0x40000 DUP(0.0)
    mat3:                                                       ;multiplication matrix
                        dd  0x40000 DUP(0.0)

extern printf                                                   ;external C functions
extern read_uint
extern read_float
extern write_float
extern write_uint
extern write_char
extern write_str
global asm_main

section .text                                                   ;text section
asm_main:                                                       ;asm_main function
    sub                 rsp, 8                                  ;subtracting 8 from rsp register in order to prevent segmentation fault
    call                read_uint                               ;calling read_uint function to get number of rows and columns from user (the input is in rax)
    mov                 qword[n], rax                           ;moving input to memory
;   mov                 rdi, qword[n]
;   call                write_uint
    mov                 rcx, qword[n]                           ;moving n to rcx in order to use it as a counter for loop
    xor                 rsi, rsi                                ;initializing the index of first matrix
    L1:                                                         ;first loop
        mov             rdx, qword[n]                           ;moving n to rdx in order to use it as a counter for loop
        L2:                                                     ;second loop
            push        rcx                                     ;pushing needed registers to stack in order to prevent unwanted changes and segmentation fault
            push        rdx 
            push        rsi
            push        rsi
            call        read_float                              ;getting the element of first matrix in the given index from user (the input is in xmm0)
            pop         rsi                                     ;poping the registers from stack
            pop         rsi
            pop         rdx
            pop         rcx
            movss       [mat1 + 4*rsi], xmm0                    ;moving the input to memroy
            
            inc         rsi                                     ;incrementing the index
            dec         rdx                                     ;decrementing second loop's counter
            jnz         L2                                      ;if the counter is not zero repeat the second loop
        dec             rsi                                     ;handling 512
        and             si, 0xFE00                              ;resetting j to 0
        add             rsi, 0x0200                             ;adding 512 to i in oreder to go to the next row

        loop            L1                                      ;while rcx is not zero repeat the first loop


    mov                 rcx, qword[n]                           ;same process as the upper loops, but for getting elements of the second matrix
    xor                 rsi, rsi
    L3:
        mov             rdx, qword[n]
        L4:
            push        rcx
            push        rdx 
            push        rsi
            push        rsi
            call        read_float
            pop         rsi
            pop         rsi
            pop         rdx
            pop         rcx
            movss       [mat2 + 4*rsi], xmm0
            
            inc         rsi
            dec         rdx
            jnz         L4
        dec             rsi                                     ;handling 512
        and             si, 0xFE00                              ;resetting j to 0
        add             rsi, 0x0200                             ;adding 512 to i in oreder to go to the next row

        loop            L3




    mov                 rcx, qword[n]                           ;moving n to rcx in order to use it as a counter for first loop
    for_i:                                                      ;first loop
        mov             r12, qword[n]                           ;moving n to r12 in order to use it as a counter for second loop
        for_k:                                                  ;second loop
        mov             r13, qword[n]                           ;moving n to r13 in order to use it as a counter for third loop
            for_j:                                              ;third loop
                mov     r14, rcx                                ;finding the element of first matrix in i'th row and k'th column
                dec     r14 
                shl     r14, 9
                add     r14, r12 
                dec     r14 
                movss   xmm0, [mat1 + 4*r14]                    ;xmm0 = mat1[i][k]
                mov     r14, r12                                ;finding the element of second matrix in k'th row and j'th column
                dec     r14
                shl     r14, 9
                add     r14, r13
                dec     r14 
                mulss   xmm0, [mat2 + 4*r14]                    ;xmm0 *= mat2[k][j]
                mov     r14, rcx                                ;finding the element of third matrix in i'th row and j'th column
                dec     r14
                shl     r14, 9
                add     r14, r13
                dec     r14
                addss   xmm0, [mat3 + 4*r14]                    ;xmm0 += mat3[i][j]
                movss   [mat3 + 4*r14], xmm0                    ;mat3[i][j] = xmm0

                dec     r13                                     ;decrementing inner loop's counter
                jnz     for_j                                   ;if counter is equal to zero repeat the loop
            dec         r12                                     ;decrementing second loop's counter
            jnz         for_k                                   ;if counter is equal to zero repeat the loop
        loop            for_i                                   ;while rcx is not zero repeat outer loop

    mov                 rcx, qword[n]                           ;moving n to rcx in order to use it as a counter for loop
    mov                 rsi, 0                                  ;initializing the index of multiplication matrix
    L5:                                                         ;first loop
        mov             rdx, qword[n]                           ;moving n to rdx in order to use it as a counter for loop
        L6:                                                     ;second loop
            movss       xmm0, [mat3 + 4*rsi]                    ;xmm0 = mat3[i][j]
            push        rsi                                     ;pushing needed registers to stackin order to prevent unwanted changes and segmentation fault
            push        rdx
            push        rcx
            push        rcx
            call        write_float                             ;printing the element at i'th row and j'th column
            mov         rdi, ' '                                ;moving whitespace character to rdi register
            call        write_char                              ;printing whitespace character
            pop         rcx                                     ;poping registers from stack
            pop         rcx
            pop         rdx
            pop         rsi
            inc         rsi                                     ;incrementing the index of third matrix
            dec         rdx                                     ;decrementing inner loop's counter
            jnz         L6                                      ;while the counter is not equal to zero repeat the loop
        dec             rsi                                     ;handling 512
        and             si, 0xFE00                              ;resetting j to 0
        add             rsi, 0x0200                             ;adding 512 to i in oreder to go to the next row

        push            rcx                                     ;pushing needed registers to stack in order to prevent unwanted changes and segmentation fault
        push            rsi 
        mov             rdi, 10                                 ;moving newline character to rdi register
        call            write_char                              ;printing newline charachter
        pop             rsi                                     ;poping registers from stack
        pop             rcx
        

        loop            L5                                      ;while rcx is not equal to zero repeat the outer loop






add             rsp, 8                                          ;adding 8 to rsp register
    ret                                                         ;returning


