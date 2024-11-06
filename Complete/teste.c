#include "gpu_lib.h"
#include <stdio.h>
#include <unistd.h>
#include <math.h>

int *full;
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

void limpaTela(int x, int y, int limite_x, int limite_y)
{
	int i, j;
	for (i = x; i < limite_x; i++)
	{
		for (j = y; j < limite_y; j++)
		{
			while (1)
			{
				if (*((full + 0xb0 / sizeof(int))) == 0)
				{
					tetrisBlock(j, i, 6, 7, 7);
					break;
				}
			}
		}
	}
}

int main()
{
    full = create_mapping_memory();
    set_background_color(0,7,0);
    clear_all();


#define LEC 0777
#define BGC 0667

int sprite_s[20][20] =
{
{BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, },
{BGC, BGC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, BGC, },
{BGC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, BGC, },
{BGC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, BGC, BGC, },
{BGC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, BGC, BGC, BGC, },
{BGC, LEC, LEC, LEC, LEC, LEC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, },
{BGC, LEC, LEC, LEC, LEC, LEC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, },
{BGC, LEC, LEC, LEC, LEC, LEC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, },
{BGC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, BGC, BGC, BGC, },
{BGC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, BGC, BGC, },
{BGC, BGC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, BGC, },
{BGC, BGC, BGC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, BGC, },
{BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, LEC, LEC, LEC, BGC, },
{BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, LEC, LEC, LEC, BGC, },
{BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, LEC, LEC, LEC, BGC, },
{BGC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, BGC, },
{BGC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, BGC, },
{BGC, BGC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, BGC, },
{BGC, BGC, BGC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, LEC, BGC, BGC, },
{BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, },
};

    int i,j,k;
    for (i = 1; i < 32; i++)
    {
        for (j=0; j < 6; j++)
        {
            set_sprite(i,i,1,i*20,j*20);
        }
    } 

    // set_sprite_memory(1,0,0,0);

    for (i = 0; i < 20; i++)
    {
        for (j = 0; j < 20; j++)
        {
            set_sprite_memory(1,sprite_s[j][i],i,j);
        }
    }

    for (k = 0; k < 32; k++)
    {
        for (i = 0; i < 20; i++)
        {
            for (j = 0; j < 20; j++)
            {
            set_sprite_memory(k,BGC,i,j);
            }
        }
    }


    // // set_sprite(1, 0, LEC, 077700, 077700);

    // set_sprite_memory(0,LEC,0,0);
    // set_sprite_memory(0,LEC,0,1);
    // set_sprite_memory(0,LEC,0,2);
    // set_sprite_memory(0,LEC,0,3);
    // set_sprite_memory(0,LEC,0,4);


    // set_sprite(3, 3, LEC, 70, 200);
    // set_sprite(4, 4, LEC, 30, 300);
    // set_sprite(5, 5, LEC, 50, 450);
    // set_sprite(6, 6, LEC, 70, 500);

    // usleep(1000000);
    // clear_sprite(-1);
    // clear_background();

    // int keys = 0;
    // while(1)
    // {
    //     keys = read_keys();
    //     printf("%d\n",keys);
    // }

    // clear_all();

    // usleep(2000000); // 2 seg

    // for (i = 0; i <15; i++)
    // {
    //     clear_polygon(i);
    // }

    // usleep(2000000); // 2 seg

    // for (i = 0; i <15; i++)
    // {
    //     set_polygon(i+1, 511, LEC, LEC, (i*20) + 10, (i*20) + 10);
    //     printf("%d\n", i);
    //     usleep(100000);
    // }
    // double base = 2.0;
    // double exponent = 3.0;
    // double result = pow(base, exponent);

    // printf("O resultado de %.1f^%.1f é: %.1f\n", base, exponent, result);
    // clear_polygon(-1);

    // clear_polygon(-1);
}