`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:03:57 10/06/2013
// Design Name:   cntr_2
// Module Name:   C:/dev/xilinx/mereshf/cntr_2_test.v
// Project Name:  mereshf
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cntr_2
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cntr_2_test;

	// Inputs
	reg clk;
	reg rst;
	reg ce;

	// Outputs
	wire [1:0] out;

	// Instantiate the Unit Under Test (UUT)
	cntr_2 uut (
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

		// Wait 100 ns for global reset to finish
		#10;
		rst=0;
		ce = 1;
        
		// Add stimulus here

	end
	
	always #5
		clk <= ~clk;
      
endmodule

