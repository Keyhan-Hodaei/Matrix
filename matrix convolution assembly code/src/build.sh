nasm -felf64 convolution.S -o convolution.o
gcc -no-pie -fno-pie driver.c convolution.o -o exec
