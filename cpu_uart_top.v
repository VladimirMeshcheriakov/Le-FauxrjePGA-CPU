`timescale 1ns / 1ps
`include "alu.v"
`include "instruction_fetch.v"
`include "register_file.v"
`include "immediate_generator.v"
`include "main_controll.v"
`include "uart_top.v"
`include "data_mem.v"

module cpu_uart_top(
    input clk,
    input rst,
    output [31:0] alu_result,
    output [31:0] pc
    );

wire [31:0] instruction = 'hz;
reg hang_uart = 0;
reg [31:0] old_pc;

/*
*
*       Core CPU
*
*/


// The data memory
data_mem data_mem 
(
    .clk(clk),
    .rst(rst),
    .re(mc.MemRead),
    .we(mc.MemWrite),
    .USR(USR),
    .UDRR(UDRR),
    .addr_bus(ALU.result),
    .data_bus_in(rf.rd2),
    .data_bus_out()
);


register_file rf
(
    .clk(clk),
    .rst(rst),
    .read_reg_1(instruction[19:15]),
    .read_reg_2(instruction[24:20]),
    .write_reg(instruction[11:7]),
    .write_data(mc.MemtoReg ? data_mem.data_bus_out : ALU.result),
    .rd1(),
    .rd2(),
    .reg_write(mc.RegWrite),
    .reg_update(pc != old_pc)
);

alu ALU
(
    .alu_op(mc.ALU_op),
    .zero(),
    .op1(rf.rd1),
    .op2(mc.ALUSrc ? ig.immOut : rf.rd2),
    .result(alu_result),
    .branch(mc.alu_branch)
);

immediate_generator ig
(
    .instruction(instruction),
    .immOut()
);

main_controll mc
(
    .instruction(instruction),
    .Branch(),
    .MemRead(),
    .MemtoReg(),
    .ALU_op(),
    .MemWrite(),
    .ALUSrc(),
    .RegWrite(),
    .alu_branch()
);

// The instruction memory is inside
instruction_fetch instr_fetch
(
    .clk(clk),
    .rst(rst),
    .branch(ALU.zero && mc.Branch),
    .immediate_address(ig.immOut),
    .instruction(instruction),
    .hang_uart(hang_uart)
);

/*
*
*   Periphirals
*
*/

wire rx;
wire tx;

/*
*
*   Map the UART registers into memory
*   Each memory cell is 32 bits, so a lot of memory will be used in vain
*/

localparam UBRR_addr = 20;
localparam UCSZ_addr = 21;
localparam UCR_addr = 22;
localparam UDRT_addr = 23;

wire [11:0] UBRR;
wire [3:0] UCSZ;
wire [1:0] UCR;
wire [7:0] UDRT;
wire [1:0] USR;
wire [7:0] UDRR;

uart_top uart
(
    .clk(clk),
    .rst(rst),
    .rx(tx),
    .tx(tx),
    .UBRR(UBRR),
    .UCSZ(UCSZ),
    .UCR(UCR),
    .UDRT(UDRT),
    .USR(USR),
    .UDRR(UDRR)
);

assign pc = instr_fetch.prog_ctr.pc;

assign UBRR = data_mem.ram[UBRR_addr];
assign UCSZ = data_mem.ram[UCSZ_addr];
assign UCR = data_mem.ram[UCR_addr];
assign UDRT = data_mem.ram[UDRT_addr];

always @(negedge clk) begin
    old_pc =  pc;
    hang_uart = mc.MemWrite && data_mem.addr_bus == UDRT_addr && USR[0];
end

endmodule