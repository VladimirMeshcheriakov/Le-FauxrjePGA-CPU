.text
    .global fact
fact:
    addi x4,x4,8 # factorial
    addi x5,x5,1
    addi x6,x6,1
main_loop:
    xor x1,x1,x1
    xor x2,x2,x2
    addi x1,x4,0
    addi x4,x4,-1
    addi x2,x5,0
mul: 
    xor x3,x3,x3        # Initialize x3 to store the result
mul_loop:
    beq x2,x0, end_mul   # Exit loop if num2 becomes zero
    add x3, x3, x1      # Add num1 to the result
    addi x2, x2, -1     # Decrement num2
    beq x0,x0, mul_loop
end_mul:
    addi x5,x3, 0
    bne x4,x6,main_loop
end_main_loop: