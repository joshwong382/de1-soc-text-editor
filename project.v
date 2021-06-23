// This project is done by both Joshua Wong and Jonathan Wong.

module project(
	input 			CLOCK_50,
	input		[3:0] KEY,
	output	[6:0]	HEX0, HEX1,
	output	[6:0] HEX2,
	output	[6:0] HEX3, HEX4,
	output	[6:0] HEX5,
	inout				PS2_CLK,
	inout				PS2_DAT,
	output			VGA_CLK,   				//	VGA Clock
	output			VGA_HS,					//	VGA H_SYNC
	output			VGA_VS,					//	VGA V_SYNC
	output			VGA_BLANK_N,			//	VGA BLANK
	output			VGA_SYNC_N,				//	VGA SYNC
	output	[9:0]	VGA_R,   				//	VGA Red[9:0]
	output	[9:0]	VGA_G,	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B	   				//	VGA Blue[9:0]
	);

	wire reset = KEY[0];
	wire[8:0] letter_x, blink_x, cursor_x, asciidisplay_x;
	wire[8:0] letter_y, blink_y, cursor_y, asciidisplay_y;
	reg [8:0] x, y;
	wire[6:0] ascii_in, ascii_out;
	wire ps2_result_ready, vga_is_done, ram_to_ps2_go, ram_to_vga_go, letter_En, blink_En, esc, clr, wr, blink;
	reg writeEn;
	reg [2:0] out_color;
	wire[2:0] letter_out_color, blink_out_color;
	wire[4:0] current_state_vga;
	wire[4:0] current_state_ram;
	wire[2:0] blink_state;
	wire[2:0] move;
	wire vga_to_blink, ram_to_blink, blink_clock;

	hexdisp h5({1'b0, blink_state}, HEX5);
	
	// Cursor input: mux_x, mux_y for external changes
	// Cursor output: cursor_x, cursor_y
	// Main FSM: State Write and Command
	cursorstate cur0(CLOCK_50, reset, esc, clr, wr, move, cursor_x, cursor_y);
	
	// RAM
	// Huge FSM: Controls the When to read PS2 and when to export to VGA
	ram_rw rw0(CLOCK_50, reset, cursor_x, cursor_y, ascii_in, ascii_out, ps2_result_ready, vga_is_done, ram_to_ps2_go, ram_to_vga_go, asciidisplay_x, asciidisplay_y, current_state_ram, move, esc, clr, wr, ram_to_blink, HEX0, HEX1, HEX4);

	// PS2 to ASCII
	ps2decoder p2d(CLOCK_50, reset, ram_to_ps2_go, ps2_result_ready, PS2_CLK, PS2_DAT, ascii_in);
	
	// ASCII, cursor_x, cursor_y to x,y, writeEn, out_color
	asciidisplay ad0(CLOCK_50, reset, vga_is_done, ram_to_vga_go, ascii_out, asciidisplay_x, asciidisplay_y, letter_x, letter_y, letter_En, letter_out_color, current_state_vga, vga_to_blink);
	
	// Blinker Module
	blink_top b_t0(CLOCK_50, reset, blink, cursor_x, cursor_y, blink_x, blink_y, blink_out_color, blink_En, blink_clock, blink_state); //cursor_x and cursor_y is block_x and block_y

	// VGA Display
	fill f0(CLOCK_50, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B, x, y, writeEn, out_color, reset);
	
	//mux the display to either asciidisplay or blink_disp
	assign blink = ram_to_blink & vga_to_blink;
	always@(*)
	begin
		case(blink)
		1'b0: begin
			x = letter_x;
			y = letter_y;
			out_color = letter_out_color;	
			writeEn = letter_En;
		end
		1'b1: begin
			x = blink_x;
			y = blink_y;
			out_color = blink_out_color;
			writeEn = blink_En;
		end
		default: begin
			x = letter_x;
			y = letter_y;
			out_color = letter_out_color;
			writeEn = letter_En;
		end
		endcase
	end
	
endmodule
