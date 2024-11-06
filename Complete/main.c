// /* Criação de um jogo inspirado em Tetris para ser executado em uma DE1-SoC
//  - Os tetrominos serão movimentados pelo jogador por meio do acelerômetro
//  - Todos os itens visuais serão exibidos por meio da interface VGA
//  - Botões serão utilizados para: reiniciar, pausar e continuar o jogo
//  - O jogo é encerrado de vez pela utilização de ^C
// */

#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include "config.c"
#include <unistd.h>
#include <math.h> 

#include "gpu_lib.h"
#include "accel_lib.h"

bool sair = false;

void encerrarJogo()
{
	sair = true;
	raise(SIGTERM);
}

// Funções

// do Sistema

void IniciarTabuleiro(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO]);
void Delay(float segundos);
void ImprimirTabuleiro(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO]);
void ImprimirTetromino(Tetromino *tetromino, int x, int y);
void ImprimirTela(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], Tetromino *tetrominoFlutuante,
				  Tetromino *tetrominoHold, Tetromino tetrominoPreview[TAMANHO_PREVIEW], int score);
void ImprimirtTextMatrix(int matriz[15][20], int indexCor);
void Resetar(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], bool *pecaFlutuanteExiste, Tetromino tetrominoPreview[TAMANHO_PREVIEW]);
void Pause();

// do Jogo

void GerarTetromino(Tetromino *tetromino, Tetromino tetrominoPreview[TAMANHO_PREVIEW]);
void PreencherPreview(Tetromino tetrominoPreview[TAMANHO_PREVIEW]);
bool TestarColisao(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], Tetromino *tetromino, int x, int y);
void CongelarTetromino(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], Tetromino *tetromino);
void VerificaLinhaCheia(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], int linhasCheias[BLOCOS_POR_PECA]);
void LimpaLinhas(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], int linhas[BLOCOS_POR_PECA], int *score);

// do Jogador

void ReceberInput(bool *hold, bool *flip, int *sentido, bool *pause);

bool Mover(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], Tetromino *tetromino, int direcao);
void RotacaoTetromino(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], Tetromino *tetromino, int sentido);
void Hold(Tetromino *tetromino, Tetromino *hold, bool *canHold, Tetromino tetrominoPreview[TAMANHO_PREVIEW]);

// do video
void ImprimirMiniTextMatrix(int cont, int matriz[5][cont], int column,int line,int R, int G, int B);
void tetrisBlock(int column, int line, int R, int G, int B);
void limpaTela(int x, int y, int limite_x, int limite_y);
void limpaTetromino(Tetromino *tetromino, int x, int y);
void printScore(int score, int line, int startColumn, int R, int G, int B);

