// This file defines the alu op ctroll operations, that are calculated by cpu controll and fed into alu control

// Here are the types that should be distinguishable in the ALU controll:
/*

    - U-Type (LUI, AUIPC) always add 000
    - B-Type for branches, always SUB  001
    - I-Type (immediate) 010
    - J-Type (very particular PC manipulation) 011
    - R-Type goes here too (same instructions) 100
    - S-Type (store), I-Type (load) 101
    - I-Type-JALR 110

*/

`define U_TYPE_CTRL         3'b000
`define B_TYPE_CTRL         3'b001
`define I_TYPE_ARITH_CTRL   3'b010
`define J_TYPE_CTRL         3'b011
`define R_TYPE_CTRL         3'b100
`define S_TYPE_CTRL         3'b101
`define I_TYPE_LOAD_CTRL    `S_TYPE_CTRL
`define I_TYPE_JALR_CTRL    3'b110