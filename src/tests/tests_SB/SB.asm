.global _boot
.text

_boot:
	addi x1, x0, 0x12
    sb x1, 5(x0)
    sb x1, 6(x0)
    lw x2, 4(x0)