#include "graphic_processor.c"
#include <stdio.h>


int main() {
    // Matriz 20x15
    int matrix[15][20] = {
        {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 3, 0, 0, 0, 0},
        {2, 2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 3, 3, 3, 0, 0, 0},
        {0, 2, 2, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 3, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 3, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0},
    };

    // Cores correspondentes para cada número
    int colors[4][3] = {
        {0, 0, 0}, // Cor para 0 (preto, espaço vazio)
        {255, 0, 0},     // Cor para 1 (vermelho)
        {0, 255, 0},     // Cor para 2 (verde)
        {0, 0, 255}      // Cor para 3 (azul)
    };

    // Loop para percorrer a matriz e desenhar os blocos
    for (int line = 0; line < 15; line++) {
        for (int column = 0; column < 20; column++) {
            int value = matrix[line][column];
            if (value > 0) { // Desenhar apenas se o valor for maior que 0
                set_tetris_block(column * 4, line, colors[value][0], colors[value][1], colors[value][2]);
            }
        }
    }

    return 0;
}
