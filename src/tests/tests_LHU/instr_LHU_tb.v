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
    #6
    // The instructions are now being executed
    if (dut.rf.write_data != 'hFFF4)
	begin
		$fatal(1, "Write data is not correct!");
	end
    #2
    if (dut.rf.write_data != 'h0)
	begin
		$fatal(1, "Write data is not correct!");
	end

    $finish;
end

endmodule
