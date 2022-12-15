module lookahead_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
  
 
	logic G0,G4,G8,G12;
	logic P0,P4,P8,P12;
	
	
	CLA_adder_4 CLA_adder1(.A(A[3:0]), .B(B[3:0]), .cin(cin), .S(S[3:0]), .P(P0), .G(G0));
	CLA_adder_4 CLA_adder2(.A(A[7:4]), .B(B[7:4]), .cin((cin & P0) | G0), .S(S[7:4]), .P(P4), .G(G4));
	CLA_adder_4 CLA_adder3(.A(A[11:8]), .B(B[11:8]), .cin((cin & P0 & P4) | (G0 & P4) | G4), .S(S[11:8]), .P(P8), .G(G8));
	CLA_adder_4 CLA_adder4(.A(A[15:12]), .B(B[15:12]), .cin((cin & P0 & P4 & P8) | (G0 & P4 & P8) | (G4 & P8) | G8), .S(S[15:12]), .P(P12), .G(G12));

	assign cout = (cin & P0 & P4 & P8 & P12) | (G0 & P4 & P8 & P12) | (G4 & P8 & P12) | G8 & P12 | G12;

endmodule
