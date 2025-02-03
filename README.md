[![leak-check](https://github.com/sucholbluk/sunfade/actions/workflows/leak-check.yml/badge.svg)](https://github.com/sucholbluk/sunfade/actions/workflows/leak-check.yml)
# Sunfade
This projects implements a **sunfade** effect on BMP images - linear interpolation between original pixel values and completely white pixel. It's a simple program written in C/Asm(x86). The C part handles: reading from file, processing BMPHeader, prompting the user for parameters and writing to file. The assembly part implements operations on pixels.

Program allows user to work in two modes:
- **Interactive mode** - where user runs the program with just `./sfade <input_file>` - it is usefull when the user doesnt know the exact image size - width and height in pixels. The img parameters are displayed and user is prompted to enter x and y coordinates of sunfade centre, range on which interpolation will occur and output file.
- **Batch/CLI** - user passes all parameters to the program: `./sfade <input_file> <center_x> <center_y> <interpolation_range> <output_filename>`


