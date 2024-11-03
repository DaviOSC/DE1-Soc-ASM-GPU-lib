# ASM-GPU-lib | Sistemas Digitais (TP01) 

<p align="center">
  <img src="imagens/top45_01.jpg" width = "600" />
</p>
<p align="center"><strong>Kit de desenvolvimento DE1-SoC</strong></p>


<h2>  Componentes da Equipe: <br></h2>
<uL> 
  <li><a href="https://github.com/Silva-Alisson">Alisson Silva</a></li>
  <li><a href="https://github.com/DaviOSC">Davi Oliveira</a></li>
  <li><a href="https://github.com/MrLaelapz">Kauã Quintella</a></li>
  <li><a href="https://github.com/Viktor-401">Sinval Victor</a></li>
</ul>

<div align="justify"> 

## Introdução

Este relatório técnico apresenta o desenvolvimento de uma biblioteca em Assembly para uma GPU do VGA na plataforma de desenvolvimento DE1-SoC com arquitetura ARMv7A. Esta biblioteca será ultilizada para rodar o jogo feito no problema anterior, junto com a implementação da uma biblioteca para o acelerômetro. E para isso, foi necessário a aplicação prática dos conceitos de programação em C e Assembly. Ao decorrer da leitura, é descrito a implementação e os recursos usados para a criação da biblioteca, incluindo a explicação dos métodos.

## Fundamentação Teórica

### Kit de desenvolvimento DE1-SoC

A placa que foi usada para executar o jogo possue uma arquitetura baseada na *Altera System-on-Chip* (SoC) FPGA, que combina um Cortex-A9 dual core com cores embarcados com lógica programável. Nela vem integrado o *HPS* (*Hard Processor System*) baseado em ARM, consistindo no processador, periféricos como o acelerômetro (ADLX456) ultilizado e a interface de memória. O sistema do Hard Processor vem ligado perfeitamente à estrutura da FPGA usando um backbone interconectado de alta-bandalarga. (DE1-SoC Manual, 2019)

Ademais, o DE1-SoC possui as seguintes especificações gerais, de acordo com o FPGA Academy:

- Main Features:
    - Intel® Cyclone V SoC FPGA
        - 85k logic-element FPGA
        - ARM Cortex A9 MPCORE
    - 1 GB DDR, 64 MB SDRAM
    - Micro SD Card


- Basic IO:
    - 10 slide switches, 4 pushbuttons
    - 10 LEDs, six 7-segment displays

- IO Devices:
    - Audio in/out
    - VGA Video out, S-Video in
    - Ethernet, USB, Accelerometer
    - A/D converter, PS/2

<p align="center">
  <img src="imagens/kitDesenvolvimentoTopView.png" width = "800" />
</p>
<p align="center"><strong>Layout e componentes do DE1-SoC</strong></p>


### G-Sensor ADXL345

Esse sensor é um acelerômetro de 3 eixos, que realiza medições de alta resolução. A saída digitalizada é formatada em 16 bits com complemento de dois e pode ser acessada via interface I2C e seu endereço é 0x53.

Para a comunicação com o acelerômetro, informações obtidas no datasheet do ADXL345 e nas aulas de Arquitetura de Computadores foram de extrema importância. 

### Protocolo I2C

O I2C (*Inter-Integrated Circuit*), é um protocolo de comunicação serial síncrono, bastante utilizado na interação entre dispositivos periféricos e processadores ou microcontroladores. A comunicação ocorre utilizando dois fios: o SDA, que transporta os dados, e o SCL, responsável pelo sinal de clock que sincroniza a troca de informações. Quando aplicamos isso no G-Sensor, ele opera como um dispositivo *slave* dentro do barramento, enquanto o processador atua como *master*, controlando toda a comunicação e o envio de comandos.

Cada dispositivo conectado ao barramento I2C possui um endereço de 7 bits, o que facilita a identificação. A interação acontece quando o processador, na função de master, envia o endereço do acelerômetro e, a partir daí, realiza operações de leitura ou escrita nos registradores internos, permitindo, por exemplo, a configuração de parâmetros ou a coleta de dados do sensor.

### Linguagem C para o Tetris e biblioteca do acelerômetro

O jogo foi elaborado em lingagem C por ser um requisito do problema, sendo usado o GCC para a compilação. A IDE ultilizada foi o Visual Studio Code.

### Linguagem Assembly para arquitetura ARMv7A

Para acessar a placa gráfica e usar as suas funcionalidades, foi usada a linguagem Assembly para a arquitetura da placa.

##### De acordo com o _ARM Architecture Reference Manual_:

