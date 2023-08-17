`timescale 1ns / 1ps
`include "main_controll.v"

module main_controll_tb;
    // Load all the tested istructions
    wire [6:0] instructions [0:3];
    assign     instructions[0] = 7'h33;
    assign     instructions[1] = 7'h03;
    assign     instructions[2] = 7'h23;
    assign     instructions[3] = 7'h63;

    // Load all the func3
    wire [2:0] func3 [0:2];
    assign     func3[0] = 3'h0;
    assign     func3[1] = 3'h7;
    assign     func3[2] = 3'h6;
    
    // Inputs
    reg [31:0] instruction;
    
    // Outputs
    wire branch, MemRead, MemtoReg, MemWrite, ALUScr, RegWrite;
    wire [3:0] ALU_op;
    
    // Instantiate the main_controll module
    main_controll dut (
        .instruction(instruction),
        .branch(branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALU_op(ALU_op),
        .MemWrite(MemWrite),
        .ALUScr(ALUScr),
        .RegWrite(RegWrite)
    );

    integer i;
    integer j;
    integer k;

    // Stimulus
    initial begin
        $dumpfile("main_controll_tb.vcd");
        $dumpvars(0, main_controll_tb);
        for (i = 0; i < 4 ; i = i + 1) begin
            for (j = 0; j < 3 ; j = j + 1 ) begin
                for (k = 0; k < 2 ; k = k + 1 ) begin
                    instruction = 32'bx;
                    instruction[30] = k;
                    instruction[14:12] = func3[j];
                    instruction[6:0] = instructions[i];
                    #10;
                end
            end
        end
        
        $finish;
    end

endmodule