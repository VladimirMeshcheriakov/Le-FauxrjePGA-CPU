.section .text
.globl main

main:
    lw x1, 10
    # Initialize factorial to 1
    li x2, 1
    sw x2, 0(x0)

    # Calculate factorial iteratively
    li x3, 1
    loop:
        lw x4, 0(x0)
        lw x5, 0(x0)
        add x4, x4, x5
        sw x4, 0(x0)    
        addi x3, x3, 1
        bne x3, x1, loop

    