O conjunto de instruções ARM é um conjunto de instruções de 32 bits que fornece funções abrangentes de processamento de dados e controle. 

O conjunto de instruções Thumb foi desenvolvido como um conjunto de instruções de 16 bits, com um subconjunto das funcionalidades do conjunto de instruções ARM. Ele oferece uma densidade de código significativamente melhorada, ao custo de uma pequena redução no desempenho. Um processador que executa instruções Thumb pode alternar para a execução de instruções ARM em segmentos críticos para o desempenho, especialmente para lidar com interrupções.

Perfil de Aplicação ARMv7-A:

- Implementa uma arquitetura ARM tradicional com múltiplos modos.
- Suporta uma Arquitetura de Sistema de Memória Virtual (VMSA) baseada em uma Unidade de Gerenciamento de Memória (MMU). Uma implementação ARMv7-A pode ser chamada de implementação VMSAv7.
- Suporta os conjuntos de instruções ARM e Thumb.

##### Instruções usadas para a biblioteca:

1. **`.section`, `.align`, `.ascii`, `.word`, `.zero`**: São diretivas de montagem, não instruções de máquina. Elas especificam detalhes sobre como organizar os dados e onde colocá-los na memória.
   - `.section`: Define uma nova seção no código (por exemplo, `.rodata`, `.data`, `.text`).
   - `.align`: Alinha os dados a um limite específico de bytes.
   - `.ascii`: Insere uma string ASCII.
   - `.word`: Define uma palavra de 32 bits.
   - `.zero`: Reserva espaço e inicializa com zero.

2. **`push` e `pop`**: Gerenciam a pilha. 
   - `push {rX, lr}`: Salva os registradores na pilha, incluindo o registrador de retorno (`lr`).
   - `pop {rX, lr}`: Recupera os valores salvos da pilha.

3. **`ldr`**: Carrega um valor na memória para um registrador.
   - `ldr r0, =pathDevMem`: Carrega o endereço de `pathDevMem` para `r0`.
   - `ldr r3, [r3, #offset]`: Carrega o valor de um endereço baseado em `r3` e um deslocamento (`offset`), útil para acessar dados mapeados.

4. **`str`**: Armazena o valor de um registrador em uma posição da memória.
   - `str r0, [r3]`: Armazena o valor de `r0` no endereço especificado por `r3`.

5. **`mov`, `movw`, `movt`**: Movem valores para registradores.
   - `mov r7, #5`: Define `r7` com o valor 5 (utilizado para identificar syscalls).
   - `movw` e `movt`: São usadas em conjunto para carregar valores de 32 bits em registradores (parte baixa e parte alta).

6. **`svc` e `swi`**: Executam chamadas ao sistema (syscalls).
   - `svc #0`: Invoca uma syscall, com o número da chamada e os parâmetros configurados em registradores.

7. **`cmp` e `bne`/`beq`**: Comparam registradores e desviam condicionalmente.
   - `cmp r0, #0`: Compara `r0` com zero.
   - `bne` e `beq`: Desviam se os valores são diferentes (bne) ou iguais (beq).

8. **`add`, `sub`**: Realizam operações de adição e subtração entre registradores.
   - `add r0, r0, r1`: Soma `r1` a `r0` e armazena o resultado em `r0`.

9. **`mul`**: Multiplicação.
   - `mul r0, r1, r2`: Multiplica `r1` e `r2`, armazenando o resultado em `r0`.

10. **`lsl` e `lsr`**: Realizam deslocamentos lógicos (bit shifts).
    - `lsl r2, r2, #6`: Desloca `r2` à esquerda por 6 bits.
    - `lsr r3, r3, #3`: Desloca `r3` à direita por 3 bits.

11. **`orr` e `and`**: Realizam operações de OR e AND bit-a-bit.
    - `orr r1, r1, r2`: Faz OR entre `r1` e `r2`.
    - `and r4, r5, #0b111000`: Faz AND entre `r5` e `0b111000`, mascarando os bits desejados.

12. **`bx lr`**: Retorna de uma função, usando o registrador de link (`lr`). 

Cada instrução desempenha um papel importante, desde configurar chamadas ao sistema para manipulação de memória até operações específicas de bits, necessários para o controle de hardware ou configuração de cores no sistema.

### Arquitetura Baseada em Sprites para criação de Jogos 2D

<p align="center">
  <img src="imagens/arquiteturaVGA.png" width = "800" />
</p>
<p align="center"><strong>Representação da Arquitetura.</strong></p>

