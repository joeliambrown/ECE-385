module ALU(input logic [15:0] A, B,
				input logic [1:0] ALUK,
				output logic [15:0] D_Out);
				
			always_comb
			begin
				unique case(ALUK)
					2'b00: D_Out = A + B;
					2'b01: D_Out = A & B;
					2'b10: D_Out = ~A;
					2'b11: D_Out = A;
				endcase
			end
			
endmodule
