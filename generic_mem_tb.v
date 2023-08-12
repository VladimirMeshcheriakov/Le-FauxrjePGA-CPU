`timescale 1ns / 1ps
`include "generic_mem.v"

module generic_mem_tb;
  // Parameters
  localparam ADDR_WIDTH = 8;
  localparam DATA_WIDTH = 8;
  // Inputs
  reg clk = 0;
  reg rst = 0;
  reg we = 0;
  reg re = 0;
  // Out data bus
  reg [31:0] data_out = 0;

  // Period of a clk pulse
  localparam period = 20; 

  // Instantiate the RAM module
  generic_mem #(
    .log2_number_of_cells(ADDR_WIDTH),
    .cell_size(DATA_WIDTH)
  ) gm (
    .clk(clk),
    .addr_bus(),
    .data_bus_in(),
    .data_bus_out(),
    .we(we),
    .re(re),
    .rst(rst)
  );

  initial begin
    $dumpfile("generic_mem_tb.vcd");
    $dumpvars(0, generic_mem_tb);
    // Initialize clock and other regs
    rst <= 1;
    #10;
    rst <= 0;
    #10
    we = 1;
    re = 0;
    gm.loadn(2,'h3812,'h0);
    #10;
    we = 0;
    re = 1;
    gm.readn(2,data_out,'h0);
    #10;
    we = 1;
    re = 0;
    gm.loadn(4,'h78945658,'h4);
    #10;
    we = 0;
    re = 1;
    gm.readn(4,data_out,'h4);
    #10;
    $finish;
  end
  
  
  // Generate clock
  always begin
    #1;
    clk = ~clk;
  end
endmodule