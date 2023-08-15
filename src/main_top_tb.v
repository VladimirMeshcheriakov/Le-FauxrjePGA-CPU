`timescale 1ns / 1ps
`include "main_top.v"

module main_top_tb;

// Size of the counter for the testbench
localparam pc_size = 32;
// Test wires
reg rst = 0;
reg clk = 0;
reg clk_out = 0;

localparam period = 300; 
// Clock generation
  always begin
    #1;
    clk = ~clk;
  end

main_top pcb (
    .clk(clk),
    .rst(rst),
    .x1(x1),
    .x3(x3),
    clk_out(clk_out)
);

// Stimulus
initial begin
    $dumpfile("main_top_tb.vcd");
    $dumpvars(0, main_top_tb);
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