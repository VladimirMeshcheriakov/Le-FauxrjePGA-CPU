`timescale 1ns / 1ps


module alu
#(
    parameter alu_op_size = 4,
    parameter alu_operand_size = 32
)
(
    input [alu_op_size - 1:0] alu_op,           // The alu operation generated from the control unit (alu_op.vh)
    output zero,                                // The zero flag
    input [alu_operand_size - 1:0] op1,         // First operand
    input [alu_operand_size - 1:0] op2,         // second operand
    input [2:0] branch,                         // Type of branch instruction   (branch_op.vh)
    output [alu_operand_size - 1:0] result      // The result of the evaluation
);
    
    reg [alu_operand_size:0] ALU_Result;
    reg zero_;
    assign result = ALU_Result[alu_operand_size-1:0]; // ALU out
    assign zero = zero_;

always @(op1 or op2 or alu_op or branch)
    begin
    case(alu_op)
        `AND: // AND
            ALU_Result = op1 & op2; 
        `OR: // OR
            ALU_Result = op1 | op2;
        `ADD: // ADD
            ALU_Result = op1 + op2;
        `XOR: // XOR
            ALU_Result = op1 ^ op2;
        `SLL: // SLL
            ALU_Result = op1 << op2;
        `SRL: // SRL
            ALU_Result = op1 >> op2;
        `SUB: // SUB 
            ALU_Result = op1 - op2;
        `SLTU: //SLTU
            ALU_Result = op1 < op2;
        `SLT: //SLT
            ALU_Result = op1[alu_operand_size-1] ^ op2[alu_operand_size-1] ? op1[alu_operand_size-1] : op1[alu_operand_size - 2:0] < op2[alu_operand_size - 2:0];
        default: //ADD
            ALU_Result = op1 + op2;
    endcase
    case(branch)
        `BEQ: // BEQ
            zero_ <= ALU_Result == 0;
        `BNE: // BNE
            zero_ <= ALU_Result != 0;
        `JAL: // JAL
            zero_ <= 1;
        `BLT: // BLT
            zero_ <= !ALU_Result[alu_operand_size];
        `BLTU: // BLTU
            zero_ <= ALU_Result[alu_operand_size];
        `BGE: // BGE
            zero_ <= ALU_Result[alu_operand_size];
        `BGEU: // BGEU
            zero_ <= !ALU_Result[alu_operand_size];
        default: // If the branch is zzz, so must the zero
            zero_ <= 1'bz;
    endcase
end 
endmodule
