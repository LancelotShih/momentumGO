module bomb(clk, positionX, positionY, color, bombDropped, bombX, bombY, bombExploded) 
    input clk;
    input [5:0] positionX, positionY;
    input color;
    input bombDropped;

    output [5:0] bombX, bombY;
    output bombExploded;
    
    always @(posedge clk) begin
        if (bombDropped == 1) begin
            bombX <= positionX;
            bombY <= positionY;
            bombExploded <= 1;
        end
    end

endmodule