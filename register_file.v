`timescale 1ns / 1ps

module register_file 
#(
    parameter regNum = 32,
    parameter regSize = 32
)
(
   input clk,
   input rst,
   input [0:$clog2(regNum)-1] read_reg_1,   // First register to read
   input [0:$clog2(regNum)-1] read_reg_2,   // Second register to read
   input [0:$clog2(regNum)-1] write_reg,    // Register to write to
   input [0:regSize-1] write_data,          // The data to write to the register  
   output [0:regSize-1] rd1,                // The output read from read_reg_1
   output [0:regSize-1] rd2,                // The output read from read_reg_2
   input reg_write,                         // Toggle to perform regWrite
   input reg_update
);

integer i;

initial begin
    for ( i = 0 ; i < regSize ; i = i + 1) begin
        // if (i != 1) begin
            registers[i] <= 0;
        // end
    end
end

    // All the registers
    reg [0:regNum-1] registers [0:regSize-1];
    // Assign the two read registers
    reg [0:regSize-1] rd1_ = 'hz;
    reg [0:regSize-1] rd2_ = 'hz;
    assign rd1 = rd1_;
    assign rd2 = rd2_;

    // Register Reading logic
    always @(read_reg_1 or read_reg_2 or reg_write or reg_update) begin 
           rd1_ <= (read_reg_1 < regSize) ? (read_reg_1 ? registers[read_reg_1] : 0) : 'hz;
           rd2_ <= (read_reg_2 < regSize) ? (read_reg_2 ? registers[read_reg_2] : 0) : 'hz;
    end

    // Register Writing logic
    always @(posedge clk)
    begin 
        if (reg_write == 1)
        begin
           registers[write_reg] <= write_data; 
        end
        if (rst)
        begin
            for ( i = 0 ; i < regSize ; i = i + 1) begin
                registers[i] <= 0;
            end
        end
        // registers[1] <= x1;
    end
endmodule
