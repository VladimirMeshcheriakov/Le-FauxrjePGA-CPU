`timescale 1ns / 1ps
`include "register_file.v"

module register_file_tb;

  // Inputs
  reg clk = 0;
  reg rst = 0;
  reg [0:4] read_reg_1 = 0;
  reg [0:4] read_reg_2 = 0;
  reg [0:4] write_reg = 0;
  reg [0:31] write_data = 0;
  wire [0:31] rd1;
  wire [0:31] rd2;
  reg reg_write = 0;


  // Period of a clk pulse
  localparam period = 20; 

  // Instantiate the RAM module
  register_file rf 
  (
    .clk(clk),
    .read_reg_1(read_reg_1),
    .read_reg_2(read_reg_2),
    .write_reg(write_reg),
    .write_data(write_data),
    .rd1(rd1),
    .rd2(rd2),
    .reg_write(reg_write)
  );

  // Itterator to fill the RAM
  initial begin
    $dumpfile("register_file_tb.vcd");
    $dumpvars(0, register_file_tb);
    // Initialize clock and other regs
    rst <= 1;
    #10;
    rst <= 0;
    read_reg_2 <= 1;
    #10;
    reg_write <= 1;
    write_data <= 32'hb19b00b5;
    write_reg <= 'b0;
    #10;
    reg_write <= 0;
    write_data <= 32'hb17eb17e;
    write_reg <= 'b0;
    #10;
    reg_write <= 1;
    write_data <= 32'hb17eb17e;
    write_reg <= 'b1;
    #10;
    reg_write <= 0;
    #10;
    reg_write <= 1;
    write_data <= 32'hb17eb17e;
    write_reg <= 'b0;
    #10;
    reg_write <= 0;
    #10;
    $finish;
  end
  
  
  // Generate clock
  always begin
    #1;
    clk = ~clk;
  end
endmodule