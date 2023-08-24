.global _boot
.text

_boot:
	addi x1, x0, -12
    sh x1, 4(x0)
    lhu x2, 4(x0)
    lhu x2, 6(x0)