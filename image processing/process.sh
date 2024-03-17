nasm -felf64 ../project3/src/convolution.S -o convolution.o
gcc -O3 -no-pie -fno-pie ../project3/src/driver.c convolution.o -o exec

for input in input_images/*
do 
    for kernel in kernels/*
    do 
        out="output_images/$(basename --suffix=.png "$input")_$(basename "$kernel")"
        #echo "$input + $kernel => $out"
        python image_reader.py $input $kernel | ./exec | python image_writer.py $out
#        python image_reader.py $input $kernel
    done
done
