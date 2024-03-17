nasm -felf64 matmul.S -o matmul.o
gcc -no-pie -fno-pie driver.c matmul.o -o exec
