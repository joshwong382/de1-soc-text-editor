module asciidisplay(
	input CLOCK_50, reset,
	output vga_go, // Tells the Main module the FSM is idle
	input go, // If go is 1 then this FSM can do stuff
	input[6:0] ASCII,
	input[8:0] reg_x, reg_y,
	output[8:0] x, y,
	output writeEn,
	output[2:0] out_color,
	output [4:0] current_state,
	output blink
	);

	wire[8:0] counteri;
	wire[8:0] counterj;
	wire[8:0] max_counteri;
	wire[8:0] max_counterj;
	wire[3:0] out_row;
	wire[2:0] out_col;
	
	control c0(CLOCK_50, reset, go, ASCII, counteri, counterj, max_counteri, max_counterj, out_row, out_col, current_state);
   datapath d0(CLOCK_50, current_state, ASCII, reset, go, reg_x, reg_y, vga_go, counteri, counterj, x, y, out_color, writeEn, max_counteri, max_counterj, out_row, out_col, blink);

endmodule

module control(
	input clock, reset, go,
	input[6:0] ASCII,
	input[8:0] counteri, counterj, max_counteri, max_counterj,
	input[3:0] out_row,
	input[2:0] out_col,
	output reg[4:0] current_state
	);

	reg[4:0] next_state;
	
	localparam	white 			= 5'd0,
					linePrep			= 5'd1,
					lineBlack 		= 5'd2,
					letterPrep		= 5'd3,
					letterAction	= 5'd4,
					letterEnd	 	= 5'd5,
					go_wait			= 5'd6,
					freeze			= 5'd7,
					setASCII			= 5'd8;
    
	// Next state logic aka our state table
	always@(*)
	begin: state_table 
			case (current_state)
				white:			begin
										if (counterj == max_counterj)
											begin
												if (counteri == max_counteri)
														next_state = linePrep;
												else next_state = white;
											end
										else next_state = white;
									end
				linePrep:		begin
										next_state = lineBlack;
									end				
				lineBlack:		begin
										if (counterj == max_counterj)
											begin
												if (counteri == max_counteri)
														next_state = freeze;
												else next_state = lineBlack;
											end
										else next_state = lineBlack;
									end
				letterPrep:		begin
										next_state = letterAction;
									end
				letterAction:	begin
										if (out_row == max_counterj)
											begin
												if (out_col == max_counteri)
													next_state = letterEnd;
												else next_state = letterAction;
											end
										else next_state = letterAction;		
									end
									
				letterEnd: 		next_state = go_wait; //moves one block over	
				
				go_wait:			next_state = go ? go_wait : freeze;
				
				// Wait for PS2 FSM to complete its task
            freeze:			next_state = go ? letterAction : freeze;
				setASCII:		next_state = letterPrep; //gets rid of the black dot
				default:			next_state = white;
			endcase
	end // state_table
   
	// current_state registers
	always@(posedge clock, negedge reset)
	begin: state_FFs
		if(!reset)
			current_state <= white;
		else
		begin
			current_state <= next_state;
		end
	end // state_FFS
endmodule

