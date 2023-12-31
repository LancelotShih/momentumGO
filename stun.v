module stunDetector (#parameter N = 50000000) (clk, RbombPosX, RbombPosY, BbombPosX, BbombPosY, redPosX, bluePosX, redPosY, bluePosY, bombEnable, redStunEnable, blueStunEnable, stunIndicator);
    input clk;
    
    input [5:0] RbombPosX, RbombPosY;
    input [5:0] BbombPosX, BbombPosY;
    input [5:0] redPosX, redPosY;
    input [5:0] bluePosX, bluePosY;

    input bombExploded;

    output reg redStunEnable = 0;
    output reg blueStunEnable = 0;
    output stunIndicator = 0;


    // always @(posedge clk) begin
        
    //     if(redStunEnable == 1) begin
    //         redStunEnable <= 1;
    //     end // need to implement a counter so they're not just perma dead lol
    //     if(checkBlueStun == 1) begin
    //         blueStunEnable <= 1;
    //     end

    // end



    output reg [27:0] counterR = (N * 5) - 1;
    output reg [27:0] counterB = (N * 5) - 1;
    
// handle blue stun timer
    always @(posedge clk) begin
        if(bombExploded) begin
            if(counterB == 0 && blueStunEnable) begin
                blueStunEnable <= 0;
            end
            else if (blueStunEnable) begin
                counterB <= counterB - 1
            end
            else begin
                counterB <= (N * 5) - 1;
            end
        end
    end 

// handle red stun timer
    always @(posedge clk) begin
        
        if(counterR == 0 && redStunEnable) begin
            redStunEnable <= 0;
        end
        else if (redStunEnable) begin
            counterR <= counterR - 1
            stunIndicator <= 1;
        end
        else begin
            counterR <= (N * 5) - 1;
        end

    end 

    checkRedStun R1(RbombPosX, RbombPosY, redPosX, redPosY, redStunEnable);
    checkBlueStun B1(BbombPosX, BbombPosY, bluePosX, bluePosy, blueStunEnable);

endmodule

// module stunCountdownvisual(clk, stunIndicator, numbers);
//     input clk, stunIndicator;
//     output numbers;

//     always @(posedge clk) begin
//         if (stunIndicator)
//             // turn the player that got stunned to the color purple? or some other indicator works too

// endmodule


module checkRedStun(clk, RbombPosX, RbombPosY, redPosX, redPosY, redStunEnable)
    // 9 cases for 3x3 blast radius
    always @(posedge clk) begin
        input [5:0] bombPosX, bombPosY, redPosX, redPosY;
        output redStunEnable;
        if( (redPosX == bombPosX && redPosY == bombPosY) ||  (redPosX == bombPosX && redPosY == bombPosY + 1) || (redPosX == bombPosX && redPosY == bombPosY - 1) ) begin
            redStunEnable <= 1; // checks middle column
        end
        else if ( (redPosX - 1 == bombPosX && redPosY == bombPosY) ||  (redPosX - 1 == bombPosX && redPosY == bombPosY + 1) || (redPosX - 1 == bombPosX && redPosY == bombPosY - 1) ) begin
            redStunEnable <= 1; // checks left column
        end
        else if ( (redPosX + 1 == bombPosX && redPosY == bombPosY) ||  (redPosX + 1 == bombPosX && redPosY == bombPosY + 1) || (redPosX + 1 == bombPosX && redPosY == bombPosY - 1) ) begin
            redStunEnable <= 1; // checks right column
        end
    end
    // note there is no turn off redStunEnable here, that is done through the counter
    // stunEnable either remains off, or turns on until turned off by the counter

endmodule

module checkBlueStun(BbombPosX, BbombPosY, bluePosX, bluePosY, blueStunEnable)
    // 9 cases for 3x3 blast radius
    always @(posedge clk) begin
        input [5:0] bombPosX, bombPosY, bluePosX, bluePosY;
        output bluedStunEnable;
        if( (bluePosX == bombPosX && bluePosY == bombPosY) ||  (bluePosX == bombPosX && bluePosY == bombPosY + 1) || (bluePosX == bombPosX && bluePosY == bombPosY - 1) ) begin
            blueStunEnable <= 1; // checks middle column
        end
        else if ( (bluePosX - 1 == bombPosX && bluePosY == bombPosY) ||  (bluePosX - 1 == bombPosX && bluePosY == bombPosY + 1) || (bluePosX - 1 == bombPosX && bluePosY == bombPosY - 1) ) begin
            bluedStunEnable <= 1; // checks left column
        end
        else if ( (bluePosX + 1 == bombPosX && bluePosY == bombPosY) ||  (bluePosX + 1 == bombPosX && bluePosY == bombPosY + 1) || (bluePosX + 1 == bombPosX && bluePosY == bombPosY - 1) ) begin
            blueStunEnable <= 1; // checks right column
        end
    end
    // note there is no turn off blueStunEnable here, that is done through the counter
    // stunEnable either remains off, or turns on until turned off by the counter

endmodule