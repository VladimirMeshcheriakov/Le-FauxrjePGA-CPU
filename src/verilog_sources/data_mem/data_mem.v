`timescale 1ns / 1ps

// Address width of the RAM (number_of_cells)
// Data width, is the number of bits stored in each cell

module data_mem #(
    parameter log2_number_of_cells = 8, //Log2 of the number of memory cells
    parameter addr_size = 32,
    parameter cell_size = 32
)
(
    input clk,
    input [addr_size-1:0] addr_bus,
    input [cell_size-1:0] data_bus_in,
    input [1:0] USR,
    input [7:0] UDRR,
    output [cell_size-1:0] data_bus_out,
    input we,
    input re,
    input rst
);

localparam number_of_cells = 1<<log2_number_of_cells;

// Each address in RAM stores one byte of size cell_size
// [0:1<<number_of_cells-1] gives an array that can be refereced
// at any cell by the number_of_cells bits combinations
reg [cell_size-1:0] ram [0:number_of_cells-1];

// internal reg for data bus assignement
assign data_bus_out = re && !we ? ram[addr_bus] : 'hz;

integer it;
always @(posedge clk ) begin    
    ram[`USR_addr] <= USR;
    ram[`UDRR_addr] <= UDRR;
    if (we && !rst && !(addr_bus == `USR_addr || addr_bus == `UDRR_addr)) begin
        ram[addr_bus] <= data_bus_in;
    end
    if (rst) begin
        for ( it = 0; it < number_of_cells; it = it + 1 ) begin
            ram[it] <= 'h0;
        end
    end
end

endmodule