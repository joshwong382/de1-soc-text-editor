module hexdisp(input[3:0] binary, output[6:0] hexbit);

	wire d1 = binary[3];
	wire d2 = binary[2];
	wire d3 = binary[1];
	wire d4 = binary[0];
	
	// Convert Bin to Hex
	wire n0 = ~(d1|d2|d3|d4);
	// 0001 1
	wire n1 = ~(d1|d2|d3) & d4;
	// 0010 2
	wire n2 = ~(d1|d2|d4) & d3;
	// 0011 3
	wire n3 = ~(d1|d2) & d3 & d4;
	// 0100 4
	wire n4 = ~(d1|d3|d4) & d2;
	// 0101 5
	wire n5 = ~(d1|d3) & d2 & d4;
	// 0110 6
	wire n6 = ~(d1|d4) & d2 & d3;
	// 0111 7
	wire n7 = ~d1 & d2 & d3 & d4;
	
	// We don't need a wire n8 because it is all 0s on hexbit.
	
	// 1001 9
	wire n9 = ~(d2|d3) & d1 & d4;
	// 1010 A
	wire na = ~(d2|d4) & d1 & d3;
	// 1011 B
	wire nb = ~d2 & d1 & d3 & d4;
	// 1100 C
	wire nc = ~(d3|d4) & d1 & d2;
	// 1101 D
	wire nd = ~d3 & d1 & d2 & d4;
	// 1110 E
	wire ne = ~d4 & d1 & d2 & d3;
	// 1111 F
	wire nf = d1 & d2 & d3 & d4;
	
	// TURN ON EACH HEX BIT WHEN THE MATCHING BINARY NUMBERS ARE ENTERED
	assign hexbit[0] = (n1|n4|nb|nd);
	assign hexbit[1] = (n5|n6|nb|nc|ne|nf);
	assign hexbit[2] = (n2|nc|ne|nf);
	assign hexbit[3] = (n1|n4|n7|na|nf);
	assign hexbit[4] = (n1|n3|n4|n5|n7|n9);
	assign hexbit[5] = (n1|n2|n3|n7|nd);
	assign hexbit[6] = (n0|n1|n7|nc);
	
endmodule