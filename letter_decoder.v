/* File Header

   Part of this file is generated from https://ca.josh-wong.tk/public/lettercases.php, which is written by Joshua Wong - the co-creator of this project.
   If the source code of this .php file is to be released to a certain party, they agree not to distribute or reuse this code in any way without permission from the owner.
	The database of the corresponding code is attached to a .csv file on https://ca.josh-wong.tk/public/lettercases.csv
	
*/

module asciiExists(input[6:0] ASCII, output reg defined); // Only specify defined=1 when a visible printable character is entered.

	always@(*)
	begin: ascii_defined
		case(ASCII)
			7'd32:	defined = 1'b1; //SPACE
			7'd33:	defined = 1'b1; //!
			7'd34:	defined = 1'b1; //"
			7'd35:	defined = 1'b1; //#
			7'd36:	defined = 1'b1; //$
			7'd37:	defined = 1'b1; //%
			7'd38:	defined = 1'b1; //&
			7'd39:	defined = 1'b1; //'
			7'd40:	defined = 1'b1; //(
			7'd41:	defined = 1'b1; //)
			7'd42:	defined = 1'b1; //*
			7'd43:	defined = 1'b1; //+
			7'd44:	defined = 1'b1; //,
			7'd45:	defined = 1'b1; //-
			7'd46:	defined = 1'b1; //.
			7'd47:	defined = 1'b1; ///
			7'd48:	defined = 1'b1; //0
			7'd49:	defined = 1'b1; //1
			7'd50:	defined = 1'b1; //2
			7'd51:	defined = 1'b1; //3
			7'd52:	defined = 1'b1; //4
			7'd53:	defined = 1'b1; //5
			7'd54:	defined = 1'b1; //6
			7'd55:	defined = 1'b1; //7
			7'd56:	defined = 1'b1; //8
			7'd57:	defined = 1'b1; //9
			7'd58:	defined = 1'b1; //:
			7'd59:	defined = 1'b1; //;
			7'd60:	defined = 1'b1; //<
			7'd61:	defined = 1'b1; //=
			7'd62:	defined = 1'b1; //>
			7'd63:	defined = 1'b1; //?
			7'd64:	defined = 1'b1; //@
			7'd65:	defined = 1'b1; //A
			7'd66:	defined = 1'b1; //B
			7'd67:	defined = 1'b1; //C
			7'd68:	defined = 1'b1; //D
			7'd69:	defined = 1'b1; //E
			7'd70:	defined = 1'b1; //F
			7'd71:	defined = 1'b1; //G
			7'd72:	defined = 1'b1; //H
			7'd73:	defined = 1'b1; //I
			7'd74:	defined = 1'b1; //J
			7'd75:	defined = 1'b1; //K
			7'd76:	defined = 1'b1; //L
			7'd77:	defined = 1'b1; //M
			7'd78:	defined = 1'b1; //N
			7'd79:	defined = 1'b1; //O
			7'd80:	defined = 1'b1; //P
			7'd81:	defined = 1'b1; //Q
			7'd82:	defined = 1'b1; //R
			7'd83:	defined = 1'b1; //S
			7'd84:	defined = 1'b1; //T
			7'd85:	defined = 1'b1; //U
			7'd86:	defined = 1'b1; //V
			7'd87:	defined = 1'b1; //W
			7'd88:	defined = 1'b1; //X
			7'd89:	defined = 1'b1; //Y
			7'd90:	defined = 1'b1; //Z
			7'd91:	defined = 1'b1; //[
			7'd93:	defined = 1'b1; //]
			7'd94:	defined = 1'b1; //^
			7'd95:	defined = 1'b1; //_
			7'd96:	defined = 1'b1; //`
			7'd97:	defined = 1'b1; //a
			7'd98:	defined = 1'b1; //b
			7'd99:	defined = 1'b1; //c
			7'd100:	defined = 1'b1; //d
			7'd101:	defined = 1'b1; //e
			7'd102:	defined = 1'b1; //f
			7'd103:	defined = 1'b1; //g
			7'd104:	defined = 1'b1; //h
			7'd105:	defined = 1'b1; //i
			7'd106:	defined = 1'b1; //j
			7'd107:	defined = 1'b1; //k
			7'd108:	defined = 1'b1; //l
			7'd109:	defined = 1'b1; //m
			7'd110:	defined = 1'b1; //n
			7'd111:	defined = 1'b1; //o
			7'd112:	defined = 1'b1; //p
			7'd113:	defined = 1'b1; //q
			7'd114:	defined = 1'b1; //r
			7'd115:	defined = 1'b1; //s
			7'd116:	defined = 1'b1; //t
			7'd117:	defined = 1'b1; //u
			7'd118:	defined = 1'b1; //v
			7'd119:	defined = 1'b1; //w
			7'd120:	defined = 1'b1; //x
			7'd121:	defined = 1'b1; //y
			7'd122:	defined = 1'b1; //z
			7'd123:	defined = 1'b1; //{
			7'd124:	defined = 1'b1; //|
			7'd125:	defined = 1'b1; //}
			7'd126:	defined = 1'b1; //~
			default: defined = 1'b0;
		endcase
	end
