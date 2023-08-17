`timescale 1ns / 1ps
`include "verilog_sources/cpu_uart_top.v"

module main_tb;

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
    $dumpfile("main_tb.vcd");
    $dumpvars(0, main_tb);
    // Let the CPU run for some cycles
    #200000;
    $finish;
end

endmodule