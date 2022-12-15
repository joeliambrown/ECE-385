module ripple_adder_4(
	input  [3:0] A, B,
	input  cin,
	output [3:0] S,
	output cout
);

	logic cout0, cout1, cout2;
	//assign S = {S3, S2, S1, S0};
	full_adder f_adder1(.A(A[0]), .B(B[0]), .cin(cin), .S(S[0]), .cout(cout0));
	full_adder f_adder2(.A(A[1]), .B(B[1]), .cin(cout0), .S(S[1]), .cout(cout1));
	full_adder f_adder3(.A(A[2]), .B(B[2]), .cin(cout1), .S(S[2]), .cout(cout2));
	full_adder f_adder4(.A(A[3]), .B(B[3]), .cin(cout2), .S(S[3]), .cout(cout));


endmodule 