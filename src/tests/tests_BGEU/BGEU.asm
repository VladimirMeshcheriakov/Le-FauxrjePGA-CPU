.global _boot
.text


_boot:  
    addi x1,x1,7
    addi x2,x2,8
    bgeu x1,x2, _boot
    addi x1,x1,-8
    bgeu x1,x2, _boot