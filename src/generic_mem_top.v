`timescale 1ns / 1ps
`include "divide.v"
`include "generic_mem.v"

module generic_mem_top(
    input clk,
    input [0:31] addr,
    input we,
    input re,
    input [0:31] data_bus_in,
    output [0:31] data_bus_out
); 

// Module to slow down the clock
// And take input from a toggle button

wire new_clk;

divide div(
    .clock_in(clk),
.clock_out(new_clk)
);


generic_mem #(.cell_size(32))
mem_dut(
    .clk(new_clk),
    .we(we),
    .re(re),
    .addr_bus(addr),
    .data_bus_in(data_bus_in),
    .data_bus_out(data_bus_out)
    );

endmodule
