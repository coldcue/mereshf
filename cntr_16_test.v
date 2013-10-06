`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:37:34 10/06/2013
// Design Name:   cntr_16
// Module Name:   C:/dev/xilinx/mereshf/cntr_16_test.v
// Project Name:  mereshf
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cntr_16
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cntr_16_test;

	// Inputs
	reg clk;
	reg rst;
	reg ce;

	// Outputs
	wire [0:15] out;

	// Instantiate the Unit Under Test (UUT)
	cntr_16 uut (
		.clk(clk), 
		.rst(rst), 
		.ce(ce), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		ce = 0;

		// Wait 20 ns for global reset to finish
		#20;
		
		rst = 0;
		ce = 1;
		// Wait 65536*5
		#327680
		
		ce = 0;
	end
	
	always #5
		clk <= ~clk;
      
endmodule

