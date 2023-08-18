.global _boot
.text


_boot:  
    addi x1,x1,8
    addi x2,x2,9
    bne x1,x2, _boot