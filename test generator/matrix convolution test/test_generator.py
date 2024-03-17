import random


def generate_test(n, m, file):
    file.write('%u\n' % n)
    file.write('%u\n' % m)
    for i in range(n):
        file.write(''.join(['%0.4f ' % random.random() for j in range(n)]))
        file.write('\n')
    for i in range(m):
        file.write(''.join(['%0.4f ' % random.random() for j in range(n)]))
        file.write('\n')


with open('test_1.in', 'w') as file:
    n = random.randint(1, 16)
    m = random.randint(1, n)
    generate_test(n, m, file)

with open('test_2.in', 'w') as file:
    n = random.randint(17, 64)
    m = random.randint(17, n)
    generate_test(n, m, file)

with open('test_3.in', 'w') as file:
    n = random.randint(65, 256)
    m = random.randint(65, n)
    generate_test(n, m, file)

with open('test_4.in', 'w') as file:
    n = random.randint(257, 384)
    m = random.randint(257, n)
    generate_test(n, m, file)

with open('test_5.in', 'w') as file:
    n = random.randint(385, 512)
    m = random.randint(385, n)
    generate_test(n, m, file)

with open('test_6.in', 'w') as file:
    n = m = 512
    generate_test(n, m, file)