int *full;
int main()
{
	// Setup
	full = create_mapping_memory();
	// Configurar signal para encerrar jogo ao usuario usar Ctrl + C
	signal(SIGINT, encerrarJogo);
	srand(time(NULL)); // seed de aleatoriedade

	// Mapeamento e acesso do /dev/mem para acessar o acelerometro via I2C
	int fd = open_and_map();

	// Verificação dos periféricos da DE1-SoC
	if (fd == -1)
	{
		printf("Erro na inicialização de periféricos.\n");
		return -1;
	}
	set_background_color(0, 0, 0);
	I2C0_init();
	accel_init();
	limpaTela(0, 0, 20, 15);
	Tetromino tetrominoFlutuante;	  // Tetromino controlado pelo jogador
	Tetromino tetrominoHold = {{-1}}; // Tetromino guardado

	Tetromino tetrominoPreview[TAMANHO_PREVIEW]; // Futuros tetrominos flutuantes

	int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO]; // Tabuleiro do jogo

	// Variáveis de controle do jogo

	bool pecaFlutuanteExiste = false;
	bool gameOver = false;

	int linhasCheias[BLOCOS_POR_PECA];
	int cooldownGravidade = 0;
	int cooldownMovimento = 0;

	// Variáveis controladas pelos periféricos

	int accel_x, inputSW, inputKEY; // Recebe input dos periféricos
	int sentido;					// Sentido do giro do peça: -1 = anti horário, 1 = horário
	bool hold = false;				// True quando usuario pressionar hold

	// True se o usuario ainda não tiver usado hold no tetromino flutuante atual
	bool canHold = true;
	bool flip = false;				 // True quando usuario pressionar o botão de flip
	bool pause = true, reset = true; // Controlados pelos switches

	int score = 0;

	FILE *pFileScore;

	// Resetar/Preparar jogo
	Resetar(tabuleiro, &pecaFlutuanteExiste, tetrominoPreview);

	inputKEY = read_keys();
	int indexCor = 1;

	while (inputKEY == 0)
	{
		inputKEY = read_keys();
		Delay(0.3);
		ImprimirtTextMatrix(TitleMatriz, indexCor);
		if (indexCor < 9)
		{
			indexCor++;
		}
		else
		{
			indexCor = 1;
		}
	}

	Resetar(tabuleiro, &pecaFlutuanteExiste, tetrominoPreview);
	score = 0;
	////video_erase();
	gameOver = false;

	// Loop Principal
	while (!sair)
	{
		// Loop do jogo
		while (!gameOver && !sair)
		{
			// o loop será executado TICKS vezes em um segundo

			if (pecaFlutuanteExiste)
			{
				// Gravidade ativada
				if (cooldownGravidade == COOLDOWN_GRAVIDADE)
				{
					/* Se não for possível mover para baixo a peça é automaticamente
					congelada*/
					if (!Mover(tabuleiro, &tetrominoFlutuante, 0))
					{
						canHold = true; // O jogador poderar usar o hold novamente
						hold = false;	// Evita que a peça seja imediatamente trocada no resurgimento
						pecaFlutuanteExiste = false;
					}
					cooldownGravidade = 0;
				}
				else
				{
					cooldownGravidade++;
				}
				// Movimento
				if (cooldownMovimento == COOLDOWN_INPUT)
				{
					accel_x = get_calibrated_accel_x(); // Receber inclinação da plana
					printf("%d\n", accel_x);
					if (accel_x < -INPUT_INCLINACAO)
					{
						// Movimento para a esquerda
						Mover(tabuleiro, &tetrominoFlutuante, -1);
						cooldownMovimento = 0;
					}
					else if (accel_x > INPUT_INCLINACAO)
					{
						// Movimento para a direita
						Mover(tabuleiro, &tetrominoFlutuante, 1);
						cooldownMovimento = 0;
					}
				}
				else
				{
					cooldownMovimento++;
				}
			}
			// Se a peça flutuante não existir(foi congelada no frame anterior)
			else
			{
				// Verificar se há linhas cheias e limpar-las
				VerificaLinhaCheia(tabuleiro, linhasCheias);
				LimpaLinhas(tabuleiro, linhasCheias, &score);

				// atualizar preview
				limpaTela(15, 0, 20, 20);
				// Gerar novo tetromino flutuante
				GerarTetromino(&tetrominoFlutuante, tetrominoPreview);

				// Verifica se há colisão no resurgimento do tetromino
				if (TestarColisao(tabuleiro, &tetrominoFlutuante, SPAWN_BLOCK_X, SPAWN_BLOCK_Y))
				{
					// caso sim, o jogo encerra
					gameOver = true;
				}
				else
				{
					pecaFlutuanteExiste = true;
				}
			}

			/* Modifica as variáveis passadas como parametros baseado no estado dos
			periféricos*/
			ReceberInput(&hold, &flip, &sentido, &pause);

			// Rotação em 180 graus
			if (flip)
			{
				RotacaoTetromino(tabuleiro, &tetrominoFlutuante, 1);
				RotacaoTetromino(tabuleiro, &tetrominoFlutuante, 1);
				flip = false;
			}

			// Guardar peça
			if (hold && canHold && pecaFlutuanteExiste)
			{
				Hold(&tetrominoFlutuante, &tetrominoHold, &canHold, tetrominoPreview);
				hold = false;
			}

			// // Gira a peça dependendo do valor de " sentido "
			RotacaoTetromino(tabuleiro, &tetrominoFlutuante, sentido);

			ImprimirTela(tabuleiro, &tetrominoFlutuante, &tetrominoHold, tetrominoPreview, score);
		}

		// Gameover
		limpaTela(0,0,20,15);
		inputKEY = read_keys();

		/* O reset deve está desligado e o jogador deve pressionar hold
		para reiniciar o jogo*/
		int index = 0;
		int listaMatriz[2] = {GameOverMatriz1, GameOverMatriz2};
		while (inputKEY == 0)
		{
			ImprimirtTextMatrix(listaMatriz[index], indexCor);
			Delay(0.3);
			if (indexCor < 9)
			{
				indexCor++;
			}
			else
			{
				indexCor = 1;
			}
			inputKEY = read_keys();
			//Delay(1 / 10);

			if(index == 0)
			{
				index = 1;
			}
			else
			{
				index = 0;
			}
			limpaTela(0,0,20,15);

		}

		Resetar(tabuleiro, &pecaFlutuanteExiste, tetrominoPreview);
		score = 0;

		gameOver = false;
	}

	close_and_unmap(fd);
	return 0;
}

