module CLA_adder_4(
	input  [3:0] A, B,
	input         cin,
	output [3:0] S,
	output 		  P, G
);

	logic G0,G1,G2,G3;
	logic P0,P1,P2,P3;
	assign G0 = A[0] & B[0];
	assign G1 = A[1] & B[1];
	assign G2 = A[2] & B[2];
	assign G3 = A[3] & B[3];
	assign P0 = A[0] ^ B[0];
	assign P1 = A[1] ^ B[1];
	assign P2 = A[2] ^ B[2];
	assign P3 = A[3] ^ B[3];
	
	
	full_adder f_adder1(.A(A[0]), .B(B[0]), .cin(cin), .S(S[0]), .cout(IDONTCARE0));
	full_adder f_adder2(.A(A[1]), .B(B[1]), .cin((cin & P0) | G0), .S(S[1]), .cout(IDONTCARE1));
	full_adder f_adder3(.A(A[2]), .B(B[2]), .cin((cin & P0 & P1) | (G0 & P1) | G1), .S(S[2]), .cout(IDONTCARE2));
	full_adder f_adder4(.A(A[3]), .B(B[3]), .cin((cin & P0 & P1 & P2) | (G0 & P1 & P2) | (G1 & P2) | G2), .S(S[3]), .cout(IDONTCARE3));

	assign P = P0 & P1 & P2 & P3;
	assign G = G3 | (G2 & P3) | (G1 & P3 & P2) | (G0 & P3 & P2 & P1);

endmodule 