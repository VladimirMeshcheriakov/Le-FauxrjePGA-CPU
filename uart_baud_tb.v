`timescale 1ns / 1ps
`include "uart_baud.v"


module uart_baud_tb;

wire baud;
wire ubrr_changed;
reg [11:0] UBRR = 1;
reg clk = 0;
reg rst = 0;

uart_baud ub 
(
    .clk(clk),
    .rst(rst),
    .UBRR(UBRR),
    .ubrr_changed(ubrr_changed),
    .baud(baud)
);

  
// Generate clock
    always begin
        #1;
        clk = ~clk;
    end



// Itterator to fill the RAM
initial begin
    $dumpfile("uart_baud_tb.vcd");
    $dumpvars(0, uart_baud_tb);
    // Initialize clock and other regs
    #100000
    UBRR <= 'd100000000/'d9600;
    #100000
    UBRR <= 'd100000000/'d115200;
    #100000
    $finish;
end
    
endmodule