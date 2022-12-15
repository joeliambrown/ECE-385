module ripple_adder_9(
	input logic  [7:0] A, SW,
	input logic       M, cin,
	output logic [7:0] SA,
	output logic     SX, cout
);


	logic [7:0] B_int, B;
	
	
	// {SW[7], SW[6], SW[5], SW[4], SW[3], SW[2], SW[1], SW[0]};
	//{!SW[7], !SW[6], !SW[5], !SW[4], !SW[3], !SW[2], !SW[1], !SW[0]};
	//{B_int[7], B_int[6], B_int[5], B_int[4], B_int[3], B_int[2], B_int[1], B_int[0]};
	//in case below syntax is bad. if not then delete these comments.
	always_comb
	begin
		unique case (cin)
	 	   1'b0   : B_int = SW;
		   1'b1   : B_int = ~SW;
	  	 endcase
	end
	always_comb
	begin
		unique case (M)
	 	   1'b0   : B = 00000000;
		   1'b1   : B = B_int;
	  	 endcase
	end
	
	
	
	ripple_adder_4 r_adder1(.A(A[3:0]), .B(B[3:0]), .cin(cin), .S(SA[3:0]), .cout(cout0));
	ripple_adder_4 r_adder2(.A(A[7:4]), .B(B[7:4]), .cin(cout0), .S(SA[7:4]), .cout(cout1));
	full_adder r_adder3(.A(A[7]), .B(B[7]), .cin(cout1), .S(SX), .cout(cout));
	
     
endmodule