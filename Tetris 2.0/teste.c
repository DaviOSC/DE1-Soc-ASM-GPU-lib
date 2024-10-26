#include "gpu_lib.h"
#include <stdio.h>
#include <unistd.h>

void limpaTela(int x, int y, int limite_x, int limite_y)
{
    int i, j;
    for (i = x; i < limite_x; i++)
    {
        for (j = y; j < limite_y; j++)
        {
            while (1)
            {
                tetrisBlock(j, i, 6, 7, 7);
                break;
            }
        }
    }
}

void tetrisBlock(int column, int line, int R, int G, int B)
{

    int i, j = 0;
    for (i = 0; i < 4; i++)
    {
        for (j = 0; j < 4; j++)
        {
            set_background_block((column * 4) + j, (line * 4) + i, R, G, B); // Pinta um bloco 4x4
        }
    }
}

int main()
{
    create_mapping_memory();
    // video_open();

    limpaTela(0, 0, 20, 15);
    set_background_color(5, 5, 1);
    set_sprite(1, 1, 1, 30, 100);
    set_sprite(2, 2, 1, 50, 150);
    set_sprite(3, 3, 1, 70, 200);
    set_sprite(4, 4, 1, 30, 300);
    set_sprite(5, 5, 1, 50, 450);
    set_sprite(6, 6, 1, 70, 500);

    usleep(1000000);
    clear_sprite(-1);
    // int keys = 0;
    // while(1)
    // {
    //     keys = read_keys();
    //     printf("%d\n",keys);
    // }
}