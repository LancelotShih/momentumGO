

//addressCounter AC1 (.clock(CLOCK_50), .reset(!KEY[0]), .enable( ), .done( ), .address( ), .doneAll( ), .LIMIT( ));
//
//addressToPosition ATP1 ( );
//positionToPixel PTP1 ();

//BRAM B1 (address_a, address_b, clock, data_a, data_b, rden_a, rden_b, wren_a, wren_b, q_a, q_b);
 //BRAM (address_a,address_b,clock,data_a,data_b,rden_a,rden_b,wren_a,wren_b,q_a,q_b);

 module addressCounter (clock, reset, enable, done, address, doneAll);

 	input clock, reset, enable, done;
 	output reg [8:0] address;
	output reg doneAll; 
	
	
	always@(posedge clock) 
	begin: address_counter
		if(reset)
		begin
			doneAll <= 0;
			address <= 0;
		end
		else if(enable && done) //
		begin
			if(address == 255) begin
				doneAll <= 1;
				address <= 0;
			end
			else begin
				doneAll <= 0;
				address <= address + 1;
			end
		end
	end
 endmodule


module addressToPosition(address, positionX, positionY);
    input [8:0]address;
    output [3:0]positionX;
    output [3:0]positionY;

    assign positionX = address % 16;
    assign positionY = (address - positionX) / 16;
endmodule


module positionToAddress(positionX, positionY, address);
    input [3:0]positionX, positionY;
    output [8:0]address;

    assign address = 16 * positionY + positionX;
endmodule

module positionToPixel(positionX, positionY, pixelX, pixelY);

	input[3:0] positionX, positionY;
	output [9:0] pixelX;
	output [8:0] pixelY;

	localparam SPACING = 2;
	localparam WIDTH = 10;

	assign pixelX = positionX * WIDTH + SPACING * (positionX) ; 
	assign pixelY = positionY * WIDTH + SPACING * (positionY) ;
	

endmodule