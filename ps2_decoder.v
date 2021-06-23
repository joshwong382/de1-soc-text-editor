module ps2decoder(input CLOCK_50, reset, ram_to_ps2_go, output ps2_result_ready, inout PS2_CLK, PS2_DAT, output reg[6:0] reg_ascii);

wire[2:0] current_state;
wire[7:0] last_data_received;
wire[6:0] ascii;
wire ps2newdata;
wire[7:0] ps2code;

PS2_Controller PS2 (
	// Inputs
	.CLOCK_50				(CLOCK_50),
	.reset				(~reset),

	// Bidirectionals
	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	// Outputs
	.received_data		(ps2code),
	.received_data_en	(ps2newdata)
);

always@(posedge CLOCK_50, negedge reset)
begin
	if (!reset)
		reg_ascii <= 1'b0;
	else if (ascii == 7'b0) reg_ascii <= reg_ascii;
	else reg_ascii <= ascii;
end

ps2control pc(CLOCK_50, reset, ram_to_ps2_go, ps2newdata, ps2code, last_data_received, current_state);
ps2datapath pd(CLOCK_50, reset, ps2_result_ready, last_data_received, ascii, current_state);

endmodule

// HEX1-0: LAST DATA RECEIVED
// HEX5: STATE


module ps2control(input clock, reset, ram_to_ps2_go, ps2newdata, input[7:0] ps2code, output reg[7:0] last_data_received, output reg[2:0] current_state);

	reg[2:0] next_state;
	
	// PS2 data register
	always @(posedge clock, negedge reset)
	begin
		if (!reset)		
			last_data_received <= 8'h00;
		else if (ps2newdata == 1'b1)
			last_data_received <= ps2code;
	end

	// States
	localparam	wait_key			= 3'd0,
					check_table		= 3'd1,
					unpress			= 3'd2,
					caps_toggle	 	= 3'd3,
					unlock_caps		= 3'd4,
					shift_toggle	= 3'd5,
					unshift			= 3'd6,
					display 			= 3'd7;
    
	// Next state logic aka our state table
	always@(*)
	begin: state_table 
			case (current_state)
			
				wait_key: begin
				
									if (ps2newdata && ram_to_ps2_go)	next_state = check_table;
									else 								next_state = wait_key;
					
				end
				
				check_table: begin
																					
																							// default
																							next_state = display;
									if (ps2code == 8'hF0)							next_state = unpress;
									if (ps2code == 8'h12 || ps2code == 8'h59)	next_state = shift_toggle;
									if (ps2code == 8'h58) 							next_state = caps_toggle;
									if (ps2code == 8'hE0)							next_state = wait_key; // ignore E0
					
				end
				
				unpress: begin
				
																							// default
																							next_state = wait_key;
									if (ps2code == 8'h12 || ps2code == 8'h59)	next_state = unshift;
									if (ps2code == 8'h58)							next_state = unlock_caps;
									if (last_data_received == 8'hF0)				next_state = unpress;
					
				end
				
				caps_toggle: begin
				
									next_state = wait_key;
					
				end
				
				unlock_caps: begin
				
									next_state = wait_key;
					
				end
				
				shift_toggle: begin
				
									next_state = wait_key;
					
				end
				
				unshift: begin
				
									next_state = wait_key;
					
				end
				
				display: begin
				
									next_state = wait_key;
					
				end
			
				default:			next_state = wait_key;
				
			endcase
	end // state_table

	// current_state register
	always@(posedge clock, negedge reset)
	begin: state_FFs
		if(!reset)
			current_state <= wait_key;
		else
			current_state <= next_state;
	end // state_FFS

endmodule

module ps2datapath(input clock, reset, output reg ps2_result_ready, input[7:0] last_data_received, output reg[6:0] ascii, input[2:0] current_state);

	// caps_wait waits for the caps to be released before allowing a caps repress
	wire shift;
	reg shift_1, shift_2, caps, caps_wait;
	reg mux_shift_1, mux_shift_2, mux_caps, mux_caps_wait, mux_go;
	wire[6:0] ascii_in;
	
	assign shift = shift_1 | shift_2;

	// shift and caps register
	always@(posedge clock, negedge reset)
	begin
      if(!reset)
			begin 
				shift_1 <= 1'b0;
				shift_2 <= 1'b0;
				caps <= 1'b0;
				caps_wait <= 1'b0;
				ps2_result_ready <= 1'b0;
			end
		else
			begin
				shift_1 <= mux_shift_1;
				shift_2 <= mux_shift_2;
				caps <= mux_caps;
				caps_wait <= mux_caps_wait;
				ps2_result_ready <= mux_go;
			end
	end

	// States
	localparam	wait_key			= 3'd0,
					check_table		= 3'd1,
					unpress			= 3'd2,
					caps_toggle	 	= 3'd3,
					unlock_caps		= 3'd4,
					shift_toggle	= 3'd5,
					unshift			= 3'd6,
					display 			= 3'd7;
					
	// ASCII stuff
	outputkey ok(last_data_received, shift, caps, ascii_in);
	
	// ASCII will be set 0 when this FSM is not ready to output.
	
	// mux for current_state
	always@(*)
	begin
		case(current_state)
		
			wait_key: begin
				
				mux_shift_1 = shift_1;
				mux_shift_2 = shift_2;
				mux_caps = caps;
				mux_caps_wait = caps_wait;
				ascii = 7'b0;
				mux_go = 1'b0;
				
			end
			
			check_table: begin
			
				mux_shift_1 = shift_1;
				mux_shift_2 = shift_2;
				mux_caps = caps;
				mux_caps_wait = caps_wait;
				ascii = 7'b0;
				mux_go = 1'b0;
			
			end
			
			unpress: begin
			
				mux_shift_1 = shift_1;
				mux_shift_2 = shift_2;
				mux_caps = caps;
				mux_caps_wait = caps_wait;
				ascii = 7'b0;
				mux_go = 1'b0;
			
			end
			
			caps_toggle: begin
			
				mux_shift_1 = shift_1;
				mux_shift_2 = shift_2;
				ascii = 7'b0;
				mux_go = 1'b0;
				
				// If caps is lifted up toggle caps
				if (caps_wait == 1'b1)
					begin
						mux_caps = caps;
						mux_caps_wait = 1'b1;
					end
				else
					begin
						mux_caps = ~caps;
						mux_caps_wait = 1'b1;
					end
			
			end
			
			unlock_caps: begin
			
				mux_shift_1 = shift_1;
				mux_shift_2 = shift_2;
				mux_caps = caps;
				mux_caps_wait = 1'b0;
				ascii = 7'b0;
				mux_go = 1'b0;
			
			end
			
			shift_toggle: begin
			
				// If one shift is already pressed down then the other shift becomes 1.
				if (last_data_received == 8'h12)
					begin
						mux_shift_1 = 1'b1;
						mux_shift_2 = shift_2;
					end
				else if (last_data_received == 8'h59)
					begin
						mux_shift_1 = shift_1;
						mux_shift_2 = 1'b1;
					end
				else
					begin
						mux_shift_1 = shift_1;
						mux_shift_2 = shift_2;
					end
					
				mux_caps = caps;
				mux_caps_wait = caps_wait;
				ascii = 7'b0;
				mux_go = 1'b0;
			
			end
			
			unshift: begin
			
				// If both shifts are pressed then only release the second shift
				if (last_data_received == 8'h12)
					begin
						mux_shift_1 = 1'b0;
						mux_shift_2 = shift_2;
					end
				else if (last_data_received == 8'h59)
					begin
						mux_shift_1 = shift_1;
						mux_shift_2 = 1'b0;
					end
				else
					begin
						mux_shift_1 = shift_1;
						mux_shift_2 = shift_2;
					end
					
				mux_caps = caps;
				mux_caps_wait = caps_wait;
				ascii = 7'b0;
				mux_go = 1'b0;
			
			end
			
			display: begin
			
				mux_shift_1 = shift_1;
				mux_shift_2 = shift_2;
				mux_caps = caps;
				mux_caps_wait = caps_wait;
				ascii = ascii_in;
				mux_go = 1'b1;
			
			end
			
			default: begin
			
				mux_shift_1 = shift_1;
				mux_shift_2 = shift_2;
				mux_caps = caps;
				mux_caps_wait = caps_wait;
				ascii = 7'b0;
				mux_go = 1'b0;
			
			end
			
		endcase
	end
	
endmodule

// Determines which table to use
module outputkey(input[7:0] ps2code, input shift, input caps, output reg[6:0] ascii);

	wire[6:0] defaultascii;
	wire[6:0] capsascii;
	wire[6:0] alternateascii;
	wire[6:0] altcapsascii;
	
	default_table dt(ps2code,defaultascii); 
	caps_table ct(ps2code, capsascii);
	alternate_table at(ps2code, alternateascii);
	alternatecaps_table act(ps2code, altcapsascii);
	
	// mux the default and alternate table.
	always@(*)
	begin
		case({shift, caps})
			2'b00:	ascii = defaultascii;
			2'b01:	ascii = capsascii;
			2'b10:	ascii = alternateascii;
			2'b11:	ascii = altcapsascii;
		endcase
	end
	
endmodule

// Shift 0, CAPS 0
module default_table(input[7:0] ps2code, output reg[6:0] ascii);
	
	always@(*)
	begin
		case(ps2code) // No tabs, Enter, Delete, do up left down right) // Keypad NOT supported
			// Letters
			8'h1C: ascii = 7'd97;
			8'h32: ascii = 7'd98;
			8'h21: ascii = 7'd99;
			8'h23: ascii = 7'd100;
			8'h24: ascii = 7'd101;
			8'h2B: ascii = 7'd102;
			8'h34: ascii = 7'd103;
			8'h33: ascii = 7'd104;
			8'h43: ascii = 7'd105;
			8'h3B: ascii = 7'd106;
			8'h42: ascii = 7'd107;
			8'h4B: ascii = 7'd108;
			8'h3A: ascii = 7'd109;
			8'h31: ascii = 7'd110;
			8'h44: ascii = 7'd111;
			8'h4D: ascii = 7'd112;
			8'h15: ascii = 7'd113;
			8'h2D: ascii = 7'd114;
			8'h1B: ascii = 7'd115;
			8'h2C: ascii = 7'd116;
			8'h3C: ascii = 7'd117;
			8'h2A: ascii = 7'd118;
			8'h1D: ascii = 7'd119;
			8'h22: ascii = 7'd120;
			8'h35: ascii = 7'd121;
			8'h1A: ascii = 7'd122;
			// Numbers
			8'h45: ascii = 7'd48;
			8'h16: ascii = 7'd49;
			8'h1E: ascii = 7'd50;
			8'h26: ascii = 7'd51;
			8'h25: ascii = 7'd52;
			8'h2E: ascii = 7'd53;
			8'h36: ascii = 7'd54;
			8'h3D: ascii = 7'd55;
			8'h3E: ascii = 7'd56;
			8'h46: ascii = 7'd57;
			8'h0E: ascii = 7'd96;
			8'h4E: ascii = 7'd45;
			8'h55: ascii = 7'd61;
			8'h5D: ascii = 7'd92;
			8'h29: ascii = 7'd32;
			8'h54: ascii = 7'd91;
			8'h5B: ascii = 7'd93;
			8'h4C: ascii = 7'd59;
			8'h52: ascii = 7'd39;
			8'h41: ascii = 7'd44;
			8'h49: ascii = 7'd46;
			8'h4A: ascii = 7'd47;
			// Non-written characters
			8'h66: ascii = 7'd08;
			8'h71: ascii = 7'd127;
			// proprietary
			8'h75: ascii = 7'd02; // up
			8'h6B: ascii = 7'd03; // left
			8'h72: ascii = 7'd04; // down
			8'h74: ascii = 7'd05; // right
			8'h76: ascii = 7'd06; // ESC
			8'h5A: ascii = 7'd07; // ENTER
			8'h0D: ascii = 7'd08; // TAB
			default: ascii = 7'b1;
		endcase
	end

endmodule

// Shift 0, CAPS 1
module caps_table(input[7:0] ps2code, output reg[6:0] ascii);
	
	always@(*)
	begin
		case(ps2code) // No backspace, tabs, Enter, Delete, do up left down right) // Keypad NOT supported
			// Letters
			8'h1C: ascii = 7'd65;
			8'h32: ascii = 7'd66;
			8'h21: ascii = 7'd67;
			8'h23: ascii = 7'd68;
			8'h24: ascii = 7'd69;
			8'h2B: ascii = 7'd70;
			8'h34: ascii = 7'd71;
			8'h33: ascii = 7'd72;
			8'h43: ascii = 7'd73;
			8'h3B: ascii = 7'd74;
			8'h42: ascii = 7'd75;
			8'h4B: ascii = 7'd76;
			8'h3A: ascii = 7'd77;
			8'h31: ascii = 7'd78;
			8'h44: ascii = 7'd79;
			8'h4D: ascii = 7'd80;
			8'h15: ascii = 7'd81;
			8'h2D: ascii = 7'd82;
			8'h1B: ascii = 7'd83;
			8'h2C: ascii = 7'd84;
			8'h3C: ascii = 7'd85;
			8'h2A: ascii = 7'd86;
			8'h1D: ascii = 7'd87;
			8'h22: ascii = 7'd88;
			8'h35: ascii = 7'd89;
			8'h1A: ascii = 7'd90;
			// Numbers
			8'h45: ascii = 7'd48;
			8'h16: ascii = 7'd49;
			8'h1E: ascii = 7'd50;
			8'h26: ascii = 7'd51;
			8'h25: ascii = 7'd52;
			8'h2E: ascii = 7'd53;
			8'h36: ascii = 7'd54;
			8'h3D: ascii = 7'd55;
			8'h3E: ascii = 7'd56;
			8'h46: ascii = 7'd57;
			8'h0E: ascii = 7'd96;
			8'h4E: ascii = 7'd45;
			8'h55: ascii = 7'd61;
			8'h5D: ascii = 7'd92;
			8'h29: ascii = 7'd32;
			8'h54: ascii = 7'd91;
			8'h5B: ascii = 7'd93;
			8'h4C: ascii = 7'd59;
			8'h52: ascii = 7'd39;
			8'h41: ascii = 7'd44;
			8'h49: ascii = 7'd46;
			8'h4A: ascii = 7'd47;
			// Non-written characters
			8'h66: ascii = 7'd08;
			8'h71: ascii = 7'd127;
			// proprietary
			8'h75: ascii = 7'd02; // up
			8'h6B: ascii = 7'd03; // left
			8'h72: ascii = 7'd04; // down
			8'h74: ascii = 7'd05; // right
			8'h76: ascii = 7'd06; // ESC
			8'h5A: ascii = 7'd07; // ENTER
			8'h0D: ascii = 7'd08; // TAB
			default: ascii = 7'b1;
		endcase
	end

endmodule

// Shift 1, CAPS 0
module alternate_table(input[7:0] ps2code, output reg[6:0] ascii);

	always@(*)
	begin
		case(ps2code) // US International Keyboard mapping
			// Letters
			8'h1C: ascii = 7'd65;
			8'h32: ascii = 7'd66;
			8'h21: ascii = 7'd67;
			8'h23: ascii = 7'd68;
			8'h24: ascii = 7'd69;
			8'h2B: ascii = 7'd70;
			8'h34: ascii = 7'd71;
			8'h33: ascii = 7'd72;
			8'h43: ascii = 7'd73;
			8'h3B: ascii = 7'd74;
			8'h42: ascii = 7'd75;
			8'h4B: ascii = 7'd76;
			8'h3A: ascii = 7'd77;
			8'h31: ascii = 7'd78;
			8'h44: ascii = 7'd79;
			8'h4D: ascii = 7'd80;
			8'h15: ascii = 7'd81;
			8'h2D: ascii = 7'd82;
			8'h1B: ascii = 7'd83;
			8'h2C: ascii = 7'd84;
			8'h3C: ascii = 7'd85;
			8'h2A: ascii = 7'd86;
			8'h1D: ascii = 7'd87;
			8'h22: ascii = 7'd88;
			8'h35: ascii = 7'd89;
			8'h1A: ascii = 7'd90;
			// Numbers
			8'h45: ascii = 7'd41;
			8'h16: ascii = 7'd33;
			8'h1E: ascii = 7'd64;
			8'h26: ascii = 7'd35;
			8'h25: ascii = 7'd36;
			8'h2E: ascii = 7'd37;
			8'h36: ascii = 7'd94;
			8'h3D: ascii = 7'd38;
			8'h3E: ascii = 7'd42;
			8'h46: ascii = 7'd40;
			8'h0E: ascii = 7'd126;
			8'h4E: ascii = 7'd95;
			8'h55: ascii = 7'd43;
			8'h5D: ascii = 7'd124;
			8'h29: ascii = 7'd32;
			8'h54: ascii = 7'd123;
			8'h5B: ascii = 7'd125;
			8'h4C: ascii = 7'd58;
			8'h52: ascii = 7'd34;
			8'h41: ascii = 7'd60;
			8'h49: ascii = 7'd62;
			8'h4A: ascii = 7'd63;
			// Non-written characters
			8'h66: ascii = 7'd08;
			8'h71: ascii = 7'd127;
			// proprietary
			8'h75: ascii = 7'd02; // up
			8'h6B: ascii = 7'd03; // left
			8'h72: ascii = 7'd04; // down
			8'h74: ascii = 7'd05; // right
			8'h76: ascii = 7'd06; // ESC
			8'h5A: ascii = 7'd07; // ENTER
			8'h0D: ascii = 7'd08; // TAB
			default: ascii = 7'b1;
		endcase
	end

endmodule

// Shift 1, CAPS 1
module alternatecaps_table(input[7:0] ps2code, output reg[6:0] ascii);

	always@(*)
	begin
		case(ps2code) // US International Keyboard mapping
			// Letters
			8'h1C: ascii = 7'd97;
			8'h32: ascii = 7'd98;
			8'h21: ascii = 7'd99;
			8'h23: ascii = 7'd100;
			8'h24: ascii = 7'd101;
			8'h2B: ascii = 7'd102;
			8'h34: ascii = 7'd103;
			8'h33: ascii = 7'd104;
			8'h43: ascii = 7'd105;
			8'h3B: ascii = 7'd106;
			8'h42: ascii = 7'd107;
			8'h4B: ascii = 7'd108;
			8'h3A: ascii = 7'd109;
			8'h31: ascii = 7'd110;
			8'h44: ascii = 7'd111;
			8'h4D: ascii = 7'd112;
			8'h15: ascii = 7'd113;
			8'h2D: ascii = 7'd114;
			8'h1B: ascii = 7'd115;
			8'h2C: ascii = 7'd116;
			8'h3C: ascii = 7'd117;
			8'h2A: ascii = 7'd118;
			8'h1D: ascii = 7'd119;
			8'h22: ascii = 7'd120;
			8'h35: ascii = 7'd121;
			8'h1A: ascii = 7'd122;
			// Numbers
			8'h45: ascii = 7'd41;
			8'h16: ascii = 7'd33;
			8'h1E: ascii = 7'd64;
			8'h26: ascii = 7'd35;
			8'h25: ascii = 7'd36;
			8'h2E: ascii = 7'd37;
			8'h36: ascii = 7'd94;
			8'h3D: ascii = 7'd38;
			8'h3E: ascii = 7'd42;
			8'h46: ascii = 7'd40;
			8'h0E: ascii = 7'd126;
			8'h4E: ascii = 7'd95;
			8'h55: ascii = 7'd43;
			8'h5D: ascii = 7'd124;
			8'h29: ascii = 7'd32;
			8'h54: ascii = 7'd123;
			8'h5B: ascii = 7'd125;
			8'h4C: ascii = 7'd58;
			8'h52: ascii = 7'd34;
			8'h41: ascii = 7'd60;
			8'h49: ascii = 7'd62;
			8'h4A: ascii = 7'd63;
			// Non-written characters
			8'h66: ascii = 7'd08;
			8'h71: ascii = 7'd127;
			// proprietary
			8'h75: ascii = 7'd02; // up
			8'h6B: ascii = 7'd03; // left
			8'h72: ascii = 7'd04; // down
			8'h74: ascii = 7'd05; // right
			8'h76: ascii = 7'd06; // ESC
			8'h5A: ascii = 7'd07; // ENTER
			8'h0D: ascii = 7'd08; // TAB
			default: ascii = 7'b1;
		endcase
	end

endmodule
