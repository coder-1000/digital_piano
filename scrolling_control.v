//fsm to control scrolling texts
module scrolling_control(clk, reset, draw1, draw2, draw3, draw4, battle, casual, delay, restart, display_select, colour_select, finish_draw1, finish_draw2, finish_draw3, finish_draw4, 
finish_update, finish_delay, wren1, wren2, wren3, wren4, load, update, shift1, shift2, shift3);
	input clk, reset, finish_delay, battle, casual, finish_draw1, finish_draw2, finish_draw3, finish_draw4, finish_update;
	output reg restart, draw1, draw2, draw3, draw4, delay, load, update, wren1, wren2, wren3, wren4, shift1, shift2, shift3;
	output reg [2:0] display_select, colour_select; 
	
	reg [4:0] current_state, next_state; 
	
	localparam 	 INIT             = 5'd0,
					 DELAY            = 5'd1,
					 RESET_DRAW1      = 5'd2,
                DRAW1        	   = 5'd3,
					 RESET_DRAW2      = 5'd4,
					 DRAW2            = 5'd5,
					 RESET_DRAW3      = 5'd6,
					 DRAW3 				= 5'd7,
					 RESET_DRAW4      = 5'd8,
					 DRAW4				= 5'd9,
					 BUFFER           = 5'd10,
					 RESET_UPDATE1    = 5'd11,
                UPDATE1			   = 5'd12,
					 RESET_UPDATE2    = 5'd13,
					 UPDATE2				= 5'd14,
					 RESET_UPDATE3    = 5'd15,
					 UPDATE3				= 5'd16,
					 RESET_UPDATE4    = 5'd17,
					 UPDATE4				= 5'd18;

	
	//current state register
	always @(posedge clk)
	begin
		//reset 
		if(reset)
			current_state <= INIT;
		else begin
			//start game if in battle/casual mode and screen finishes drawing
			current_state <= next_state;
		end
	end
	
	//next state state tables
	always @(*)
	begin
		case(current_state)
			INIT: begin
						if(battle | casual)
							next_state = DELAY;
						else //stay in current state if not in battle or casual modes
							next_state = INIT;
					end
			DELAY: next_state = finish_delay ? RESET_DRAW1 : DELAY; //setup game and give player time to be ready (instructions)
			RESET_DRAW1: next_state = DRAW1;
			DRAW1: begin
						if(battle | casual)
							next_state = finish_draw1 ? RESET_DRAW2 : DRAW1; //draw a letter on screen for a few moments before erasing
						else 
							next_state = INIT;
					end
			RESET_DRAW2: next_state = DRAW2;
			DRAW2: begin	
						if(battle | casual)
							next_state = finish_draw2 ? RESET_DRAW3 : DRAW2;
						else
							next_state = INIT;
					end
			RESET_DRAW3: next_state = DRAW3;
			DRAW3: begin 
						if(battle | casual)
							next_state = finish_draw3 ? RESET_DRAW4: DRAW3;
						else
							next_state = INIT;
					end
			RESET_DRAW4: next_state = DRAW4;
			DRAW4: begin
						if(battle | casual)
							next_state = finish_draw4 ? BUFFER : DRAW4;
						else
							next_state = INIT;
					end
			BUFFER: next_state = finish_delay ? RESET_UPDATE1 : BUFFER;
			RESET_UPDATE1: next_state = UPDATE1;
			UPDATE1: next_state = finish_update ? RESET_UPDATE2 : UPDATE1;
			RESET_UPDATE2: next_state = UPDATE2;
			UPDATE2: next_state = finish_update ? RESET_UPDATE3 : UPDATE2;
			RESET_UPDATE3: next_state = UPDATE3;
			UPDATE3: next_state = finish_update ? RESET_UPDATE4 : UPDATE3;
			RESET_UPDATE4: next_state = UPDATE4;
			UPDATE4: next_state = finish_update ? RESET_DRAW1 : UPDATE4;
			default: next_state = INIT;
		endcase
	end
	
	//current state output logics
	always @(*)
	begin
	//default signals to 0
		case(current_state)
			INIT: begin
						restart = 1'b0;
						draw1 = 1'b0;
						draw2 = 1'b0;
						draw3 = 1'b0;
						draw4 = 1'b0;
						delay = 1'b0;
						load = 1'b0;
						update = 1'b0;
						wren1 = 1'b0;
						wren2 = 1'b0;
						wren3 = 1'b0;
						wren4 = 1'b0;
						shift1 = 1'b0;
						shift2 = 1'b0;
						shift3 = 1'b0;
						display_select = 3'b0; //switch to reading from game img ram
						colour_select = 3'b0; //switch to reading from game img ram
						//display_select_scroll = 3'b0;
						//display_select_error = 3'b0;
						
					 end
			DELAY: begin
						restart = 1'b0;
						draw1 = 1'b0;
						draw2 = 1'b0;
						draw3 = 1'b0;
						draw4 = 1'b0;
						delay = 1'b1;
						load = 1'b0;
						update = 1'b0;
						wren1 = 1'b0;
						wren2 = 1'b0;
						wren3 = 1'b0;
						wren4 = 1'b0;
						shift1 = 1'b0;
						shift2 = 1'b0;
						shift3 = 1'b0;
						display_select = 3'b0; //switch to reading from game img ram
						colour_select = 3'b0; //switch to reading from game img ram
					 end
			RESET_DRAW1: begin
						restart = 1'b1;
						draw1 = 1'b0;
						draw2 = 1'b0;
						draw3 = 1'b0;
						draw4 = 1'b0;
						delay = 1'b0;
						load = 1'b0;
						update = 1'b0;
						wren1 = 1'b0;
						wren2 = 1'b0;
						wren3 = 1'b0;
						wren4 = 1'b0;
						shift1 = 1'b0;
						shift2 = 1'b0;
						shift3 = 1'b0;
						display_select = 3'd1; //switch to reading from game img ram
						colour_select = 3'd1; //switch to reading from game img ram
					 end
		   DRAW1: begin
						restart = 1'b0;
						draw1 = 1'b1;
						draw2 = 1'b0;
						draw3 = 1'b0;
						draw4 = 1'b0;
						delay = 1'b0;
						load = 1'b0;
						update = 1'b0;
						wren1 = 1'b0;
						wren2 = 1'b0;
						wren3 = 1'b0;
						wren4 = 1'b0;
						shift1 = 1'b0;
						shift2 = 1'b0;
						shift3 = 1'b0;
						display_select = 3'd1; //switch to reading from game img ram
						colour_select = 3'd1; //switch to reading from game img ram
					end
			RESET_DRAW2: begin
						restart = 1'b1;
						draw1 = 1'b0;
						draw2 = 1'b0;
						draw3 = 1'b0;
						draw4 = 1'b0;
						delay = 1'b0;
						load = 1'b0;
						update = 1'b0;
						wren1 = 1'b0;
						wren2 = 1'b0;
						wren3 = 1'b0;
						wren4 = 1'b0;
						shift1 = 1'b0;
						shift2 = 1'b0;
						shift3 = 1'b0;
						display_select = 3'd1; //switch to reading from game img ram
						colour_select = 3'd1; //switch to reading from game img ram
					end
			DRAW2: begin
						restart = 1'b0;
						draw1 = 1'b0;
						draw2 = 1'b1;
						draw3 = 1'b0;
						draw4 = 1'b0;
						delay = 1'b0;
						load = 1'b0;
						update = 1'b0;
						wren1 = 1'b0;
						wren2 = 1'b0;
						wren3 = 1'b0;
						wren4 = 1'b0;
						shift1 = 1'b0;
						shift2 = 1'b0;
						shift3 = 1'b0;
						display_select = 3'd1; //switch to reading from game img ram
						colour_select = 3'd2; //switch to reading from game img ram
					end
			RESET_DRAW3: begin
						restart = 1'b1;
						draw1 = 1'b0;
						draw2 = 1'b0;
						draw3 = 1'b0;
						draw4 = 1'b0;
						delay = 1'b0;
						load = 1'b0;
						update = 1'b0;
						wren1 = 1'b0;
						wren2 = 1'b0;
						wren3 = 1'b0;
						wren4 = 1'b0;
						shift1 = 1'b0;
						shift2 = 1'b0;
						shift3 = 1'b0;
						display_select = 3'd1; //switch to reading from game img ram
						colour_select = 3'd2; //switch to reading from game img ram
					end
			DRAW3: begin
						restart = 1'b0;
						draw1 = 1'b0;
						draw2 = 1'b0;
						draw3 = 1'b1;
						draw4 = 1'b0;
						delay = 1'b0;
						load = 1'b0;
						update = 1'b0;
						wren1 = 1'b0;
						wren2 = 1'b0;
						wren3 = 1'b0;
						wren4 = 1'b0;
						shift1 = 1'b0;
						shift2 = 1'b0;
						shift3 = 1'b0;
						display_select = 3'd1; //switch to reading from game img ram
						colour_select = 3'd3; //switch to reading from game img ram
					end
			RESET_DRAW4: begin
						restart = 1'b1;
						draw1 = 1'b0;
						draw2 = 1'b0;
						draw3 = 1'b0;
						draw4 = 1'b0;
						delay = 1'b0;
						load = 1'b0;
						update = 1'b0;
						wren1 = 1'b0;
						wren2 = 1'b0;
						wren3 = 1'b0;
						wren4 = 1'b0;
						shift1 = 1'b0;
						shift2 = 1'b0;
						shift3 = 1'b0;
						display_select = 3'd1; //switch to reading from game img ram
						colour_select = 3'd3; //switch to reading from game img ram
					end
			DRAW4: begin
						restart = 1'b0;
						draw1 = 1'b0;
						draw2 = 1'b0;
						draw3 = 1'b0;
						draw4 = 1'b1;
						delay = 1'b0;
						load = 1'b0;
						update = 1'b0;
						wren1 = 1'b0;
						wren2 = 1'b0;
						wren3 = 1'b0;
						wren4 = 1'b0;
						shift1 = 1'b0;
						shift2 = 1'b0;
						shift3 = 1'b0;
						display_select = 3'd1; //switch to reading from game img ram
						colour_select = 3'd4; //switch to reading from game img ram
					end
			BUFFER: begin
						restart = 1'b0;
						draw1 = 1'b0;
						draw2 = 1'b0;
						draw3 = 1'b0;
						draw4 = 1'b0;
						delay = 1'b1;
						load = 1'b0;
						update = 1'b0;
						wren1 = 1'b0;
						wren2 = 1'b0;
						wren3 = 1'b0;
						wren4 = 1'b0;
						shift1 = 1'b0;
						shift2 = 1'b0;
						shift3 = 1'b0;
						display_select = 3'd1; //switch to reading from game img ram
						colour_select = 3'd4; //switch to reading from game img ram
					end
			RESET_UPDATE1: begin
						restart = 1'b1;
						draw1 = 1'b0;
						draw2 = 1'b0;
						draw3 = 1'b0;
						draw4 = 1'b0;
						delay = 1'b0;
						load = 1'b1;
						update = 1'b0;
						wren1 = 1'b0;
						wren2 = 1'b0;
						wren3 = 1'b0;
						wren4 = 1'b0;
						shift1 = 1'b0;
						shift2 = 1'b0;
						shift3 = 1'b0;
						display_select = 3'd5; //default
						colour_select = 3'd5; //default
					end
			UPDATE1: begin
							restart = 1'b0;
							draw1 = 1'b0;
							draw2 = 1'b0;
							draw3 = 1'b0;
							draw4 = 1'b0;
							delay = 1'b0;
							load = 1'b0;
							update = 1'b1;
							wren1 = 1'b0;
							wren2 = 1'b0;
							wren3 = 1'b0;
							wren4 = 1'b1;
							shift1 = 1'b0;
							shift2 = 1'b0;
							shift3 = 1'b1;
							display_select = 3'd5; //default
							colour_select = 3'd5; //default 
						end
			RESET_UPDATE2: begin
							restart = 1'b1;
							draw1 = 1'b0;
							draw2 = 1'b0;
							draw3 = 1'b0;
							draw4 = 1'b0;
							delay = 1'b0;
							load = 1'b0;
							update = 1'b0;
							wren1 = 1'b0;
							wren2 = 1'b0;
							wren3 = 1'b0;
							wren4 = 1'b0;
							shift1 = 1'b0;
							shift2 = 1'b0;
							shift3 = 1'b0;
							display_select = 3'd5; //default
							colour_select = 3'd5; //default 
						end
			UPDATE2: begin
							restart = 1'b0;
							draw1 = 1'b0;
							draw2 = 1'b0;
							draw3 = 1'b0;
							draw4 = 1'b0;
							delay = 1'b0;
							load = 1'b0;
							update = 1'b1;
							wren1 = 1'b0;
							wren2 = 1'b0;
							wren3 = 1'b1;
							wren4 = 1'b0;
							shift1 = 1'b0;
							shift2 = 1'b1;
							shift3 = 1'b0;
							display_select = 3'd5; //default
							colour_select = 3'd5; //default 
						end
			RESET_UPDATE3: begin
							restart = 1'b1;
							draw1 = 1'b0;
							draw2 = 1'b0;
							draw3 = 1'b0;
							draw4 = 1'b0;
							delay = 1'b0;
							load = 1'b0;
							update = 1'b0;
							wren1 = 1'b0;
							wren2 = 1'b0;
							wren3 = 1'b0;
							wren4 = 1'b0;
							shift1 = 1'b0;
							shift2 = 1'b0;
							shift3 = 1'b0;
							display_select = 3'd5; //default
							colour_select = 3'd5; //default 
						end
			UPDATE3: begin
							restart = 1'b0;
							draw1 = 1'b0;
							draw2 = 1'b0;
							draw3 = 1'b0;
							draw4 = 1'b0;
							delay = 1'b0;
							load = 1'b0;
							update = 1'b1;
							wren1 = 1'b0;
							wren2 = 1'b1;
							wren3 = 1'b0;
							wren4 = 1'b0;
							shift1 = 1'b1;
							shift2 = 1'b0;
							shift3 = 1'b0;
							display_select = 3'd5; //default
							colour_select = 3'd5; //default 
						end
			RESET_UPDATE4: begin
							restart = 1'b1;
							draw1 = 1'b0;
							draw2 = 1'b0;
							draw3 = 1'b0;
							draw4 = 1'b0;
							delay = 1'b0;
							load = 1'b0;
							update = 1'b0;
							wren1 = 1'b0;
							wren2 = 1'b0;
							wren3 = 1'b0;
							wren4 = 1'b0;
							shift1 = 1'b0;
							shift2 = 1'b0;
							shift3 = 1'b0;
							display_select = 3'd5; //default
							colour_select = 3'd5; //default 
						end
			UPDATE4: begin
							restart = 1'b0;
							draw1 = 1'b0;
							draw2 = 1'b0;
							draw3 = 1'b0;
							draw4 = 1'b0;
							delay = 1'b0;
							load = 1'b0;
							update = 1'b1;
							wren1 = 1'b1;
							wren2 = 1'b0;
							wren3 = 1'b0;
							wren4 = 1'b0;
							shift1 = 1'b0;
							shift2 = 1'b0;
							shift3 = 1'b0;
							display_select = 3'd5; //default
							colour_select = 3'd5; //default 
						end
			default: begin
							restart = 1'b0;
							draw1 = 1'b0;
							draw2 = 1'b0;
							draw3 = 1'b0;
							draw4 = 1'b0;
							delay = 1'b0;
							load = 1'b0;
							update = 1'b0;
							wren1 = 1'b0;
							wren2 = 1'b0;
							wren3 = 1'b0;
							wren4 = 1'b0;
							shift1 = 1'b0;
							shift2 = 1'b0;
							shift3 = 1'b0;
							display_select = 3'b0; //switch to reading from game img ram
							colour_select = 3'b0; //switch to reading from game img ram
					   end
		endcase
	end
endmodule
