module cursorstate(
	input clock, reset, esc, clr, wr,
	input[2:0] move,
	output[8:0] cursor_x, cursor_y
	);

	wire [3:0] current_state, next_state;
	assign cursor_y[8] = 0;
	
	cursor_ctrl c_c0 (clock, reset, esc, clr, wr, current_state);
	cursor_dpath d_p0 (clock, reset, move, current_state, cursor_x, cursor_y[7:0]);
	
endmodule	

//FSM
module cursor_ctrl(input clock, reset, esc, clr, wr, output reg[3:0] current_state);

	reg[3:0] next_state;
	
	// State logic
	localparam	write			= 4'd0,
					command		= 4'd1,
					_wait			= 4'd2,
					clear			= 4'd3;

// state table
	always@(*)
	begin: state_table 
			case (current_state)
				write: begin
						next_state = esc ? _wait : write;				
				end
				command: begin
						if (clr) next_state = clear;
						else if (wr) next_state = write;
						else next_state = command;
				end
				_wait: begin
						next_state = esc ? _wait : command;
				end
				clear: begin
						next_state = command;
				end	
				default: next_state = clear;
			endcase
	end
	
	// current_state registers
	always@(posedge clock, negedge reset)
	begin: state_FFs
		if(!reset)
			current_state <= write;
		else
		begin
			current_state <= next_state;
		end
	end // state_FFS
	
endmodule

module cursor_dpath (input clock, reset, input[2:0] move, input[3:0] current_state, output reg [8:0] mux_cursor_x, output reg [7:0] mux_cursor_y);
	
	localparam	write					= 4'd0,
					command				= 4'd1,
					_wait					= 4'd2,
					clear					= 4'd3;
	

	wire [8:0] w_cursor_x, c_cursor_x;
	wire [7:0] w_cursor_y, c_cursor_y;
	reg w_go, c_go, mux_reset;
	reg [8:0] reg_cursor_x;
	reg [7:0] reg_cursor_y;
	
	write_cursor wc (clock, mux_reset, w_go, move, w_cursor_x, w_cursor_y);
	command_cursor cc (clock, reset, c_go, move[1:0], c_cursor_x, c_cursor_y);
	
	//Register for cursor_x and cursor_y		
	always@(posedge clock, negedge reset)
	begin
		if (!reset)
		begin
			reg_cursor_x <= 9'b0;
			reg_cursor_y <= 8'b0;
		end
		else
		begin
			reg_cursor_x <= mux_cursor_x;
			reg_cursor_y <= mux_cursor_y;
		end
	end
	
	always@(*) 
	begin
		case (current_state)
			write: begin
				w_go = 1'b1;
				c_go = 1'b0;
				mux_reset = reset;
				mux_cursor_x = w_cursor_x;
				mux_cursor_y = w_cursor_y;
			end
			command: begin
				w_go = 1'b0;
				c_go = 1'b1;
				mux_reset = reset;
				mux_cursor_x = c_cursor_x;
				mux_cursor_y = c_cursor_y;
			end
			_wait: begin
				w_go = 1'b0;
				c_go = 1'b0;
				mux_reset = reset;
				mux_cursor_x = reg_cursor_x;
				mux_cursor_y = reg_cursor_y;
			end
			clear: begin
				w_go = 1'b0;
				c_go = 1'b0;
				mux_reset = 1'b0; //write_cursor gets reset 
				mux_cursor_x = reg_cursor_x;
				mux_cursor_y = reg_cursor_y;
			end
			default: begin
				w_go = 1'b0;
				c_go = 1'b0;
				mux_reset = 1'b1; 
				mux_cursor_x = reg_cursor_x;
				mux_cursor_y = reg_cursor_y;
			end
		endcase
	end
	
endmodule

//Move: left = 1, right = 2, up = 3, down = 4, stay still = 0
// Returns write_cursor after 1 clock tick
module write_cursor (input clock, reset, w_go, input [2:0] move, output reg[8:0] cursor_x, output reg[7:0] cursor_y);

	always @(posedge clock, negedge reset)
	begin
		if (!reset)
			begin
				cursor_x <= 0;
				cursor_y <= 0;
			end	
		else if (w_go == 1'b1 && cursor_y == 8'd0 && cursor_x == 9'd0 && move == 3'd1) //reverse from top left corner stays put
			begin
				cursor_x <= 0;
				cursor_y <= 0;
			end
		else if (w_go == 1'b1 && cursor_x == 9'd0 && move == 3'd1) //move up, set x to far right
			begin
				cursor_x <= 9'd308;
				cursor_y <= cursor_y - 4'd10;
			end
		else if (w_go == 1'b1 && move == 3'd1) //move left
			begin
				cursor_x <= cursor_x - 3'd7;
				cursor_y <= cursor_y;
			end
		else if (w_go == 1'b1 && cursor_y == 8'd210 && cursor_x == 9'd308 && move == 3'd2) //restart at top left corner
			begin
				cursor_x <= cursor_x;
				cursor_y <= cursor_y;
			end	
		else if (w_go == 1'b1 && cursor_x == 9'd308 && move == 3'd2) //move down
			begin
				cursor_x <= 0;
				cursor_y <= cursor_y + 4'd10;
			end
		else if (w_go == 1'b1 && move == 3'd2) //move right
			begin
				cursor_x <= cursor_x + 3'd7;
				cursor_y <= cursor_y;
			end
		else if (w_go == 1'b1 && move == 3'd3 && cursor_y == 8'd0) //	move up from top stays
			begin
				cursor_x <= cursor_x;
				cursor_y <= cursor_y;
			end	
		else if (w_go == 1'b1 && move == 3'd3) //	move up
			begin
				cursor_x <= cursor_x;
				cursor_y <= cursor_y - 4'd10;
			end
		else if (w_go == 1'b1 && move == 3'd4 && cursor_y == 8'd210) //	move down from bottom stays
			begin
				cursor_x <= cursor_x;
				cursor_y <= cursor_y;
			end		
		else if (w_go == 1'b1 && move == 3'd4) // move down
			begin
				cursor_x <= cursor_x;
				cursor_y <= cursor_y + 4'd10;
			end	
		else
			begin
				cursor_x <= cursor_x;
				cursor_y <= cursor_y;
			end
	end

endmodule

// Returns write_cursor after 1 clock tick
//y position never changes
module command_cursor (input clock, reset, c_go, input [1:0] move, output reg[8:0] cursor_x, output reg[7:0] cursor_y);
	
	always @(posedge clock, negedge reset)
	begin
		if (!reset)
			begin
				cursor_x <= 0;
				cursor_y <= 8'd227;// 227-237 is under the black line leaving space for white above and below 
			end	
		else if (c_go == 1'b1 && cursor_x == 9'd0 && move == 2'd1) //reverse from far left stays put
			begin
				cursor_x <= 0;
				cursor_y <= 8'd227;
			end
		else if (c_go == 1'b1 && move == 2'd1) //move left
			begin
				cursor_x <= cursor_x - 3'd7;
				cursor_y <= cursor_y;
			end	
		else if (c_go == 1'b1 && cursor_x == 9'd308 && move == 2'd2) //move right from far right stays put
			begin
				cursor_x <= cursor_x;
				cursor_y <= cursor_y;
			end
		else if (c_go == 1'b1 && move == 2'd2) //move right
			begin
				cursor_x <= cursor_x + 3'd7;
				cursor_y <= cursor_y;
			end
		else
			begin
				cursor_x <= cursor_x;
				cursor_y <= 8'd227;
			end
	end

endmodule
