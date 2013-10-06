`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:11:42 10/06/2013 
// Design Name: 
// Module Name:    baudrate_gen 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module baudrate_gen(
    input clk,
    input rst,
    input sel,
	 input ce,
    output rateclk
    );		
	 
	 //parameter BAUD_RATE_2400 = 20833;
	 //parameter BAUD_RATE_9600 = 8928;
	 parameter BAUD_RATE_2400 = 5;
	 parameter BAUD_RATE_9600 = 1;
	 
	 reg cntr_rst;
	 reg outrate;
	 
	 assign rateclk = outrate;
	 
	 // 16 bit counter
	 wire [15:0] cntr;
	 cntr_16 counter (
    .clk(clk), 
    .rst(cntr_rst), 
    .ce(ce), 
    .out(cntr)
    );
	 

	 always @ (posedge clk) begin
		if(rst) begin
			cntr_rst <= 1;
			outrate  <= 0;
		end
		else if(ce) begin
			if( (!sel && cntr==BAUD_RATE_2400) || (sel && cntr==BAUD_RATE_9600) )  begin
				outrate  <= 1;
				cntr_rst <= 1;
			end
			else begin 
				cntr_rst <= 0;
				outrate  <= 0;
			end
		end
	 end

endmodule
