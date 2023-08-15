`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2023 07:10:11
// Design Name: 
// Module Name: pc_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pc_top (
    input clk,
    output clk_out,
    input [3:0] jump,
    output [3:0] addr_led,
    input branch,
    input latch,
    input rst,
    output [3:0] addr
);

wire new_clk;

divide div(
    .clock_in(clk),
.clock_out(new_clk)
);


assign addr_led = jump;
assign new_clk = clk_out;

program_counter #(.pc_size(4), .pc_incr(6)) pc_dut(
    .clk(new_clk),
    .immediate_address(jump),
    .branch(branch),
    .latch(latch),
    .rst(rst),
    .pc(addr)
);

endmodule
