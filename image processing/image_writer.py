import sys
import numpy as np
from PIL import Image


def generate_grayscale_image(matrix, path):
    _size = len(matrix)
    image = Image.new('L', (_size, _size))
    for y in range(_size):
        for x in range(_size):
            image.putpixel((x, y), int(matrix[y][x] * 255))
    image.save(path)


_size = int(input())
matrix = [[float(x) for x in input().split()] for _ in range(_size)]
generate_grayscale_image(matrix, sys.argv[1])
