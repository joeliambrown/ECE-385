module BUSMUX(input logic [15:0] PC ,MDR , ALU, ADDR2MUXplusADDR1MUX,
					input logic GatePC, GateMDR, GateALU, GateMARMUX, 
					output logic [15:0] BUSMUX_Out);
					
					always_comb
					begin
						if(GatePC)
							BUSMUX_Out = PC;
						else if(GateMDR)
							BUSMUX_Out = MDR;
						else if(GateMARMUX)
							BUSMUX_Out = ADDR2MUXplusADDR1MUX;
						else if(GateALU)
							BUSMUX_Out = ALU;
						else
							BUSMUX_Out = 16'bzzzzzzzzzzzzzzzz;  
					end
					
					
endmodule 