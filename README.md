# Matrix
This project, is the final project of **Computer Architecture and Language** course in my third semester at SUT.
This project contains codes that calculate the multiplication and convolution of matrices in **Assembly** and these assembly codes are written in two ways:
    1) Using SISD commands
    2) Using SIMD commands
Each micro project has its own directory which you can open. By running `./build.sh` command you will compile the codes and then by running `./exec` you can give inputs to the code and get the ouptputs.
There is also an **image processing** directory. We used the convolution codes to make some changes to the input pictures.
  There are two **Python** files: 
    ***image_reader.py*** reads the input image and turns it into a grayscale matrix.
    ***image_writer.py*** gets a matrix as an input and will give the grayscale image of it as its output.
    There are several _kernels_ in this project that will change the image in different ways. These images will be changed to a grayscale matrix by ***image_reader.py***.
    Then, the image and kernels will be given as matrix inputs to the convolution code that is written in assembly and the output will be calculated.
    This output will be passed to ***image_writer.py*** and the output images will be saved in `output_images` directory.
