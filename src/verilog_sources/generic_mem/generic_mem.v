`timescale 1ns / 1ps

// Address width of the RAM (number_of_cells)
// Data width, is the number of bits stored in each cell

module generic_mem #(
    parameter log2_number_of_cells = 8, //Log2 of the number of memory cells
    parameter addr_size = 32,
    parameter cell_size = 8
)
(
    input clk,
    input [addr_size-1:0] addr_bus,
    input [cell_size-1:0] data_bus_in,
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

//integer i;

//Load n cell
// task  loadn(input [(addr_size/cell_size) - 1 : 0]num_cell, input [addr_size-1:0] load_val, input [addr_size-1:0] addr);
// begin
//     if (we)
//     begin
//         for (i = 0; i < num_cell ; i = i + 1 ) begin
//             @ (posedge clk) begin
//                 ram[addr + i] <= load_val[i*cell_size +: cell_size];
//             end
//         end
//     end
// end 
// endtask

// task  readn(input [(addr_size/cell_size) - 1 : 0]num_cell, output [addr_size-1:0] read_val, input [addr_size-1:0] addr);
// begin
//     if (re)
//     begin

//         for ( i = 0; i < num_cell ; i = i + 1 ) begin
//             read_val[i*cell_size +: cell_size] = ram[addr + i];
//         end

//         for (i = num_cell; i < addr_size / cell_size ; i = i+1 ) begin
//             read_val[i*cell_size +: cell_size] = 0;
//         end
//     end
//     else begin
//         for (i = 0; i < addr_size / cell_size ; i = i+1 ) begin
//             read_val[i*cell_size +: cell_size] = 'hz;
//         end
//     end
// end 
// endtask
integer it;
always @(posedge clk ) begin
    if (we && !rst) begin
        ram[addr_bus] <= data_bus_in;
    end
    if (rst) begin
        for ( it = 0; it < number_of_cells; it = it + 1 ) begin
            ram[it] <= 'h0;
        end
    end
end

endmodule