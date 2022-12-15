module select_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);

    
	 ripple_adder_4 s_adder1(.A(A[3:0]), .B(B[3:0]), .cin(cin), .S(S[3:0]), .cout(cout0));
	 
	 select_adder_4 s_adder2(.A(A[7:4]), .B(B[7:4]), .cin(cout0), .S(S[7:4]), .cout(cout1));
	 
	 select_adder_4 s_adder3(.A(A[11:8]), .B(B[11:8]), .cin(cout1), .S(S[11:8]), .cout(cout2));
	 
	 select_adder_4 s_adder4(.A(A[15:12]), .B(B[15:12]), .cin(cout2), .S(S[15:12]), .cout(cout));
	 
	 
	  

endmodule
