`timescale 1ns / 1ps
`include "divide.v"
`include "generic_register.v"

module generic_register_top
    #(
    parameter data_bus_size = 4
    )
    (
    input clk,
    input oe,
    input rst,
    input latch,
    inout [data_bus_size-1:0] data_bus,
    output [data_bus_size-1:0] register_state
    ); 

// Module to slow down the clock
// And take input from a toggle button

wire new_clk;

divide div(
    .clock_in(clk),
.clock_out(new_clk)
);


generic_register #(.data_bus_size(data_bus_size)) reg_dut(
    .clk(new_clk),
    .oe(oe),
    .rst(rst),
    .latch(latch),
    .data_bus(data_bus),
    .register_state(register_state)
    );
    
endmodule

