`timescale 1ns / 1ps
`include "divide.v"
`include "register_file.v"

module register_file_top(
    input clk,
    input read1,
    input read2,
    input writeReg,
    input regWrite,
    input [0:1] wd ,
    output [0:1] rd1,
    output [0:1] rd2
    );


register_file 
#(
    .regNum(2),
    .regSize(2)
) rf
(
    .clk(clk),
    .read_reg_1(read1),
    .read_reg_2(read2),
    .write_reg(writeReg),
    .reg_write(regWrite),
    .write_data(wd),
    .rd1(rd1),
    .rd2(rd2)
);

endmodule