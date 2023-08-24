`timescale 1ns / 1ps


// This ALU controll is not generic and is made for the RISCV simple processor (not pipelined)


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
            `U_TYPE_CTRL: begin
                branch_ = 3'bzzz;
                alu_op_res_ = `ADD;
            end  
            `B_TYPE_CTRL: begin
                branch_ = instruction[2:0];
                alu_op_res_ = `SUB;
            end 
            `I_TYPE_ARITH_CTRL: begin
                branch_ = 3'bzzz;
                // This is done so that SRA and SRAI can pass, their funct 3 is distinguished from all artmetic immediate, and their funct7 too
                alu_op_res_ =  instruction == `SRA ? instruction : {1'b0,instruction[2:0]};                
            end 
            `J_TYPE_CTRL, `I_TYPE_JALR_CTRL: begin
                branch_ = `JAL;
                alu_op_res_ = `ADD;
            end 
            `R_TYPE_CTRL: begin
                branch_ = 3'bzzz;
                alu_op_res_ = instruction;                
            end         
            `S_TYPE_CTRL, `I_TYPE_LOAD_CTRL: begin
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
