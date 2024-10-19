	.global	pDevMem
	.type	pDevMem, %object
pDevMem:
	.space	4
    
	.global	pDataA
	.type	pDataA, %object
pDataA:
	.space	4

	.global	pDATAB
	.type	pDATAB, %object
pDATAB:
	.space	4

	.global	pWrReg
	.type	pWrReg, %object
pWrReg:
	.space	4

	.global	pWrFull
	.type	pWrFull, %object
pWrFull:
	.space	4

	.global	pScreen
	.type	pScreen, %object
pScreen:
	.space	4

	.global	pResetPulseCounter
	.type	pResetPulseCounter, %object
pResetPulseCounter:
	.space	4

	.global	fd
	.type	fd, %object
fd:
	.space	4