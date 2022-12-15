module gainstager (input ENABLE, LRCLK,
	input [1:0] GAIN,
	input  [31:0] DINL, DINR,
	output [31:0] DOUTL, DOUTR);

	
logic [23:0] dataL, dataR;
logic [31:0] outL, outR;

//dataL and dataR contain sample data with gain applied (bitshift left by GAIN applies gain)
assign dataL = DINL[30:7] << GAIN;
assign dataR = DINR[30:7] << GAIN;	

always_comb
begin
	
	//apply gain
	if (ENABLE)
		begin
		outL = {DINL[30], dataL, DINL[6:0]};
		outR = {DINR[30], dataR, DINR[6:0]};
		end
	//bypass
	else
		begin
		outL = DINL;
		outR = DINR;
		end

end

always_ff @ (posedge LRCLK)
begin
	DOUTL <= outL;
end
always_ff @ (negedge LRCLK)
begin
	DOUTR <= outR;
end

	
endmodule