module bitcrusher (input ENABLE, LRCLK,
	input [2:0] BITDEPTH,
	input  [31:0] DINL, DINR,
	output [31:0] DOUTL, DOUTR);

logic [23:0] dataL, dataR;
logic [31:0] outL, outR;

logic [4:0] actualbitdepth;

//bit depth will be reduced by BITDEPTH + 12 bits
assign actualbitdepth = {2'b00, BITDEPTH} + 5'b01100;
//shift sample data right to get rid of the bottom actualbitdepth bits
assign dataL = DINL[30:7] >> actualbitdepth;
assign dataR = DINR[30:7] >> actualbitdepth;	
	
always_comb
begin
	//apply bitcrusher, shift sample data back to the left, thus reducing bitdepth (the bottom actualbitdepth bits are now zeroes) while keeping the same volume
	if (ENABLE)
		begin
		outL = {DINL[30], dataL << actualbitdepth, DINL[6:0]};
		outR = {DINL[30], dataR << actualbitdepth, DINL[6:0]};
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

