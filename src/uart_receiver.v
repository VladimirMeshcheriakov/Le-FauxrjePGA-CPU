`timescale 1ns / 1ps

module uart_receiver
(
    input rst,                  // Resets the receiver
    input baud,                 // Baud rate
    input [3:0] char_size,      // Size of one transmitted character in bits (5 - 8)
    input rx_en,                // Rx enable signal
    input rx,                   // The receive line
    output [7:0] data_out,      // The register containing the received char
    output rdy                  // Flag indicating if the receiver stopped receiving
);

localparam IDLE = 1'b1;
localparam START = 1'b0;


localparam STATE_IDLE = 2'b00;
localparam STATE_RECEIVE = 2'b01;
localparam STATE_STOP = 2'b10;

// Scratch register that accomodates the received bits before shifting them to the data_out
reg [7:0] scratch = 'b0;
reg [1:0] state = STATE_IDLE;
reg [3:0] offset = 'b0;
reg [7:0] data_out_ ='b0;
// By default the receiver is ready to receive
reg rdy_ = 'b1;

assign rdy = rdy_;
assign data_out = data_out_;

always @(posedge baud) begin
    // hard reset
    if (rst) begin
        state <= STATE_IDLE;
        data_out_ <= 7'b0;
        rdy_ <= 1;
    end
    // Main state machine
    case(state)
    STATE_IDLE:
    begin
        rdy_ <= 1;
        offset <= 0;
        // If the START bit has been received from the transmitter
        if (rx == START && rx_en) begin
            // The receiver is now busy and the state machine should transition
            state <= STATE_RECEIVE;
            rdy_ <= 0;
        end
    end
    STATE_RECEIVE:
    begin
        // Write the received bit to the scratch register
        scratch[offset] <= rx;
        offset <= offset + 1;
        // All the chars were received, transition to stop
        if (offset >= char_size - 1) begin
            state <= STATE_STOP;
        end
    end
    STATE_STOP:
    begin
        // Output the scratch register to the data output
        data_out_ <= scratch;
        // The receiver is now ready
        rdy_ <= 1;
        offset <= 0;
        // Next state is the IDLE state
        state <= STATE_IDLE;
    end
    endcase
end

endmodule