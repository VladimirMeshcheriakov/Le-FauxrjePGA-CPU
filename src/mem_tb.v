`timescale 1ns / 1ps
`include "generic_mem.v"

module generic_mem_tb;
  // Parameters
  localparam ADDR_WIDTH = 4;
  localparam DATA_WIDTH = 4;
  // Inputs
  reg clk;
  reg [0:ADDR_WIDTH-1] addr_bus;
  reg we;
  reg re;
  // Bidirectional data bus
  wire [0:DATA_WIDTH-1] data_bus;
  reg [0:DATA_WIDTH-1] data_in;

  // Period of a clk pulse
  localparam period = 20; 

  // Instantiate the RAM module
  generic_mem #(
    .addr_width(ADDR_WIDTH),
    .data_width(DATA_WIDTH)
  ) dut (
    .clk(clk),
    .addr_bus(addr_bus),
    .data_bus(data_bus),
    .we(we),
    .re(re)
  );

  assign data_bus = (!we) == 0 ? data_in : 'hz;
  // Itterator to fill the RAM
  integer i ;
  initial begin
    $dumpfile("mem_tb.vcd");
    $dumpvars(0, generic_mem_tb);
    // Initialize clock and other regs

    clk = 0;
    we = 1;
    re = 0;
    #period;
    // Write to memory
    for (i = 0; i < 16; i = i + 1 ) begin
        data_in = i;
        addr_bus = i;
        #period;
    end
    #period;
    addr_bus = 'hz;
    #period;
    // Read from memory
    we = 0;
    re = 1;
    #period;
    for (i = 0; i < 16; i = i + 1 ) begin
        addr_bus = i;
        #period;
    end
    #period;
    $finish;
  end
  
  
  // Generate clock
  always begin
    #1;
    clk = ~clk;
  end
endmodule