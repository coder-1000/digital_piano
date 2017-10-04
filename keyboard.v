//module takes in ps2_data, extracts its scan codes and assigns bin to the characters on the keyboard
//NOTE: PS_clk runs when a key is pressed/unpressed
module keyboard(clk, ps_clk, ps_data, key_out, hex_1, hex_2, scan_code);			
	//I/O
	input clk;
	input ps_data;
	input ps_clk;
	output [7:0] key_out, scan_code;
	output [6:0] hex_1, hex_2;
	reg [7:0] dataout;
	reg [13:0] hex_out;

 
	//internal registers
	reg [7:0] counter;
	reg [10:0] data;
	reg valid;
	reg cnt;
	reg cnt2;
	
	//hold keyboard pressed/unpressed state
	reg break;
	
	//parameters
 parameter HEX_0 = 14'b11111111000000;		// zero
 parameter HEX_2 = 14'b11111110100100;	   // two
 parameter HEX_a = 14'b11111110001000;		// a
 parameter HEX_b = 14'b11111110000011;		// b
 parameter HEX_c = 14'b11111111000110;		// c
 parameter HEX_d = 14'b11111110100001;		// d
 parameter HEX_e = 14'b11111110000110;		// e
 parameter HEX_f = 14'b11111110001110;		// f
 parameter HEX_g = 14'b01100101000110;		// g
 parameter HEX_h = 14'b11111110001001;		// h
 parameter HEX_i = 14'b10001101110110;		// I
 parameter HEX_j = 14'b11111101100000;		// J
 parameter HEX_k = 14'b01101010001011;		// K
 parameter HEX_l = 14'b11111111000111; 	// L
 parameter HEX_m = 14'b10110001001100;		// M
 parameter HEX_n = 14'b11100010001011;		// N
 parameter HEX_o = 14'b11100001000110;		// O
 parameter HEX_p = 14'b11111110001100;		// P
 parameter HEX_q = 14'b11101111000000;		// Q
 parameter HEX_r = 14'b01001000001110;		// R
 parameter HEX_s = 14'b01100100010110;		// S
 parameter HEX_t = 14'b10011101111110;		// T
 parameter HEX_u = 14'b11111111000001;		// U
 parameter HEX_v = 14'b11011011011011;		// V
 parameter HEX_w = 14'b11000011000011; 	// w
 parameter HEX_x = 14'b01101010010011; 	// x
 parameter HEX_y = 14'b01111010011011; 	// y
 parameter HEX_z = 14'b01101000100110;		// Z


///////////////////////////////////////
/////// counters enables       ////////
///////////////////////////////////////	

///////////////////////////////////////
/////// counters enables       ////////
///////////////////////////////////////	

