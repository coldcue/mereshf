`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:14:03 10/06/2013
// Design Name:   uart
// Module Name:   C:/dev/xilinx/mereshf/uart_test.v
// Project Name:  mereshf
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module uart_test;

	// Inputs
	reg rst;
	reg clk;
	reg ce;
	reg [3:0] word_length;
	reg [1:0] stop_bits;
	reg bitmode;

	// Outputs
	wire finished;
	wire rts;
	wire txd;

	// Instantiate the Unit Under Test (UUT)
	uart uut (
		.rst(rst), 
		.clk(clk), 
		.ce(ce), 
		.word_length(word_length), 
		.stop_bits(stop_bits), 
		.bitmode(bitmode),
		.finished(finished),
		.rts(rts), 
		.txd(txd)
	);

	initial begin
		// Initialize Inputs
		rst = 1;
		clk = 0;
		ce = 0;
		word_length = 0;
		stop_bits = 0;
		bitmode = 0;

		// Wait 100 ns for global reset to finish
		#100;
		ce = 1;
		word_length = 6;
		stop_bits = 0;
        
		// Add stimulus here

	end
	
	always #1
		clk <= ~clk;
      
endmodule

