.global _boot
.text

_boot:
	addi x1, x0, 12
	addi x5, x0, 24
	slt x2, x1, x5
	addi x5, x0, -18
	slt x3, x1, x5
	addi x5, x0, 12
	slt x4, x1, 12
	addi x6, x0, -12
	slt x7, x6, x5
