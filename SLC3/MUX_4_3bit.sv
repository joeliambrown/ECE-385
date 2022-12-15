module MUX_4_3bit(input logic [2:0] D, D1,
						input logic S,
						output logic [2:0] D_Out);
						
			always_comb
			begin
				unique case(S)
					1'b0: D_Out = D;
					1'b1: D_Out = D1;
				endcase
			end
						

endmodule 
