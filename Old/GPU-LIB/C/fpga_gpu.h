#ifndef fpga_gpu_H
#define fpga_gpu_H

// Barramentos da GPU
#define DATA_A 0X80
#define DATA_B 0X70
#define RESET_PULSECOUNTER 0X90
#define SCREEN 0XA0
#define WRFULL 0XB0
#define WRREG 0XC0

// Mapeamento de memória

#define ALT_LWFPGASLVS_OFST 0xff200000
#define HW_REGS_BASE 0xfc000000
#define HW_REGS_SPAN 0x04000000
#define HW_REGS_MASK (HW_REGS_SPAN - 1) // 0x3FFFFFF

/*---- Constants that define the direction of a sprite -----*/
#define LEFT 0
#define UPPER_RIGHT 1
#define UP 2
#define UPPER_LEFT 3
#define RIGHT 4
#define BOTTOM_LEFT 5
#define DOWN 6
#define BOTTOM_RIGHT 7

/*-------Defining data relating to mobile sprites -------------------------------------------------------------------------*/
typedef struct
{
    int coord_x;       // current x-coordinate of the sprite on screen.
    int coord_y;       // current y-coordinate of the sprite on screen.
    int direction;     // variable that defines the sprite's movement angle.
    int offset;        // Variable that defines the sprite's memory offset. Used to choose which animation to use.
    int data_register; // Variable that defines in which register the data relating to the sprite will be stored.
    int step_x;        // Number of steps the sprite moves on the X axis.
    int step_y;        // Number of steps the sprite moves on the Y axis.
    int ativo;
    int collision; // 0 - without collision , 1 - collision detected
} Sprite;

/*-------Defining data relating to fixed sprites -------------------------------------------------------------------------*/
typedef struct
{
    int coord_x;       // current x-coordinate of the sprite on screen.
    int coord_y;       // current y-coordinate of the sprite on screen.
    int offset;        // Variable that defines the sprite's memory offset. Used to choose which animation to use.
    int data_register; // Variable that defines in which register the data relating to the sprite will be stored.
    int ativo;
} Sprite_Fixed;

void set_sprite_memory(unsigned long sprite_slot, unsigned long cor, unsigned long x, unsigned long y);

/*Id : id do sprite a ser desativado. -1 desativa todos os sprites*/
void clear_sprite(unsigned long id);

/*Id : id do poligono a ser desativado. -1 desativa todos os poligonos*/
void clear_polygon(unsigned long id);

void set_sprite(unsigned long id, unsigned long sprite_image, unsigned long ativado,
                unsigned long x, unsigned long y);

void set_background_color(unsigned long vermelho, unsigned long verde,
                          unsigned long azul);

void set_background_block(unsigned long linha, unsigned long coluna, unsigned long vermelho, unsigned long verde, unsigned long azul);

void set_polygon(unsigned long id, unsigned long cor, unsigned long forma,
                 unsigned long tamanho, unsigned long x, unsigned long y);

void send_instruction(unsigned int dataA, unsigned int dataB);

void close_mapping_memory();

int create_mapping_memory();

void wait_screen(int limit);

#endif