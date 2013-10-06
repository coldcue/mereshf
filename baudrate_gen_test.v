`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:29:09 10/06/2013
// Design Name:   baudrate_gen
// Module Name:   C:/dev/xilinx/mereshf/baudrate_gen_test.v
// Project Name:  mereshf
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: baudrate_gen
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module baudrate_gen_test;

	// Inputs
	reg clk;
	reg rst;
	reg gen;
	reg sel;
	reg ce;

	// Outputs
	wire rateclk;

	// Instantiate the Unit Under Test (UUT)
	baudrate_gen uut (
		.clk(clk), 
		.rst(rst), 
		.sel(sel), 
		.ce(ce), 
		.rateclk(rateclk)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		gen = 0;
		sel = 0;
		ce = 0;

		// Wait 100 ns for global reset to finish
		#5;
		ce = 1;
		rst = 0;
		#100;
		sel = 1;
	end
	
	always #1
		clk <= ~clk;
      
endmodule

