`timescale 1ns / 1ps

module immediate_generator
(
    input [31:0] instruction, 
    output[31:0] immOut
);
    reg[31:0] IMM_OUT;
    wire[6:0] opcode;
    //wire[2:0] funct3;

    assign immOut = IMM_OUT;
    assign opcode = instruction[6:0];
    //assign funct3 = instruction[14:12];
    
always @(instruction or opcode) begin
    case(opcode)
        // S-Type (first extend the sign, func7 = immed[11:5], rd = immed[4:0]) // R-type goes here too
        `S_TYPE: 
        begin
            IMM_OUT <= { {21{instruction[31]}}, instruction[30:25], instruction[11:7]};
        end
        // I-type (Extend the sign, funct7+rs2 = immediate)
        `I_TYPE_LW, `I_TYPE_IMM: begin
            IMM_OUT <= { {21{instruction[31]}}, instruction[30:20]}; 
        end
        // B-type (Extend the sign, really weird look in the doc)
        `B_TYPE: 
        begin
            IMM_OUT <= { {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], {1{1'b0}}}; 
        end
        // J-type (Go see the doc) JAL is here
        `J_TYPE_JAL: 
        begin
            IMM_OUT <= { {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], {1{1'b0}}};  
        end
        // U-type (Doc is your best friend)
        `U_TYPE_LUI, // LUI places the 20-bit U-immediate into bits 31–12 of register rd and places zero in the lowest 12 bits
        `U_TYPE_AUIPC: // AUIPC (add upper immediate to pc)
        begin
            IMM_OUT <= {{ instruction[31:12]}, {12{1'b0}}};
        end
        default: begin
            IMM_OUT <= 32'hz;
        end
    endcase
end
endmodule