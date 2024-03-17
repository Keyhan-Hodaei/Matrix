nasm -felf64 matmul_simd.S -o matmul_simd.o
gcc -no-pie -fno-pie driver.c matmul_simd.o -o exec
