module gameBoardFSM(
                    clock, reset, 
                    red_X, red_Y, blue_X, blue_Y, 
                    redBombPlaced, blueBombPlaced, redBomb_X, redBomb_Y, blueBomb_X, blueBomb_Y,
                    oRed_X, oRed_Y, oBlue_X, oBlue_Y,

                    oColour, plot_enable,

                    writeMemory, readMemory, 
                    address_Red, address_Blue,

                    draw_enable_background, draw_enable_foreground, count255_enable, reset_counter255, 

                    finished
                    );

input clock, reset;
input redBombPlaced, blueBombPlaced;
input [3:0] red_X, red_Y, blue_X, blue_Y, redBomb_X, redBomb_Y, blueBomb_X, blueBomb_Y;


output oRed_X, oRed_Y, oBlue_X, oBlue_Y, address_Red, address_Blue;
output [2:0] oColour;
output plot_enable;


output writeMemory, readMemory, draw_enable_background, draw_enable_foreground;
output [8:0]red_address, blue_address; 

localparam Idle = 10'd0,
            StartWriting = 10'd1,
            WriteRed = 10'd2,
            WriteBlue = 10'd3 ,
            StartDrawBackground = 10'd4 ,
            DrawBackground = 10'd5,
            StartDrawForeground = 10'd6 ,
            DrawForeground = 10'd7,
            frame1 = 10'd8,
            frame2 = 10'd9,
            frame3 = 10'd10,
            frame4 = 10'd11,
            frame5 = 10'd12;

reg [10:0] current_state, next_state;

wire doneWriting, doneBackground; //corresponding to short buffer and buffer respectively
reg reset_buffer, buffer_enable;
reg reset_short_buffer, buffer_short_enable;

buffer_short BS1(.clk(), .reset(), .enable(), .done(doneWriting));
buffer B1(.clk(), .reset(), .enable(), .done(doneBackground));


always@(*)
begin: state_transition_table
    case (current_state)
        Idle: begin
            
                next_state <= WriteBoard;
                
            
        end
        StartWritingRed: begin
            next_state <= WriteRed;
        end
        WriteRed: begin
            if(doneWriting) //need to have a condition for doneWriting 
            next_state <= StartWritingBlue;
            else
            next_state <= WriteRed;
        end

        StartWritingBlue: begin
            next_state <= WriteBlue;
        end


        WriteBlue: begin
            if(doneWriting)
            next_state <= DrawBackground;
            else
            next_state <= WriteBlue;
        end

        DrawBackground: begin
            // note that the frame 
            
            if (doneframe1 && doneBackground)
            next_state <= frame2;
            else if (doneframe2 && doneBackground)
            next_state <= frame3;
            else if (doneframe3 && doneBackground)
            next_state <= frame4;
            else if(doneframe4 && doneBackground)
            next_state <= frame5;
            else if (doneframe5 && doneBackground )
            next_state <= DrawForeground;
            else if(doneBackground)
            next_state <= DrawForeground;
            else 
            next_state <= DrawBackground;
        end

        DrawForeground: begin
            if(startFrame1)
            next_state <= frame1;
            else
            next_state <= DrawForeground;
        end

        frame1: begin
            if(doneframe1)
            next_state <= DrawBackground;
            else 
            next_state <= frame1;
        end

        frame2:begin
            if(doneframe2)
            next_state <= DrawBackground;
            else 
            next_state <= frame2;
        end

        frame3: begin
            if(doneframe3)
            next_state <= DrawBackground;
            else 
            next_state <= frame3;
        end

        frame4: begin
            if(doneframe4)
            next_state <= DrawBackground;
            else 
            next_state <= frame4;
        end

        frame5: begin
            if(doneframe5)
            next_state <= DrawBackground;
            else 
            next_state <= frame5;
        end
    endcase

    //BRAM (address_a,address_b,clock,data_a,data_b,rden_a,rden_b,wren_a,wren_b,q_a,q_b);
    //positionToAddress(positionX, positionY, address);

    positionToAddress RedPosToAddress(red_X, red_Y, red_address);
    positionToAddress BluePosToAddress(blue_X, blue_Y, blue_address);

    reg [2:0] data_a; //RED
    reg [2:0] data_b; //BLUE

    
    always @(*)
    begin: output_logic
        // By default make all our signals 0
        

        case (current_state)

            //writing states //////////////////////////////////////////////////////////
            StartWritingRed: begin
                writeMemory <= 1;
            end

            WriteRed: begin
                writeMemory <= 1;
                address_a <= red_address; 

                if(red_address == blue_address)begin
                    
                    data_a <= 3'b110; //let Yellow be NULL colour
                end
                else begin
                    data_a <= 3'b100;
                end
            end

            StartWritingBlue: begin
                writeMemory <= 1;
            end

            WriteBlue: begin
                writeMemory <= 1;
                address_a <= blue_address;
                
                if(red_address == blue_address)begin
                    
                    data_b <= 3'b110;
                end
                else begin
                    data_b <= 3'b001;
                end
            end
            ////////////////////////////////////////////////////////////////////////////


            //drawing background states /////////////////////////////////////////////////////////////
            StartDrawBackground: begin
                //reset 
                //prepares to start the counter from 0-255
                reset_counter255 <= 1;
                writeMemory <= 0;
                readMemory <= 1; // there should be one read port with its corresponding address. 
                plot_enable <= 1;

            end

            ResetBackgroundDraw: begin
                //goes to this state upon receiving finished. Always sends back to Drawbackground.
                reset_draw <= 1;
                draw_enable_background <= 0;
                reset_counter255 <= 0;
            end

            DrawBackground: begin //either goes to Reset or goes to next state if done all is high
                count255_enable <= 1;
                plot_enable <= 1;
                draw_enable_background <= 1;
                reset_draw <= 0;
            end

            
            /////////////////////////////////////////////////////////////////////////////////

        endcase
    end 

        // current_state registers
        always@(posedge clk)
        begin: state_FFs
            if(reset) begin
                current_state <= Idle;
            end
            else
                current_state <= next_state;
        end // state_FFS
    end
endmodule


module draw(clock, reset, enable_draw, initial_xPosition, initial_yPosition, xOutput, yOutput, finished );
	
	localparam WIDTH = 10'd40;
	
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
//
	//increment Y
	always @(posedge clock) begin
		
		if(reset || finished)begin
			movingY <= 0;
			finished <= 0;
			yCounter <= 0;
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
			if(buffer_counter == 50000000 - 1) //60Hz = 50000000 / 60 - 1
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