.global _boot
.text

_boot:
	addi x1, x0, 12
	addi x5, x0, 24
	sltu x2, x1, x5
	addi x5, x0, -18
	sltu x3, x1, x5
	addi x5, x0, 12
	sltu x4, x1, 12
	addi x6, x0, -12
	sltu x7, x6, x5
