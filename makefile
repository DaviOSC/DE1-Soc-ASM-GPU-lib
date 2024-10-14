make: GPUexec
	./GPUexec

GPUexec:libGPU.o main.o
	ld libGPU.o main.o -o GPUexec

libGPU.o: libGPU.s
	as libGPU.s -o libGPU.o

main.o: main.c
	gcc -C -o main.o main.c