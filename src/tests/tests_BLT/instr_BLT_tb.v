
`include "verilog_sources/cpu_uart_top.v"

`timescale 1ns / 1ps


module main_tb;

// Parameters

// Inputs
reg clk = 0;
reg rst = 0;

// Outputs
wire [31:0] alu_result = 'hz;
wire [31:0] pc = 'hz;

// Instantiate the DUT
cpu_uart_top dut (
    .clk(clk),
    .rst(rst),
    .alu_result(alu_result),
    .pc(pc)
);

// Clock generation
  always begin
    #1;
    clk = ~clk;
  end

// Reset initialization
initial begin
    clk = 0;
    rst = 1;
    #5; // Hold reset for 5 clock cycles
    rst = 0;
end

// Test cases
initial begin
    $dumpfile(`VCD_FILE);
    $dumpvars(0, main_tb);
    // Let the CPU run for the load portion
    #5
    #(`CELL_NUMBERS/2)

    //get to the third instruction  
    #6
    // Should not branch
    if (dut.instr_fetch.instruction == 'h00808093)
    begin
        $fatal(1, "Should not branch but did on BLT (8 < 8)");
    end
    #4
    if (dut.instr_fetch.instruction == 'h00808093)
    begin
        $fatal(1, "Should not branch (9 < 8)");
    end
    #4
    #2
    if (dut.instr_fetch.instruction != 'h00808093)
    begin
        $fatal(1, "Should branch because unsigned (-1 < 8)");
    end
    $finish;
end

endmodule