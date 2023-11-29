module VGASquareDrawer(	
		CLOCK_50,						//	On Board 50 MHz
		SW, 								// On Board Switches
		KEY,							   // On Board Keys
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,					//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						   //	VGA Blue[9:0]
	);

	input		    CLOCK_50;			//	50 MHz
	input	 [3:0] KEY;					// Keys
	input  [9:0] SW;					// Switches
	output		 VGA_CLK;   		//	VGA Clock
	output		 VGA_HS;				//	VGA H_SYNC
	output		 VGA_VS;				//	VGA V_SYNC
	output		 VGA_BLANK_N;		//	VGA BLANK
	output		 VGA_SYNC_N;		//	VGA SYNC
	output [7:0] VGA_R;   			//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output [7:0] VGA_G;	 			//	VGA Green[7:0]
	output [7:0] VGA_B;   			//	VGA Blue[7:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire 		  writeEn; 

	// Create an Instance of a VGA controller 
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	wire go, clear, plotKey;
	assign go = ~KEY[3];
	assign clear = ~KEY[2];
	assign plotKey = ~KEY[1];
	assign resetn = KEY[0];
	
	wire loadX = go;
	wire loadY, loadColour, blackEn, plotEn;
	wire [5:0] plotCounter;
	wire [7:0] xCounter;
	wire [6:0] yCounter;
	
	controlPath c(CLOCK_50, resetn, plotKey, clear, go, 
					  plotCounter, xCounter, yCounter, 
					  loadY, loadColour, writeEn, plotEn, blackEn);
	
	dataPath d(CLOCK_50, resetn, loadX, loadY, loadColour, 
				  plotEn, blackEn, SW[6:0], SW[9:7], 
				  x, y, colour, 
				  plotCounter, xCounter, yCounter);
endmodule

module controlPath(input clk, resetn, plotKey, clear, go, 
						 input [5:0] plotCounter,
						 input [7:0] xCounter,
						 input [6:0] yCounter,
						 output reg loadY, loadColour, plot, plotEn, blackEn );
	reg [2:0] currentSt, nextSt;
	
	localparam St0 = 3'b0,
				  St1 = 3'b001,
				  St1HOLD = 3'b010,
				  St2 = 3'b011,
				  DRAW = 3'b100,
				  BLK = 3'b101;

	//State Table
	always @(*)
	begin
		case(currentSt)
			BLK: begin
				if (xCounter != 8'd160 & yCounter != 7'd120) nextSt = BLK;
				else nextSt = St1HOLD;
			end
			St0: begin
				if (go == 1'b1) nextSt = St1;
				if (go == 1'b0) nextSt = St0; 
			end
			St1: nextSt = go ? St1 : St1HOLD;
			St1HOLD: begin
				if (clear == 1'b1) nextSt = BLK;
				if (plotKey == 1'b1) nextSt = St2;
				else if (resetn == 1'b0) nextSt = St1HOLD;
			end
			St2: nextSt = DRAW;
			DRAW: begin
				if (plotCounter <= 6'd15) nextSt = DRAW;
				else nextSt = St1HOLD;
			end
			default: nextSt = St1HOLD;
		endcase
	end 

	//Control signals
	always @(*)
	begin
		//reset all enable signals
		//loadX = 1'b0;
		loadY = 1'b0;
		loadColour = 1'b0; 
		plot = 1'b0; 
		plotEn = 1'b0;
		blackEn = 1'b0;
		
		case(currentSt)
			//St1: loadX = 1'b1;
			St2: begin
				loadY = 1'b1;
				loadColour = 1'b1;
			end
			DRAW: begin
				plot = 1'b1;
				plotEn = 1'b1;
				loadColour = 1'b1;
			end
			BLK: begin
				plot = 1'b1;
				blackEn = 1'b1;
			end
		endcase
	end

	// Control current state
   always @(posedge clk)
   begin
		if (!resetn) currentSt <= St1HOLD;
		else if (clear) currentSt <= BLK;
      else currentSt <= nextSt;
   end 
endmodule 

module dataPath(input clk, resetn, loadX, loadY, loadColour, plotEn, blackEn,
					 input [7:0] datain,
					 input [2:0] clr,
					 output reg [7:0] X,
					 output reg [6:0] Y,
					 output reg [2:0] CLR,
					 output reg [5:0] plotCounter,
					 output reg [7:0] xCounter,
					 output reg [6:0] yCounter );
	reg [6:0] xTemp, yTemp;
	always @(posedge clk) 
	begin
		if (!resetn) begin
			X <= 8'b0;
			Y <= 7'b0;
			CLR <= 3'b0;
			plotCounter <= 6'b0;
			xCounter <= 8'b0;
			yCounter <= 7'b0;
		end
		else begin
			if (loadX) begin
				X <= datain;
				xTemp <= datain; 
			end
			if (loadY) begin
				Y <= datain;
				yTemp <= datain; 
			end
			if (loadColour) begin
				CLR<=clr;
			end
			if (plotEn) begin
				if (plotCounter == 6'b10000) plotCounter <= 6'b0;
				else plotCounter <= plotCounter + 1;
				X <= xTemp + plotCounter[1:0];
				Y <= yTemp + plotCounter[3:2];
			end
			if (blackEn) begin
				if (xCounter == 8'd160 && yCounter != 7'd120) begin
					xCounter <= 8'b0;
					yCounter <= yCounter + 1;
				end
				else begin
					xCounter <= xCounter + 1;
				end
				X <= xCounter;
				Y <= yCounter;
				CLR <= 3'b0;
			end
		end
	end
endmodule