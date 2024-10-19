#include "fpga_gpu.h"
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>

unsigned long *pDevMem;

int fd;

int create_mapping_memory()
{
    if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1)
    {
        printf("dev/mem não foi aberto\n");
        return -1;
    }

    unsigned long base = HW_REGS_BASE + ALT_LWFPGASLVS_OFST;
    pDevMem = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, base);
    if (pDevMem == MAP_FAILED)
    {
        printf("Mapeamento do dev/mem não foi realizado\n");
        close(fd);
        return -1;
    }
    printf("Dev/mem aberto e mapeado\n");
    return 1;
}

void close_mapping_memory()
{
    // clean up our memory mapping and exit
    if (munmap(pDevMem, HW_REGS_SPAN) != 0)
    {
        printf("unmap realizado com sucesso");
        close(fd);
    }
}

void send_instruction(unsigned int dataA, unsigned int dataB)
{
    while (1)
    {
        if (pDevMem[WRFULL / 4] == 0)
        {
            pDevMem[DATA_A / 4] = dataA;
            pDevMem[WRREG / 4] = 0;
            pDevMem[DATA_B / 4] = dataB;
            pDevMem[WRREG / 4] = 1;
            pDevMem[WRREG / 4] = 0;
            break;
        }
    }
}

/*address -> r0, opcode -> r1, color -> r2, form -> r3, (mult, ref_point_x e refpoint_y) -> stack*/
void set_polygon(unsigned long id, unsigned long cor, unsigned long forma,
                 unsigned long tamanho, unsigned long x, unsigned long y)
{
    unsigned long dataA;   // id[7:4], opcode[3:0]
    dataA = (id << 4) | 3; // opcode = 3

    unsigned long dataB; // Forma[31], BGR[30:22], Tamanho[21:18], y[17:9], x[8:0]
    dataB = (forma << 31) | (cor << 22) | (tamanho << 18) | (y << 9) | x;
    send_instruction(dataA, dataB);
}

void set_sprite(unsigned long id, unsigned long sprite_image, unsigned long ativado,
                unsigned long x, unsigned long y)
{
    unsigned long dataA; // id[8:4], opcode[3:0]
    dataA = id << 4;     // opcode = 0

    unsigned long dataB; // ativado[29], x[28:19], y[18:9], sprite_image[8:0]
    dataB = (ativado << 29) | (x << 19) | (y << 9) | sprite_image;

    send_instruction(dataA, dataB);
}

void set_background_color(unsigned long vermelho, unsigned long verde,
                          unsigned long azul)
{
    // registro = 0 e opcode = 0
    unsigned long dataA = 0;

    /*Ao inves de facilitar o trabalho, gabriel achou uma boa ideia
    usar "BGR" ao inves do popular RGB...... era só inverter o bagulho bixo*/
    unsigned long dataB; // azul[8:6], verde[5:3], vermelho[2:0]
    dataB = (azul << 6) | (verde << 3) | vermelho;

    send_instruction(dataA, dataB);
}

void set_background_block(unsigned long linha, unsigned long coluna, unsigned long vermelho, unsigned long verde, unsigned long azul)
{
    unsigned long dataA; // endereco[17:4], opcode[3:0]
    dataA = (linha * 80) + coluna;
    dataA = (dataA << 4) | 2; // opcode = 2

    unsigned long dataB; // azul[8:6], verde[5:3], vermelho[2:0]
    dataB = (azul << 6) | (verde << 3) | vermelho;

    send_instruction(dataA, dataB);
}

void wait_screen(int limit)
{
    int screens = 0;
    while (screens <= limit)
    { // Wait x seconds for restart Game
        if (pDevMem[SCREEN / 4] == 1)
        { // Checks if a screen has finished drawing.
            // Structure for counter of screen and set parameters.
            screens++;
            pDevMem[RESET_PULSECOUNTER / 4] = 1;
            pDevMem[RESET_PULSECOUNTER / 4] = 0;
        }
    }
}
