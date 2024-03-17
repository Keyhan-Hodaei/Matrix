nasm -felf64 convolution_simd.S -o convolution_simd.o
gcc -no-pie -fno-pie driver.c convolution_simd.o -o exec
