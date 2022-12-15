module full_adder(
		
	input  A, B,
	input  cin,
	output S,
	output cout

);

	assign S = A^B^cin;
	assign cout = (A&B)|(B&cin)|(A&cin);

endmodule 