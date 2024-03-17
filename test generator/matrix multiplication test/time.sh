nasm -felf64 ../../project/src/matmul.S -o matmul.o
gcc -W -O3 -no-pie -fno-pie ../../project/src/driver.c matmul.o -o asm_exec

nasm -felf64 ../../project2/src/matmul_simd.S -o matmul_simd.o
gcc -W -O3 -no-pie -fno-pie ../../project2/src/driver.c matmul_simd.o -o asm_simd_exec

gcc -W -O3 ../../matrix\ multiplication\ c\ code/main.c -o normal_c_exec

gcc -W -O0 ../../matrix\ multiplication\ c\ code/main.c -o normal_c0_exec

flag=0

python3 test_generator.py

declare -A asmTimer
declare -A asmSimdTimer
declare -A normalCTimer
declare -A normalC0Timer
for test in test_*.in 
do 
    asmTimer["$test"]=0.0
    asmSimdTimer["$test"]=0.0
    normalCTimer["$test"]=0.0
    normalC0Timer["$test"]=0.0
done

for i in $(seq 10)
do 
    echo "TEST $i"
    python3 test_generator.py
    for test in test_*.in 
    do 
        time1=$(date +%s.%N)
        ./asm_exec < $test > /dev/null
        time2=$(date +%s.%N)
        time3=$(date +%s.%N)
        ./normal_c_exec < $test > /dev/null
        time4=$(date +%s.%N)
        ./asm_simd_exec < $test > /dev/null
        time5=$(date +%s.%N)
        time6=$(date +%s.%N)
        ./normal_c0_exec < $test > /dev/null
        time7=$(date +%s.%N)


        asmTimer["$test"]=$(echo "$time2 - $time1 + "${asmTimer["$test"]} | bc)
        asmSimdTimer["$test"]=$(echo "$time4 - $time3 + "${asmSimdTimer["$test"]} | bc)
        normalCTimer["$test"]=$(echo "$time5 - $time4 + "${normalCTimer["$test"]} | bc)
        normalC0Timer["$test"]=$(echo "$time7 - $time6 + "${normalC0Timer["$test"]} | bc)

    done

    if [[ $flag -eq 1 ]]
    then 
        break 
    fi 

done


echo -e "Code\t\t1<=n<=16\t\t16<n<=64\t\t64<n<=256\t\t256<n<=384\t\t384<n<=512\t\tn=512"
echo -e 'assembly(simd)\t'${asmSimdTimer["test_1.in"]}"\t\t"${asmSimdTimer["test_2.in"]}"\t\t"${asmSimdTimer["test_3.in"]}"\t\t"${asmSimdTimer["test_4.in"]}"\t\t"${asmSimdTimer["test_5.in"]}"\t\t"${asmSimdTimer["test_6.in"]}
echo -e 'assembly(sisd)\t'${asmTimer["test_1.in"]}"\t\t"${asmTimer["test_2.in"]}"\t\t"${asmTimer["test_3.in"]}"\t\t"${asmTimer["test_4.in"]}"\t\t"${asmTimer["test_5.in"]}"\t\t"${asmTimer["test_6.in"]}
echo -e 'c(gcc -O3)\t'${normalCTimer["test_1.in"]}"\t\t"${normalCTimer["test_2.in"]}"\t\t"${normalCTimer["test_3.in"]}"\t\t"${normalCTimer["test_4.in"]}"\t\t"${normalCTimer["test_5.in"]}"\t\t"${normalCTimer["test_6.in"]}
echo -e 'c(gcc -O0)\t'${normalC0Timer["test_1.in"]}"\t\t"${normalC0Timer["test_2.in"]}"\t\t"${normalC0Timer["test_3.in"]}"\t\t"${normalC0Timer["test_4.in"]}"\t\t"${normalC0Timer["test_5.in"]}"\t\t"${normalC0Timer["test_6.in"]}