A arquitetura desenvolvida para o projeto é baseada em sprites e voltada para criação de jogos 2D em FPGAs, aproveitando o padrão VGA para exibir gráficos. A estrutura é composta por um processador principal (Nios II) para executar a lógica do jogo em C, e um processador gráfico responsável pela renderização dos sprites e elementos visuais. O sistema inclui memórias dedicadas para armazenamento dos sprites e do background, permitindo atualização rápida e eficiente dos gráficos. Um co-processador em estrutura pipeline auxilia na criação de polígonos (como quadrados e triângulos) e na análise de colisão entre elementos da tela, operando de forma paralela e em tempo real. Essa arquitetura modular permite que jogos sejam desenvolvidos e controlados por meio de uma API, abstraindo detalhes de baixo nível e facilitando a interação com os elementos gráficos.

### Monitor VGA

O monitor empregado no projeto foi o DELL M782p, um modelo CRT que utiliza um tubo de raios catódicos para gerar imagens. Com uma tela de 17 polegadas e resolução máxima de 1280x1024 pixels, ele possui uma interface VGA para conexão com o computador ou uma placa de desenvolvimento. Monitores CRT são conhecidos por sua reprodução de cores intensas e rápida resposta, sendo uma escolha apropriada para projetos que necessitam de interação em tempo real, como jogos e simulações.

## Descrição de alto nível

### Funções da <a href="https://github.com/DaviOSC/DE1-Soc-ASM-GPU-lib/blob/main/Tetris%202.0/gpu_lib.s">gpu_lib.s</a>

#### `create_mapping_memory() : int`
- **Propósito**: Mapeia a memória do dispositivo `/dev/mem` para acesso direto.
- **Implementação**:
  - Abre o dispositivo com a syscall `open` e obtém o file descriptor.
  - A função `mmap2` é chamada para mapear a memória no espaço de endereçamento do processo, com o resultado armazenado no ponteiro `pDevMem`.
  - Os parâmetros `PROT_READ` e `PROT_WRITE` são usados para configurar permissões de leitura e escrita na memória mapeada.
- **Assembly**: Registros como `r0` e `r1` carregam parâmetros da syscall; o resultado da `mmap2` é salvo em `pDevMem`.

#### `close_mapping_memory() : void`
- **Propósito**: Desfaz o mapeamento de memória e fecha o file descriptor.
- **Implementação**:
  - Chama `munmap` para liberar o mapeamento, passando `pDevMem` e o tamanho da memória mapeada.
  - Em seguida, usa `close` para encerrar o file descriptor.
- **Assembly**: Registros `r0` e `r1` carregam o endereço e o tamanho para `munmap`; `r0` armazena o fd antes de chamar `close`.

#### `send_instruction(unsigned int dataA, unsigned int dataB) : void`
- **Propósito**: Envia instruções compostas para um periférico.
- **Implementação**:
  - Primeiro, verifica o estado do periférico ao ler um endereço específico em `pDevMem`.
  - Em seguida, armazena `dataA` e `dataB` nos registros correspondentes para iniciar a operação.
- **Assembly**: `ldr` carrega dados de `pDevMem`; `mov` e `str` configuram `dataA` e `dataB`.

#### `set_background_color(unsigned long vermelho, unsigned long verde, unsigned long azul) : void`
- **Propósito**: Define a cor de fundo combinando valores RGB.
- **Implementação**:
  - Calcula `dataB` com deslocamentos e combinações lógicas para integrar os valores RGB.
  - `dataA` é definido como `0`, e `send_instruction` é chamado para enviar a instrução.
- **Assembly**: Usa `lsl` para deslocar bits e `orr` para combinar os valores RGB em `dataB`.

#### `set_background_block(unsigned long linha, unsigned long coluna, unsigned long vermelho, unsigned long verde, unsigned long azul) : void`
- **Propósito**: Define a cor de um bloco de fundo em uma posição específica.
- **Implementação**:
  - Calcula o endereço com base em `linha` e `coluna`, e combina os valores RGB em `dataB`.
  - Envia `dataA` e `dataB` via `send_instruction`.
- **Assembly**: Usa instruções `mul` para calcular a posição e `orr` para combinar valores RGB.

#### `background_box(unsigned long x, unsigned long y, unsigned long largura, unsigned long altura, unsigned long cor) : void`
- **Propósito**: Desenha um retângulo colorido no fundo.
- **Implementação**:
  - Utiliza laços para preencher o retângulo, calculando os limites usando `x`, `y`, `largura` e `altura`.
  - `dataA` e `dataB` são configurados para cada posição do bloco no retângulo.
