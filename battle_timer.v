//modules controls timer for battle mode. Divide 50 Mhz on board clock to 1 second enables
module battle_timer(clk, reset, battle, timer, restart);
	//declear I/O ports
	input clk, reset, battle, restart;
	output timer;
	reg enable;
	reg [31:0] counter;
	
	//1 minute counter
	always @(posedge clk)
	begin
		//reset counter to 0
		if(reset | restart) begin
			counter <= 0;
			enable <= 0;
		end
		else if(battle) begin
			if(counter == 32'd2999999999) begin //2999999999
				counter <= 0;
				enable <= 1'b1;
			end
			else begin
				counter <= counter + 32'd1;
			end
		end
	end
	
	//determine whether 1 minute has reached
	assign timer = (enable == 1'b1) ? 1'b1 : 1'b0;
endmodule
			