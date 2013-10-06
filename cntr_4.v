`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:18:47 10/06/2013 
// Design Name: 
// Module Name:    cntr_4 
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
module cntr_4(
    input clk,
    input rst,
    input ce,
    output [3:0] out
    );
	 
reg [3:0] data;

assign out = data;

always @ (posedge clk) begin
	if(rst)
		data <= 4'b0;
	else if (ce)
		data <= data + 1'b1;
end

endmodule
