module gameBoardFSM(red_X, red_Y, blue_X, blue_Y, clock, reset, 
                    redBombPlaced, blueBombPlaced, redBomb_X, redBomb_Y, blueBomb_X, blueBomb_Y,
                    oRed_X, oRed_Y, oBlue_X, oBlue_Y,
                    oColour, writeMemoryRed, writeMemoryBlue, readMemory, 
                    draw_background, draw_foreground,
                    address_Red, address_Blue,
                    draw_enable, plot_enable
                    );

input [3:0] red_X, red_Y, blue_X, blue_Y, redBomb_X, redBomb_Y, blueBomb_X, blueBomb_Y;
input redMoved, blueMoved, clock, reset, 
redBombPlaced, blueBombPlaced;
output oRed_X, oRed_Y, oBlue_X, oBlue_Y;
output [2:0] oColour1, oColour2;
output writeMemoryRed, writeMemoryBlue, readMemory, draw_background, draw_foreground;
output [8:0]red_address, blue_address; 

localparam Idle = 10'd0,
            StartWriting = 10'd ,
            WriteBoard = 10'd,
            StartDrawBackground = 10'd ,
            DrawBackground = 10'd,
            StartDrawForeground = 10'd ,
            DrawForeground = 10'd,
            frame1 = 10'd,
            frame2 = 10'd,
            frame3 = 10'd,
            frame4 = 10'd,
            frame5 = 10'd;

reg [10:0] current_state, next_state;

reg doneWriting, doneBackground, 

// positionToAddress converter1(red_X, red_Y, red_address);
// positionToAddress converter2(blue_X, blue_Y, blue_address);

always@(*)
begin: state_transition_table
    case (current_state)
        Idle: begin
            if(redMoved || blueMoved || redBombPlaced || blueBombPlaced) begin
                next_state <= WriteBoard;
            end    
            
        end

        WriteBoard: begin
            if(doneWriting)
            next_state <= DrawBackground;
            else
            next_state <= WriteBoard;
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
            else if (doneBackground )
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
            next_state <= Idle;
            else 
            next_state <= frame5;
        end
    endcase


    
    always @(*)
    begin: output_logic
        // By default make all our signals 0
        

        case (current_state)

           WriteBoard: begin
            //position to address convert
            //write enable for both ports
            //check if they are same
            //write colours
            //all happens in one tick? 
           //determine address based on x and y positions, then write.
            writeMemoryRed <= 1;
            writeMemoryBlue <= 1;

           end

           DrawBackground: begin
            

           end

        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals

    
        // current_state registers
        always@(posedge clk)
        begin: state_FFs
            if(!Reset) begin
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