module full_adder(
		
	input logic  A, B,
	input logic  cin,
	output logic S,
	output logic cout

);

	assign S = A^B^cin;
	assign cout = (A&B)|(B&cin)|(A&cin);

endmodule 