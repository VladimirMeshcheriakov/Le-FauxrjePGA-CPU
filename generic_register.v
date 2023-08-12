`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2023 23:08:28
// Design Name: 
// Module Name: register
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

// init
// generic_register reg_dut(
//     .clk(),
//     .oe(),
//     .rst(),
//     .data_bus(),
//     .register_state()
//     );


// Start with a non generic model
module generic_register
#(
    parameter data_bus_size = 32
)
(
    input clk,
    input oe,
    input rst,
    input latch,
    inout [data_bus_size-1:0] data_bus,
    output [data_bus_size-1:0] register_state
);

    reg [data_bus_size-1:0] r;

    assign register_state = r;
    assign data_bus = (oe) ? r : 'hz;

    always @(posedge clk, rst) begin
        if (rst == 1) begin
            r <= 0;
        end else begin
            if (latch) begin
                r <= data_bus;
            end
        end
    end
endmodule

