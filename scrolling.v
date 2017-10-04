//rng generates a number and each update state copies previous ram data into next ram
module scrolling (clk, reset, restart, wren1, wren2, wren3, wren4, finish_update, q1, q2, q3, q4, load, update, shift1, shift2, shift3, scancode_out, draw1, draw2, draw3, draw4);
	//declear I/O ports
	input clk, reset, restart, wren1, wren2, wren3, wren4, load, update, shift1, shift2, shift3, draw1, draw2, draw3, draw4;
	output finish_update;
	output [2:0] q1, q2, q3, q4;
	output [7:0] scancode_out;
	
	//internal wires
	wire [3:0] address;
	wire [9:0] initial_x, x;
	wire [8:0] initial_y, y;
	wire [18:0] mem_address;
	wire [2:0] dataout;
	wire [7:0] w1, w2, w3, w4, w5; 
	
	//instantiate modules
	lsfr u0(.clock(clk), .reset(reset), .rnd(address));
	letter_select u1(.clk(clk), .address(address), .load(load), .initial_x(initial_x), .initial_y(initial_y), .data_out(w1));
	text_shift1 m0(.clk(clk), .reset(reset), .datain(w1), .dataout(w2), .load(load));
	text_shift2 m1(.clk(clk), .reset(reset), .datain(w2), .dataout(w3), .shift1(shift1));
	text_shift3 m2(.clk(clk), .reset(reset), .datain(w3), .dataout(w4), .shift2(shift2));
	text_shift4 m3(.clk(clk), .reset(reset), .datain(w4), .dataout(w5), .shift3(shift3));
	text_module_counter u2(.clk(clk), .reset(reset), .initial_x(initial_x), .initial_y(initial_y), .x(x), .y(y), .update(update), .restart(restart));
	textmodule_address_translator u3(.x(x), .y(y), .mem_address(mem_address));
	textmodule_ram u4(.address(mem_address), .clock(clk), .data(3'b0), .wren(1'b0), .q(dataout));
	text_ram u5(.clk(clk), .reset(reset), .restart(restart), .wren1(wren1), .wren2(wren2), .wren3(wren3), .wren4(wren4), .q(dataout), .finish_update(finish_update), .q1(q1), .q2(q2), .q3(q3), .q4(q4), .draw1(draw1), .draw2(draw2), .draw3(draw3), .draw4(draw4), .update(update));
	
	//assign outputs
	assign scancode_out = w5;
endmodule
	