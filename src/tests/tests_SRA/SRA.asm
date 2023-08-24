.global _boot
.text

_boot:
	addi x1, x0, -8
	addi x2, x0, 2
	sra x3, x1, x2
