module gameBoardFSM(red_X, red_Y, blue_X, blue_Y, clock, reset, 
                    redBombPlaced, blueBombPlaced, redBomb_X, redBomb_Y, blueBomb_X, blueBomb_Y,
                    oRed_X, oRed_Y, oBlue_X, oBlue_Y,
                    oColour, writeMemoryRed, writeMemoryBlue, readMemory, 
                    draw_background, draw_foreground,
                    address_Red, address_Blue,
                    draw_enable, plot_enable, count255_enable,
                    finished
                    );

input [3:0] red_X, red_Y, blue_X, blue_Y, redBomb_X, redBomb_Y, blueBomb_X, blueBomb_Y;
input clock, reset, 
redBombPlaced, blueBombPlaced;
output oRed_X, oRed_Y, oBlue_X, oBlue_Y;
output [2:0] oColour1, oColour2;
output writeMemory, readMemory, draw_background, draw_foreground;
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

reg doneWriting, doneBackground, 

// positionToAddress converter1(red_X, red_Y, red_address);
// positionToAddress converter2(blue_X, blue_Y, blue_address);

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
            next_state <= WriteBlue;
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
        
        writeMemory <= 0;

        case (current_state)

            StartWriting: begin
                writeMemory <= 1;
            end

            WriteRed: begin
                writeMemory <= 1;
                
                if(red_address == blue_address)begin
                    address_a <= 
                    data_a <= 3'b110; //let Yellow be NULL colour
                end
                else begin
                    data_a <= 3'b100;
                end
            end

            WriteBlue: begin
                writeMemory <= 1;
                
                if(red_address == blue_address)begin
                    data_b <= 3'b110;
                end
                else begin
                    data_b <= 3'b001;
                end
            end

            StartDrawBackground: begin
                //reset 
                //prepares to start the counter from 0-255
                writeMemory <= 0;
                readMemory <= 1; // there should be one read port with its corresponding address. 
                plot_enable <= 1;

            end

            DrawBackground: begin
                count255_enable <= 1;
                plot_enable <= 1;
                if(finished)
                draw_enable <= 0;
                reset_draw <= 1;
                else begin
                draw_enable <= 1;
                reset_draw <= 0;
                end
                
            end

        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals

    
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



//  reg [2:0] write_counter = 0;

//     always@(posedge clk)
//     begin: write_state_holding_clock //so that it can guarantee no timing problems with writing to BRAM

//         if(reset) begin
//         counter <= 0;
//         doneWriting <= 0;
//         end

//         else if(current_state == WriteBoard) begin
//             if(write_counter == 3) begin
//                 write_counter <= 0;
//                 doneWriting <= 1;
//             end
//             else begin
//                 write_counter <= write_counter + 1;
//             end
//         end
//     end


// module rate_divider #(parameter division = 0) (

// 	input wire clk, //50 Mhz
// 	output reg divided_clk = 0
	
// );

// reg[2:0] counter_value = 0;



// always @ (posedge clk) begin

// 	//division is 2^ (n+1)
// 	if (counter_value == division) 
// 	counter_value <= 0;
// 	else
// 	counter_value <= counter_value + 1;

// end

// always @ (posedge clk) begin
	
// 	if(counter_value == division)
// 	divided_clk <= !divided_clk;
// end
// endmodule

