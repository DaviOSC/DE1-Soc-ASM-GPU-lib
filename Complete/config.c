#include <stdio.h>

// //Defines

#define QUANTIDADE_TETROMINOS 7 // Quantidade de tetrominos no jogo
#define BLOCOS_POR_PECA 4		// Quantidade de blocos que compõe as peças
#define SPAWN_BLOCK_X 3			// Coordenada X de surgimento do tetromino
#define SPAWN_BLOCK_Y 0			// Coordenada Y de surgimento do tetromino
#define TAMANHO_PREVIEW 4		// Quantidades de peças no preview

#define LINHAS_TABULEIRO 15	 // Quantidade de colunas de blocos no tabuleiro, contando com chão
#define COLUNAS_TABULEIRO 10 // Quantidade de linhas de blocos no tabuleiro, contando com paredes

#define TICKS 60			  // Quantas vezes a main é executada em um único segundo
#define COOLDOWN_GRAVIDADE 10 // Tempo em ticks do cooldown da gravidade
#define COOLDOWN_INPUT 15	  // Tempo em ticks do cooldown para input do jogador
#define INPUT_INCLINACAO 30	  // Inclinação necessaria para aceitar o input do jogador

// //Structs

/*
Tetromino é o nome das peças do tetris :)
	int formato[BLOCOS_POR_PECA][BLOCOS_POR_PECA]; : 0 não tem bloco, 1 tem bloco
	int cor; : Cor do bloco, o index da lista de cores
	int x; : posição horizontal do tetromino no tabuleiro
	int y; : posição vertical do tetromino no tabuleiro
*/
typedef struct Tetromino
{
	int formato[BLOCOS_POR_PECA][BLOCOS_POR_PECA]; // 0 não tem bloco, 1 tem bloco
	int cor;									   // Cor do bloco, o index da lista de cores
	int x;
	int y;
} Tetromino;

typedef struct Cor
{
	int R;
	int G;
	int B;
} Cor;

const Cor BLACK = {0, 0, 0};
const Cor GRAY = {7, 7, 7};
const Cor YELLOW = {7, 7, 0};
const Cor ORANGE = {7, 4, 1};
const Cor BLUE = {0, 0, 7};
const Cor CYAN = {0, 7, 7};
const Cor MAGENTA = {7, 0, 7};
const Cor GREEN = {0, 7, 0};
const Cor RED = {7, 0, 0};

// const short LISTA_CORES[] = {0, 1, 2, 3, 4, 5, 6, 7, 8};

const Cor *LISTA_CORES[] = {&BLACK, &GRAY, &YELLOW, &ORANGE, &BLUE, &CYAN, &MAGENTA, &GREEN, &RED};

// TETROMINOS

/*
0000
1111
0000
0000*/
const Tetromino TETROMINO_I = {{{0, 0, 0, 0},
								{1, 1, 1, 1},
								{0, 0, 0, 0},
								{0, 0, 0, 0}},
							   5,
							   SPAWN_BLOCK_X,
							   SPAWN_BLOCK_Y};
/*
0000
0100
0111
0000*/
const Tetromino TETROMINO_J = {{{0, 0, 0, 0},
								{0, 1, 0, 0},
								{0, 1, 1, 1},
								{0, 0, 0, 0}},
							   4,
							   SPAWN_BLOCK_X,
							   SPAWN_BLOCK_Y};
/*
0000
0001
0111
0000*/
const Tetromino TETROMINO_L = {{{0, 0, 0, 0},
								{0, 0, 0, 1},
								{0, 1, 1, 1},
								{0, 0, 0, 0}},
							   3,
							   SPAWN_BLOCK_X,
							   SPAWN_BLOCK_Y};
/*
0000
0110
0110
0000*/
const Tetromino TETROMINO_O = {{{0, 0, 0, 0},
								{0, 1, 1, 0},
								{0, 1, 1, 0},
								{0, 0, 0, 0}},
							   2,
							   SPAWN_BLOCK_X,
							   SPAWN_BLOCK_Y};
/*
0000
0011
0110
0000*/
const Tetromino TETROMINO_S = {{{0, 0, 0, 0},
								{0, 0, 1, 1},
								{0, 1, 1, 0},
								{0, 0, 0, 0}},
							   7,
							   SPAWN_BLOCK_X,
							   SPAWN_BLOCK_Y};
/*
0000
0010
0111
0000*/
const Tetromino TETROMINO_T = {{{0, 0, 0, 0},
								{0, 0, 1, 0},
								{0, 1, 1, 1},
								{0, 0, 0, 0}},
							   6,
							   SPAWN_BLOCK_X,
							   SPAWN_BLOCK_Y};
