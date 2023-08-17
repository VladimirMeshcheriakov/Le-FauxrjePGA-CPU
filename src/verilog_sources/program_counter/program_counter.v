`timescale 1ns / 1ps

module program_counter 
#(
    // Size of the counter in bits presumably the memory will have to address 2^32 locations
    parameter pc_size = 32,
    parameter addr_size = 32,
    // The increment on regular instruction (should be 4 for RISCV)
    parameter pc_incr = 4
)
(
    input clk,
    input [addr_size-1:0] immediate_address,
    input branch,
    input latch,
    input rst,
    output [addr_size-1:0] pc
);
    
reg [pc_size-1:0] saved_pc;
reg [pc_size-1:0] current_pc;

assign pc = saved_pc;

always @(posedge clk) begin
    if ((latch) && !rst) begin //  || branch
        saved_pc <= current_pc;
    end
    if (rst) begin
        saved_pc <= 0;
    end
end

always @(*) begin
    if (!rst)
    begin
        if (branch)
        begin
            current_pc <= immediate_address + saved_pc;
        end
        else begin
            current_pc <= pc_incr + saved_pc;
        end
    end
    else
    begin
        current_pc <= 0;
    end
end

endmodule