`timescale 1ns / 1ps
`include "generic_mem.v"
`include "program_counter.v"

module instruction_fetch
#
(
    parameter instr_size = 32,                      // The size of each instruction (since we are on RISCV it is locked to 32) 
    parameter pc_incr = 4,                          // The increment in the case of non-branch (+4 (32bits) on RISCV)
    parameter mem_size = 8,                         // The number of blocks of the instruction memory
    parameter cell_numbers = 32576
)
(
    input clk,                                      // Global clk
    input [instr_size-1:0] immediate_address,       // The immediate address tobranch to (Also used for the load)
    input branch,                                   // Should the PC branch to immediate or +4? (Also used for the load)
    input rst,                                      // Reset the PC to 0
    input hang_uart,                                // wait for uart to be ready again
    output [instr_size-1:0] instruction             // The instruction read
);

// Other wires
reg on;
wire on_;
assign on_ = on;

// Define the load function, it will open a file and load the bytes from it to the instruction memory
reg we;                                         // Used only during instruction load
reg re;                                         // Read enable, goes high after the instructions were loaded into memory
reg pc_or_load;
reg [instr_size-1:0] load_instruction;          // Temporary storage for the instruction being loaded
reg [mem_size-1:0] mem [0:(cell_numbers)-1];        // The place where memory will be loaded from the file
wire [instr_size-1:0] read_address;
reg [instr_size-1:0] load_address = 0;


localparam LOAD = 1'b0;
localparam READY = 1'b1;

//State Machine
reg state = LOAD;

integer i = 0;


program_counter prog_ctr 
(
    .clk(clk),
    .immediate_address(immediate_address),
    .branch(branch),
    .latch(on_ && ! hang_uart),
    .rst(rst),
    .pc(read_address)
);

// Instruction Memory
generic_mem #(.cell_size(32))
instruction_memory
(
    .clk(clk),
    .addr_bus(pc_or_load ? load_address : read_address),
    .data_bus_in(load_instruction),
    .data_bus_out(instruction),
    .we(we),
    .re(re),
    .rst(rst)
);


always @(posedge clk) begin
    if (rst)
    begin
        $readmemh("mem.mem", mem);
        we <= 1'b1;
        re <= 1'b0;
        pc_or_load <= 1'b1;
        state <= LOAD;
        on <= 0;
        i = 0;
    end
    else
    begin
        case(state)
            LOAD:
            begin
                we <= 1'b1;
                re <= 1'b0;
                pc_or_load <= 1'b1;
                load_address <= i;
                load_instruction <= {mem[i],mem[i+1],mem[i+2], mem[i+3]};
                // instruction_memory.loadn(4, load_instruction, load_address);
                i = i + 4;
                if (i >= cell_numbers) begin
                    state <= READY;
                end
            end
            READY:
            begin
                we <= 1'b0;
                re <= 1'b1; 
                // desactivate the loader forever
                pc_or_load <= 1'b0;
                on <= 1;
            end
        endcase
    end
end

// reg [instr_size-1:0] instruction_ = 'hz;
// assign instruction = instruction_;

// always @(re or read_address or rst) begin
//     instruction_memory.readn(4, instruction_, read_address);
// end
                


endmodule
