module ripple_adder_9(input logic Clk,//input logic Clk, Clr_Reg, Load_Reg, 
	input logic  [7:0] A, SWADD,
	input logic       M, cin, 
	output logic [7:0] SA,
	output logic     SX, cout
);


	logic [7:0] B_int, B, OUT;
	logic OUTX, cinreal;
	logic cout0, cout1;
	
	
	assign SA = OUT;
	assign SX = OUTX;
	
	

	
	always_comb
	begin
		unique case ({cin, M})
	 	   2'b00   : B = 8'b00000000;
			2'b01   : B = SWADD;
			2'b10   : B = 8'b00000000;
			2'b11   : B = ~SWADD;
		endcase
	
	
		unique case (M)
		   1'b0   : cinreal = 0;
		   1'b1   : cinreal = cin;
		endcase
	end
	
	
	ripple_adder_4 r_adder1(.A(A[3:0]), .B(B[3:0]), .cin(cinreal), .S(OUT[3:0]), .cout(cout0));
	ripple_adder_4 r_adder2(.A(A[7:4]), .B(B[7:4]), .cin(cout0), .S(OUT[7:4]), .cout(cout1));
	full_adder r_adder3(.A(A[7]), .B(B[7]), .cin(cout1), .S(OUTX), .cout(cout));
	
     
endmodule