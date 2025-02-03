#include <stdio.h>
#include <stdlib.h>

#pragma pack(push, 1)
typedef struct {
    // BFH
    unsigned short signature;       // 2B
    unsigned int size;              // 4B
    unsigned short reserved1;       // 2B
    unsigned short reserved2;       // 2B
    unsigned int offset;            // 4B
    // DIB
    unsigned int header_size;       // 4B
    int width;                      // 4B
    int height;                     // 4B
    unsigned short planes;          // 2B
    unsigned short bits_per_pixel;  // 2B
    unsigned int compression;       // 4B
    unsigned int image_size;        // 4B
    int x_resolution;               // 4B
    int y_resolution;               // 4B
    unsigned int colors_used;       // 4B
    unsigned int colors_important;  // 4B
} BMPHeader;                        // sums to 54B
#pragma pack(pop)


void sunfade(void *img, int width, int height, int dist, int x, int y);

void get_parameters_from_user(int params[3], int img_width, int img_height, char *output_filename){
    do{
        printf("Enter correct x parameter of sunfade center: ");
        scanf("%d", &params[0]);
    } while((params[0] < 1) || (params[0] > img_width) );

    do{
        printf("Enter correct y parameter of sunfade center: ");
        scanf("%d", &params[1]);
    } while((params[1] < 1) || (params[1] > img_height) );

    do{
        printf("Enter interpolation range: ");
        scanf("%d", &params[2]);
    }while(params[2] < 0);

    printf("Enter filename where you want to store the picture: ");
    scanf("%s", output_filename);
}


int main(int argc, char* argv[]) {
    int interactive = 1;
    char *file_path;
    void *img;
    int img_width;
    int img_height;
    int bbp; // bits per pixel
    char *new_filename;
    int params[3]; // [x, y, range]
    int x;
    int y;
    int range;

    if (argc != 2 && argc != 6) {
        printf("Incorrect input\nUsage options:\n Interactive Mode:\n\t./sfade <input_file>\n");
        printf(" Batch/CLI Mode:\n\t./sfade <input_file> <center_x> <center_y> <interpolation_range> <output_filename>");
        return 1;
    }
	    
    file_path = argv[1];
    if (argc == 6) {
        params[0] = atoi(argv[2]);
        params[1] = atoi(argv[3]);
        params[2] = atoi(argv[4]);
        new_filename = argv[5];
        interactive = 0;
        printf("here");
    }

    FILE *file = fopen(file_path, "rb");
    if (!file){
        printf("Problem with opening the file\n");
        return 1;
    }   

    BMPHeader header;
    fread(&header, sizeof(BMPHeader), 1, file);

    img_width = header.width;
    img_height = header.height;
    printf("bpp: %d \nwidth: %d \nheight: %d\n",
        header.bits_per_pixel, img_width, img_height);

    img = malloc(header.image_size);

    fseek(file, header.offset, SEEK_SET);
    fread(img, header.image_size, 1, file);
    fclose(file);
    
    if (interactive) {
        get_parameters_from_user(params, img_width, img_height, new_filename);
    }


    sunfade(img, img_width, img_height, params[2], params[0], params[1]);
    

    FILE *output_file = fopen(new_filename, "wb");
    if (!output_file) {
        printf("Error creating output file\n");
        free(img);
        return 1;
    }

    fwrite(&header, sizeof(BMPHeader), 1, output_file);
    fwrite(img, header.image_size, 1, output_file);

    fclose(output_file);
    free(img);

    printf("Image processed successfully\n");

    return 0;
}
