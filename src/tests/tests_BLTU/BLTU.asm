.global _boot
.text


_boot:  
    addi x1,x1,8
    addi x2,x2,7
    bltu x1,x2, _boot
    addi x2,x2,1
    bltu x1,x2, _boot
    addi x1,x1,-9
    bltu x1,x2, _boot
    addi x1,x1, 1
    bltu x1,x2, _boot