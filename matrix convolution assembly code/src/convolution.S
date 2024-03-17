; Student:      Keyhan Hodaei
; Instructor:   Dr. Jahangir
; Calculating the convolution of two matrices
; Inputs: number of rows and columns of two matrices (mat1 and mat2 defined as 'n' and 'm'), getting two matrices as inputs after getting n
section .data align=64
    mat1:                                               ;first matrix
                        dd  0x40000 DUP(0.0)
    mat2:                                               ;second matrix
                        dd  0x40000 DUP(0.0)
    mat3:                                               ;third matrix (convolution matrix)
                        dd  0x40000 DUP(0.0)
    n:                                                  ;number of rows and columns of first matrix
                        dq  0
    m:                                                  ;number of rows and columns of second matrix
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
    call                read_uint                       ;read the number of rows and columns of first matrix, the input is in rax
    mov                 qword[n], rax                   ;moving rax to memory
    call                read_uint                       ;read the number of rows and columns of second matrix, the input is in rax
    mov                 qword[m], rax                   ;moving rax to memory
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


    mov                 rcx, qword[m]                   ;same process as the upper loops for getting inputs from user for second matrix
    xor                 rsi, rsi
    L3:
        mov             rdx, qword[m]
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



    mov                 rbx, qword[n]                   ;rbx = n
    sub                 rbx, qword[m]                   ;rbx = n - m
    inc                 rbx                             ;rbx = n - m + 1
    mov                 rcx, 0                          ;initializing the counter of first loop (i = 0)
    for_i:                                              ;first loop
        mov             r11, 0                          ;initializing the counter of second loop (j = 0)
        for_j:                                          ;second loop
            call        find_dot_product                ;calling find_dot_product function
            inc         r11                             ;incrementing j
            cmp         r11, rbx                        ;comparing j with n-m+1
            jl          for_j                           ;if j was lower, repeat the loop
        inc             rcx                             ;incrementing i
        cmp             rcx, rbx                        ;comparing i with n-m+1
        jl              for_i                           ;if i was lower, repeat the loop


    mov                 rdi, qword[n]                   ;rdi = n
    sub                 rdi, qword[m]                   ;rdi -= m 
    inc                 rdi                             ;rdi = n-m+1
    push                rsi                             ;pushing needed registers to stack in order to prevent unwanted changes and segmentation fualt
    push                rdx
    push                rcx
    push                rbx
    call                write_uint                      ;printing n-m+1 (the number of rows and columns of convolution matrix)
    mov                 rdi, 10                         ;moving newline character to rdi
    call                write_char                      ;printing newline character
    pop                 rbx                             ;poping registers from stack
    pop                 rcx
    pop                 rdx
    pop                 rsi

    mov                 rcx, rbx                        ;moving n to rcx to use it as counter in loop
    mov                 rsi, 0                          ;initializing the index of third matrix
    L5:                                                 ;loop 5
        mov             rdx, rbx                        ;moving n to rdx
        L6:                                             ;loop6
            movss       xmm0, [mat3 + 4*rsi]            ;moving the element of third matrix in the given index to xmm0
            push        rsi                             ;pushing needed registers to stack in order to prevent unwanted changes and segmentation faults
            push        rdx
            push        rcx
            push        rbx
            call        write_float                     ;printing the said element of third matrix
            mov         rdi, ' '                        ;moving white space character to rdi
            call        write_char                      ;printing the said character
            pop         rbx                             ;poping the registers from stack
            pop         rcx
            pop         rdx
            pop         rsi
            inc         rsi                             ;incrementing the index of third matrix
            dec         rdx                             ;decrementing rdx
            jnz         L6                              ;if rdx is not zero repeat the loop
        dec             rsi                             ;handling 512
        and              si, 0xFE00                     ;resetting j to 0
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



find_dot_product:                                       ;find_dot_product of two matrices function

mov        r12, 0                                       ;initializing the counter of third loop (k = 0)
for_k:                                                  ;first loop
   mov     r13, 0                                       ;initializing the counter of fourth loop (l = 0)
   for_l:                                               ;second loop
       mov r14, rcx                                     ;r14 = i
       add r14, r12                                     ;r14 = i + k
       shl r14, 9                                       ;r14 = 512 * (i+k)
       add r14, r11                                     ;r14 += j
       add r14, r13                                     ;r14 = 512 * (i+k) + (j+l)
       movss xmm0, [mat1 + 4*r14]                       ;xmm0 = mat1[i+k][j+l]

       mov r14, r12                                     ;r14 = k
       shl r14, 9                                       ;r14 *= 512
       add r14, r13                                     ;r14 = 512 * k + l 
       mulss xmm0, [mat2 + 4*r14]                       ;xmm0 *= mat2[k][l]

       mov r14, rcx                                     ;r14 = i
       shl r14, 9                                       ;r14 *= 512
       add r14, r11                                     ;r14 = 512 * i + j
       addss xmm0, [mat3 + 4*r14]                       ;xmm0 += mat3[i][j]
       movss [mat3 + 4*r14], xmm0                       ;mat3[i][j] = xmm0
       
       inc r13                                          ;incrementing l 
       cmp r13, qword[m]                                ;comparing l with m 
       jl  for_l                                        ;if l is lower than m repeat the loop
   inc     r12                                          ;incrementing k
   cmp     r12, qword[m]                                ;comparing k with m 
   jl      for_k                                        ;if k is lower than m repeat the loop   
ret                                                     ;returning






