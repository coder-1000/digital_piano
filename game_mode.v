///datapath controls game mode transitions
module game_mode(clk, reset, battle, timer, init, menu, casual, restart, restart_scroll, restart_error, datain, dataout, x, y
, wren1, wren2, wren3, wren4, finish_update, load, update, shift1, shift2, shift3, key_in, color, draw1, draw2, draw3, draw4
, finish_draw1, finish_draw2, finish_draw3, finish_draw4, clear, draw_error, redraw_error, finish_error, display_select, color_select, delay, finish_delay, display_select_scroll, display_select_error, color_select_error, color_select_scroll, finish);
	//declear I/O ports
	input clk, reset, init, menu, battle, casual, restart, restart_scroll, restart_error, wren1, wren2, wren3, wren4, load, update
	,shift1, shift2, shift3, draw1, draw2, draw3, draw4, draw_error, redraw_error, delay;
	input [2:0] display_select, color_select, display_select_scroll, display_select_error, color_select_scroll, color_select_error;
	output timer, finish_update, color, clear, finish_draw1, finish_draw2, finish_draw3, finish_draw4, finish_error, finish_delay, finish;
	input [7:0] datain, key_in;
	output [2:0] dataout;
	output [9:0] x;
	output [8:0] y;
	
	//internal wires
	wire [9:0] w1;
	wire [8:0] w2;
	wire [18:0] w3;
	wire [7:0] scancode_out;
	wire [2:0] q0, q1, q2, q3, q4;
	wire [9:0] x2, x3;
	wire [8:0] y2, y3;
	
	//declear modules
	game_img_ram u0(.clk(clk), .address(w3), .datain(datain), .init(init), .menu(menu), .battle(battle), .casual(casual), .restart(restart), .dataout(q0));
	counter u1(.clk(clk), .reset(reset), .x(w1), .y(w2), .restart(restart));
	battle_timer u2(.clk(clk), .reset(reset), .battle(battle), .timer(timer), .restart(restart));
	frame_delay m0(.clk(clk), .reset(reset), .timer(finish), .restart(restart));
	delay_counter h0(.clk(clk), .reset(reset), .delay(delay), .finish(finish_delay), .restart(restart_scroll));
	vga_address_translator u3(.x(w1), .y(w2), .mem_address(w3));
	scrolling u4(.clk(clk), .reset(reset), .restart(restart_scroll), .wren1(wren1), .wren2(wren2), .wren3(wren3), .wren4(wren4), .finish_update(finish_update), .q1(q1), .q2(q2), .q3(q3), .q4(q4), .load(load), .update(update), .shift1(shift1), .shift2(shift2), .shift3(shift3), .scancode_out(scancode_out), .draw1(draw1), .draw2(draw2), .draw3(draw3), .draw4(draw4));
	text_draw u5(.clk(clk), .reset(reset), .restart(restart_scroll), .x(x2), .y(y2), .draw1(draw1), .draw2(draw2), .draw3(draw3), .draw4(draw4), .finish_draw1(finish_draw1), .finish_draw2(finish_draw2), .finish_draw3(finish_draw3), .finish_draw4(finish_draw4));
	error_delay u6(.clk(clk), .reset(reset), .restart(restart_error), .clear(clear));
	error_color u7(.clk(clk), .reset(reset), .restart(restart_error), .x_out(x3), .y_out(y3), .draw(draw_error), .redraw(redraw_error), .finish(finish_error));
	Error_checking u8(.reset(reset), .clk(clk), .data_in(key_in), .scan_code(scancode_out), .color_signal(color));
	display_counter_select u9(.x1(w1), .y1(w2), .x2(x2), .y2(y2), .x3(x3), .y3(y3), .xout(x), .yout(y), .display_select(display_select), .display_select_scroll(display_select_scroll), .display_select_error(display_select_error));
	color_select u10(.q0(q0), .q1(q1), .q2(q2), .q3(q3), .q4(q4), .qout(dataout), .color_select(color_select), .color_select_scroll(color_select_scroll), .color_select_error(color_select_error));
	
endmodule