void ReceberInput(bool *hold, bool *flip, int *sentido, bool *pause)
{
	int input;

	input = read_keys();

	*sentido = 0;

	if (input == 4)
	{
		*hold = true;
	}
	else if (input == 8)
	{
		Pause();
	}
	else if (input == 2)
	{
		*sentido = -1;
	}
	else if (input == 1)
	{
		*sentido = 1;
	}
}

/* O jogador pode escolher guardar a peça flutuante atual, o jogador só poderá usar
esse mecânica novamente após posicionar a peça atual*/
void Hold(Tetromino *tetromino, Tetromino *hold, bool *canHold, Tetromino tetrominoPreview[TAMANHO_PREVIEW])
{
	if (*canHold)
	{
		limpaTetromino(tetromino, tetromino->x, tetromino->y);
		limpaTela(0, 0, 5, 5);
		// Variável auxiliar
		Tetromino temp = *tetromino;
		// verifica se o hold está vazio
		if (hold->formato[0][0] == -1)
		{
			// hold vazio: gera novo tetromino
			GerarTetromino(tetromino, tetrominoPreview);
			limpaTela(15, 0, 20, 20);
		}
		else
		{
			limpaTetromino(tetromino, tetromino->x, tetromino->y);
			// coloca o tetromino no hold como tetromino flutuante
			memcpy(tetromino, hold, sizeof(*tetromino));
		}

		// coloca o tetromino flutuante no hold
		memcpy(hold, &temp, sizeof(*tetromino));


		// reseta coordenadas do tetromino no hold
		hold->x = SPAWN_BLOCK_X;
		hold->y = SPAWN_BLOCK_Y;

		*canHold = false;
	}
}

/*Gerar novo tetromino flutuante*/
void GerarTetromino(Tetromino *tetromino, Tetromino tetrominoPreview[TAMANHO_PREVIEW])
{
	int i;
	int indexAleatorio;

	// Tetromino flutuante = tetromino na primeira posição do preview
	memcpy(tetromino, &(tetrominoPreview[0]), sizeof(*tetromino));

	// mudar posições dos tetrominos no preview em uma posição
	for (i = 0; i < TAMANHO_PREVIEW - 1; i++)
	{
		memcpy(&(tetrominoPreview[i]), &(tetrominoPreview[i + 1]), sizeof(*tetromino));
	}

	// gerar tetromino aleatório na ultima posição do preview
	indexAleatorio = rand() % QUANTIDADE_TETROMINOS;
	memcpy(&(tetrominoPreview[TAMANHO_PREVIEW - 1]), LISTA_PONTEIROS_TETROMINOS[indexAleatorio], sizeof(*tetromino));
}