- **Assembly**: Laços `loop` para `x` e `y`; `mov` e `str` atualizam a posição e cor para cada pixel.

#### `set_sprite_memory(unsigned long sprite_slot, unsigned long cor, unsigned long x, unsigned long y) : void`
- **Propósito**: Configura um pixel específico em um sprite.
- **Implementação**:
  - Calcula o endereço de memória do pixel com base em `sprite_slot`, `x`, e `y`.
  - Configura `dataA` e `dataB` com a posição e cor.
- **Assembly**: Instruções `mul` para cálculo de posição; `mov` e `orr` definem a cor.

#### `set_sprite(unsigned long id, unsigned long sprite_image, unsigned long ativado, unsigned long x, unsigned long y) : void`
- **Propósito**: Configura um sprite com posição e imagem.
- **Implementação**:
  - Define `dataA` com coordenadas e `dataB` com o identificador da imagem.
  - `send_instruction` aplica as configurações.
- **Assembly**: `mov` e `orr` para configurar posição e imagem.

#### `clear_sprite(unsigned long id) : void`
- **Propósito**: Desativa um sprite específico ou todos os sprites.
- **Implementação**:
  - Define `dataA` e `dataB` com valores apropriados para desativar o sprite ou todos.
- **Assembly**: Usa `cmp` para verificar se `id` é `-1`; caso positivo, limpa todos os sprites.

#### `set_polygon(unsigned long id, unsigned long cor, unsigned long forma, unsigned long tamanho, unsigned long x, unsigned long y) : void`
- **Propósito**: Configura um polígono com propriedades específicas.
- **Implementação**:
  - Usa `dataA` e `dataB` para representar forma, tamanho, posição e cor do polígono.
  - Envia a instrução para desenhar o polígono.
- **Assembly**: `mov` e `orr` para configurar as características do polígono.

#### `clear_polygon(unsigned long id) : void`
- **Propósito**: Desativa um polígono específico ou todos os polígonos.
- **Implementação**:
  - Configura `dataA` e `dataB` para desativar o polígono com o `id` dado.
- **Assembly**: `cmp` verifica se `id` é `-1` para desativar todos os polígonos.

#### `clear_background() : void`
- **Propósito**: Limpa o fundo aplicando uma cor transparente em toda a área.
- **Implementação**:
  - Configura um retângulo de fundo com altura e largura máximas.
  - Usa `background_box` para aplicar a cor transparente em toda a área.
- **Assembly**: Calcula a altura e largura máximas; chama `background_box`.

#### `clear_all() : void`
- **Propósito**: Executa uma limpeza completa da tela.
- **Implementação**:
  - Chama `clear_background`, `clear_all_sprite` e `clear_all_polygon`.
- **Assembly**: Invoca cada função de limpeza em sequência.

#### `read_keys() : int`
- **Propósito**: Lê o estado dos botões de entrada.
- **Implementação**:
  - Carrega o estado dos botões de `pDevMem`.
  - Usa `mvn` para inverter os bits e retornar o estado dos botões.
- **Assembly**: Usa `ldr` para carregar dados e `mvn` para inversão.


<div align="justify">

## Bibliografia

Using the Accelerometer on DE-Series Boards. Disponível em: https://github.com/fpgacademy/Tutorials/releases/download/v21.1/Accelerometer.pdf. Acessado em: 23 de setembro de 2024.

TERASIC. DE1-SoC User-Manual. Disponível em: https://drive.google.com/file/d/1HzYtd1LwzVC8eDobg0ZXE0eLhyUrIYYE/view. Acessado em: 26 de setembro de 2024.

FPGA Academy. Disponível em: https://fpgacademy.org/. Acessado em: 26 de setembro de 2024.

SOUZA, Fábio. Comunicação I2C. Postado em: 03 de janeiro de 2023. Disponível em: https://embarcados.com.br/comunicacao-i2c/. Acessado em: 26 de setembro de 2024.

PATTERSON, David A.; HENNESSY, John L. Computer Organization and Design: The Hardware Software Interface, ARM Edition. 2016. Morgan Kaufmann. ISBN: 978-0-12-801733-3.

FONTES:

https://developer.arm.com/documentation/ddi0406/latest/

###### Trello: 
- https://trello.com/b/MT18QH97/sd
###### GPT: 
- https://chatgpt.com/share/670ac12f-6718-8003-8857-b176f2d0ca2b
- https://chatgpt.com/share/670c39ec-804c-8003-942f-fa64f709721b
- https://chatgpt.com/share/670c3a0b-1edc-8003-b0ae-fc1e65823288
