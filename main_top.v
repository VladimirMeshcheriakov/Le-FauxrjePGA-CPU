`timescale 1ns / 1ps
`include "cpu_top.v"
`include "divide.v"

module main_top (
    input clk,
    input rst,
    input [3:0] x1,
    output [31:0] x3,
    output clk_out
);

wire new_clk;

divide div(
    .clock_in(clk),
.clock_out(new_clk)
);

cpu_top ct
(
    .clk(new_clk),
    .rst(rst),
    .alu_result(),
    .pc(),
    .x1(x1)
);

assign clk_out = new_clk;
assign x3 = ct.rf.registers[3];
    
endmodule