`timescale 1ns / 1ps


// This ALU controll is not generic and is made for the RISCV simple processor (not pipelined)

// Here are the types that should be distinguishable in the ALU controll:
/*

    - U-Type (LUI, AUIPC) always add 000
    - I-Type (immediate) 010
    - J-Type (very particular PC manipulation) 011
    - B-Type for branches, always SUB  001
    - R-Type goes here too (same instructions) 100
    - S-Type,I-Type (load)  101
*/


module alu_control(
    input   [3:0] instruction,             // The [30, 14-12] bits of the instruction
    input   [2:0] alu_ctrl_op,                       //ALUop2 and ALUop1 and ALUop0 signals
    output  [3:0] alu_op_res,                   // The result
    output  [2:0] branch,
    output  [2:0] store
    );

    reg [3:0] alu_op_res_;
    reg [2:0] branch_;
    reg [2:0] store_;
    assign alu_op_res = alu_op_res_;
    assign branch = branch_;
    assign store = store_;
    always @(instruction or alu_ctrl_op) 
    begin
        case (alu_ctrl_op)
            3'b100: begin
                branch_ = 3'bzzz;
                alu_op_res_ = instruction;                
            end         
            3'b011: begin
                branch_ = `JAL;
                alu_op_res_ = `ADD;
            end 
            3'b010: begin
                branch_ = 3'bzzz;
                alu_op_res_ =  {1'b0,instruction[2:0]};                
            end 
            3'b001: begin
                branch_ = instruction[2:0];
                alu_op_res_ = `SUB;
            end 
            3'b000: begin
                branch_ = 3'bzzz;
                alu_op_res_ = `ADD;
            end  
            3'b101: begin   //S-Type
                branch_ = 3'bzzz;
                alu_op_res_ = `ADD;
                store_ = instruction[2:0];
            end                                   
            default: begin
                branch_ = 3'bzzz;
                alu_op_res_ = `ADD;
            end  
        endcase;
    end

endmodule
