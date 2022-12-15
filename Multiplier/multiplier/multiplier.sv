module multiplier(input logic   Clk,     // Internal
                                Reset_Load_Clear,   // Push button 0
                                Run,   // Push button 1
										  Reset,
                  input  logic [7:0]  SW,     // input data
                  output logic [7:0]  Aval,    
                                Bval,  
                  output logic [6:0]  HEX1,
                                HEX0,
                                HEX3,
                                HEX2 );

						
						logic Reset_Load_Clear_SH, Run_SH, Reset_SH;
						logic SUBTRACT, Ld_B, Ld_A_X, S, Clr_A_X;
						logic M, Xin, Mboy, IDONTCARE;
						logic X;
						logic [7:0] A, B, Ain, SW_S;
						
						assign Aval = A;
						assign Bval = B;
						
register_unit    reg_unit (
                        .Clk(Clk),
                        .Reset(Clr_A_X),
                        .X_in(Xin), 
								.Ld_AX(Ld_A_X), 
								.Ld_B(Ld_B), 
                        .Shift_En(S),
                        .SWB(SW_S),
							   .A_in(Ain),
                        .M(M), 
                        .A(A),
                        .B(B) );
								
ripple_adder_9   adder (
							.Clk(Clk),
							.A(A),	
							.SWADD(SW_S),
							.M(M),
							.cin(SUBTRACT),
							.SA(Ain),
							.SX(Xin),
							.cout(IDONTCARE) );
							
control          control_unit (
									.Clk(Clk),
									.RLC(Reset_Load_Clear_SH),
									.Run(Run_SH),
									.M(M),
									.Reset(Reset_SH),
									.Shift_En(S),
									.Ld_A_X(Ld_A_X),
									.Ld_B(Ld_B),
									.SUBTRACT(SUBTRACT),
									.Clr_A_X(Clr_A_X),
									.Myeah(Mboy)   );

								
								
								
								
		
	 HexDriver        HexAL (
                        .In0(A[3:0]),
                        .Out0(HEX2) );
	 HexDriver        HexBL (
                        .In0(B[3:0]),
                        .Out0(HEX0) );
								
	 
	 HexDriver        HexAU (
                        .In0(A[7:4]),
                        .Out0(HEX3) );	
	 HexDriver        HexBU (
                       .In0(B[7:4]),
                        .Out0(HEX1) );
								
								
	  sync button_sync[2:0] (Clk, {~Reset_Load_Clear, ~Run, Reset}, {Reset_Load_Clear_SH, Run_SH, Reset_SH});
	  sync SW_sync[7:0] (Clk, SW, SW_S);

endmodule 