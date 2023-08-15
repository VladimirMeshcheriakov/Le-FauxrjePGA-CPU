`timescale 1ns / 1ps
`include "uart_top.v"

module uart_tb;

localparam CPU_freq = 'd100000000;
localparam baud_rate = 'd115200;

reg [11:0] UBRR = CPU_freq/baud_rate;
reg [3:0] UCSZ = 'd8;
reg [7:0] UDRT = 'b0;
wire [7:0] UDRR;
wire [1:0] USR;
reg tx_en = 0;
reg rx_en = 0;
wire tx_rx;
reg clk = 0;
reg [0:12*8-1]string = "Hello world!";

uart_top ut 
(
  .clk(clk),
  .UBRR(UBRR),
  .UCSZ(UCSZ),
  .UCR({rx_en,tx_en}),
  .UDRT(UDRT),
  .UDRR(UDRR),
  .USR(USR),
  .rx(tx_rx),
  .tx(tx_rx)
);

integer i = 0;
  // Itterator to fill the RAM
  initial begin
    $dumpfile("uart_tb.vcd");
    $dumpvars(0, uart_tb);
    // Initialize clock and other regs
    rx_en = 1;
    tx_en = 1;
    while (i != 17) begin
      @(USR) begin
        // If the transmitter is ready load the next
        if (USR[0])
        begin
          UDRT <= string[i*8 +: 8];
          i <= i + 1;
        end
      end
    end
    $finish;
  end
  
  
  // Generate clock
  always begin
    #1;
    clk = ~clk;
  end

endmodule