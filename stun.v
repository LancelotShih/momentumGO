module stunDetector(bombPos, bombPos, redPos, clk, bombEnable, redStunEnable, blueStunEnable);
    input [9:0][8:0] bombPos;
    input [9:0][8:0] redPos;
    input [9:0][8:0] bluePos;

    input clk;
    input bombEnable;

    output redStunEnable;
    output blueStunEnable;



    function void checkRedStun(int x, int y, reg [7:0] item);
        if (x >= 0 && x < WIDTH && y >= 0 && y < HEIGHT) begin
            board[x][y] = item;
        end
    endfunction

    always @(posedge clk) begin
        
        if(checkRedStun == 1) begin
            redStunEnable <= 1;
        end // need to implement a counter so they're not just perma dead lol
        if(checkBlueStun == 1) begin
            blueStunEnable <= 1;
        end



    end


endmodule