`timescale 1ns / 1ps


// This ALU controll is not generic and is made for the RISCV simple processor (not pipelined)


module alu_control(
    input   [3:0] instruction,             // The [30, 14-12] bits of the instruction
    input   [1:0] alu_op,                       // ALUop1 and ALUop0 signals
    output  [3:0] alu_op_res,                   // The result
    output  [2:0] branch
    );

    reg [3:0] alu_op_res_;
    reg [2:0] branch_;
    assign alu_op_res = alu_op_res_;
    assign branch = branch_;

    always @(instruction or alu_op) begin
        if (alu_op[1:0] == 2'b11) begin // J-Type
            alu_op_res_ = `ADD; // JAL
            branch_ = 3'b010;
        end
        else if (!alu_op[1]) begin
            if (alu_op[0]) begin // BEQ
                alu_op_res_ = 4'b0110;
                branch_ = instruction[2:0];
            end
            else begin  
                case(instruction[2:0])
                    3'b000: alu_op_res_ = `ADD; // ADDI
                    3'b001: alu_op_res_ = `SLLI; // SLLI
                    3'b010: alu_op_res_ = `SLT; // SLTI
                    3'b011: alu_op_res_ = `SLTU; // SLTIU
                    3'b100: alu_op_res_ = `XOR; // XORI
                    3'b101:  alu_op_res_ = `SRLI; // SRLI
                    3'b110: alu_op_res_ = `OR; // ORI
                    3'b111: alu_op_res_ = `AND; // ANDI
                    default:  alu_op_res_ = `ADD; // ADDI
                endcase
                branch_ = 3'b000;
            end
        end
        else begin // R-Type
            case(instruction[3:0])
                4'b0000: alu_op_res_ = `ADD; // ADD
                4'b0001: alu_op_res_ = `SLL; // SLL
                4'b0010: alu_op_res_ = `SLT; // SLT
                4'b0011: alu_op_res_ = `SLTU; // SLTU
                4'b1000: alu_op_res_ = `SUB; // SUB
                4'b0100: alu_op_res_ = `XOR; // XOR
                4'b0101:  alu_op_res_ = `SRL; // SRL
                4'b0110: alu_op_res_ = `OR; // OR
                4'b0111: alu_op_res_ = `AND; // AND
                default: alu_op_res_ = `ADD; // ADD
            endcase
        end
    end

endmodule
