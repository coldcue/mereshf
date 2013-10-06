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
module uart(
    input rst,
    input clk,
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
	 
	parameter [3:0] WORD_LENGHT_7 = 6;
	parameter [3:0] WORD_LENGHT_8 = 7;
	
	parameter [3:0] STOP_BITS_1 = 0;
	parameter [3:0] STOP_BITS_2 = 1;
 
   //if not reset, enable
   reg ce;	
	always @ (posedge btn1)
		ce <= 1;
	
	//outputs
	reg rts_out;
	reg txd_out;
	assign rts = rts_out;
	assign txd = txd_out;
	
	initial begin
		rts_out <= 0;
		txd_out <= 1;
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

	// Bit counter
	wire [3:0] bit_cntr_data;
	reg bit_cntr_ce;
	reg bit_cntr_rst;
	cntr_4 bit_cntr (
    .clk(rateclk), 
    .rst(bit_cntr_rst), 
    .ce(bit_cntr_ce), 
    .out(bit_cntr_data)
    );
	 
	// Stop Bit counter
	wire [3:0] stopbit_cntr_data;
	reg stopbit_cntr_ce;
	reg stopbit_cntr_rst;
	cntr_4 stopbit_cntr (
    .clk(rateclk), 
    .rst(stopbit_cntr_rst), 
    .ce(stopbit_cntr_ce), 
    .out(stopbit_cntr_data)
    );
	
	// output logic
	parameter [1:0] STATE_IDLE  = 0;
	parameter [1:0] STATE_START = 1;
	parameter [1:0] STATE_SEND  = 2;
	parameter [1:0] STATE_STOP  = 3;
	reg [1:0] state;
	reg bitmode;
	
	//reset states when reset
	initial begin
		state        <= 0;
		bitmode      <= 0;
		bit_cntr_rst <= 1;
	end
	
	always @ (posedge rateclk) begin
		case (state)
		
			STATE_IDLE: begin
				rts_out <= 0;
				txd_out <= 1;
				
				//Reset bit counter for further counting
				bit_cntr_rst <= 1;
				bit_cntr_ce  <= 0;
				
				//Reset stopbit counter for further counting
				stopbit_cntr_rst <= 1;
				stopbit_cntr_ce  <= 0;
				
				state <= STATE_START;
			end
		
			STATE_START: begin
				//Send a start bit
				rts_out <= 1;
				txd_out <= 0;
				state   <= STATE_SEND;
				
				//Flip bitmode
				bitmode <= ~bitmode;
			end
			
			STATE_SEND: begin
				//Enable bit counter
				bit_cntr_rst <= 0;
				bit_cntr_ce  <= 1;
				
				//Send the right bit
				txd_out <= bitmode;
				
				if( (!sw4 && WORD_LENGHT_7 == bit_cntr_data) || (sw4 && WORD_LENGHT_8 == bit_cntr_data) ) begin
						//Set state
						state <= STATE_STOP;
						
						//Reset bit counter for further counting
						bit_cntr_rst <= 1;
						bit_cntr_ce  <= 0;
				end
			end
			
			STATE_STOP: begin
				//Enable bit counter
				stopbit_cntr_rst <= 0;
				stopbit_cntr_ce  <= 1;
				
				//Send a stop bit
				txd_out <= 1;
				
				if( (!sw5 && STOP_BITS_1 == stopbit_cntr_data) || (sw5 && STOP_BITS_2 == stopbit_cntr_data) ) begin
						//Set state
						state <= STATE_IDLE;
						
						//Reset stopbit counter for further counting
						stopbit_cntr_rst <= 1;
						stopbit_cntr_ce  <= 0;
				end
			end
		
		endcase
	end
	
endmodule