// preencher preview com tetrominos aleatórios
void PreencherPreview(Tetromino tetrominoPreview[TAMANHO_PREVIEW])
{
	int i;
	int indexAleatorio;
	for (i = 0; i < TAMANHO_PREVIEW; i++)
	{
		indexAleatorio = rand() % QUANTIDADE_TETROMINOS;
		memcpy(&(tetrominoPreview[i]), LISTA_PONTEIROS_TETROMINOS[indexAleatorio], sizeof(tetrominoPreview[0]));
	}
}

// Resetar jogo
void Resetar(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO],
			 bool *pecaFlutuanteExiste, Tetromino tetrominoPreview[TAMANHO_PREVIEW])
{
	IniciarTabuleiro(tabuleiro);
	limpaTela(0, 0, 20, 15);
	*pecaFlutuanteExiste = false;
	PreencherPreview(tetrominoPreview);
}

// pausar jogo
void Pause()
{
	int indexCor = 1;
	limpaTela(0,0,20,15);
	while (1)
	{
		ImprimirtTextMatrix(PauseMatriz, indexCor);
		Delay(0.3);
		if (indexCor < 9)
		{
			indexCor++;
		}
		else
		{
			indexCor = 1;
		}
		
		if(read_keys() == 8)
		{
			break;
		}

	}
	Delay(0.3);
	limpaTela(0,0,20,15);
}

/*
Inicia o tabuleiro, gerando o chão e as paredes do tabuleiro do jogo.
Ex:
1 0 0 0 1
1 0 0 0 1
1 0 0 0 1
1 1 1 1 1
uma tabuleiro composto de 0s e 1s
1 : significa uma parede
0 : espaço livre
*/
void IniciarTabuleiro(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO])
{
	int i;
	int j;

	for (i = 0; i < LINHAS_TABULEIRO; i++)
	{
		for (j = 0; j < COLUNAS_TABULEIRO; j++)
		{
			if (j == 0 || j == COLUNAS_TABULEIRO - 1 || i == LINHAS_TABULEIRO - 1)
			{
				tabuleiro[i][j] = 1;
			}
			else
			{
				tabuleiro[i][j] = 0;
			}
		}
	}
}

/*
Função para mover a peça para a esquerda, direita ou para baixo
Parametros:
int direcao : -1 = esquerda , 0 = baixo ou 1 = direita
int tabuleiro : tabuleiro do jogo
Tetromino *tetromino : tetromino flutuante
*/
bool Mover(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], Tetromino *tetromino, int direcao)
{
	// Para baixo
	if (direcao == 0)
	{
		if (TestarColisao(tabuleiro, tetromino, tetromino->x, tetromino->y + 1))
		{
			// Há colisão e o movimento não foi realizado
			// Congelar o tetromino
			CongelarTetromino(tabuleiro, tetromino);
			return false;
		}
		else
		{
			;
			// Não há colisão, movimento realizado
			limpaTetromino(tetromino, tetromino->x, tetromino->y);
			tetromino->y = tetromino->y + 1;
			return true;
		}
	}
	// Para os lados
	else
	{
		if (TestarColisao(tabuleiro, tetromino, tetromino->x + direcao, tetromino->y))
		{
			// Há colisão e o movimento não foi realizado
			return false;
		}
		else
		{
			// Não há colisão, movimento realizado
			limpaTetromino(tetromino, tetromino->x, tetromino->y);
			tetromino->x = tetromino->x + direcao;
			return true;
		}
	}
}

