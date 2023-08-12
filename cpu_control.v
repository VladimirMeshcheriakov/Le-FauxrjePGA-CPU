`timescale 1ns / 1ps


module cpu_control(
    input [6:0] instruction,
    output Branch,
    output MemRead,
    output MemtoReg,
    output [1:0] ALUOp,
    output MemWrite,
    output ALUSrc,
    output RegWrite
);

    assign ALUSrc = !(instruction[4] && instruction[5]|| instruction[6] && instruction[5]);
    assign MemtoReg = !instruction[4];
    assign RegWrite = !(3'b010 == instruction[6:4]);
    assign MemRead = 3'b000 == instruction[6:4];
    assign MemWrite = 3'b010 == instruction[6:4];
    assign Branch = 3'b110 == instruction[6:4];
    assign ALUOp[1] = (3'b011 == instruction[6:4]) || (7'b1101111 == instruction[6:0]);
    assign ALUOp[0] = 3'b110 == instruction[6:4];

endmodule