module datapath(
	input clock,
	input[4:0] current_state,
	input[6:0] ASCII,
	input reset, ps2_go,
	input[8:0] reg_x, reg_y,
	output reg vga_go,
	output reg[8:0] counteri,
	output reg[8:0] counterj,
	output reg [8:0] x,
	output reg [8:0] y,
	output reg [2:0] letter_color,
	output reg writeEn,
	output reg [8:0] max_counteri, max_counterj,
	output[3:0] out_row,
	output[2:0] out_col,
	output reg blink
	);
	
	reg mux_go;
	reg[8:0] mux_maxcounteri;
	reg[8:0] mux_maxcounterj;
	reg[6:0] ascii_reg;
	reg[6:0] mux_ascii;
	reg rowcolcount; //enables rowcolCounter
	wire[2:0] ascii_color;
	reg [4:0] previous_state;
	
	localparam	white 			= 5'd0,
					linePrep			= 5'd1,
					lineBlack 		= 5'd2,
					letterPrep		= 5'd3,
					letterAction	= 5'd4,
					letterEnd	 	= 5'd5,
					go_wait			= 5'd6,
					freeze			= 5'd7,
					setASCII			= 5'd8;
	
	//send ASCII code, row and col position, and get the color of the corresponding pixel
	letterDecoder ld0(ascii_reg, out_row, out_col, ascii_color);
	
	//instantiate row/col counter. Only enabled during certain states
	rowcolCounter rc0(clock, reset, rowcolcount, out_row, out_col);
	
	always@(posedge clock, negedge reset)
	begin
		if (!reset)
			begin
				previous_state <= 5'b0;
			end
		else 
			begin
				previous_state <= current_state;
			end
	end
	
	// Register for Counters
	always@(posedge clock, negedge reset)
	begin
		if (!reset)
			begin
				counteri <= 9'b0;
				counterj <= 9'b0;
			end
		else if (ps2_go) //wait state: do not count
			begin
				counteri <= counteri;
				counterj <= counterj;
			end	
		else 
			begin
				if (counteri == max_counteri && counterj == max_counterj)
					begin
						counteri <= 9'd0;
						counterj <= 9'd0;
					end
				else if (counteri == max_counteri)	
					begin
						counteri <= 9'd0;
						counterj <= counterj + 1;
					end
				else
					begin
						counteri <= counteri + 1;
						counterj <= counterj;
					end
			end
	end			

	//Register for x and y
	always@(posedge clock, negedge reset)
	begin
        if(!reset)
			  begin 
					max_counteri <= 9'd319;
					max_counterj <= 9'd239;
					ascii_reg <= 7'b0;
					vga_go <= 1'b0;
			  end
		  else
			  begin
					max_counteri <= mux_maxcounteri;
					max_counterj <= mux_maxcounterj;
					ascii_reg <= mux_ascii;
					vga_go <= mux_go;
			  end
	end
 
	// mux for current_state
	always@(*)
	begin
		case(current_state)
			white: begin
					x = 9'd0 + counteri;
					y = 9'd0 + counterj;
					letter_color = 3'b111;
					writeEn = 1'b1;
					mux_maxcounteri = 9'd319;
					mux_maxcounterj = 9'd239;
					rowcolcount = 1'b0;
					mux_ascii = ascii_reg;
					mux_go = 1'b0;
					blink = 1'b0;
					end
			linePrep: begin
					x = 9'd0;
					y = 9'd224; 
					letter_color = 3'b000;
					writeEn = 1'b1;
					mux_maxcounteri = 9'd319;
					mux_maxcounterj = 9'd1; 
					rowcolcount = 1'b0;
					mux_ascii = ascii_reg;	
					mux_go = 1'b0;	
					blink = 1'b0;
					end
			lineBlack: begin
					x = 9'd0 + counteri;
					y = 9'd224 + counterj; //draw black line starting at pixel y=224
					letter_color = 3'b000;
					writeEn = 1'b1;
					mux_maxcounteri = 9'd319;
					mux_maxcounterj = 9'd1; //black line is 2 pixels thick
					rowcolcount = 1'b0;
					mux_ascii = ascii_reg;	
					mux_go = 1'b0;	
					blink = 1'b0;
					end
			letterPrep: begin //since registers are one clock tick behind we have a prep state to cover the top left corner
					x = reg_x; 
					y = reg_y; 
					letter_color = ascii_color;
					writeEn = 1'b0;
					mux_maxcounteri = 9'd7; 
					mux_maxcounterj = 9'd10; 
					rowcolcount = 1'b0;
					mux_ascii = ascii_reg; //feed in ASCII code
					mux_go = 1'b0;
					blink = 1'b0;
					end
			letterAction: begin
					x = reg_x + out_col; //col gets incremented, then gets added to x
					y = reg_y + out_row; //row gets incremented, then gets added to y
					letter_color = ascii_color;
					writeEn = 1'b1;
					mux_maxcounteri = 9'd7; //count one block. we stay in this state for one block
					mux_maxcounterj = 9'd10; //count one block. we stay in this state for one block
					rowcolcount = 1'b1; //row and col gets incremented within the block
					mux_ascii = ascii_reg; //feed in ASCII code
					mux_go = 1'b0;
					blink = 1'b0;
					end
			letterEnd: begin
					x = reg_x;
					y = reg_y;
					letter_color = 3'bx;
					writeEn = 1'b0;
					mux_maxcounteri = max_counteri;
					mux_maxcounterj = max_counterj;
					rowcolcount = 1'b0;
					mux_ascii = ascii_reg;
					mux_go = 1'b0;
					blink = 1'b0;
					end		
			go_wait: begin
					x = 9'bx;
					y = 9'bx;
					letter_color = 3'bx;
					writeEn = 1'b0;
					mux_maxcounteri = 9'bx;
					mux_maxcounterj = 9'bx;
					rowcolcount = 1'b0;
					mux_ascii = ascii_reg;
					mux_go = 1'b0;
					blink = 1'b0;
					end		
			freeze: begin
					x = 9'bx;
					y = 9'bx;
					letter_color = 3'bx;
					writeEn = 1'b1;
					mux_maxcounteri = 9'bx;
					mux_maxcounterj = 9'bx;
					rowcolcount = 1'b0;
					mux_ascii = ASCII;
					// Set if next state is freeze mux_go = 0
					if (previous_state == 5'd7) mux_go = 1'b0;
					else mux_go = 1'b1;
					blink = 1'b1;
					end
			setASCII: begin
					x = 9'bx;
					y = 9'bx;
					letter_color = 3'bx;
					writeEn = 1'b0;
					mux_maxcounteri = 9'bx;
					mux_maxcounterj = 9'bx;
					rowcolcount = 1'b0;
					mux_ascii = ascii_reg;
					mux_go = 1'b0;
					blink = 1'b0;
					end				
			default:
				begin
					x = 9'bx;
					y = 9'bx;
					letter_color = 3'bx;
					writeEn = 1'b0;
					mux_maxcounteri = 9'bx;
					mux_maxcounterj = 9'bx;
					rowcolcount = 1'b0;	
					mux_ascii = ascii_reg;	
					mux_go = 1'b0;	
					blink = 1'b0;
				end
		endcase
	end
 
endmodule

// Increment within a block
module rowcolCounter (input clock, reset, rowcolcount, output reg[3:0] reg_row, output reg[2:0] reg_col);

	always @(posedge clock, negedge reset)
	begin
		if (!reset)
			begin
				reg_row <= 0;
				reg_col <= 0;
			end
		else if (reg_col == 3'd7 && rowcolcount == 1'd1) 
			begin
				if (reg_row == 4'd10)
					begin
						reg_row <= 0;
						reg_col <= 0;
					end
				else
					begin
						reg_row <= reg_row + 1'd1;
						reg_col <= 0;
					end
			end		
		else if (rowcolcount == 1'd1)
			begin
				reg_col <= reg_col + 1'd1;
				reg_row <= reg_row;
			end
		else
			begin
				reg_col <= reg_col;
				reg_row <= reg_row;
			end
	end

endmodule
