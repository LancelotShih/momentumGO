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

    
    



endmodule



module playerAnimation(
    input clock,
    input reset,
    input stunnedEffect,
    input bombEnable,
    output reg [3:0]animationAction

);


endmodule