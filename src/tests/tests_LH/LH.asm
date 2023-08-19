.global _boot
.text

_boot:
	addi x1, x0, -12
    sw x1, 4(x0)
    lh x2, 4(x0)
    lh x2, 6(x0)