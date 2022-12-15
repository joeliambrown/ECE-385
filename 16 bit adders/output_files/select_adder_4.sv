module select_adder_4(
	input  [3:0] A, B,
	input cin,
	output logic [3:0] S,
	output        cout
);

	logic [3:0] S1, S0;
	
	//cra assuming cin = 0
	full_adder f_adder0_1(.A(A[0]), .B(B[0]), .cin(1'b0), .S(S0[0]), .cout(cout0_0));
	full_adder f_adder0_2(.A(A[1]), .B(B[1]), .cin(cout0_0), .S(S0[1]), .cout(cout0_1));
	full_adder f_adder0_3(.A(A[2]), .B(B[2]), .cin(cout0_1), .S(S0[2]), .cout(cout0_2));
	full_adder f_adder0_4(.A(A[3]), .B(B[3]), .cin(cout0_2), .S(S0[3]), .cout(cout0));
	
	//cra assuming cin = 1
	full_adder f_adder1_1(.A(A[0]), .B(B[0]), .cin(1'b1), .S(S1[0]), .cout(cout1_0));
	full_adder f_adder1_2(.A(A[1]), .B(B[1]), .cin(cout1_0), .S(S1[1]), .cout(cout1_1));
	full_adder f_adder1_3(.A(A[2]), .B(B[2]), .cin(cout1_1), .S(S1[2]), .cout(cout1_2));
	full_adder f_adder1_4(.A(A[3]), .B(B[3]), .cin(cout1_2), .S(S1[3]), .cout(cout1));
	
	//mux
	always_comb
	begin
			unique case(cin)
					1'b0	:	S[0] = S0[0];
					1'b1	:	S[0] = S1[0];
			endcase
	end
	always_comb
	begin
			unique case(cin)
					1'b0	:	S[1] = S0[1];
					1'b1	:	S[1] = S1[1];
			endcase
	end
	always_comb
	begin
			unique case(cin)
					1'b0	:	S[2] = S0[2];
					1'b1	:	S[2] = S1[2];
			endcase
	end
	always_comb
	begin
			unique case(cin)
					1'b0	:	S[3] = S0[3];
					1'b1	:	S[3] = S1[3];
			endcase
	end

	//calculate cout
	assign cout = (cin & cout1) | cout0;

endmodule 