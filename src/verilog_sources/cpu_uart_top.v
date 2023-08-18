// headers
`include "verilog_headers/alu_op.vh"
`include "verilog_headers/uart_registers.vh"
`include "verilog_headers/imm_gen_op.vh"
`include "verilog_headers/branch_op.vh"
// sources
`include "verilog_sources/alu/alu.v"
`include "verilog_sources/instruction_fetch/instruction_fetch.v"
`include "verilog_sources/register_file/register_file.v"
`include "verilog_sources/immediate_generator/immediate_generator.v"
`include "verilog_sources/main_controll_unit/main_controll.v"
`include "verilog_sources/uart/uart_top.v"
`include "verilog_sources/data_mem/data_mem.v"

`timescale 1ns / 1ps

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

wire [11:0] UBRR;
wire [3:0] UCSZ;
wire [1:0] UCR;
wire [7:0] UDRT;
wire [1:0] USR;
wire [7:0] UDRR;

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
    .op1(mc.fetchPC ? mc.fetchPC[0] ? instr_fetch.prog_ctr.pc + 4 : instr_fetch.prog_ctr.pc : rf.rd1),
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
    .alu_branch(),
    .fetchPC()
);

// The instruction memory is inside
instruction_fetch instr_fetch
(
    .clk(clk),
    .rst(rst),
    .branch(ALU.zero && mc.Branch),
    .immediate_address(ig.immOut), // we have to subtract the current PC otherwise it is not a real branching
    .instruction(instruction),
    .hang_uart(hang_uart)
);



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

assign UBRR = data_mem.ram[`UBRR_addr];
assign UCSZ = data_mem.ram[`UCSZ_addr];
assign UCR = data_mem.ram[`UCR_addr];
assign UDRT = data_mem.ram[`UDRT_addr];

always @(negedge clk) begin
    old_pc =  pc;
    hang_uart = mc.MemWrite && data_mem.addr_bus == `UDRT_addr && USR[0];
end

endmodule