endmodule

module letterDecoder(input [6:0] ASCII, input [3:0] out_row, input [2:0] out_col, output reg [2:0] letter_color);

	always@(*)
	begin: letter_decoder
		case(ASCII)
	// SPACE
			7'd32:	begin
					case({out_row, out_col})
						default: letter_color = 3'b111;
					endcase
				end
	// !
			7'd33:	begin
					case({out_row, out_col})
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// "
			7'd34:	begin
					case({out_row, out_col})
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd1}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// #
			7'd35:	begin
					case({out_row, out_col})
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd5}: letter_color = 3'd0;
						{4'd3, 3'd6}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd1}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd5}: letter_color = 3'd0;
						{4'd5, 3'd6}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// $
			7'd36:	begin
					case({out_row, out_col})
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd8, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// %
			7'd37:	begin
					case({out_row, out_col})
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd1}: letter_color = 3'd0;
						{4'd2, 3'd5}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd5}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// &
			7'd38:	begin
					case({out_row, out_col})
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd1}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd5}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// '
			7'd39:	begin
					case({out_row, out_col})
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// (
			7'd40:	begin
					case({out_row, out_col})
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// )
			7'd41:	begin
					case({out_row, out_col})
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// *
			7'd42:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd1}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// +
			7'd43:	begin
					case({out_row, out_col})
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd5}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd5}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// ,
			7'd44:	begin
					case({out_row, out_col})
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd8, 3'd1}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// -
			7'd45:	begin
					case({out_row, out_col})
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// .
			7'd46:	begin
					case({out_row, out_col})
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// /
			7'd47:	begin
					case({out_row, out_col})
						{4'd2, 3'd5}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// 0
			7'd48:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// 1
			7'd49:	begin
					case({out_row, out_col})
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// 2
			7'd50:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd5}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// 3
			7'd51:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// 4
			7'd52:	begin
					case({out_row, out_col})
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd5}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// 5
			7'd53:	begin
					case({out_row, out_col})
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// 6
			7'd54:	begin
					case({out_row, out_col})
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// 7
			7'd55:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd0, 3'd5}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// 8
			7'd56:	begin
					case({out_row, out_col})
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// 9
			7'd57:	begin
					case({out_row, out_col})
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// :
			7'd58:	begin
					case({out_row, out_col})
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// ;
			7'd59:	begin
					case({out_row, out_col})
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd8, 3'd1}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// <
			7'd60:	begin
					case({out_row, out_col})
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// =
			7'd61:	begin
					case({out_row, out_col})
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd1}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// >
			7'd62:	begin
					case({out_row, out_col})
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// ?
			7'd63:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// @
			7'd64:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd0, 3'd5}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd6}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd6}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd6}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd6}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd5}: letter_color = 3'd0;
						{4'd5, 3'd6}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd6}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// A
			7'd65:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// B
			7'd66:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// C
			7'd67:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// D
			7'd68:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// E
			7'd69:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// F
			7'd70:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// G
			7'd71:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// H
			7'd72:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// I
			7'd73:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// J
			7'd74:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd0, 3'd5}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// K
			7'd75:	begin
					case({out_row, out_col})
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// L
			7'd76:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// M
			7'd77:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// N
			7'd78:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd5}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd5}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd5}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd5}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd5}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd5}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd5}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// O
			7'd79:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// P
			7'd80:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// Q
			7'd81:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// R
			7'd82:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// S
			7'd83:	begin
					case({out_row, out_col})
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// T
			7'd84:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// U
			7'd85:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// V
			7'd86:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd5}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd5}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd5}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd5}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd5}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd5}: letter_color = 3'd0;
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// W
			7'd87:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// X
			7'd88:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd5}: letter_color = 3'd0;
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// Y
			7'd89:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// Z
			7'd90:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd0, 3'd5}: letter_color = 3'd0;
						{4'd1, 3'd5}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// [
			7'd91:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd2, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd5, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// ]
			7'd93:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// ^
			7'd94:	begin
					case({out_row, out_col})
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// _
			7'd95:	begin
					case({out_row, out_col})
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// `
			7'd96:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// a
			7'd97:	begin
					case({out_row, out_col})
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd5}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd5}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd5}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// b
			7'd98:	begin
					case({out_row, out_col})
						{4'd0, 3'd0}: letter_color = 3'd0;
						{4'd1, 3'd0}: letter_color = 3'd0;
						{4'd2, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// c
			7'd99:	begin
					case({out_row, out_col})
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// d
			7'd100:	begin
					case({out_row, out_col})
						{4'd0, 3'd4}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd4}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// e
			7'd101:	begin
					case({out_row, out_col})
						{4'd2, 3'd1}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd1}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// f
			7'd102:	begin
					case({out_row, out_col})
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd4}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd8, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// g
			7'd103:	begin
					case({out_row, out_col})
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd1}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						{4'd8, 3'd1}: letter_color = 3'd0;
						{4'd8, 3'd4}: letter_color = 3'd0;
						{4'd9, 3'd2}: letter_color = 3'd0;
						{4'd9, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// h
			7'd104:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd2, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd1}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// i
			7'd105:	begin
					case({out_row, out_col})
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// j
			7'd106:	begin
					case({out_row, out_col})
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// k
			7'd107:	begin
					case({out_row, out_col})
						{4'd0, 3'd1}: letter_color = 3'd0;
						{4'd1, 3'd1}: letter_color = 3'd0;
						{4'd2, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// l
			7'd108:	begin
					case({out_row, out_col})
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// m
			7'd109:	begin
					case({out_row, out_col})
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd5}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd6}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd6}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd6}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// n
			7'd110:	begin
					case({out_row, out_col})
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd1}: letter_color = 3'd0;
						{4'd5, 3'd5}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd5}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// o
			7'd111:	begin
					case({out_row, out_col})
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// p
			7'd112:	begin
					case({out_row, out_col})
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd1}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd8, 3'd0}: letter_color = 3'd0;
						{4'd9, 3'd0}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// q
			7'd113:	begin
					case({out_row, out_col})
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd8, 3'd3}: letter_color = 3'd0;
						{4'd8, 3'd4}: letter_color = 3'd0;
						{4'd9, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// r
			7'd114:	begin
					case({out_row, out_col})
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// s
			7'd115:	begin
					case({out_row, out_col})
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd1}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// t
			7'd116:	begin
					case({out_row, out_col})
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// u
			7'd117:	begin
					case({out_row, out_col})
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// v
			7'd118:	begin
					case({out_row, out_col})
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// w
			7'd119:	begin
					case({out_row, out_col})
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd6, 3'd0}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd4}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// x
			7'd120:	begin
					case({out_row, out_col})
						{4'd3, 3'd0}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd4}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// y
			7'd121:	begin
					case({out_row, out_col})
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd0}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						{4'd8, 3'd0}: letter_color = 3'd0;
						{4'd8, 3'd3}: letter_color = 3'd0;
						{4'd9, 3'd1}: letter_color = 3'd0;
						{4'd9, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// z
			7'd122:	begin
					case({out_row, out_col})
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd0}: letter_color = 3'd0;
						{4'd7, 3'd1}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// {
			7'd123:	begin
					case({out_row, out_col})
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd4, 3'd1}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// |
			7'd124:	begin
					case({out_row, out_col})
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd1, 3'd2}: letter_color = 3'd0;
						{4'd2, 3'd2}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd2}: letter_color = 3'd0;
						{4'd5, 3'd2}: letter_color = 3'd0;
						{4'd6, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// }
			7'd125:	begin
					case({out_row, out_col})
						{4'd0, 3'd2}: letter_color = 3'd0;
						{4'd0, 3'd3}: letter_color = 3'd0;
						{4'd1, 3'd3}: letter_color = 3'd0;
						{4'd2, 3'd3}: letter_color = 3'd0;
						{4'd3, 3'd4}: letter_color = 3'd0;
						{4'd4, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd6, 3'd3}: letter_color = 3'd0;
						{4'd7, 3'd2}: letter_color = 3'd0;
						{4'd7, 3'd3}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// ~
			7'd126:	begin
					case({out_row, out_col})
						{4'd3, 3'd1}: letter_color = 3'd0;
						{4'd3, 3'd2}: letter_color = 3'd0;
						{4'd4, 3'd0}: letter_color = 3'd0;
						{4'd4, 3'd3}: letter_color = 3'd0;
						{4'd4, 3'd6}: letter_color = 3'd0;
						{4'd5, 3'd3}: letter_color = 3'd0;
						{4'd5, 3'd4}: letter_color = 3'd0;
						{4'd5, 3'd5}: letter_color = 3'd0;
						default: letter_color = 3'b111;
					endcase
				end
	// DEL
			7'd127:	begin
					case({out_row, out_col})
						default: letter_color = 3'b111;
					endcase
				end
				
				default: letter_color = 3'b111;
		endcase
	end
endmodule
