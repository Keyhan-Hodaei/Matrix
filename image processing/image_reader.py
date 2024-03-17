import sys
from PIL import Image


def generate_grayscale_matrix(image_path):
    image = Image.open(image_path).convert('L')
    pixels = list(image.getdata())
    width, height = image.size
    _size = max(width, height)
    grayscale_matrix = [[0 for _ in range(_size)] for _ in range(_size)]
    for y in range(height):
        for x in range(width):
            grayscale_matrix[y][x] = pixels[width*y + x]

    return grayscale_matrix


grayscale_matrix, kernel_matrix = generate_grayscale_matrix(
    sys.argv[1]), generate_grayscale_matrix(sys.argv[2])
print(len(grayscale_matrix), len(kernel_matrix))
for row in grayscale_matrix:
    for element in row:
        print(element/255, end=' ')
    print()
for row in kernel_matrix:
    for element in row:
        print((4 * element/255) - 2, end=' ')
    print()
