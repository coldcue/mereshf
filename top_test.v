`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:04:50 10/06/2013
// Design Name:   top
// Module Name:   C:/dev/xilinx/mereshf/top_test.v
// Project Name:  mereshf
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_test;

	// Inputs
	reg rst;
	reg clk;
	reg btn1;
	reg sw4;
	reg sw5;
	reg sw8;

	// Outputs
	wire rts;
	wire txd;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.rst(rst), 
		.clk(clk), 
		.btn1(btn1), 
		.sw4(sw4), 
		.sw5(sw5), 
		.sw8(sw8), 
		.rts(rts), 
		.txd(txd)
	);

	initial begin
		// Initialize Inputs
		rst = 1;
		clk = 0;
		btn1 = 0;
		sw4 = 0;
		sw5 = 0;
		sw8 = 0;

		// Wait 100 ns for global reset to finish
		#20;
		rst = 0;
		#20;
		
		//A button click
		btn1=1;
		#20;
		btn1=0;

		#300;
		 
		sw4 = 1;
		sw5 = 1;
		sw8 = 1;
		#20
		 
		//A button click
		btn1=1;
		#20;
		btn1=0;

	end
	
	always #1 
		clk <= ~clk;
      
endmodule

