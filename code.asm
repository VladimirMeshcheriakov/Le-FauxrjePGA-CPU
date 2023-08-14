.global _boot
.text


_boot:  
    addi x1, x1, 868
    addi x2, x2, 20     
    sw x1, 0(x2)        
    addi x1, x1, -860
    addi x2, x2, 1     
    sw x1, 0(x2)        
    addi x1, x1, -5
    addi x2, x2, 1
    sw x1, 0(x2)         
	addi x1,x1, 46      
    add x3,x3,x1
    addi x3,x3, 9       
   	addi x2,x2, -22     
loop:               
    sw	x1, 0(x2)
    addi x1, x1, 1
    addi x2,x2,1      
    bne x1,x3,loop
    addi x4,x4, 23
    xor x2,x2,x2
    addi x2,x2, 24 
    addi x8,x8, 57
send_str:
send_char:
    lw  x5, 0(x2)
    andi    x5, x5, 1
    beq x0, x5, send_char
    lw x7, 0(x6)
    sw x7, 0(x4)
    addi x6,x6,1
    bne  x8, x7, send_str