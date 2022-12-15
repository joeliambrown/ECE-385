module register_unit (input  logic Clk, Reset, X_in, Ld_AX, Ld_B, 
                            Shift_En,
                      input  logic [7:0]  SWB,
							 input  logic [7:0] A_in,
                      output logic M, 
                      output logic [7:0]  A,
                      output logic [7:0]  B);

	 logic X;
	 
	 
	 reg_1  reg_X (.Clk(Clk), .Reset(Reset), .Load(Ld_AX), .Shift_En(Shift_En), .D(X_in),
						 .Data_Out(X));
								
    reg_8  reg_A (.Clk(Clk), .Reset(Reset), .Shift_In(X), .Load(Ld_AX), .Shift_En(Shift_En), .D(A_in),
	                .Data_Out(A));
						
    reg_8  reg_B (.Clk(Clk), .Reset(1'b0), .Shift_In(A[0]), .Load(Ld_B), .Shift_En(Shift_En), .D(SWB),
	                .Data_Out(B));
						 
	 assign M = B[0];
	 

endmodule
