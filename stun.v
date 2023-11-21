module stunDetector (#parameter N = 50000000) (clk, bombPos, redPos, bluePos, bombEnable, redStunEnable, blueStunEnable);
    input clk;
    
    input [9:0][8:0] bombPos;
    input [9:0][8:0] redPos;
    input [9:0][8:0] bluePos;

    input bombEnable;

    output reg redStunEnable;
    output reg blueStunEnable;


    always @(posedge clk) begin
        
        if(checkRedStun == 1) begin
            redStunEnable <= 1;
        end // need to implement a counter so they're not just perma dead lol
        if(checkBlueStun == 1) begin
            blueStunEnable <= 1;
        end

    end

    output reg [5:0] counterR = (N * 5) - 1;
    output reg [5:0] counterB = (N * 5) - 1;
    

// handle blue stun timer
    always @(posedge clk) begin
        
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

// handle red stun timer
    always @(posedge clk) begin
        
        if(counterR == 0 && redStunEnable) begin
            redStunEnable <= 0;
        end
        else if (redStunEnable) begin
            counterR <= counterR - 1
        end
        else begin
            counterR <= (N * 5) - 1;
        end

    end 


endmodule


module checkRedStun(RbombPosX, RbombPosY, redPosX, redPosY, redStunEnable)
    // 9 cases for 3x3 blast radius
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
    // note there is no turn off redStunEnable here, that is done through the counter
    // stunEnable either remains off, or turns on until turned off by the counter

endmodule

module checkBlueStun(BbombPosX, BbombPosY, bluePosX, bluePosY, blueStunEnable)
    // 9 cases for 3x3 blast radius
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
    // note there is no turn off blueStunEnable here, that is done through the counter
    // stunEnable either remains off, or turns on until turned off by the counter

endmodule