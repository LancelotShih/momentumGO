module VGA_Square_Drawer(
    input wire clk,
    input wire reset,
    output reg [2:0] VGA_R,
    output reg [2:0] VGA_G,
    output reg [2:0] VGA_B,
    output reg VGA_HS,
    output reg VGA_VS,
    output reg VGA_BLANK_N,
    output reg VGA_SYNC_N
);
    reg [11:0] counter_x;
    reg [10:0] counter_y;
    reg [1:0] state;

    // Set VGA resolution
    localparam WIDTH = 640;
    localparam HEIGHT = 480;

    // Square position and size
    reg [9:0] square_x;
    reg [8:0] square_y;
    localparam SQUARE_SIZE = 4;

    // Colors for the square
    reg [2:0] square_color_r;
    reg [2:0] square_color_g;
    reg [2:0] square_color_b;

    // Animation speed and direction
    localparam SPEED = 2;
    localparam DIRECTION = 1; // 0 for right, 1 for down, 2 for left, 3 for up

    // VGA signal generation
    always @(posedge clk) begin
        if (reset) begin
            counter_x <= 0;
            counter_y <= 0;
            state <= 2'b00;
        end else begin
            counter_x <= counter_x + 1;
            counter_y <= counter_y + 1;

            // Horizontal sync and blank signals
            VGA_HS <= (counter_x >= WIDTH) ? 1 : 0;
            VGA_BLANK_N <= VGA_HS;

            // Vertical sync and blank signals
            VGA_VS <= (counter_y >= HEIGHT) ? 1 : 0;
            VGA_SYNC_N <= VGA_VS;

            // Square drawing logic
            case (state)
                2'b00: begin  // Draw the square
                    square_x <= counter_x[9:0];
                    square_y <= counter_y[8:0];

                    square_color_r <= 3'b111; // Red
                    square_color_g <= 3'b000; // Green
                    square_color_b <= 3'b000; // Blue
                end
                2'b01: begin  // Erase the square
                    square_color_r <= 3'b000;
                    square_color_g <= 3'b000;
                    square_color_b <= 3'b000;
                end
            endcase

            // State transition
            if (counter_x == WIDTH && counter_y == HEIGHT) begin
                state <= (state == 2'b01) ? 2'b00 : 2'b01;
                counter_x <= 0;
                counter_y <= 0;
            end
        end
    end

    // Assign colors to VGA outputs
    always @(posedge clk) begin
        VGA_R <= VGA_HS ? square_color_r : 3'b000;
        VGA_G <= VGA_HS ? square_color_g : 3'b000;
        VGA_B <= VGA_HS ? square_color_b : 3'b000;
    end
endmodule