/*
Sentido horario : sentido = 1
Sentido anti-horario : sentido = -1
*/
void RotacaoTetromino(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], Tetromino *tetromino, int sentido)
{
    static bool buttonPressed = false; // Estado do botão pressionado
    static int lastButtonState = 0; // Último estado do botão
    int currentButtonState = read_keys(); // Lê o estado atual do botão

    // Lógica de debounce para rotação
    if (currentButtonState != lastButtonState)
    {
        // O botão foi pressionado ou liberado
        if (currentButtonState != 0
		 && !buttonPressed) // Supondo que 1 indica que o botão está pressionado
        {
            // Apenas realiza a rotação se o botão foi pressionado
            if (sentido != 0)
            {
                int i;
                int j;

                // Variáveis auxiliares
                int matrizTemp[BLOCOS_POR_PECA][BLOCOS_POR_PECA];
                int posXTemp = tetromino->x;

                // Guardar formato atual do tetromino
                memcpy(&matrizTemp, tetromino->formato, sizeof(tetromino->formato));
				limpaTetromino(tetromino, tetromino->x, tetromino->y);
                // Rotacionar tetromino
                for (i = 0; i < BLOCOS_POR_PECA; i++)
                {
                    for (j = 0; j < BLOCOS_POR_PECA; j++)
                    {
                        if (sentido == 1)
                        {
                            // rotacionar matriz no sentido horário
                            tetromino->formato[j][BLOCOS_POR_PECA - i - 1] = matrizTemp[i][j];
                        }
                        else if (sentido == -1)
                        {
                            // rotacionar matriz no sentido anti-horário
                            tetromino->formato[BLOCOS_POR_PECA - j - 1][i] = matrizTemp[i][j];
                        }
                    }
                }

                // Testar colisão com matriz rotacionada
                i = 0;
                while (TestarColisao(tabuleiro, tetromino, tetromino->x, tetromino->y))
                {
                    // Há colisão
                    if (tetromino->x > COLUNAS_TABULEIRO / 2)
                    {
                        // Mover tetromino para esquerda se ele estiver no lado direito do tabuleiro
                        tetromino->x--;
                    }
                    else
                    {
                        // Mover para o outro lado
                        tetromino->x++;
                    }

                    // Tentar mover o tetromino apenas duas vezes
                    if (i == 2)
                    {
                        // Rotação falhou, desfaz as alterações
                        tetromino->x = posXTemp;
                        memcpy(tetromino->formato, &matrizTemp, sizeof(tetromino->formato));
                        break;
                    }
                    i++;
                }
            }

            buttonPressed = true; // Marca que o botão foi pressionado
        }
        else if (currentButtonState == 0)
        {
            buttonPressed = false; // Marca que o botão foi liberado
        }
    }

    lastButtonState = currentButtonState; // Atualiza o último estado do botão
}


/*O tetromino flutuante só é escrito na matriz do tabuleiro
quando é congelado*/
void CongelarTetromino(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], Tetromino *tetromino)
{
	int i;
	int j;

	for (i = 0; i < BLOCOS_POR_PECA; i++)
	{
		for (j = 0; j < BLOCOS_POR_PECA; j++)
		{
			if (tetromino->formato[i][j] == 1)
			{
				/* De acordo com o formato do tetromino e sua posição relativa ao
				tabuleiro o tetromino é escrito no tabuleiro com o inteiro que representa
				sua cor*/
				tabuleiro[tetromino->y + i][tetromino->x + j] = tetromino->cor;
			}
		}
	}
}

/*
Baseando se na matriz do formato do tetromino e sua posição, essa função busca
no tabuleiro se há alguma parede na mesma posição, caso o
tetromino se movesse para as coordenadas x e y.
Parametros:
int tabuleiroColisao[][] : tabuleiro de colisao a ser consultado
Tetromino *tetromino : ponteiro apontando para o tetromino a ser movido
int x e int y : coordenadas da possível nova posição
*/
bool TestarColisao(int tabuleiroColisao[LINHAS_TABULEIRO][COLUNAS_TABULEIRO],
				   Tetromino *tetromino, int x, int y)
{
	int i;
	int j;

	for (i = 0; i < BLOCOS_POR_PECA; i++)
	{
		for (j = 0; j < BLOCOS_POR_PECA; j++)
		{
			// valores maiores que 0 no tabuleiro significam colisão
			if (tabuleiroColisao[y + i][x + j] > 0 && tetromino->formato[i][j] == 1)
			{
				return true;
			}
		}
	}
	// não há colisão
	return false;
}

