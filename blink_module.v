module blink_top(
	input CLOCK_50, reset, blink,
	input [8:0] block_x, input [8:0] block_y,
	output [8:0] x, output [8:0] y, output [2:0] out_color, output writeEn, blink_clock, output[2:0] current_state
	);

	assign writeEn = 1'b1;
	
	//ratedivider and upcounter slows down the clock
	ratedivider r0(CLOCK_50, reset, blink_clock);
	
	blink_ctrl b_C(CLOCK_50, blink_clock, reset, blink, current_state);
	blink_dpath b_d(CLOCK_50, reset, blink, current_state, block_x, block_y, x, y, out_color);
 
endmodule

module blink_ctrl(input clock, blink_clock, reset, blink, output reg [2:0] current_state);

	reg[2:0] next_state;
	
	localparam	on 		= 3'd0,
					off		= 3'd1,
					on_wait 	= 3'd2,
					off_wait = 3'd3,
					_switch	= 3'd4;
					
	// Next state logic aka our state table
	always@(*)
	begin: state_table 
			case (current_state)
				on: next_state = blink_clock ? on_wait : on;
				off: next_state = blink_clock ? off_wait : off;
				on_wait: next_state = blink_clock ? on_wait : off; //wait until on's blink_clock is 0
				off_wait: next_state = blink_clock ? off_wait : on; //wait until off's blink_clock is 0
				_switch: next_state = off;
				default:	next_state = off;
			endcase
	end // state_table
   
	// current_state registers
	always@(posedge clock, negedge reset)
	begin: state_FFs
		if (!reset) 
			current_state <= off;
		else if (!blink && current_state == off) //on_wait proceeds to off, which stays at off while blink is 0
			current_state <= off;
		else if (!blink && current_state != _switch) //when blink is turned off, we go to _switch in order to reset row counter (happens before previous else if case)
			current_state <= _switch;
		else 
			current_state <= next_state;
	end // state_FFS
endmodule

module blink_dpath(input clock, reset, blink, input [2:0] current_state, input [8:0] block_x, input [8:0] block_y, output reg [8:0] x, output reg [8:0] y, output reg [2:0] color);
	
	wire [3:0] out_row;
	reg [8:0] reg_x;
	reg [8:0] reg_y;
	reg switch;
	reg new_x;
	
	localparam	on 		= 5'd0,
					off		= 5'd1,
					on_wait 	= 5'd2,
					off_wait = 5'd3,
					_switch	= 5'd4;
	
	rowcol_counter rc_c(clock, reset, switch, out_row);
	
	always@(posedge clock, negedge reset)
	begin
		if (!reset) 
			begin
				reg_x <= 0;
				reg_y <= 0;
			end
		else 
			begin
				if (block_x == 9'b0 && block_y == 9'b0)
				begin
					reg_x <= block_x;
					reg_y <= block_y;
				end
				else if (block_x == 9'b0 && block_y == 9'd227)
				begin
					reg_x <= block_x;
					reg_y <= block_y;
				end
				else if (block_x == 9'b0)
				begin
					reg_x <= 9'b0;
					reg_y <= block_y;
				end
				else
				begin
					reg_x <= block_x-1'b1;
					reg_y <= block_y;
				end
			end
	end
	
	always@(*)
	begin
		case(current_state)
			//on draw
			on: begin
				y = reg_y + out_row; //row gets incremented, then gets added to y
				x = reg_x;
				color = 3'b000; //draw black cursor
				switch = 1'b0;
			end		
			//off	erase
			off: begin
				y = reg_y + out_row; //row gets incremented, then gets added to y
				x = reg_x;
				color = 3'b111; //erase black cursor
				switch = 1'b0;
			end	
			on_wait: begin
				y = reg_y;
				x = reg_x;
				color = 3'bx;
				switch = 1'b1; //switch resets row
			end
			off_wait: begin
				y = reg_y;
				x = reg_x;
				color = 3'b111;
				switch = 1'b1; //switch resets row
			end
			_switch: begin
				y = reg_y;
				x = reg_x;
				color = 3'bx;
				switch = 1'b1; //switch resets row
			end
			
			default: begin	
				y = reg_y + out_row; //row gets incremented, then gets added to y
				x = reg_x;
				color = 3'b111; //erase black cursor
				switch = 1'b0;
			end
		endcase
	end
	
endmodule


// Increment within a block
module rowcol_counter(input clock, reset, switch, output reg[3:0] reg_row);

	always @(posedge clock, negedge reset)
	begin
		if (!reset) reg_row <= 0;
		else if (switch == 1'b1) reg_row <= 0; //switch is a reset before drawing or erasing
		else if (reg_row == 4'd10)
			begin
				reg_row <= reg_row;
			end
		else 
			begin
				reg_row <= reg_row + 1'd1;
			end
	end

endmodule

module ratedivider(input clock, reset, output reg slowclock);

	wire [31:0] x = 32'd25000000;	
	reg [31:0] count;
	
	always @(posedge clock, negedge reset)
	begin
		if (!reset)
			begin
				count <= 0;
				slowclock <= 0;
			end
		else if (count == x) 
			begin
				count <= 0;
				slowclock <= 1;
			end
		else
			begin
				count <= count + 1;
				slowclock <= 0;
			end
	end	
endmodule
	
	