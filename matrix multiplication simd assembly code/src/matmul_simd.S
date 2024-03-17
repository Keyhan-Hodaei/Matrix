; Student:      Keyhan Hodaei
; Instructor:   Dr. Jahangir
; Calculating the multiplication of two matrices
; Inputs: number of rows and columns of two matrices (mat1 and mat2 defined as 'n'), getting two matrices as inputs after getting n
section .data align=64
    mat1:                                               ;first matrix
                        dd  0x40000 DUP(0.0)
    mat2:                                               ;second matrix
                        dd  0x40000 DUP(0.0)
    mat3:                                               ;third matrix (multiplication matrix)
                        dd  0x40000 DUP(0.0)
    n:                                                  ;number of rows and columns
                        dq  0

extern printf                                           ;external C functions
extern read_uint
extern read_float
extern write_float
extern write_uint
extern write_char
extern write_str
global asm_main

section .text
asm_main:
    sub                 rsp, 8                          ;subtracting 8 from rsp to avoid segmentation fault
    call                read_uint                       ;read the number of rows and columns, the input is in rax
    mov                 qword[n], rax                   ;moving rax to memory
    mov                 rcx, qword[n]                   ;moving `n` to rcx to use it as counter in loop
    xor                 rsi, rsi                        ;initializing the index of matrix
    L1:                                                 ;first loop
        mov             rdx, qword[n]                   ;moving `n` to rdx
        L2:                                             ;second loop
            push        rcx                             ;pushing needed registers that might change while reading input to stack
            push        rdx 
            push        rsi
            push        rsi
            call        read_float                      ;read the element of first matrix, the input is in xmm0
            pop         rsi                             ;poping (former) value of registers from stack
            pop         rsi
            pop         rdx
            pop         rcx
            movss       [mat1 + 4*rsi], xmm0            ;moving the element to the given index of first matrix
            
            inc         rsi                             ;incrementing the index
            dec         rdx                             ;decrementing rdx (loop's counter)
            jnz         L2                              ;jumping to L2 while rdx is not zero
        dec             rsi                             ;handling 512
        and              si, 0xFE00                     ;resetting j to 0
        add             rsi, 0x0200                     ;adding 512 to i in oreder to go to the next row

        loop            L1                              ;jumping L1 while rcx is not zero


    mov                 rcx, qword[n]                   ;same process as the upper loops for getting inputs from user for second matrix
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
        dec             rsi 
        and              si, 0xFE00
        add             rsi, 0x0200

        loop            L3




    mov                 rcx, 0                          ;rcx is firs loop's counter (i), initializing i
    for_i:                                              ;first loop
        mov             r12, 0                          ;r12 is second loop's counter (k), initializing k
        for_k:                                          ;second loop
        mov             r13, 0                          ;r13 is third loop's counter (j), initializing j
            for_j:                                      ;third loop
                ;finding the element in k'th row and j'th column of second matrix
                mov     r14, r12                        ;r14 = k
                shl     r14, 9                          ;r14 = 512 * k
                add     r14, r13                        ;r14 = 512 * k + j
                movups  xmm0, [mat2 + 4*r14]            ;xmm0 = {mat2[k][j], mat2[k][j+1], mat2[k][j+2], mat2[k][j+3]}
                ;finding the element in i'th row and k'th column of first matrix
                mov     r14, rcx                        ;r14 = i
                shl     r14, 9                          ;r14 = 512 * i
                add     r14, r12                        ;r14 = 512 * i + k
                vbroadcastss xmm1, [mat1 + 4*r14]       ;xmm1 = {mat1[i][k], mat1[i][k], mat1[i][k], mat1[i][k]}
                mulps   xmm0, xmm1                      ;xmm0 = {mat2[k][j] * mat1[i][k], mat2[k][j+1] * mat1[i][k], mat2[k][j+2] * mat1[i][k], mat2[k][j+2] * mat1[i][k]}
                ;finding the element in i'th row and j'th column of third matrix
                mov     r14, rcx                        ;r14 = i
                shl     r14, 9                          ;r14 = 512 * i
                add     r14, r13                        ;r14 = 512 * i + j
                movups  xmm1, [mat3 + 4*r14]            ;xmm1 = {mat3[i][j], mat3[i][j+1], mat3[i][j+2], mat3[i][j+3]}
                addps   xmm0, xmm1                      ;xmm0 = {mat3[i][j] + mat2[k][j]*mat1[i][k], {mat3[i][j] + mat2[k][j]*mat1[i][k], {mat3[i][j] + mat2[k][j]*mat1[i][k], }{mat3[i][j] + mat2[k][j]*mat1[i][k]
                movups  [mat3 + 4*r14], xmm0            ;moving xmm0 elements to four consecutive elements of mat3 in these indices: (i, j), (i, j+1), (i, j+2), (i, j+3)

                add     r13, 4                          ;adding 4 to j, because we are finding four consecutive elements of mat3
                cmp     r13, qword[n]                   ;comparing j and n
                jl      for_j                           ;if j is lower than n repeat the loop
            inc         r12                             ;incrementing k
            cmp         r12, qword[n]                   ;comparing k and n
            jl          for_k                           ;if k is lower than n repeat the loop
        inc             rcx                             ;incrementing i
        cmp             rcx, qword[n]                   ;comparing i and n
        jl              for_i                           ;if i is lower than n repeat the loop

    mov                 rcx, qword[n]                   ;moving n to rcx to use it as counter in loop
    mov                 rsi, 0                          ;initializing the index of third matrix
    L5:                                                 ;loop 5
        mov             rdx, qword[n]                   ;moving n to rdx
        L6:                                             ;loop6
            movss       xmm0, [mat3 + 4*rsi]            ;moving the element of third matrix in the given index to xmm0
            push        rsi                             ;pushing needed registers to stack in order to prevent unwanted changes and segmentation faults
            push        rdx
            push        rcx
            push        rcx
            call        write_float                     ;printing the said element of third matrix
            mov         rdi, ' '                        ;moving white space character to rdi
            call        write_char                      ;printing the said character
            pop         rcx                             ;poping the registers from stack
            pop         rcx
            pop         rdx
            pop         rsi
            inc         rsi                             ;incrementing the index of third matrix
            dec         rdx                             ;decrementing rdx
            jnz         L6                              ;if rdx is not zero repeat the loop
        dec             rsi                             ;handling 512
        and             si, 0xFE00                      ;resetting j to 0
        add             rsi, 0x0200                     ;adding 512 to i in oreder to go to the next row
        push            rcx                             ;pushing indices to stack in order to prevent unwanted changes and segmentation fault
        push            rsi
        mov             rdi, 10                         ;moving newline character to rdi
        call            write_char                      ;printing newline character
        pop             rsi                             ;poping indices
        pop             rcx

        loop            L5                              ;while rcx is not zero repeat the loop

add             rsp, 8                                  ;adding 8 to rsp
    ret                                                 ;returning
