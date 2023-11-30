// module PS2Keyboard (
//     input wire clk,
//     input wire rst,
//     input wire ps2_clk,
//     input wire ps2_data,
//     output wire [7:0] key_data,
//     output wire key_valid
// );

//     reg [10:0] shift_reg;
//     reg [7:0] key_data_reg;
//     reg key_valid_reg;

//     always @(posedge clk or posedge rst) begin
//         if (rst) begin
//             shift_reg <= 11'b0;
//             key_data_reg <= 8'b0;
//             key_valid_reg <= 1'b0;
//         end
//         else begin
//             // Shift in PS/2 data on each rising edge of the clock
//             shift_reg <= {ps2_data, shift_reg[10:1]};
            
//             // Check for start bit (0) and stop bit (1) to detect a valid PS/2 packet
//             if ((shift_reg[0] == 1'b0) && (shift_reg[1] == 1'b1)) begin
//                 key_data_reg <= shift_reg[8:1]; // Extract 8-bit key data
//                 key_valid_reg <= 1'b1;
//             end
//             else begin
//                 key_valid_reg <= 1'b0; // Invalidate data if start bit is not detected
//             end
//         end
//     end

//     assign key_data = key_data_reg;
//     assign key_valid = key_valid_reg;

// endmodule


module PS2Input(PS2_CLK, PS2_DAT, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR[9:0]);
    input PS2_CLK;
    input PS2_DAT;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    output [9:0] LEDR;

    reg [31:0] blueButtons = 32'b10101100010111010101110010011101;
    reg [7:0] stop = 8'b00011111;
    reg [31:0] redButtons  = 32'b01110000011100011011000110001000;

    reg [31:0] keyboard = 0;
    reg [4:0] counter = 9;
    reg sendEnable;
    // output [7:0] recievedData;
    // output recievedEnable;

    always @(negedge PS2_CLK) begin
        keyboard = (keyboard << 1) | PS2_DAT;
        if (counter == 0) begin
            sendEnable <= 1;
            counter <= 7;
        end
        else begin
            sendEnable <= 0;
            counter <= counter - 1;
        end
    end

    // PS2_Controller u0(CLOCK_50, 0, keyboard[7:0], sendEnable, PS2_CLK, PS2_DAT, receivedData, recievedEnable);
    //wire w1, w2, w3, w4;

    // hex_decoder u1(keyboard[4:1], HEX0);
    // hex_decoder u2(keyboard[8:5], HEX1);
    // hex_decoder u3(keyboard[15:12], HEX2);
    // hex_decoder u4(keyboard[19:16], HEX3);
    // hex_decoder u5(keyboard[26:23], HEX4);
    // hex_decoder u6(keyboard[30:27], HEX5); // we want to make sure that this is the one we read

// we can run the ps2 hex output at the same time the normal game is running
    // output reg [5:0] readCounter = 32;
    // always@(negedge PS2_CLK) begin
    //     if(readCounter == 0) begin
    //         PS2decoder u0(PS2_CLK, keyboard, blueButtons, stop, LEDR[0], LEDR[1], LEDR[2], LEDR[3]);
    //         PS2decoder u1(PS2_CLK, keyboard, redButtons, stop, LEDR[5], LEDR[6], LEDR[7], LEDR[8]);
    //         readCounter = 32;
    //     end
    //     else if (readCounter != 0) begin
    //         readCounter <= readCounter - 1;
    //     end
    // end

    PS2decoder u7(sendEnable, PS2_CLK, keyboard, blueButtons, stop, LEDR[0], LEDR[1], LEDR[2], LEDR[3]);
    PS2decoder u8(sendEnable, PS2_CLK, keyboard, redButtons, stop, LEDR[5], LEDR[6], LEDR[7], LEDR[8]);

    // hex_decoder u1(w1, HEX0);
    // hex_decoder u2(w2, HEX1);
    // hex_decoder u3(w4, HEX2);
    // hex_decoder u4(w3, HEX3);


endmodule

// module hex_decoder(c, display);
// 	input [3:0] c;
// 	output [6:0] display;
	
