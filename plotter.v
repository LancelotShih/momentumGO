module plotter( input reset,
                input clk,
                output reg [2:0] colour,
                output reg [7:0]xPixel,
                output reg [6:0]yPixel,
                output reg writeEn
                ); 

    reg counter;

    always @ (posedge clk) begin

        

        if (!reset) begin 
            writeEn <= 1;
            colour <= 3'b110;
            xPixel <= 0;
            yPixel <= 0

        end

        yPixel <= yPixel + 1;
        xPixel <= xPixel + 1;

        if (xPixel == 100)
            writeEn <= 0;

    end


endmodule