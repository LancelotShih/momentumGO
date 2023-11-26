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


module PS2Input(PS2_CLK, PS2_DAT, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input PS2_CLK;
    input PS2_DAT;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    reg [31:0] keyboard = 0;
    always @(negedge PS2_CLK) begin
        keyboard = (keyboard << 1) | PS2_DAT;
    end

    hex_decoder u1(keyboard[4:1], HEX0);
    hex_decoder u2(keyboard[8:5], HEX1);
    hex_decoder u3(keyboard[15:12], HEX2);
    hex_decoder u4(keyboard[19:16], HEX3);
    hex_decoder u5(keyboard[26:23], HEX4);
    hex_decoder u6(keyboard[30:27], HEX5); // we want to make sure that this is the one we read

// we can run the ps2 hex output at the same time the normal game is running

endmodule

module PS2decoder(clk, keyboard, directionLeft, directionRight, directionUp, directionDown);
    input clk;
    input [31:0] keyboard;

    output reg directionLeft = 0 
    output reg directionRight = 0
    output reg directionUp = 0
    output reg directionDown = 0;

    always@(posedge clk) begin
        if(keyboard[30:27] == 1101010101) // insert bit representation here for LEFT
            directionLeft <= 1;
            directionRight <= 0;
            directionUp <= 0;
            directionDown <= 0;
        else if (keyboard[30:27] == 1101010101) // insert bit representation here for RIGHT
            directionLeft <= 0;
            directionRight <= 1;
            directionUp <= 0;
            directionDown <= 0;
        else if (keyboard[30:27] == 1101010101) // insert bit representation here for UP
            directionLeft <= 0;
            directionRight <= 0;
            directionUp <= 1;
            directionDown <= 0;
        else if (keyboard[30:27] == 1101010101) // insert bit representation here for DOWN
            directionLeft <= 0;
            directionRight <= 0;
            directionUp <= 0;
            directionDown <= 1;
        else // resets if direction input to be 0 otherwise
            directionLeft <= 0 
            directionRight <= 0
            directionUp <= 0
            directionDown <= 0;
    end

end