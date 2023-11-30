//module for creating a box that alternates colour at 60 Hz



    module november28printtest
    	(
    		CLOCK_50,						//	On Board 50 MHz
    		// Your inputs and outputs here
    		KEY,							// On Board Keys
    		// The ports below are for the VGA output.  Do not change.
    		VGA_CLK,   						//	VGA Clock
    		VGA_HS,							//	VGA H_SYNC
    		VGA_VS,							//	VGA V_SYNC
    		VGA_BLANK_N,						//	VGA BLANK
    		VGA_SYNC_N,						//	VGA SYNC
    		VGA_R,   						//	VGA Red[9:0]
    		VGA_G,	 						//	VGA Green[9:0]
    		VGA_B,   						//	VGA Blue[9:0]
    		LEDR
    	);

    	input			CLOCK_50;				//	50 MHz
    	input	[3:0]	KEY;					
    	// Declare your inputs and outputs here
    	// Do not change the following outputs
    	output			VGA_CLK;   				//	VGA Clock
    	output			VGA_HS;					//	VGA H_SYNC
    	output			VGA_VS;					//	VGA V_SYNC
    	output			VGA_BLANK_N;				//	VGA BLANK
    	output			VGA_SYNC_N;				//	VGA SYNC
    	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
    	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
    	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
    	output [3:0]LEDR;
	
    	wire resetn;
    	assign resetn = KEY[0];
	
    	// Create the colour, x, y and writeEn wires that are inputs to the controller.

    	wire [2:0] colour;
    	wire [9:0] x;
    	wire [8:0] y;
    	wire writeEn;

    	// Create an Instance of a VGA controller - there can be only one!
    	// Define the number of colours as well as the initial background
    	// image file (.MIF) for the controller.
    	vga_adapter VGA(
    			.resetn(resetn),
    			.clock(CLOCK_50),
    			.colour(colour),
    			.x(x),
    			.y(y),
    			.plot(plot_enable),
    			/* Signals for the DAC to drive the monitor. */
    			.VGA_R(VGA_R),
    			.VGA_G(VGA_G),
    			.VGA_B(VGA_B),
    			.VGA_HS(VGA_HS),
    			.VGA_VS(VGA_VS),
    			.VGA_BLANK(VGA_BLANK_N),
    			.VGA_SYNC(VGA_SYNC_N),
    			.VGA_CLK(VGA_CLK));
    		defparam VGA.RESOLUTION = "320x240";
    		defparam VGA.MONOCHROME = "FALSE";
    		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
    		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	
    	wire draw_enable;
		wire plot_enable;
    	wire [9:0]initial1;
    	wire [8:0]initial2;
    	wire finishedDrawingSignal;

    	//communication variables to VGA are colour, draw_enable
	
    	// 	draw D1(.clock(CLOCK_50), .reset(!KEY[0]), .enable_draw(draw_enable), .initial_xPosition(initial1), .initial_yPosition(initial2), .xOutput(x), .yOutput(y), .finished(finishedDrawingSignal) );
    // 	simpleBoardFSM B1(.idleLED(LEDR[0]), .trigger(!KEY[1]), .colour(colour), .clock(CLOCK_50), .reset(!KEY[0]), .draw_enable(draw_enable), .initial_xPosition(initial1), .initial_yPosition(initial2), .finished(finishedDrawingSignal));

	
    	simpleBoardFSM simple(.idleLED(LEDR[1]), .trigger(!KEY[1]), .colour(colour), .clock(CLOCK_50), .reset(!KEY[0]), .draw_enable(draw_enable), .plot_enable(plot_enable), .initial_xPosition(initial1), .initial_yPosition(initial2), .finished(finishedDrawingSignal));
    	draw draw1(.clock(CLOCK_50), .reset(!KEY[0]), .enable_draw(draw_enable), .initial_xPosition(initial1), .initial_yPosition(initial2), .xOutput(x), .yOutput(y), .finished(finishedDrawingSignal));
	
    	assign LEDR[0] = plot_enable;

    endmodule

// module topLevel(CLOCK_50, KEY, LEDR, x, y, colour, draw_enable, enable_plot);

// 	output wire [2:0] colour;
// 	output wire [9:0] x;
// 	output wire [8:0] y;
// 	output [3:0] LEDR;
	
	
// 	input CLOCK_50;
// 	input [3:0] KEY;
		
// 	output draw_enable;
// 	output enable_plot;
// 	wire [9:0]initial1;
// 	wire [8:0]initial2;
// 	wire finishedDrawingSignal;

// 	assign LEDR[0] = draw_enable;

// 	draw D1(.clock(CLOCK_50), .reset(!KEY[0]), .enable_draw(draw_enable), .initial_xPosition(initial1), .initial_yPosition(initial2), .xOutput(x), .yOutput(y), .finished(finishedDrawingSignal) );
// 	simpleBoardFSM B1(.idleLED(LEDR[0]), .trigger(!KEY[1]), .colour(colour), .clock(CLOCK_50), .reset(!KEY[0]), .draw_enable(draw_enable), .plot_enable(enable_plot), .initial_xPosition(initial1), .initial_yPosition(initial2), .finished(finishedDrawingSignal));

// endmodule

//  module positionReceiver();
//  endmodule

//  module addressToScreenPosition();
//  endmodule
// //



