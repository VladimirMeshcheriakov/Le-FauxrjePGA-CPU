`include "verilog_sources/uart/uart_transmitter.v"
`include "verilog_sources/uart/uart_receiver.v"
`include "verilog_sources/uart/uart_baud.v"

`timescale 1ns / 1ps

module uart_top#(
    parameter CPU_freq = 'd100000000  // 100Mhz for the current FPGA
) 
(
  input clk,
  input rst,
  input [11:0] UBRR,
  input [3:0] UCSZ,
  input [1:0] UCR,
  input [7:0] UDRT,
  input rx,
  output [1:0] USR,
  output [7:0] UDRR,
  output tx
);





wire ubrr_changed;
wire tx_busy;
wire rx_ready;
wire baud;


assign USR = {rx_ready,!tx_busy};

uart_baud  #(.CPU_freq(CPU_freq))
ub(
  .clk(clk),
  .rst(rst),
  .UBRR(UBRR),
  .ubrr_changed(ubrr_changed),
  .baud(baud)
);

uart_transmitter ut 
(
  .rst(ubrr_changed),
  .baud(baud),
  .data_in(UDRT),
  .char_size(UCSZ),
  .te(UCR[0]),
  .tx(tx),
  .tx_busy(tx_busy)
);

uart_receiver ur 
(
  .rst(ubrr_changed),
  .baud(baud),
  .rx(rx),
  .char_size(UCSZ),
  .rx_en(UCR[1]),
  .data_out(UDRR),
  .rdy(rx_ready)
);
  

endmodule