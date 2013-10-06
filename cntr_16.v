`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:34:06 10/06/2013 
// Design Name: 
// Module Name:    cntr_16 
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
module cntr_16(
    input clk,
    input rst,
    input ce,
    output [15:0] out
    );
	 
reg [15:0] data;

assign out = data;

always @ (posedge clk) begin
	if(rst)
		data <= 16'b0;
	else if (ce)
		data <= data + 1'b1;
end

endmodule
