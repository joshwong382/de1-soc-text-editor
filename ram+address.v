module ram_rw(
	input clock, reset,
	input[8:0] cursor_x, cursor_y,
	input[6:0] ascii_in,
	output[6:0] ascii_out,
	input ps2_result_ready, vga_is_done, 
	output ram_to_ps2_go, ram_to_vga_go,
	output[8:0] asciidisplay_x, asciidisplay_y,
	output[4:0] current_state,
	output[2:0] move,
	output esc, clr, wr, blink,
	output[6:0] HEX0, HEX1, HEX4
	);
	
	wire writeEn, readEn, enter_shift;
	wire[4:0] next_state;
	reg[6:0] last_ascii_in;
	wire[6:0] last_ascii_read;
	wire[8:0] rampos_x, rampos_y;
	wire[8:0] out_blocki;
	wire[7:0] out_blockj;
	
	// last_ascii_in will = 1 when it's not found in the table.
	always@(posedge clock, negedge reset)
	begin
		if(!reset)
			last_ascii_in <= 7'b0;
		else
		begin
			last_ascii_in <= ascii_in;
		end
	end
	
	hexdisp h0(last_ascii_in[3:0], HEX0);
	hexdisp h1({1'b0,last_ascii_in[6:4]}, HEX1);
	hexdisp h4(current_state[3:0], HEX4);
	
	// To Bypass the RAM comment everything below and uncomment these 5 lines
	
	/*assign ram_to_vga_go = ps2_result_ready;
	assign ram_to_ps2_go = vga_is_done;
	assign ascii_out = ascii_in;
	assign asciidisplay_x = cursor_x;
	assign asciidisplay_y = cursor_y;*/
	
	// FSM and Statements
	ram_crtl ramc0(clock, reset, ps2_result_ready, vga_is_done, out_blocki, cursor_x, out_blockj, cursor_y[7:0], current_state, next_state, last_ascii_in, last_ascii_read, enter_shift);
	ram_dpath ramd0(clock, reset, ram_to_ps2_go, ram_to_vga_go, current_state, next_state, last_ascii_in, ascii_out, readEn, writeEn, rampos_x, rampos_y, out_blocki, out_blockj, cursor_x, cursor_y, asciidisplay_x, asciidisplay_y, last_ascii_read, move, blink, esc, enter_shift);
	
endmodule

module ram_crtl(input clock, reset, ps2_result_ready, vga_is_done, input[8:0] blocki, cursor_x, input[7:0] blockj, cursor_y, output reg[4:0] current_state, next_state, input[6:0] last_ascii_in, input[6:0] last_ascii_read, input enter_shift);

	wire defined;
	reg proceed;
	asciiExists ae0(last_ascii_in, defined);
	
	// State logic
	localparam	idle					= 5'd0,
					check_ascii			= 5'd1,
					escape				= 5'd2,
					enter					= 5'd3,
					undefined_idle		= 5'd4,
					changeaddr			= 5'd5,
					shiftleft_prep		= 5'd6,
					shiftleft_read		= 5'd7,
					shiftleft_write	= 5'd8,
					shiftright_prep	= 5'd9,
					shiftright_read	= 5'd10,
					shiftright_write	= 5'd11,
					PS2_to_RAM			= 5'd12,
					RAM_to_VGA_preprep= 5'd13,
					RAM_to_VGA_prep 	= 5'd14,
					RAM_to_VGA			= 5'd15,
					RAM_to_VGA_wait	= 5'd16,
					pre_idle				= 5'd17;
    
	// state table
	always@(*)
	begin: state_table 
			case (current_state)
				idle: begin
						if (ps2_result_ready)				next_state = check_ascii;
						else										next_state = idle;
				end
				
				check_ascii:  begin
					// Defined
					if (defined)								next_state = shiftright_prep;
					// BKSP
					else if (last_ascii_in == 7'd08)		next_state = changeaddr;
					// DEL
					else if (last_ascii_in == 7'd127)	next_state = shiftleft_prep;
					// cursor_move
					else if (last_ascii_in == 7'd02 || last_ascii_in == 7'd03 || last_ascii_in == 7'd04 || last_ascii_in == 7'd05)
																	next_state = RAM_to_VGA_preprep; // ASCII 1-4 is being used for arrow keys
					// ESC
					else if (last_ascii_in == 7'd06)		next_state = escape;
					// ENTER or TAB
					else if (last_ascii_in == 7'd07 || last_ascii_in == 7'd08)
																	next_state = shiftright_prep; // Loop Creating a Shift until next line
					// Undefined
					else											next_state = undefined_idle;
				end
				
				escape:											next_state = idle;
				
				enter:											next_state = enter_shift ? shiftright_prep : RAM_to_VGA_preprep;
				
				undefined_idle:								next_state = ps2_result_ready ? undefined_idle : idle;
				
				changeaddr:										next_state = shiftleft_prep;
				
				shiftleft_prep: begin
																	if (blockj == 8'd210)
																		begin
																			if (blocki == 9'd308)
																					next_state = RAM_to_VGA_preprep;
																			else next_state = shiftleft_read;
																		end
																	else next_state = shiftleft_read;
				end
				
				shiftleft_read:								next_state = shiftleft_write;
				
				// Count until EOF... If not then stay in prep-read-write
				shiftleft_write:								next_state = shiftleft_prep;																
				
				shiftright_prep: begin
																	if (blockj == cursor_y) // cursory
																		begin
																			if (blocki == cursor_x) // cursorx
																					next_state = PS2_to_RAM;
																			else next_state = shiftright_read;
																		end
																	else next_state = shiftright_read;
				end
				
				shiftright_read:								next_state = shiftright_write;
				
				// Count until EOF... If not then stay in shiftright_read
				shiftright_write:								next_state = shiftright_prep;
				
				
				PS2_to_RAM:										next_state = enter_shift ? enter : RAM_to_VGA_preprep;
				
				RAM_to_VGA_preprep: 							next_state = RAM_to_VGA_prep;	
				
				RAM_to_VGA_prep: 								next_state = RAM_to_VGA;									
				
				
				RAM_to_VGA:										// Replace every single pixel after address
																	next_state = RAM_to_VGA_wait;
				
				RAM_to_VGA_wait: begin
																	if (blockj == 8'd227) //210
																		begin
																			if (blocki == 9'd308) //308
																					next_state = vga_is_done ? idle : RAM_to_VGA_wait;
																			else next_state =  vga_is_done ? RAM_to_VGA_prep : RAM_to_VGA_wait;
																		end
																	else next_state = vga_is_done ? RAM_to_VGA_prep : RAM_to_VGA_wait;
				end
				
				// Print whole RAM after VGA successfully initialized.
				pre_idle:										next_state = vga_is_done ? RAM_to_VGA_preprep : pre_idle;
				
				default:											next_state = idle;
				
			endcase
	end
	
	// current_state registers
	always@(posedge clock, negedge reset)
	begin: state_FFs
		if(!reset)
			current_state <= pre_idle;
		else
		begin
			current_state <= next_state;
		end
	end // state_FFS

endmodule

module ram_dpath(
	input clock, reset,
	output reg ram_to_ps2_go, ram_to_vga_go,
	input[4:0] current_state, next_state,
	input[6:0] last_ascii_in,
	output reg[6:0] ascii_out,
	output reg readEn, writeEn,
	output[8:0] rampos_x, rampos_y,
	output [8:0] out_blocki, output [7:0] out_blockj,
	input[8:0] cursor_x, cursor_y,
	output reg[8:0] asciidisplay_x, asciidisplay_y,
	output reg[6:0] last_ascii_read,
	output reg[2:0] move,
	output reg blink, esc, enter_shift
	);

	reg moveEn, writeBlock, writefrommux, mux_enter_shift;
	reg[1:0] tab_shift, mux_tab_shift;
	reg[8:0] mux_ramposx, mux_ramposy, mux_enter_y, enter_y;
	reg reverse, outblockbool;
	reg[6:0] mux_ascii_write;
	wire[6:0] ascii_write, ascii_read;
	wire[10:0] address;
	reg[2:0] cursor_move, mux_cursormove;
	reg[4:0] previous_state;
	
	// Cursor Address Translation
	// address = {blockxpos 6 bits, blockypos 5 bits}
	cat cat0(rampos_x, rampos_y, address);
	
	// Read, then optionally next clock tick write what was read.
	// To write from external ascii, use ascii_read = last_ascii_in;
	ram2048x7 ram0(address, clock, ascii_write, readEn, writeEn, ascii_read);
	
	assign ascii_write = writefrommux ? mux_ascii_write : ascii_read;
	
	always@(posedge clock, negedge reset)
	begin
		if (!reset)
		begin
			previous_state <= 4'b0;
			cursor_move <= 2'b0;
			enter_shift <= 1'b0;
			enter_y <= 9'b0;
			tab_shift <= 1'b0;
		end
		else
		begin
			previous_state <= current_state;
			cursor_move <= mux_cursormove;
			enter_shift <= mux_enter_shift;
			enter_y <= mux_enter_y;
			tab_shift <= mux_tab_shift;
		end
	end
	
	always@(posedge clock, negedge reset)
	begin
		if(!reset)
			last_ascii_read <= 7'b0;
		else if (readEn) last_ascii_read <= ascii_read;
		else last_ascii_read <= last_ascii_read;
	end	
	
	// Figure out what the next block is.
	nextBlock nb0(clock, reset, moveEn, writeBlock, out_blocki, out_blockj, mux_ramposx, mux_ramposy[7:0], reverse, rampos_x, rampos_y, outblockbool);
	
	// State logic
	localparam	idle					= 5'd0,
					check_ascii			= 5'd1,
					escape				= 5'd2,
					enter					= 5'd3,
					undefined_idle		= 5'd4,
					changeaddr			= 5'd5,
					shiftleft_prep		= 5'd6,
					shiftleft_read		= 5'd7,
					shiftleft_write	= 5'd8,
					shiftright_prep	= 5'd9,
					shiftright_read	= 5'd10,
					shiftright_write	= 5'd11,
					PS2_to_RAM			= 5'd12,
					RAM_to_VGA_preprep= 5'd13,
					RAM_to_VGA_prep 	= 5'd14,
					RAM_to_VGA			= 5'd15,
					RAM_to_VGA_wait	= 5'd16;
					
	// mux for current_state
	always@(*)
	begin
		case(current_state)
		
			idle:
			begin
				if (previous_state == idle || previous_state == check_ascii) move = 3'b0;
				else move = cursor_move;
				mux_cursormove = 3'b0;
				ram_to_ps2_go = 1'b1;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b0;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				moveEn = 1'b0;
				writeBlock = 1'b1;
				// !outblockbool then rampos_x <= mux_ramposx
				outblockbool = 1'b0;
				mux_ramposx = cursor_x;
				mux_ramposy = cursor_y;
				reverse = 1'b0;
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b1;
				esc = 1'b0;
				mux_enter_shift = 1'b0;
				mux_enter_y = 9'b0;
				mux_tab_shift = 2'b0; // No tab
			end
			
			check_ascii:
			begin
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b0;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				moveEn = 1'b0;
				writeBlock = 1'b1;
				// !outblockbool then rampos_x <= mux_ramposx
				outblockbool = 1'b0;
				reverse = 1'b0;
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b0;
				esc = 1'b0;
				// Enter Sub-state Enter_Shift
				if (last_ascii_in == 7'd07)
				begin
					mux_enter_shift = 1'b1;
					mux_enter_y = cursor_y;
					mux_tab_shift = 2'b0;
				end
				else if (last_ascii_in == 7'd08)
				begin
					mux_enter_shift = 1'b1;
					mux_tab_shift = 1'b1;
					mux_enter_y = 9'b0;
				end
				else
				begin
					mux_enter_shift = 1'b0;
					mux_enter_y = 9'b0;
					mux_tab_shift = 2'b0;
				end
				
				// Cursor and RAM_position stuff
				if (next_state == shiftright_prep)
				begin
					move = 3'b0;
					mux_ramposx = 9'd308; // Last Block on RAM
					mux_ramposy = 9'd210;
					mux_cursormove = 3'd2;
				end
				else if (next_state == shiftleft_prep) // Delete
				begin
					move = 3'b0;
					mux_ramposx = cursor_x;
					mux_ramposy = cursor_y;
					mux_cursormove = 3'd0;
				end
				else if (next_state == changeaddr) // move cursor before shifting left (Bksp)
				begin
					move = 3'b1;
					mux_ramposx = cursor_x;
					mux_ramposy = cursor_y;
					mux_cursormove = 3'd0;
				end
				else
				begin
					mux_ramposx = cursor_x;
					mux_ramposy = cursor_y;
					mux_cursormove = 3'd0;
					if (last_ascii_in == 7'd3) move = 3'd1;		// Left
					else if (last_ascii_in == 7'd5) move = 3'd2;	// Right
					else if (last_ascii_in == 7'd2) move = 3'd3;	// Up
					else if (last_ascii_in == 7'd4) move = 3'd4;	// Down
					else move = 3'b0;
				end
				
			end
			
			escape:
			begin
				move = 3'b0;
				mux_cursormove = 3'b0;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b0;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				moveEn = 1'b0;
				writeBlock = 1'b1;
				// !outblockbool then rampos_x <= mux_ramposx
				outblockbool = 1'b0;
				mux_ramposx = cursor_x;
				mux_ramposy = cursor_y;
				reverse = 1'b0;
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b0;
				esc = 1'b0; // Disabled
				mux_enter_shift = 1'b0;
				mux_enter_y = 9'b0;
				mux_tab_shift = 2'b0;
			end
			
			enter:
			begin
				move = 3'b0;
				mux_cursormove = 3'b0;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b0;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				moveEn = 1'b0;
				writeBlock = 1'b1;
				// !outblockbool then rampos_x <= mux_ramposx
				outblockbool = 1'b0;
				reverse = 1'b0;
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b0;
				esc = 1'b0;
				if (tab_shift == 2'b1) mux_tab_shift = 2'd2;
				else mux_tab_shift = 2'b0;
				
				// Skip the loop if y is next-line
				if (cursor_y == enter_y + 9'd10 || tab_shift == 2'd2)
				begin
					mux_enter_shift = 1'b0;
					mux_enter_y = 9'b0;
					mux_ramposx = cursor_x;
					mux_ramposy = cursor_y;
					
				end
				else
				begin
					mux_enter_shift = enter_shift;
					mux_enter_y = enter_y;
					mux_ramposx = 9'd308; // Last Block on RAM
					mux_ramposy = 9'd210;
				end
			end
			
			undefined_idle:
			begin
				move = 3'b0;
				mux_cursormove = 3'b0;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b0;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				moveEn = 1'b0;
				writeBlock = 1'b1;
				// !outblockbool then rampos_x <= mux_ramposx
				outblockbool = 1'b0;
				mux_ramposx = cursor_x;
				mux_ramposy = cursor_y;
				reverse = 1'b0;
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b1;
				esc = 1'b0;
				mux_enter_shift = 1'b0;
				mux_enter_y = 9'b0;
				mux_tab_shift = 2'b0;
			end
			
			changeaddr:
			begin
				move = 3'b0;
				mux_cursormove = 3'd0;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b0;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				// We don't move because we reached the cursor
				moveEn = 1'b0;
				writeBlock = 1'b1;
				// !outblockbool then rampos_x <= mux_ramposx
				outblockbool = 1'b0;
				mux_ramposx = cursor_x; // We just wait for 1 clock tick
				mux_ramposy = cursor_y;
				reverse = 1'b0;
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b0;
				esc = 1'b0;
				mux_enter_shift = 1'b0;
				mux_enter_y = 9'b0;
				mux_tab_shift = 2'b0;
			end
			
			shiftleft_prep:
			begin
				move = 3'b0;
				mux_cursormove = cursor_move;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b0;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				// We don't move because we reached the cursor
				if (next_state == RAM_to_VGA_preprep) moveEn = 1'b0;
				else moveEn = 1'b1;
				writeBlock = 1'b0;
				// Outblockbool then rampos_x becomes out_blocki
				outblockbool = 1'b1;
				mux_ramposx = 7'bx;
				mux_ramposy = 7'bx;
				reverse = 1'b0;
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b0;
				esc = 1'b0;
				mux_enter_shift = 1'b0;
				mux_enter_y = 9'b0;
				mux_tab_shift = 2'b0;
			end
			
			shiftleft_read:
			begin
				move = 3'b0;
				mux_cursormove = cursor_move;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b1;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				moveEn = 1'b1;
				writeBlock = 1'b0;
				// Outblockbool then rampos_x becomes out_blocki
				outblockbool = 1'b1;
				mux_ramposx = 7'bx;
				mux_ramposy = 7'bx;
				reverse = 1'b1; // Move to next block
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b0;
				esc = 1'b0;
				mux_enter_shift = 1'b0;
				mux_enter_y = 9'b0;
				mux_tab_shift = 2'b0;
			end
			
			shiftleft_write:
			begin
				move = 3'b0;
				mux_cursormove = cursor_move;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b0;
				writeEn = 1'b1; // Write this block from previous value
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				moveEn = 1'b1;
				writeBlock = 1'b0;
				// Outblockbool then rampos_x becomes out_blocki
				outblockbool = 1'b1;
				mux_ramposx = 7'bx;
				mux_ramposy = 7'bx;
				reverse = 1'b0; // Reverse block
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b0;
				esc = 1'b0;
				mux_enter_shift = 1'b0;
				mux_enter_y = 9'b0;
				mux_tab_shift = 2'b0;
			end
			
			shiftright_prep: 
			begin
				move = 3'b0;
				mux_cursormove = cursor_move;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b0;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				// We don't move because we reached the cursor
				if (next_state == PS2_to_RAM) moveEn = 1'b0;
				else moveEn = 1'b1;
				writeBlock = 1'b0;
				// Outblockbool then rampos_x becomes out_blocki
				outblockbool = 1'b1;
				mux_ramposx = 7'bx;
				mux_ramposy = 7'bx;
				reverse = 1'b1;
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b0;
				esc = 1'b0;
				mux_enter_shift = enter_shift;
				mux_enter_y = enter_y;
				mux_tab_shift = tab_shift;
			end
			
			shiftright_read:
			begin
				move = 3'b0;
				mux_cursormove = cursor_move;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b1;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				moveEn = 1'b1;
				writeBlock = 1'b0;
				// Outblockbool then rampos_x becomes out_blocki
				outblockbool = 1'b1;
				mux_ramposx = 7'bx;
				mux_ramposy = 7'bx;
				reverse = 1'b0; // Move to next block
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b0;
				esc = 1'b0;
				mux_enter_shift = enter_shift;
				mux_enter_y = enter_y;
				mux_tab_shift = tab_shift;
			end
			
			shiftright_write:
			begin
				move = 3'b0;
				mux_cursormove = cursor_move;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b0;
				writeEn = 1'b1; // Write this block from previous value
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				moveEn = 1'b1;
				writeBlock = 1'b0;
				// Outblockbool then rampos_x becomes out_blocki
				outblockbool = 1'b1;
				mux_ramposx = 7'bx;
				mux_ramposy = 7'bx;
				reverse = 1'b1; // Reverse block
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b0;
				esc = 1'b0;
				mux_enter_shift = enter_shift;
				mux_enter_y = enter_y;
				mux_tab_shift = tab_shift;
			end

			PS2_to_RAM: // Write the block from PS2 ASCII
			begin
				mux_cursormove = cursor_move;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b0;
				writeEn = 1'b1;
				writefrommux = 1'b1;
				moveEn = 1'b0; // Return the next block on shiftright_rw
				writeBlock = 1'b0;
				// !outblockbool then rampos_x <= mux_ramposx
				outblockbool = 1'b0;
				mux_ramposx = rampos_x;
				mux_ramposy = rampos_y;
				reverse = 1'b0;
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b0;
				esc = 1'b0;
				mux_tab_shift = tab_shift;
				if (enter_shift == 1'b1) // Go to Enter
				begin
					move = 3'd2; // Move Cursor
					mux_enter_y = enter_y;
					mux_ascii_write = 7'd32; // SPACE
					if (cursor_x == 9'd308 && tab_shift == 1'b0) mux_enter_shift = 1'b0;
					else mux_enter_shift = enter_shift;
				end
				else
				begin
					move = 3'b0;
					mux_enter_shift = 1'b0;
					mux_enter_y = 9'b0;
					mux_ascii_write = last_ascii_in;
				end
				
			end
			
			RAM_to_VGA_preprep: // Read that block
			begin
				move = 3'b0;
				mux_cursormove = cursor_move;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;		
				ascii_out = 7'bx;
				readEn = 1'b0;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				moveEn = 1'b0;
				writeBlock = 1'b1;
				// !outblockbool then rampos_x <= mux_ramposx
				outblockbool = 1'b0;
				mux_ramposx = 7'b0;
				mux_ramposy = 7'b0;
				reverse = 1'b0;
				asciidisplay_x = rampos_x;
				asciidisplay_y = rampos_y;
				blink = 1'b0;
				esc = 1'b0;
				mux_enter_shift = 1'b0;
				mux_enter_y = 9'b0;
				mux_tab_shift = 2'b0;
			end
			
			RAM_to_VGA_prep: // Read that block
			begin
				move = 3'b0;
				mux_cursormove = cursor_move;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;		
				ascii_out = 7'bx;
				readEn = 1'b1;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				moveEn = 1'b0;
				writeBlock = 1'b0;
				// Outblockbool then rampos_x becomes out_blocki
				outblockbool = 1'b1;
				mux_ramposx = 7'bx;
				mux_ramposy = 7'bx;
				reverse = 1'b0;
				asciidisplay_x = rampos_x;
				asciidisplay_y = rampos_y;
				blink = 1'b0;
				esc = 1'b0;
				mux_enter_shift = 1'b0;
				mux_enter_y = 9'b0;
				mux_tab_shift = 2'b0;
			end
			
			RAM_to_VGA: // Export that block to VGA
			begin
				move = 3'b0;
				mux_cursormove = cursor_move;
				ram_to_ps2_go = 1'b0;
				//if (ascii_read == 7'd0 || ascii_read == 7'd32) ram_to_vga_go = 1'b0;
				ram_to_vga_go = 1'b1; // Everytime this loops move 1 block for read
				
				ascii_out = ascii_read;
				readEn = 1'b0;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				moveEn = 1'b0;
				writeBlock = 1'b0;
				// Outblockbool then rampos_x becomes out_blocki
				outblockbool = 1'b1;
				mux_ramposx = 7'bx;
				mux_ramposy = 7'bx;
				reverse = 1'b0;
				asciidisplay_x = rampos_x;
				asciidisplay_y = rampos_y;
				blink = 1'b0;
				esc = 1'b0;
				mux_enter_shift = 1'b0;
				mux_enter_y = 9'b0;
				mux_tab_shift = 2'b0;
			end
			
			RAM_to_VGA_wait: // Moves a block
			begin
				move = 3'b0;
				mux_cursormove = cursor_move;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0; // Everytime this loops move 1 block for read
				ascii_out = 7'b0;
				readEn = 1'b0;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				if (next_state == RAM_to_VGA_prep) moveEn = 1'b1;
				else moveEn = 1'b0;
				writeBlock = 1'b0;
				// Outblockbool then rampos_x becomes out_blocki
				outblockbool = 1'b1;
				mux_ramposx = 7'bx;
				mux_ramposy = 7'bx;
				reverse = 1'b0;
				asciidisplay_x = rampos_x;
				asciidisplay_y = rampos_y;
				blink = 1'b0;
				esc = 1'b0;
				mux_enter_shift = 1'b0;
				mux_enter_y = 9'b0;
				mux_tab_shift = 2'b0;
			end

			default:
			begin
				move = 3'b0;
				mux_cursormove = cursor_move;
				ram_to_ps2_go = 1'b0;
				ram_to_vga_go = 1'b0;
				ascii_out = 7'bx;
				readEn = 1'b0;
				writeEn = 1'b0;
				writefrommux = 1'b0;
				mux_ascii_write = 7'bx;
				moveEn = 1'b0;
				writeBlock = 1'b0;
				// !outblockbool then rampos_x <= mux_ramposx
				outblockbool = 1'b0;
				mux_ramposx = cursor_x;
				mux_ramposy = cursor_y;
				reverse = 1'b0;
				asciidisplay_x = cursor_x;
				asciidisplay_y = cursor_y;
				blink = 1'b0;
				esc = 1'b0;
				mux_enter_shift = enter_shift;
				mux_enter_y = enter_y;
				mux_tab_shift = tab_shift;
			end
		endcase
	end

endmodule

module cat(input[8:0] cursor_x, cursor_y, output[10:0] address);

	// Blocks are x = [0-45] 6'b, y = [0-22] 5'b
	wire[5:0] ram_x, ram_y;
	assign ram_x = cursor_x/7;
	assign ram_y = cursor_y/10;
	assign address = {ram_x,ram_y[4:0]};
	
endmodule

// Returns next block after 1 clock tick
module nextBlock (input clock, reset, moveEn, writeBlock, output reg[8:0] reg_blocki, output reg[7:0] reg_blockj, input[8:0] in_blocki, input[7:0] in_blockj, input reverse, output reg[8:0] rampos_x, output reg[8:0] rampos_y, input outblockbool);

	always @(posedge clock, negedge reset)
	begin
		if (!reset)
			begin
				reg_blocki <= 0;
				reg_blockj <= 0;
				rampos_x <= 0;
				rampos_y <= 0;
				
			end
		else if (writeBlock) //write in
			begin
				reg_blocki <= in_blocki;
				reg_blockj <= in_blockj;
				rampos_x <= in_blocki;
				rampos_y <= in_blockj;
			end		
		else if (reg_blockj == 8'd0 && reg_blocki == 9'd0 && reverse == 1'd1 && moveEn == 1'd1) //reverse from top left corner stays put
			begin
				reg_blocki <= 0;
				reg_blockj <= 0;
				if (outblockbool)
				begin
					rampos_x <= 0;
					rampos_y <= 0;
				end
				else
				begin
					rampos_x <= in_blocki;
					rampos_y <= in_blockj;
				end
			end
		else if (reg_blocki == 9'd0 && reg_blockj == 8'd227 && reverse == 1'd1 && moveEn == 1'd1) //move up, set i to far right
			begin
				reg_blockj <= 8'd210;
				reg_blocki <= 9'd308;
				if (outblockbool)
				begin
					rampos_x <= 9'd308;
					rampos_y <= 8'd210;
				end
				else
				begin
					rampos_x <= in_blocki;
					rampos_y <= in_blockj;
				end
			end
		else if (reg_blocki == 9'd0 && reverse == 1'd1 && moveEn == 1'd1) //move up, set i to far right
			begin
				reg_blockj <= reg_blockj - 4'd10;
				reg_blocki <= 9'd308;
				if (outblockbool)
				begin
					rampos_x <= 9'd308;
					rampos_y <= reg_blockj - 4'd10;
				end
				else
				begin
					rampos_x <= in_blocki;
					rampos_y <= in_blockj;
				end
			end
		else if (reverse == 1'd1 && moveEn == 1'd1) //move left
			begin
				reg_blockj <= reg_blockj;
				reg_blocki <= reg_blocki - 3'd7;
				if (outblockbool)
				begin
					rampos_x <= reg_blocki - 3'd7;
					rampos_y <= reg_blockj;
				end
				else
				begin
					rampos_x <= in_blocki;
					rampos_y <= in_blockj;
				end
			end
		else if (reg_blockj == 8'd210 && reg_blocki == 9'd308 && moveEn == 1'd1)
			begin
				reg_blocki <= 9'd0;
				reg_blockj <= 8'd227;
				if (outblockbool)
				begin
					rampos_x <= 9'd0;
					rampos_y <= 8'd227;
				end
				else
				begin
					rampos_x <= in_blocki;
					rampos_y <= in_blockj;
				end
			end
		else if (reg_blockj == 8'd227 && reg_blocki == 9'd308 && moveEn == 1'd1)
			begin
				reg_blocki <= reg_blocki;
				reg_blockj <= reg_blockj;
				if (outblockbool)
				begin
					rampos_x <= reg_blocki;
					rampos_y <= reg_blockj;
				end
				else
				begin
					rampos_x <= in_blocki;
					rampos_y <= in_blockj;
				end
			end
		else if (reg_blocki == 9'd308 && moveEn == 1'd1) //move down
			begin
				reg_blocki <= 0;
				reg_blockj <= reg_blockj + 4'd10;
				if (outblockbool)
				begin
					rampos_x <= 0;
					rampos_y <= reg_blockj + 4'd10;
				end
				else
				begin
					rampos_x <= in_blocki;
					rampos_y <= in_blockj;
				end
			end
		else if (moveEn == 1'd1) //move right
			begin
				reg_blocki <= reg_blocki + 3'd7;
				reg_blockj <= reg_blockj;
				if (outblockbool)
				begin
					rampos_x <= reg_blocki + 3'd7;
					rampos_y <= reg_blockj;
				end
				else
				begin
					rampos_x <= in_blocki;
					rampos_y <= in_blockj;
				end
			end
		else
			begin
				reg_blocki <= reg_blocki;
				reg_blockj <= reg_blockj;
				if (outblockbool)
				begin
					rampos_x <= reg_blocki;
					rampos_y <= reg_blockj;
				end
				else
				begin
					rampos_x <= in_blocki;
					rampos_y <= in_blockj;
				end
			end
	end
	
endmodule
