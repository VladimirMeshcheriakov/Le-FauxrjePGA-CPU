`include "verilog_sources/main_controll_unit/cpu_control.v"
`include "verilog_sources/main_controll_unit/alu_control.v"

`timescale 1ns / 1ps

module main_controll(
    input [31:0] instruction,            // The instruction fed into the ctrl unit
    output Branch,
    output MemRead,
    output MemtoReg,
    output  [3:0] ALU_op,               // The 4 bit op code sent to the ALU
    output MemWrite,
    output ALUSrc,
    output [2:0] alu_branch,
    output RegWrite,
    output [1:0] fetchPC
    );

    wire [2:0] alu_ctrl_op = 'hz;

    cpu_control cc
    (
        .instruction(instruction[6:0]),
        .fetchPC(fetchPC),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(alu_ctrl_op),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    alu_control alu_control
    (
        .instruction({instruction[30],instruction[14:12]}),
        .alu_ctrl_op(alu_ctrl_op),
        .alu_op_res(ALU_op),
        .branch(alu_branch)
    );

endmodule
