
 module addressCounter(clock, reset, enable, done, address, doneAll)

 	input clk, reset, enable, done;
 	output [10:0] address;
	output doneAll; 
	
	
	always@(posedge clock) 
	begin: address_counter
		if(reset || doneAll)
		begin
			doneAll <= 0;
			address <= 0;
		end
		else if(enable && done) //
		begin
			if(address_counter == 255) begin
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
    input [3:0]positionX, [3:0]positionY;
    output [8:0]address;

    assign address = 9'd(16 * positionY + positionX);
endmodule

