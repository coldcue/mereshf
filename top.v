`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineers:  Toth Andras / Szell Andras
// 
// Create Date:    11:42:27 10/06/2013 
// Module Name:    uart 
// Project Name: MeresLabor1 HF
// Description: 
// Soros adó egység (UART)
//
// Realizálás: FPGA méropanelen
//
// A soros adó egység start és stop bittel keretezett, speciális karakterpárosokat ad a panel aszinkron soros portjának TXD vonalán az RS232/V24 szabvány eloírásainak megfeleloen (lásd 3. mérés dokumentáció). (A Start bit 0 értéku, a Stop bit 1 értéku, a megfelelo jelszinteket az FPGA panelbe épített szintkonverter áramkör biztosítja.).
// Az egység adást a BTN1 gomb minden megnyomására kiad egy karakterpárost. Az adás megkezdésekor a soros port RTS vonalát ON állapotba kapcsolja, majd az utolsó karakter kiadása után a vonalat visszakapcsolja OFF állapotba (az RTS vonal a panelen nincs kivezetve, de funkcionálisan helyesen kell megvalósítani).
//
// Az adatátvitel paraméterei:
// Az egység egymás után felváltva 000...0 és 111...1 karaktert ad.
// A karakterek az SW4 kapcsoló OFF állásában 7 bitesek, ON állásában 8 bitesek.
// A stop bitek száma az SW5 kapcsoló állásától függoen 1 vagy 2.
// A Baud-rate 2400 vagy 9600, értéke az SW8 kapcsolóval választható.
//
// Kötelezo szinkron rendszer tervezése, azaz az összes FF órajel bemenetére az 50 MHz-es rendszerórajelet kell kötni!
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
