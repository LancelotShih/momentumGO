module playerFSM(
    input clock,
    input reset,
    input directionLeft, input directionRight,
    input directionUp, input directionDown,
    input bombEnable, 
    input stunnedEffect,
    output reg bombRequested,
    output reg [5:0]positionX,
    output reg [5:0]positionY,
    output reg [3:0]animationAction
);
    
     localparam stationary = 4'd0, 
                moveLEFT = 4'd1,
                moveRIGHT = 4'd2,
                moveUP = 4'd3, 
                moveDOWN = 4'd4,
                stunned = 4'd5,
                stunTimer = 4'd6;


    //need a FSM state switcher 
    //the states are as follows: stationary, moving left, moving right, moving up, moving down, stunned. 
    // stunned is like an interrupt that is triggered from stundetector's stunnedEffect. 
    //The WASD states are all accessible from eachother, updated based on direction
    reg [5:0] current_state, next_state;

    always@(*)
    begin: state_FFs
        if(!Reset) begin
            positionX <= 0;
            positionY <= 0;
            current_state <= stationary;
        end
        else if(stunnedEffect) begin
            current_state <= stunned;
        end
         else if (directionUp) begin
            current_state <= moveUP;
         end
         else if (directionRight) begin
            current_state <= moveRIGHT;
         end
         else if (directionLeft) begin
            current_state <= moveLEFT;
         end
         else if (directionDown) begin
            current_state <= moveDOWN;
         end

        else
            current_state <= next_state;


    end // state_FFS


    always@(*)
    begin //output logic


            case (current_state)
            stationary: begin
                //do nothing
            end
            moveLEFT: begin
                if(positionX > 0 && positionX < 15)
                positionX <= positionX - 1;
                else 
                //animation trigger
            end
            moveRIGHT: begin
                if(positionX > 0 && positionX < 15)
                positionX <= positionX + 1;
                else 
                //animation trigger
            end
            moveUP: begin
                if(positionY > 0 && positionY < 15)
                positionY <= positionY + 1;
                else 
                //animation trigger
            end
            moveDOWN: begin
                if(positionY > 0 && positionY < 15)
                positionY <= positionY - 1;
                else 
                //animation trigger

            end
            stunned: begin
                //animation trigger
            end
            
            

        endcase
    end // state_table            


    
    //datapath: it should consistently output the positions regardless of state. However, bombRequested is a specific state output and the animations may be configured based on direction? I imagine player should face that way on screen 
    // additionally, the position must increment depending on the direction. 
    //players are allowed to overlap! This results in an empty square case which must be handled in GameBoard. 
    //must bound movement to the 16x16 space.  

endmodule



module playerAnimation(
    input clock,
    input reset,
    input stunnedEffect,
    input bombEnable,
    output reg [3:0]animationAction

);


endmodule