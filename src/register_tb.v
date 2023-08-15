`timescale 1ns / 1ps
`include "register_top.v"

module register_tb;
  reg clk;
  wire clk_step;
  wire oe;
  wire rst;
  reg [3:0] data_bus;
  reg [3:0] register_state;
  wire slow_clk;

  generic_register_top grt(
    .clk(clk),
    .clk_step(clk_step),
    .oe(oe),
    .rst(rst),
    .data_bus(data_bus),
    .register_state(register_state),
    .slow_clk(slow_clk)
  );

  initial begin
    $dumpfile("register_tb.vcd");
    $dumpvars(0, register_tb);

    // Initialize clock
    clk = 0;
    rst = 1;  // Activate reset
    // Test case 1: Putting a value into the register
    #10;  // Wait for 10 time units
    data_bus = 4'b1010;  // Set data_bus to the desired value
    rst = 0;  // Deactivate reset
    #10;  // Wait for 10 time units

    // Test case 2: Another test case...
    // Add your own test cases here

    // End simulation
    #10;  // Wait for 10 time units
    $display("Finished testing");
    $finish;
  end

  always begin
    #5;  // Toggle the clock every 5 time units
    clk = ~clk;
  end

endmodule