// 	assign display[0] = (c[0] & !c[1] & !c[2] & !c[3]) + (!c[0] & !c[1] & c[2] & !c[3]) + (c[0] & c[1] & !c[2] & c[3]) + (c[0] & !c[1] & c[2] & c[3]);
// 	assign display[1] = (c[0] & !c[1] & c[2] & !c[3]) + (!c[0] & c[1] & c[2] & !c[3]) + (c[0] & c[1] & !c[2] & c[3]) + (!c[0] & !c[1] & c[2] & c[3]) + (!c[0] & c[1] & c[2] & c[3]) + (c[0] & c[1] & c[2] & c[3]);
// 	assign display[2] = (!c[0] & c[1] & !c[2] & !c[3]) + (!c[0] & !c[1] & c[2] & c[3]) + (!c[0] & c[1] & c[2] & c[3]) + (c[0] & c[1] & c[2] & c[3]);
// 	assign display[3] = (c[0] & !c[1] & !c[2] & !c[3]) + (!c[0] & !c[1] & c[2] & !c[3]) + (c[0] & c[1] & c[2] & !c[3]) + (!c[0] & c[1] & !c[2] & c[3]) + (c[0] & c[1] & c[2] & c[3]);
// 	assign display[4] = (c[0] & !c[1] & !c[2] & !c[3]) + (c[0] & c[1] & !c[2] & !c[3]) + (!c[0] & !c[1] & c[2] & !c[3]) + (c[0] & !c[1] & c[2] & !c[3]) + (c[0] & c[1] & c[2] & !c[3]) + (c[0] & !c[1] & !c[2] & c[3]);
// 	assign display[5] = (c[0] & !c[1] & !c[2] & !c[3]) + (!c[0] & c[1] & !c[2] & !c[3]) + (c[0] & c[1] & !c[2] & !c[3]) + (c[0] & c[1] & c[2] & !c[3]) + (c[0] & !c[1] & c[2] & c[3]);
// 	assign display[6] = (!c[0] & !c[1] & !c[2] & !c[3]) + (c[0] & !c[1] & !c[2] & !c[3]) + (c[0] & c[1] & c[2] & !c[3]) + (!c[0] & !c[1] & c[2] & c[3]);
	
// endmodule

module PS2decoder(sendEnable, clk, keyboard, colorButtons, stop, directionLeft, directionRight, directionUp, directionDown);
    input sendEnable;
    input clk;  
    input [31:0] keyboard;
    input [31:0] colorButtons;
    input [7:0] stop;

    output reg directionLeft = 0;
    output reg directionRight = 0;
    output reg directionUp = 0;
    output reg directionDown = 0;

    always@(posedge sendEnable) begin
        if(keyboard[8:1] == colorButtons[31:24] && keyboard[17:9] != stop) begin // insert bit representation here for LEFT
            directionLeft <= 1;
            directionRight <= 0;
            directionUp <= 0;
            directionDown <= 0; 
        end
        else if (keyboard[8:1] == colorButtons[23:16] && keyboard[17:9] != stop) begin // insert bit representation here for RIGHT
            directionLeft <= 0;
            directionRight <= 1;
            directionUp <= 0;
            directionDown <= 0;
        end
        else if (keyboard[8:1] == colorButtons[15:8] && keyboard[17:9] != stop) begin// insert bit representation here for UP
            directionLeft <= 0;
            directionRight <= 0;
            directionUp <= 1;
            directionDown <= 0;
        end
        else if (keyboard[8:1] == colorButtons[7:0] && keyboard[17:9] != stop) begin// insert bit representation here for DOWN
            directionLeft <= 0;
            directionRight <= 0;
            directionUp <= 0;
            directionDown <= 1;
        end
        // else if (keyboard[30:18] == stop) begin// resets if direction input to be 0 otherwise
        //     directionLeft <= 0;
        //     directionRight <= 0;
        //     directionUp <= 0;
        //     directionDown <= 0;
        // end
        else begin// resets if direction input to be 0 otherwise
            directionLeft <= 0;
            directionRight <= 0;
            directionUp <= 0;
            directionDown <= 0;
        end
    end

endmodule