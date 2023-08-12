`timescale 1ns / 1ps

module alu
#(
    parameter alu_op_size = 4,
    parameter alu_operand_size = 32
)
(
    input [alu_op_size - 1:0] alu_op,           // The alu operation generated from the control unit
    output zero,                                // The zero flag
    input [alu_operand_size - 1:0] op1,         // First operand
    input [alu_operand_size - 1:0] op2,         // second operand
    input [2:0] branch,
    output [alu_operand_size - 1:0] result      // The result of the evaluation
);
    
    reg [alu_operand_size:0] ALU_Result;
    reg zero_;
    assign result = ALU_Result[alu_operand_size-1:0]; // ALU out
    assign zero = zero_;

always @(op1 or op2 or alu_op) begin
    case(alu_op)
        4'b0000: // AND
            ALU_Result = op1 & op2 ; 
        4'b0001: // OR
            ALU_Result = op1 | op2 ;
        4'b0010: // add
            ALU_Result = op1 + op2 ;
        4'b0011: // xor
            ALU_Result = op1 ^ op2 ;
        4'b0100: //SLL
            ALU_Result = op1 << op2 ;
        4'b0101: //SRL
            ALU_Result = op1 >> op2 ;
        4'b0110: // subtract
            ALU_Result = op1 - op2 ;
        4'b1100: //SLLI
            ALU_Result = op1 << op2[4:0] ;
        4'b1101: //SRLI
            ALU_Result = op1 >> op2[4:0] ;
        default: 
            ALU_Result = op1 + op2 ;
    endcase
    case(branch)
        3'b000: zero_ <= ALU_Result == 0; // BEQ
        3'b001: zero_ <= ALU_Result != 0; // BNE
        3'b010: zero_ <= 1; // JAL
        3'b100: zero_ <= !ALU_Result[alu_operand_size]; // BLT
        3'b110: zero_ <= ALU_Result[alu_operand_size]; // BLTU
        3'b101: zero_ <= ALU_Result[alu_operand_size]; // BGE
        3'b111: zero_ <= !ALU_Result[alu_operand_size]; // BGEU
        default: zero_ <= ALU_Result == 0; // BEQ
    endcase
end 
endmodule