/*
0000
0110
0011
0000*/
const Tetromino TETROMINO_Z = {{{0, 0, 0, 0},
								{0, 1, 1, 0},
								{0, 0, 1, 1},
								{0, 0, 0, 0}},
							   8,
							   SPAWN_BLOCK_X,
							   SPAWN_BLOCK_Y};

const Tetromino *LISTA_PONTEIROS_TETROMINOS[QUANTIDADE_TETROMINOS] =
	{
		&TETROMINO_I, &TETROMINO_J, &TETROMINO_L, &TETROMINO_O,
		&TETROMINO_S, &TETROMINO_T, &TETROMINO_Z};

//" TETRIS "

int TitleMatriz[15][20] = {
    {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1},
    {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1},
	{0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0},
	{0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1},
	{0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1},
	{0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1},
    {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0}
};

int PauseMatriz[15][20] = {
    {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 2, 2, 2, 0, 2, 2, 2, 0, 2, 0, 2, 0, 2, 2, 2, 0, 2, 2, 0},
    {0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 0, 0, 2, 0, 0},
    {0, 2, 2, 2, 0, 2, 2, 2, 0, 2, 0, 2, 0, 2, 2, 2, 0, 2, 2, 0},
    {0, 2, 0, 0, 0, 2, 0, 2, 0, 2, 0, 2, 0, 0, 0, 2, 0, 2, 0, 0},
    {0, 2, 0, 0, 0, 2, 0, 2, 0, 2, 2, 2, 0, 2, 2, 2, 0, 2, 2, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1},
    {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
};

int GameOverMatriz1[15][20] = {
    {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0},
    {1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0},
    {1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0},
    {1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0},
    {0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1},
    {0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1},
    {0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1},
    {0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0},
    {0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 0, 1},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1},
};

int GameOverMatriz2[15][20] = {
    {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1},
    {0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0},
    {0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1},
    {0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0},
    {1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0},
    {1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0},
    {1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0},
    {0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0}
};
int number0[5][5] = 
{
	{0,1,1,1,0},
	{0,1,0,1,0},
	{0,1,0,1,0},
	{0,1,0,1,0},
	{0,1,1,1,0}
};
int number1[5][5] = 
{
	{0,0,1,0,0},
	{0,1,1,0,0},
	{0,0,1,0,0},
	{0,0,1,0,0},
	{0,1,1,1,0}
};
int number2[5][5] = 
{
	{0,1,1,1,0},
	{0,0,0,1,0},
	{0,1,1,1,0},
	{0,1,0,0,0},
	{0,1,1,1,0}
};
int number3[5][5] = 
{
	{0,1,1,1,0},
	{0,0,0,1,0},
	{0,1,1,1,0},
	{0,0,0,1,0},
	{0,1,1,1,0}
};
int number4[5][5] = 
{
	{0,1,0,1,0},
	{0,1,0,1,0},
	{0,1,1,1,0},
	{0,0,0,1,0},
	{0,0,0,1,0}
};
int number5[5][5] = 
{
	{0,1,1,1,0},
	{0,1,0,0,0},
	{0,1,1,1,0},
	{0,0,0,1,0},
	{0,1,1,1,0}
};
int number6[5][5] = 
{
	{0,1,1,1,0},
	{0,1,0,0,0},
	{0,1,1,1,0},
	{0,1,0,1,0},
	{0,1,1,1,0}
};
int number7[5][5] = 
{
	{0,1,1,1,0},
	{0,0,0,1,0},
	{0,0,0,1,0},
	{0,0,0,1,0},
	{0,0,0,1,0}
};
int number8[5][5] = 
{
	{0,1,1,1,0},
	{0,1,0,1,0},
	{0,1,1,1,0},
	{0,1,0,1,0},
	{0,1,1,1,0}
};
int number9[5][5] = 
{
	{0,1,1,1,0},
	{0,1,0,1,0},
	{0,1,1,1,0},
	{0,0,0,1,0},
	{0,1,1,1,0}
};

int scoreText[5][20] = 
{
	{0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1},
	{0,1,0,0,0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,0},
	{0,1,1,1,0,1,0,0,0,1,0,1,0,1,1,0,0,1,1,1},
	{0,0,0,1,0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,0},
	{0,1,1,1,0,1,1,1,0,1,1,1,0,1,0,1,0,1,1,1},
};

int (*matrizesNumeros[10])[5][5] = {&number0, &number1, &number2, &number3, &number4, &number5, &number6, &number7, &number8, &number9};
	