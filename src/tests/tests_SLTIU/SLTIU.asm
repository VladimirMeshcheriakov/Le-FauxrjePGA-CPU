.global _boot
.text

_boot:
	addi x1, x0, 12
	sltiu x2, x1, 24
	sltiu x3, x1, -18
	sltiu x4, x1, 12
