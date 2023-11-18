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
    
    //need a FSM state switcher 
    //the states are as follows: stationary, moving left, moving right, moving up, moving down, stunned. 
    // stunned is like an interrupt that is triggered from stundetector's stunnedEffect. 
    //The WASD states are all accessible from eachother, updated based on direction

    
    //datapath: it should consistently output the positions regardless of state. However, bombRequested is a specific state output and the animations may be configured based on direction? I imagine player should face that way on screen 
    // additionally, the position must increment depending on the direction. 
    //players are allowed to overlap! This results in an empty square case which must be handled in GameBoard. 
    //must bound movement to the 16x16 space.  

    localparam stationary = 0, 
                moveLEFT = 1,
                moveRIGHT = 2,
                moveUP = 3, 
                moveDOWN = 4,
                stunned = 5;

    



endmodule



module playerAnimation(
    input clock,
    input reset,
    input stunnedEffect,
    input bombEnable,
    output reg [3:0]animationAction

);


endmodule