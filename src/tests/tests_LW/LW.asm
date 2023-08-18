.global _boot
.text

_boot:
	addi x1, x0, 0x12
	sw x1, 0(x5)
	lw x2, 0(x5)
