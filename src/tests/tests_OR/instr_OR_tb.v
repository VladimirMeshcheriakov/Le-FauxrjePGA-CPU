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
    #(`CELL_NUMBERS)
    // The instructions are now being executed

	if (dut.rf.reg_write == 1'b0)
	begin
		$fatal(1, "Reg Write not 1");
	end
    if (dut.rf.write_data != 'he)
	begin
		$fatal(1, "Write data is not correct!");
	end
	if (dut.rf.write_reg != 'h3)
	begin
		$fatal(1, "Write reg is wrong!");
	end 


    $finish;
end

endmodule