/*Verifica se há uma linha horizontal completa, sem qualquer descontinuidade.
Parâmetros:
	- tabuleiroColisão: tabuleiro do jogo
	- linhasCheias: lista para que a função retorne os
	indices das linhas completas no tabuleiro*/
void VerificaLinhaCheia(int tabuleiroColisao[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], int linhasCheias[BLOCOS_POR_PECA])
{
	int i;
	int j;
	bool cheia;

	// limpar lista de linhas a serem limpadas
	for (i = 0; i < BLOCOS_POR_PECA; i++)
	{
		linhasCheias[i] = -1;
	}

	int indexLinhasCheias = 0;

	// buscar no tabuleiro por linhas cheias
	i = 0;
	for (i = 0; i < LINHAS_TABULEIRO - 1; i++)
	{
		// valor padrão
		cheia = true;

		for (j = 1; j < COLUNAS_TABULEIRO - 1; j++)
		{
			if (tabuleiroColisao[i][j] == 0)
			{
				// caso encontre um buraco
				cheia = false;
				break;
			}
		}
		if (cheia)
		{
			linhasCheias[indexLinhasCheias] = i;
			indexLinhasCheias++;
		}

		// máximo de linhas cheias possíveis
		if (indexLinhasCheias == BLOCOS_POR_PECA)
		{
			break;
		}
	}
}

// limpa a linha do tabuleiro ao completar
void LimpaLinhas(int tabuleiroColisao[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], int linhas[BLOCOS_POR_PECA], int *score)
{
	int i;
	int j;
	int k;

	// percorre todas as linhas da lista de linhas para tirar
	for (k = 0; k < BLOCOS_POR_PECA; k++)
	{
		// verifica se a linha é valida
		if (linhas[k] >= 0)
		{
			// percorre o tabuleiro de baixo pra cima, a partir da linha a ser excluida
			for (i = linhas[k]; i > 0; i--)
			{
				for (j = 0; j < COLUNAS_TABULEIRO; j++)
				{
					// copia os elementos da linha de cima para a linha de baixo
					tabuleiroColisao[i][j] = tabuleiroColisao[i - 1][j];
				}
			}
			j = 0;
			// define as bordas laterais do  tabuleiro e a primeira linha
			for (j = 1; j < COLUNAS_TABULEIRO - 1; j++)
			{
				tabuleiroColisao[0][j] = 0;
			}
			tabuleiroColisao[0][0] = 1;
			tabuleiroColisao[0][COLUNAS_TABULEIRO] = 1;
			*score += 100 * (k + 1);
			limpaTela(6, 0, 14, 14);
			limpaTela(0, 10, 5, 15);
		}
	}
}

/*Mostra o tabuleiro na tela. Utilizando a biblioteca de video*/
void ImprimirTabuleiro(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO])
{
	int i;
	int j;

	for (i = 0; i < LINHAS_TABULEIRO; i++)
	{
		for (j = 0; j < COLUNAS_TABULEIRO; j++)
		{
			if (tabuleiro[i][j] > 0)
			{
				tetrisBlock((i), (j + 5), LISTA_CORES[tabuleiro[i][j]]->R, LISTA_CORES[tabuleiro[i][j]]->G, LISTA_CORES[tabuleiro[i][j]]->B);
			}
		}
	}
}

