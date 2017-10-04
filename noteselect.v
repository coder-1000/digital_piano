//selects note to be played depending on key pressed
module noteselect(datain, delay);
	//I/O
	input [7:0] datain;
	output reg [18:0] delay;
	
	//combinational logic to select note to play
	always @(*)
	begin
		case(datain)
        8'd0:  begin delay = 19'd95600;end   //C   //a
        8'd1:  begin delay = 19'd90250;end   //C# //s
        8'd2:  begin delay = 19'd85180; end   //D //d
        8'd3:  begin delay = 19'd80390;  end   //D# //f
        8'd4:  begin delay = 19'd75870; end   //E //g
        8'd5:  begin delay = 19'd71630;  end   //F //h
        8'd6:  begin delay = 19'd67660;  end   //F# //j
        8'd7:  begin delay = 19'd63780;  end   //G //k
        8'd8:  begin delay = 19'd60170;  end   //G# //l
        8'd9: begin delay = 19'd56820;  end   //A //u
        8'd10: begin delay = 19'd53640;  end   //A# //i
        8'd11: begin delay = 19'd50660;  end   //B //o
		  8'd12: begin delay = 19'd1; end
    default: begin delay = 19'd1;    end   //nothing
    endcase
  end
 endmodule
 