module draw(clock, reset, enable_draw, initial_xPosition, initial_yPosition, xOutput, yOutput, finished );
	
	localparam WIDTH = 40;
	
	input clock, reset;
	input enable_draw;
	input [9:0]initial_xPosition;
	input [8:0]initial_yPosition;

	output [9:0]xOutput;
	output [8:0]yOutput;
	output reg finished = 0;
	
	reg [20:0]yCounter = 0;
	reg [9:0]movingX = 0;
	reg [8:0]movingY = 0;

	assign xOutput = movingX + initial_xPosition;
	assign yOutput = movingY + initial_yPosition;
	
	//increment X
	always @(posedge clock) begin

		if(reset || finished)begin
			movingX <= 0;
		end
		else if (enable_draw) begin 
			if(movingX == WIDTH - 1) begin //width - 1
				movingX <= 0;
			end 
			else begin
				movingX <= movingX + 1;
			end
			
		end
	end

	//increment Y
	always @(posedge clock) begin
		
		if(reset || finished)begin
			movingY <= 0;
			finished <= 0;
		end
		else if (enable_draw) begin
			if(yCounter == WIDTH * WIDTH - 1) begin // width * 10 - 1
				yCounter <= 0;
				movingY <= 0;
				finished <= 1;
			end
			else if((yCounter+1) % WIDTH == 0 && yCounter != 0)begin // replace 10 with width
				movingY <= movingY + 1;
				yCounter <= yCounter + 1;
			end
			else begin
				yCounter <= yCounter + 1;
			end
		end
	end
endmodule


module simpleBoardFSM(idleLED, trigger, colour, clock, reset, draw_enable, plot_enable, initial_xPosition, initial_yPosition, finished);


	localparam  Idle = 10'd1,
				DRAW1_START = 10'd2,
				DRAW1 = 10'd3,
				WAIT1 = 10'd4,
				DRAW2_START = 10'd5,
				DRAW2 = 10'd6,
				WAIT2 = 10'd7;

	input trigger, clock, reset, finished;
	output reg idleLED = 1;

	output reg [2:0] colour;
	output [9:0]initial_xPosition;
	output [8:0]initial_yPosition;
	output reg draw_enable = 0;
	output reg plot_enable = 0;

	reg [9:0] initialX;
	reg [8:0] initialY;
	reg [9:0]current_state, next_state;

	//buffering for 60Hz 
	
	reg reset_buffer = 0;
	reg enable_buffer = 0;
	wire done_buffering;

	buffer b1(.clk(clock), .reset(reset_buffer), .enable(enable_buffer), .done(done_buffering));

	assign initial_xPosition = initialX;
	assign initial_yPosition = initialY;

	///
	always@(*) begin: state_transition_table
		case(current_state)
			Idle: begin
				if(trigger)
				next_state <= DRAW1_START;
				else
				next_state <= Idle;
			end

			DRAW1_START: begin
				next_state <= DRAW1;
			end

			DRAW1: begin
				if(finished)
				next_state <= WAIT1;
				else
				next_state <= DRAW1; 

			end

			WAIT1: begin
				if(done_buffering)
				next_state <= DRAW2_START;
				else
				next_state <= WAIT1;
			end

			DRAW2_START: begin
				next_state <= DRAW2;
			end


			DRAW2: begin
				if(finished)
				next_state <= WAIT2;
				else
				next_state <= DRAW2; 

			end

			WAIT2: begin 
				if(done_buffering)
				next_state <= DRAW1_START;
				else
				next_state <= WAIT2;
			end
		endcase 
	end

	///
	always@(*) begin: output_logic 

		idleLED <= 0;
		colour <= 3'b000;

		case(current_state)
			Idle: begin
				draw_enable <= 0;
				plot_enable <= 0;
				idleLED <= 1;
			end

			DRAW1_START: begin
				colour <= 3'b001;
				plot_enable <= 1;
				reset_buffer <= 1;
				initialX <= 20;
				initialY <= 20;
			end

			DRAW2_START: begin
				colour <= 3'b100;
				plot_enable <= 1;
				reset_buffer <= 1;
				initialX <= 20;
				initialY <= 20;
			end

			DRAW1: begin //BLUE
				draw_enable <= 1;
				colour <= 3'b100;
				reset_buffer <= 0;
				enable_buffer <= 1;
			end

			DRAW2: begin //RED
				draw_enable <= 1;
				colour <= 3'b001;
				reset_buffer <= 0;
				enable_buffer <= 1;
			end

			WAIT1: begin 
				draw_enable <= 0;
				plot_enable <= 0;
				enable_buffer <= 1;
			end

			WAIT2: begin
				draw_enable <= 0;
				plot_enable <= 0;
				enable_buffer <= 1;
			end
		endcase
	end

	// current_state registers
    always@(posedge clock)
    begin: state_FFs
        if(reset) begin
            current_state <= Idle;
        end
        else
            current_state <= next_state;
    end // state_FFS


endmodule



module buffer(clk, reset, enable, done);

	input clk, reset, enable;
	output reg done = 0;

	reg [40:0] buffer_counter = 0;

	always@(posedge clk)
	begin: wait_time
		if(reset)
		begin
			done <= 0;
			buffer_counter <= 0;
		end 

		else if(enable)
		begin
			if(buffer_counter == 50000000  - 1) //60Hz = 50000000 / 60 - 1
			begin
				done <= 1;
				buffer_counter <= 0;
			end
			else begin
			done <= 0;
			buffer_counter <= buffer_counter + 1;
			end
		end
	end
endmodule



module buffer_short(clk, reset, enable, done);

	input clk, reset, enable;
	output reg done;

	reg [3:0] buffer_counter = 0;

	always@(posedge clk)
	begin: pulse_time
		if(reset)
		begin
			done <= 0;
			buffer_counter <= 0;
		end 

		else if(enable)
		begin
			if(buffer_counter == 5)
			begin
				done <= 1;
				buffer_counter <= 0;
			end
			else begin
			done <= 0;
			buffer_counter <= buffer_counter + 1;
			end
		end
	end
endmodule