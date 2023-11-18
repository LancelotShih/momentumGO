module gameBoard;
    parameter WIDTH = 16;
    parameter HEIGHT = 16;
    reg [2:0] board [0:HEIGHT-1][0:WIDTH-1]; // 16x16 2D array of 3-bit values
    // For the 3 bit values, they can represent
    // 1 nobody is on this square
    // 2 square is taken by red
    // 3 square is taken by blue
    // 4 red is sitting on this square
    // 5 blue is sitting on this square
    // 6 red bomb is sitting on this square
    // 7 blue bomb is sitting on this square

    function void initBoard;
        for (int i = 0; i < WIDTH; i = i + 1) begin
            for (int j = 0; j < HEIGHT; j = j + 1) begin
                board[i][j] = 8'b00000000; // Initialize to some default value
            end
        end
    endfunction

    function 


    always @(posedge clk) begin
        if(reset)
            initBoard;
    end

endmodule
