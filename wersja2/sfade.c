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
} BMPHeader;                        // lacznie 54B
#pragma pack(pop)


void sunfade(void *img, int width, int height, int dist, int x, int y);

int main(int argc, char* argv[]) {
	
    char *file_path = argv[1];

    FILE *file = fopen(file_path, "rb");
    if (!file){
        printf("Problem with opening the file");
        return 1;
    }   

    BMPHeader header;
    fread(&header, sizeof(BMPHeader), 1, file);

    int width = header.width;
    int height = header.height;
    unsigned int offset = header.offset;

    int bpp = header.bits_per_pixel;

    printf("bpp: %d \nwidth: %d \nheight: %d\noffset: %i\n",
    bpp, width, height, offset);
    void *img = malloc(header.image_size);

    fseek(file, offset, SEEK_SET);
    fread(img, header.image_size, 1, file);
    fclose(file);

    int dist;
    
    do{
        printf("Enter distance: ");
        scanf("%d", &dist);
    }while(dist < 0);

    int x;

    do{
        printf("Enter correct x parameter of sunfade center: ");
        scanf("%d", &x);
    } while((x < 1) || (x > width) );

    int y;

    do{
        printf("Enter correct y parameter of sunfade center: ");
        scanf("%d", &y);
    } while((y < 1) || (y > height) );


    sunfade(img, width, height, dist, x, y);
    

    char new_filename[20];

    printf("Enter filename where you want to store the picture: ");
    scanf("%s", new_filename);
    printf("Filename: %s\n", new_filename);

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