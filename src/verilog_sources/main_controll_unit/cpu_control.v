`timescale 1ns / 1ps


module cpu_control(
    input [6:0] instruction,
    output MemRead,
    output MemtoReg,
    output [2:0] ALUOp,
    output MemWrite,
    output ALUSrc,
    output RegWrite,
    output Branch,
    output [1:0] fetchPC // 00 dont fetch pc, 10 fetch pc, 01 fetch pc+4
);
    assign fetchPC = {`U_TYPE_AUIPC == instruction,`J_TYPE_JAL == instruction};
    assign ALUSrc = `S_TYPE == instruction || `I_TYPE_LW == instruction || `I_TYPE_IMM == instruction || `U_TYPE_LUI == instruction || `U_TYPE_AUIPC == instruction;
    assign MemtoReg = `I_TYPE_LW == instruction;
    assign RegWrite = `I_TYPE_LW == instruction || `I_TYPE_IMM == instruction || `R_TYPE == instruction || `U_TYPE_LUI == instruction || `U_TYPE_AUIPC == instruction || `J_TYPE_JAL == instruction;
    assign Branch = `B_TYPE == instruction || `J_TYPE_JAL == instruction;
    assign MemRead = `I_TYPE_LW == instruction;
    assign MemWrite = `S_TYPE == instruction;
    assign ALUOp[2] = `R_TYPE == instruction;
    assign ALUOp[1] = `J_TYPE_JAL == instruction || `I_TYPE_IMM == instruction; 
    assign ALUOp[0] =  `B_TYPE == instruction || `J_TYPE_JAL == instruction;
endmodule
