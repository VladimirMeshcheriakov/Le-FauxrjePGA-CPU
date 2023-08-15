`timescale 1ns / 1ps
`include "instruction_fetch.v"

module tb_instruction_fetch;

// Parameters
parameter mem_size = 8;
parameter instr_size = 32;
parameter pc_incr = 4;

// Inputs
reg clk = 0;
reg rst = 0;
reg [mem_size-1:0] immediate_address = 'b0;
reg branch = 0;

// Outputs
wire [instr_size-1:0] instruction;


localparam period = 300; 
// Clock generation
  always begin
    #1;
    clk = ~clk;
  end


// Instantiate the module under test
instruction_fetch dut (
    .clk(clk),
    .immediate_address(immediate_address),
    .branch(branch),
    .rst(rst),
    .instruction(instruction)
);

// Stimulus
initial begin
    $dumpfile("instruction_fetch_tb.vcd");
    $dumpvars(0, tb_instruction_fetch);
    $monitor("Instruction: %x", instruction);
    branch = 0;
    rst = 1;
    // Wait a few cycles to ensure instructions are loaded into memory
    #10;
    rst = 0;
    #650;

    // Testcase 1: Non-Branching Instruction
    immediate_address = 0;
    branch = 0;
    #10;

    // Testcase 2: Branching Instruction
    immediate_address = 23;
    branch = 1;
    #10;
    immediate_address = 23;
    branch = 0;
    #10;
    
    immediate_address = 23;
    branch = 0;
    rst = 1;
    #10;
    rst = 0;
    #10;
    

    $finish; // End the simulation
end

endmodule
