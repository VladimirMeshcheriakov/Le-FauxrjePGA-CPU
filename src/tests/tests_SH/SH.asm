.global _boot
.text

_boot:
	addi x1, x0, 0x12
    sh x1, 4(x0)
    sh x1, 6(x0)
    lw x2, 4(x0)