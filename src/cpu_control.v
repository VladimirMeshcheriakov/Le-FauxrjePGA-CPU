`timescale 1ns / 1ps


module cpu_control(
    input [6:0] instruction,
    output auipcEn,
    output Branch,
    output MemRead,
    output MemtoReg,
    output [1:0] ALUOp,
    output MemWrite,
    output ALUSrc,
    output RegWrite
);

    assign auipcEn = 7'b0010111 == instruction[6:0]; 
    assign ALUSrc = !(instruction[4] && instruction[5] || instruction[6] && instruction[5]) || 7'b0110111 == instruction[6:0]; 
    assign MemtoReg = !instruction[4]; // Store, Load or branch
    assign RegWrite = !(3'b010 == instruction[6:4]); // in other words not a Store
    assign MemRead = 3'b000 == instruction[6:4];    // Certainly a load
    assign MemWrite = 3'b010 == instruction[6:4];   // Certainly a Store
    assign Branch = 3'b110 == instruction[6:4] || 7'b0010111 == instruction;     // JAL, JALR, Branches, or AUICP
    assign ALUOp[1] = (3'b011 == instruction[6:4]) || (7'b1101111 == instruction[6:0]) || (7'b0010111 == instruction[6:0]); // Arithmetic or JAL, or LUI?
    assign ALUOp[0] = 3'b110 == instruction[6:4] || 7'b0010111 == instruction[6:0]; // JAL, JALR, or Branches

endmodule
