`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineers:  Toth Andras / Szell Andras
// 
// Create Date:    11:42:27 10/06/2013 
// Module Name:    uart 
// Project Name: MeresLabor1 HF
// Description: 
// Soros ad� egys�g (UART)
//
// Realiz�l�s: FPGA m�ropanelen
//
// A soros ad� egys�g start �s stop bittel keretezett, speci�lis karakterp�rosokat ad a panel aszinkron soros portj�nak TXD vonal�n az RS232/V24 szabv�ny elo�r�sainak megfeleloen (l�sd 3. m�r�s dokument�ci�). (A Start bit 0 �rt�ku, a Stop bit 1 �rt�ku, a megfelelo jelszinteket az FPGA panelbe �p�tett szintkonverter �ramk�r biztos�tja.).
// Az egys�g ad�st a BTN1 gomb minden megnyom�s�ra kiad egy karakterp�rost. Az ad�s megkezd�sekor a soros port RTS vonal�t ON �llapotba kapcsolja, majd az utols� karakter kiad�sa ut�n a vonalat visszakapcsolja OFF �llapotba (az RTS vonal a panelen nincs kivezetve, de funkcion�lisan helyesen kell megval�s�tani).
//
// Az adat�tvitel param�terei:
// Az egys�g egym�s ut�n felv�ltva 000...0 �s 111...1 karaktert ad.
// A karakterek az SW4 kapcsol� OFF �ll�s�ban 7 bitesek, ON �ll�s�ban 8 bitesek.
// A stop bitek sz�ma az SW5 kapcsol� �ll�s�t�l f�ggoen 1 vagy 2.
// A Baud-rate 2400 vagy 9600, �rt�ke az SW8 kapcsol�val v�laszthat�.
//
// K�telezo szinkron rendszer tervez�se, azaz az �sszes FF �rajel bemenet�re az 50 MHz-es rendszer�rajelet kell k�tni!
//////////////////////////////////////////////////////////////////////////////////
module top(
    input rst,
    input clk,
	 
	 //start
    input btn1,
	 //word length selector
    input sw4,
	 //stop bits selector
    input sw5,
	 //rate selector
    input sw8,
	 
	 output rts,
    output txd
    );
	 
   // Paramaters
	parameter [3:0] WORD_LENGHT_7 = 6;
	parameter [3:0] WORD_LENGHT_8 = 7;
	
	parameter [1:0] STOP_BITS_1 = 0;
	parameter [1:0] STOP_BITS_2 = 1;
	
	//States
	parameter [1:0] STATE_1 = 0;
	parameter [1:0] STATE_2 = 1;
	parameter [1:0] STATE_FINISHED = 2;
	reg [1:0] state;
	
	//Enable on button
	reg ce;
	always @ (posedge clk) begin
		if(btn1) begin
			state <= STATE_1;
			ce <= 1;
		end
		else if(state == STATE_FINISHED) begin
			ce <= 0;
		end
	end
		
	// Baud rate generator
	wire rateclk;
	baudrate_gen rategen (
    .clk(clk), 
    .rst(rst), 
    .sel(!sw8), 
    .ce(ce), 
    .rateclk(rateclk)
   ); 
	
	
	// Instantiate the module	
	wire uart_finished;
	reg uart_ce;
	reg uart_bitmode;
	uart uart_module (
    .rst(rst), 
    .clk(rateclk), 
    .ce(uart_ce), 
    .word_length((sw4) ? WORD_LENGHT_7 : WORD_LENGHT_7), 
    .stop_bits((sw5) ? STOP_BITS_2 : STOP_BITS_1), 
    .bitmode(uart_bitmode),
	 .finished(uart_finished),
    .rts(rts), 
    .txd(txd)
    );
	 
	 initial begin
		uart_bitmode <= 0;
	 end
	 
	 //Reset state if reset
	 always @ (posedge rateclk) begin			
		case (state)				
			STATE_1: begin
				uart_bitmode <= 0;
				uart_ce 		 <= 1;
				
				if(uart_finished)
					state <= STATE_2;
			end
			
			STATE_2: begin
				uart_bitmode <= 1;
				uart_ce 		 <= 1;
				
				if(uart_finished)
					state <= STATE_FINISHED;
			end
			
			STATE_FINISHED:
				state <= STATE_1;
		endcase
		
	 end
	
	 

endmodule
