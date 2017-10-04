//display game states on vga depending on which mode user is in according to the FSM
//NOTE: READ_ONLY MODE FOR RAM 
module game_img_ram(clk, address, datain, init, menu, battle, casual, restart, dataout);
	//declear I/O ports
	input clk, init, menu, battle, casual, restart;
	input [18:0] address;
	input [2:0] datain;
	output [2:0] dataout;
	wire [2:0] dataout1, dataout2, dataout3, dataout4;
	reg [2:0] dataout5;
	
	//declear ram modules
	start_img u0(.address(address), .clock(clk), .data(datain), .wren(1'b0), .q(dataout1));
	//menu_img u1(.address(address), .clock(clk), .data(datain), .wren(1'b0), .q(dataout2));
	background_img u2(.address(address), .clock(clk), .data(datain), .wren(1'b0), .q(dataout3));
	
	//select which ram to read from depending on the mode
	always @(*)
	begin
		if(init) //load start screen
			dataout5 = dataout1;
		else if(menu) //menu screen
			dataout5 = dataout2;
		else if(battle | casual) //game screen
			dataout5 = dataout3;
		//else if(restart) //restart screen
			//dataout5 = dataout4;
		else //start screen for default case
			dataout5 = dataout1;
	end
	
	//output contents at each memory address
	assign dataout = dataout5;
endmodule
