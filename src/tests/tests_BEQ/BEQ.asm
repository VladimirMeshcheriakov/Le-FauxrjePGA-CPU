.global _boot
.text


_boot:  
    addi x1,x1,8
    addi x2,x2,8
    beq x1,x2, _boot