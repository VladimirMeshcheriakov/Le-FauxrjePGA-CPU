`timescale 1ns / 1ps
`include "program_counter.v"

module program_counter_tb;

// Size of the counter for the testbench
localparam pc_size = 32;
// Test wires
reg rst = 0;
reg clk = 0;
reg branch = 0;
reg latch = 0;
reg [pc_size-1:0] immediate_address = 'b0;
wire [pc_size-1:0] pc;

localparam period = 300; 
// Clock generation
  always begin
    #1;
    clk = ~clk;
  end

program_counter pcb (
    .clk(clk),
    .rst(rst),
    .immediate_address(immediate_address),
    .branch(branch),
    .latch(latch),
    .pc(pc)
);

// Stimulus
initial begin
    $dumpfile("program_counter_tb.vcd");
    $dumpvars(0, program_counter_tb);
    $monitor("New pc Value: %d", pc);

    // set vals

    #1;

    $display("Test reset");
    rst = 1'b1;
    #4;
    $display("Test default increment (should increment by 8)");
    latch = 1;
    rst = 0;
    #4;
    $display("Test no increment (latch = 0)");

    latch = 0;
    #4;
    $display("Test immediate branch");
    latch = 1;
    branch = 1;
    immediate_address = 'h17;
    #4;
    $display("Test no branch (latch = 0)");
    latch = 0;
    branch = 1;
    immediate_address = 'h17;
    #4;
    $display("Test stop branch");
    latch = 1;
    branch = 0;
    #4;
    $display("Test reset to default after execution");

    rst = 1;
    #4;
    
    $finish; // End the simulation
end

endmodule