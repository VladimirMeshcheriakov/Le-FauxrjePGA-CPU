.global _boot
.text

_boot:

	addi x1, x0, 12
	slti x2, x1, 24
	slti x3, x1, -18
	slti x4, x1, 12

