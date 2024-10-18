#include <unistd.h>  
#include "graphic_processor.c"

// essa loucura do for pode dar errado, mas achei melhor assim

//Em teoria esse krai é pra fazer 50 sprites, caso fique alternando tem que diminuir o tempo que demora pra alternar entre os grupos.

//Talvez dê erro pq não sei se colocar o ativo = 0 é o suficiente pra não usar o registrador mais

// fazer o teste com 32 sprites sem alternar...

int main(){
    Sprite grupo1[25];
    for (int i = 0; i < 25; i++) {
        grupo1[i].ativo = 1;
        grupo1[i].data_register = i + 1;
        grupo1[i].coord_x = 220 + (i % 6) * 30;
        grupo1[i].coord_y = 100 + (i / 6) * 30;
        grupo1[i].offset = i;
    }

    Sprite grupo2[25];
    for (int i = 0; i < 25; i++) {
        grupo2[i].ativo = 1;
        grupo2[i].data_register = i + 26;
        grupo2[i].coord_x = 220 + (i % 6) * 30;
        grupo2[i].coord_y = 280 + (i / 6) * 30;
        grupo2[i].offset = i + 25;
    }

    createMappingMemory();
    set_background_color(0b111, 0b111, 0b000);

    while (1) {
        for (int i = 0; i < 25; i++) {
            while (1) {
                if (isFull() == 0) { 
                    set_sprite(grupo1[i].data_register, grupo1[i].coord_x, grupo1[i].coord_y, grupo1[i].offset, grupo1[i].ativo); 
                    break; 
                    //IMPORTANTE: acho q tem tirar esse break, to com sono não lembro.
                }
            }
        }

        usleep(100000);

        for (int i = 0; i < 25; i++) {
            grupo1[i].ativo = 0;
        }

        for (int i = 0; i < 25; i++) {
            while (1) {
                if (isFull() == 0) { 
                    set_sprite(grupo2[i].data_register, grupo2[i].coord_x, grupo2[i].coord_y, grupo2[i].offset, grupo2[i].ativo); 
                    break; 
                }
            }
        }

        usleep(100000);

        for (int i = 0; i < 25; i++) {
            grupo2[i].ativo = 0;
        }
    }

    closeMappingMemory();
}
