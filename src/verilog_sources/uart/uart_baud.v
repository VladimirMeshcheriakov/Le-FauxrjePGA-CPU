`timescale 1ns / 1ps

module uart_baud#(
    parameter CPU_freq = 'd100000000  // 100Mhz for the current FPGA
) 
(
    input clk,
    input rst,
    // UBRR (UART Baud Rate Register), every time it changes the uart baud rate should change instantly (goes from 0 to 4095 to accomodate all the baudrates)
    input [11:0] UBRR,
    output ubrr_changed, // UBRR has changed
    output baud
);
// old ubrr used for comparison
reg [11:0] UBRR_old = 'b1;
// Counter register
reg [11:0] counter = 'b0;
// The output baudrate clock
reg baud_ = 0;
reg [11:0] DIVISOR = 'b1;
// Calculate the clock
assign baud = baud_;
assign ubrr_changed = UBRR_old != UBRR ? 'b1 : 'b0;

always @(negedge clk)
begin
    if (rst)
    begin
        counter <= 11'd0;
        baud_ <= 'b0;
    end
    DIVISOR <= CPU_freq/UBRR;
    if(UBRR_old != UBRR || counter >= ( DIVISOR - 1 ) )
    begin
        counter <= 11'd0;
    end
    UBRR_old <= UBRR;
end

always @(posedge clk)
begin
    if (rst)
    begin
        counter <= 11'd0;
        baud_ <= 'b0;
    end
    DIVISOR <= CPU_freq/UBRR;
    if(UBRR_old != UBRR || counter >= ( DIVISOR - 1 ))
    begin
        counter <= 11'd0;
    end
    // Increment the counter
    counter <= counter + 11'd1;
    // Output the baudrate signal (either 0 or 1)
    baud_ <= (counter < DIVISOR / 2) ? 1'b1:1'b0;
    // Put the UBRR into UBRR_old for reset in case of UBRR change
    UBRR_old <= UBRR;
end
endmodule