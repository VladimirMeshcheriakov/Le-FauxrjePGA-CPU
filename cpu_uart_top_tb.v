`timescale 1ns / 1ps
`include "cpu_uart_top.v"

module cpu_top_tb;

// Parameters

// Inputs
reg clk = 0;
reg rst = 0;

// Outputs
wire [31:0] alu_result = 'hz;
wire [31:0] pc = 'hz;

// Instantiate the DUT
cpu_uart_top dut (
    .clk(clk),
    .rst(rst),
    .alu_result(alu_result),
    .pc(pc)
);

// Clock generation
  always begin
    #1;
    clk = ~clk;
  end

// Reset initialization
initial begin
    clk = 0;
    rst = 1;
    #5; // Hold reset for 5 clock cycles
    rst = 0;
end

// Test cases
initial begin
    $dumpfile("cpu_uart_top_tb.vcd");
    $dumpvars(0, cpu_top_tb);
    // Test case 1: Simple ALU operation (add)
    #200000;
    
    // Add more test cases as needed
    
    $finish; // End the simulation
end

endmodule