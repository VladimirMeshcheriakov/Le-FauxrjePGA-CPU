`timescale 1ns / 1ps
`include "alu.v"
`include "instruction_fetch.v"
`include "register_file.v"
`include "immediate_generator.v"
`include "main_controll.v"
`include "uart_top.v"

module cpu_top(
    input clk,
    input rst,
    output [31:0] alu_result,
    output [31:0] pc,
    input [3:0] x1
    );

wire [31:0] instruction = 'hz;
reg [31:0] old_pc;

/*
*
*       Core CPU
*
*/

// The data memory
generic_mem #(
    .cell_size(32)
) data_mem 
(
    .clk(clk),
    .rst(rst),
    .re(mc.MemRead),
    .we(mc.MemWrite),
    .addr_bus(ALU.result),
    .data_bus_in(rf.rd2),
    .data_bus_out()
);


register_file rf
(
    .clk(clk),
    .rst(rst),
    .read_reg_1(instruction[19:15]),
    .read_reg_2(instruction[24:20]),
    .write_reg(instruction[11:7]),
    .write_data(mc.MemtoReg ? data_mem.data_bus_out : ALU.result),
    .rd1(),
    .rd2(),
    .reg_write(mc.RegWrite),
    .reg_update(pc != old_pc),
    .x1(x1)
);

alu ALU
(
    .alu_op(mc.ALU_op),
    .zero(),
    .op1(rf.rd1),
    .op2(mc.ALUSrc ? ig.immOut : rf.rd2),
    .result(alu_result),
    .branch(mc.alu_branch)
);

immediate_generator ig
(
    .instruction(instruction),
    .immOut()
);

main_controll mc
(
    .instruction(instruction),
    .Branch(),
    .MemRead(),
    .MemtoReg(),
    .ALU_op(),
    .MemWrite(),
    .ALUSrc(),
    .RegWrite(),
    .alu_branch()
);

// The instruction memory is inside
instruction_fetch instr_fetch
(
    .clk(clk),
    .rst(rst),
    .branch(ALU.zero && mc.Branch),
    .immediate_address(ig.immOut),
    .instruction(instruction)
);

/*
*
*   Periphirals
*
*/

wire rx;
wire tx;

uart_top uart
(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .tx(tx)
);

assign pc = instr_fetch.prog_ctr.pc;
always @(negedge clk ) begin
    old_pc = pc;
end

endmodule
