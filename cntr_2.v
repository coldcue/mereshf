`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:02:52 10/06/2013 
// Design Name: 
// Module Name:    cntr_2 
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
module cntr_2(
    input clk,
    input rst,
    input ce,
    output [1:0] out
    );
	 
reg [1:0] data;

assign out = data;

always @ (posedge clk) begin
	if(rst)
		data <= 2'b0;
	else if (ce)
		data <= data + 1'b1;
end

endmodule