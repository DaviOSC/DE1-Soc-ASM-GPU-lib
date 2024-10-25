void tetrisBlock(int column, int line, int R, int G, int B) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            set_background_block((column * 4) + j, (line * 4) + i, R, G, B);  // Pinta um bloco 4x4
        }
    }
}
int main() {
    tetrisBlock(5, 0, 255, 0, 0); //primeiro bloco

    tetrisBlock(5, 1, 0, 255, 0); // bloco embaixo do primeiro bloco

    tetrisBlock(6, 0, 0, 0, 255); // bloco do lado do primiero block
}