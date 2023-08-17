.global _boot
.text


_boot:  
    addi x1,x1,3
    sltiu x3,x1,4
    slti x4,x1,4
    addi x1,x1,-4
    sltiu x3,x1,4
    slti x4,x1,4
