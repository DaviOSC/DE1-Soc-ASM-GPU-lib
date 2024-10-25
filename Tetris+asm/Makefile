#make all
all:
	as -o lib.o FpgaGpu.s
	gcc main.c -lintelfpgaup lib.o -o exec
	sudo ./exec

#make teste
teste:
	as -o lib.o FpgaGpu.s
	gcc teste.c lib.o -lintelfpgaup -o exec
	sudo ./exec