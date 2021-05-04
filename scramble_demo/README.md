# Scramble Images Demo

This demo shows how to use the `scramble()` function in order to create masks from images. Within this demo there are two important functions:
-  `read_all_images()` function that is a wrapper for the `readImages()` function from the [SHINE Toolbox](https://link.springer.com/article/10.3758/BRM.42.3.671). This function read all images within a specific folder and evenrually convert to greyscale.
- `scramble()` given an image as input and the number of pieces, this function return a scrambled version of the input image. Taken from https://it.mathworks.com/matlabcentral/fileexchange/70491-scrambling-image-hb_imagescramble-m