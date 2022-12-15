module MUX_4(input logic [15:0] D, D1, D2, D3,
					input logic [1:0] S,
					output logic [15:0] D_Out);
					
					
			always_comb
			begin
				unique case(S)
					2'b00: D_Out = D;
					2'b01: D_Out = D1;
					2'b10: D_Out = D2;
					2'b11: D_Out = D3;
				endcase
			end
			
			
			
			
endmodule 