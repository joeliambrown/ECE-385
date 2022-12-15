module delay (input ENABLE, CLK, LRCLK, FEEDBACK,
	input [2:0] DELAYTIME,
	input  [31:0] DINL, DINR,
	output [31:0] DOUTL, DOUTR);

logic [15:0] dL, dR;
logic [15:0] dataL, dataR;
logic [31:0] outL, outR;
logic [15:0] writeL, writeR;
logic [14:0] writeaddL, writeaddR, readL, readR;

assign readL = writeaddL - (15'b000000010000000 << DELAYTIME);
assign readR = writeaddR - (15'b000000010000000 << DELAYTIME);
assign dataL = DINL[30:15];
assign dataR = DINR[30:15];

always_comb
begin

	//apply delay
	if (ENABLE)
		begin
		outL = {1'b0, dataL, 15'b000000000000000} + {1'b0, dL[15], dL[15], dL[15:2], 15'b000000000000000};
		outR = {1'b0, dataR, 15'b000000000000000} + {1'b0, dR[15], dR[15], dR[15:2], 15'b000000000000000};
		end
	//bypass
	else
		begin
		outL = DINL;
		outR = DINR;
		end
		
		
	if (FEEDBACK)
	begin
		writeL = dataL + {dL[15], dL[15], dL[15:2]};
		writeR = dataR + {dR[15], dR[15], dR[15:2]};
	end
	else
	begin
		writeL = dataL;
		writeR = dataR;
	end
end

	
	
Spoogus penis_spamL(.clock(CLK), .data(writeL), .rdaddress(readL), .rden(1'b1), .wraddress(writeaddL), .wren(LRCLK), .q(dL));
Spoogus penis_spamR(.clock(CLK), .data(writeR), .rdaddress(readR), .rden(1'b1), .wraddress(writeaddR), .wren(~LRCLK), .q(dR));


	
always_ff @ (posedge LRCLK)
begin
	DOUTL <= outL;
	writeaddL <=  writeaddL + 15'b000000000000001;
end

always_ff @ (negedge LRCLK)
begin
	DOUTR <= outR;
	writeaddR <= writeaddR + 15'b000000000000001;
end
	
endmodule