wire cnt1 = (counter >= 8'd11 )? 1'b1 : 1'b0;

/////////////////////////////
/// clock for PS2      //////
/////////////////////////////	

//	 always @ (negedge ps_clk or posedge cnt1 )
//	 begin
//		case(cnt1)
//			1'b1: begin
//				counter <= 0;
//				cnt <= 1;
//			end
//			1'b0: begin
//				counter <= counter + 8'd1;
//				cnt <= 0;
//			end
//			default: counter <= 0;
//		endcase
//	 end


	 always @ (negedge ps_clk or posedge cnt1 )
	 
	 begin 
	 
		if (cnt1)
		begin
			counter <= 0;
			cnt <= 1;
		end
		
			else
			
		begin
			
			counter <= counter + 1;
			cnt <= 0;
			
		end	
	end
	
	 
	
	
/////////////////////////////////////////////////////////////////////
/// Serial shift register to reteive data from the PS_data line   ///
/////////////////////////////////////////////////////////////////////

	
always @ (negedge ps_clk or  posedge cnt )

 begin
 
 if (cnt) begin  valid <= 1; end
 
// else begin
// 
// case (counter)
// 	
//		8'd0	: begin valid = 1; data[0] = ps_data; end // start
//		8'd1	: begin valid = 0; data[1] = ps_data; end // bit 0
//		8'd2	: begin valid = 0; data[2] = ps_data; end // bit 1
//		8'd3	: begin valid = 0; data[3] = ps_data; end // bit 2 	
//		8'd4	: begin valid = 0; data[4] = ps_data; end // bit 3
//		
//		8'd5	: begin valid = 0; data[5] = ps_data; end // bit 4
//		8'd6	: begin valid = 0; data[6] = ps_data; end // bit 5		
//		8'd7	: begin valid = 0; data[7] = ps_data; end // bit 6
//		8'd8	: begin valid = 0; data[8] = ps_data; end // bit 7
//		
//		8'd9	: begin valid = 1; data[9] = ps_data; end // parity
//		8'd10 : begin valid = 1; data[10] = ps_data; end // stop
//		8'd11	: begin valid = 1; end 
//		8'd12	: begin valid = 1; end
//
//	endcase
//	end
	
	else if(break) begin
	//2nd shift register for storing scan code of break code
	case (counter)
 	
		8'd0	: begin valid = 1; data[0] = ps_data; end // start
		8'd1	: begin valid = 0; data[1] = 0; end // bit 0
		8'd2	: begin valid = 0; data[2] = 0; end // bit 1
		8'd3	: begin valid = 0; data[3] = 0; end // bit 2 	
		8'd4	: begin valid = 0; data[4] = 0; end // bit 3
		
		8'd5	: begin valid = 0; data[5] = 0; end // bit 4
		8'd6	: begin valid = 0; data[6] = 0; end // bit 5		
		8'd7	: begin valid = 0; data[7] = 0; end // bit 6
		8'd8	: begin valid = 0; data[8] = 0; end // bit 7
		
		8'd9	: begin valid = 1; data[9] = ps_data; end // parity
		8'd10 : begin valid = 1; data[10] = ps_data; end // stop
		8'd11	: begin valid = 1; end 
		8'd12	: begin valid = 1; end

	endcase
		//key_off <= 1'b0;
	end

	else begin
 
	case (counter)
 	
		8'd0	: begin valid = 1; data[0] = ps_data; end // start
		8'd1	: begin valid = 0; data[1] = ps_data; end // bit 0
		8'd2	: begin valid = 0; data[2] = ps_data; end // bit 1
		8'd3	: begin valid = 0; data[3] = ps_data; end // bit 2 	
		8'd4	: begin valid = 0; data[4] = ps_data; end // bit 3
		
		8'd5	: begin valid = 0; data[5] = ps_data; end // bit 4
		8'd6	: begin valid = 0; data[6] = ps_data; end // bit 5		
		8'd7	: begin valid = 0; data[7] = ps_data; end // bit 6
		8'd8	: begin valid = 0; data[8] = ps_data; end // bit 7
		
		8'd9	: begin valid = 1; data[9] = ps_data; end // parity
		8'd10 : begin valid = 1; data[10] = ps_data; end // stop
		8'd11	: begin valid = 1; end 
		8'd12	: begin valid = 1; end

	endcase
	end	
end
	
 
///////////////////////////////////////////////////////////////////////////
/// compare and select key code value to be displayed on HEX displays   ///
///////////////////////////////////////////////////////////////////////////

// always @(posedge clk)	
//	begin
//	case(data[8:1])
//	  //check if key released
//		8'h00001111: begin dataout <= 8'd12; hex_out <= HEX_b; end
//		8'b00011100: begin dataout <= 8'd0; hex_out <= HEX_a; end//a 
//		8'b00011011: begin dataout <= 8'd1; hex_out <= HEX_s; end//s
//		8'b00100011: begin  
//		dataout <= 8'd2;	//d
//		hex_out <= HEX_d;
//		end
//		8'b00101011: begin  
//		dataout <= 8'd3; //f
//		hex_out <= HEX_f;
//		end
//		8'b00110100: begin  
//		dataout <= 8'd4; //g
//		hex_out <= HEX_g;
//		end
//		8'b00110011: begin  
//		dataout <= 8'd5;  //h
//		hex_out <= HEX_h;
//		end
//		8'b11011100: begin  
//		dataout <= 8'd6; //j
//		hex_out <= HEX_j;
//		end
//		8'b01000010: begin  
//		dataout <= 8'd7; //k
//		hex_out <= HEX_k;
//		end
//		8'b11010010: begin  
//		dataout <= 8'd8; //l
//		hex_out <= HEX_l;
//		end
//		8'b00111100: begin  
//		dataout <= 8'd9; //u
//		hex_out <= HEX_u;
//		end
//		8'b11000010: begin  
//		dataout <= 8'd10; //i
//		hex_out <= HEX_i;
//		end
//		8'b00100010: begin  
//		dataout <= 8'd11; //o
//		hex_out <= HEX_o;
//		end
//		default: begin dataout <= 8'd12; hex_out <= HEX_c; end
//	endcase
//end


always @(posedge clk)	
 
	begin
	
		
		hex_out = 14'b11111111111111;  	// default setting
		//dataout = 8'd12;
		
		if (data[8:1] == 8'b11110000) begin
		hex_out <= HEX_0;
		break <= 1'b1;
		dataout <= 8'd12;
		end
		
		
		//by default ps2 dat sends out 8 bit's 0 initially
		if (data[8:1] == 8'b00000000) begin
		hex_out <= HEX_0;
		break <= 1'b0;
		dataout <= 8'd12;
		end
		
		else
		
		//2nd break code
		if (data[8:1] == 8'b11111111) begin
		hex_out <= HEX_2;
		break <= 1'b0;
		dataout <= 8'd12;
		end
		
		else
		
		if (data[8:1] == 8'b00011100) begin		
		hex_out <= HEX_a;
		dataout <= 8'd0;
		end
		
		else
		
		if (data[8:1] == 8'b00100011) begin  
		hex_out <= HEX_d;
		dataout <= 8'd2;
		end
		
		else
		
		if (data[8:1] == 8'b00101011) begin  
		hex_out <= HEX_f; 
		dataout <= 8'd3;
		end
		
		else
		
		if (data[8:1] == 8'b00110100) begin  
		hex_out <= HEX_g; 
		dataout <= 8'd4;
		end
		
		else

		if (data[8:1] == 8'b00110011) begin  
		hex_out <= HEX_h; 
		dataout <= 8'd5;
		end
		
		else
		
		if (data[8:1] == 8'b01000011) begin  
		hex_out <= HEX_i; 
		dataout <= 8'd10;
		end
		
		else
		
		if (data[8:1] == 8'b00111011) begin  
		hex_out <= HEX_j; 
		dataout <= 8'd6;
		end
		
		else
		
		if (data[8:1] == 8'b01000010) begin  
		hex_out <= HEX_k; 
		dataout <= 8'd7;
		end
		
		else 
		
		if (data[8:1] == 8'b01001011) begin  
		hex_out <= HEX_l; 
		dataout <= 8'd8;
		end
		
		else
		
		if (data[8:1] == 8'b01000100) begin  
		hex_out <= HEX_o; 
		dataout <= 8'd11;
		end
		
		else
		
		if (data[8:1] == 8'b00011011) begin  
		hex_out <= HEX_s;
		dataout <= 8'd1;
		end
		
		else
		
		if (data[8:1] == 8'b00111100) begin
		hex_out <= HEX_u;
		dataout <= 8'd9;
		end
	end

assign key_out = dataout;
assign scan_code = data[8:1];
assign hex_1 = hex_out[6:0];
assign hex_2 = hex_out[13:7];
endmodule
