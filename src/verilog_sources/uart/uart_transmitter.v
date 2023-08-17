`timescale 1ns / 1ps

module uart_transmitter
(
    input rst,                  // Resets the transmitter
    input [7:0] data_in,        // UDR
    input baud,                 // The clokc (baud rate)
    input [3:0] char_size,      // Size of one transmitted character in bits (5 - 8)
    input te,                   // Transmitter enable, nothing will start before this flag is set
    output tx,                  // The transmitter wire
    output tx_busy              // flag indicating the the transmitter did not finish the transmission
);

localparam IDLE = 1'b1;
localparam START = 1'b0;

localparam STATE_IDLE = 2'b00;
localparam STATE_START = 2'b01;
localparam STATE_SEND = 2'b10;
localparam STATE_STOP = 2'b11;

// Should be IDLE by default
reg tx_ = IDLE;
// Transmitting
reg tx_busy_ = 'b0;
// Offset in the byte to send
reg [3:0] offset = 'b0;
// Initial state of the FSM
reg [1:0] state = STATE_IDLE;

// The output line of TX
assign tx = tx_;
// Output line of TX busy
assign tx_busy = tx_busy_;

// Baud is our clock, the transitions are made on the
// posedge on both the transmitter and receiver
always @(posedge baud) begin
    // hard reset
    if (rst) begin
        offset <= 0;
        tx_ <= IDLE;
        tx_busy_ <= 0;
        state <= STATE_IDLE;
    end
    // The main code for the state machine
    else 
    case(state) 
        STATE_IDLE:
        begin
            tx_ <= IDLE;
            tx_busy_ <= 0;
            if (te) begin
                // If enabled and last state was STATE_IDLE, transition
                state <= STATE_START;
                tx_busy_ <= 1;
            end
        end
        STATE_START:
        begin
            tx_busy_ <= 1;
            tx_ <= START;
            state <= STATE_SEND;
            offset <= 0;
        end
        STATE_SEND:
        begin
            tx_ <= data_in[offset];
            offset <= offset + 1;
            $display("calc %x", offset);
            // Untill the char_size bits were transmitted do not change states
            if (offset >= char_size - 1) begin
            $display("reset %x", offset);
                state <= STATE_STOP;
            end
        end
        STATE_STOP:
        begin
            // Busy cleared, tx to IDLE and state machine to IDLE
            tx_ <= IDLE;
            tx_busy_ <= 0;
            state <= STATE_IDLE;
        end
    endcase
end

endmodule