/*Imprime um tetromino na tela nas coordenadas x e y*/
void ImprimirTetromino(Tetromino *tetromino, int x, int y)
{
	int i;
	int j;

	for (i = 0; i < BLOCOS_POR_PECA; i++)
	{
		for (j = 0; j < BLOCOS_POR_PECA; j++)
		{
			if (tetromino->formato[i][j])
			{
				tetrisBlock(((y + i)), ((5 + x + j)),
							LISTA_CORES[tetromino->cor]->R,
							LISTA_CORES[tetromino->cor]->G,
							LISTA_CORES[tetromino->cor]->B);
			}
		}
	}
}
/*Imprime uma matriz com um texto na tela*/
void ImprimirtTextMatrix(int matriz[15][20], int indexCor)
{
	int i;
	int j;
	for (i = 0; i < 15; i++)
	{
		for (j = 0; j < 20; j++)
		{
			if (matriz[i][j] != 0)
			{
				tetrisBlock((i), (j), LISTA_CORES[indexCor]->R, LISTA_CORES[indexCor]->G, LISTA_CORES[indexCor]->B);
			}
		}
	}
}

/*Imprimir tela de jogo completa*/
void ImprimirTela(int tabuleiro[LINHAS_TABULEIRO][COLUNAS_TABULEIRO], Tetromino *tetrominoFlutuante,
				  Tetromino *tetrominoHold, Tetromino tetrominoPreview[TAMANHO_PREVIEW], int score)
{
	ImprimirTabuleiro(tabuleiro);
	ImprimirTetromino(tetrominoFlutuante, tetrominoFlutuante->x, tetrominoFlutuante->y);
	ImprimirTetromino(tetrominoHold, -5, 0);


	int i;
	for (i = 0; i < TAMANHO_PREVIEW; i++)
	{
		ImprimirTetromino(&(tetrominoPreview[i]), 11, i * 4);
	}
	ImprimirMiniTextMatrix(20, scoreText, -1,45, LISTA_CORES[1]->R ,LISTA_CORES[1]->R,LISTA_CORES[1]->R);
	printScore(score, 52, -1, LISTA_CORES[1]->R ,LISTA_CORES[1]->R,LISTA_CORES[1]->R);
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

void printScore(int score, int line, int startColumn, int R, int G, int B) {
    int columnOffset = 0;
    int digito;
	int i;
    // Para garantir que estamos tratando cinco dígitos, incluindo zeros à esquerda
    for (i = 4; i >= 0; i--) {
        // Extrai cada dígito diretamente
        if (i == 4) {
            digito = score / 10000; // Dezena de milhar
        } else if (i == 3) {
            digito = (score / 1000) % 10; // Milhar
        } else if (i == 2) {
            digito = (score / 100) % 10; // Centena
        } else if (i == 1) {
            digito = (score / 10) % 10; // Dezena
        } else {
            digito = score % 10; // Unidade
        }

        // Imprime o dígito na matriz correspondente
        ImprimirMiniTextMatrix(5, matrizesNumeros[digito], startColumn + columnOffset, line, R, G, B);
        
        columnOffset += 4; // Move para a próxima coluna
    }
}

/*Imprime uma matriz com blocos pequenos na tela*/
void ImprimirMiniTextMatrix(int cont, int matriz[5][cont], int column,int line,int R, int G, int B)
{
	int i;
	int j;
	for (i = 0; i < 5; i++)
	{
		for (j = 0; j < cont; j++)
		{
			if (matriz[i][j] != 0)
			{
				set_background_block((line) + i, (column) + j, R, G, B); 
			}
		}
	}
}

// função para gerar Delay, parametro é dado em segundos
void Delay(float segundos)
{
	// converter segundos para microsegundos
	int microSegundos = 1000000 * segundos;

	// tempo inicial
	clock_t start_time = clock();

	// loop até o Delay necessário
	while (clock() < start_time + microSegundos);
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

/*Apaga a peca da tela, de acordo com sua posição atual*/
void limpaTetromino(Tetromino *tetromino, int x, int y)
{
	int i;
	int j;

	for (i = 0; i < BLOCOS_POR_PECA; i++)
	{
		for (j = 0; j < BLOCOS_POR_PECA; j++)
		{
			if (tetromino->formato[i][j])
			{
				while (1)
				{
					if (*((full + 0xb0 / sizeof(int))) == 0)
					{
						tetrisBlock(((y + i)), ((5 + x + j)), 6, 7, 7);
						break;
					}
				}
			}
		}
	}
}
