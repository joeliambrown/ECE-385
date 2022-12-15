module overdrive (input ENABLE, LRCLK,
	input [2:0] CLIP,
	input  [31:0] DINL, DINR,
	output [31:0] DOUTL, DOUTR);
	
	
logic [23:0] dataL, dataR;
logic [31:0] outL, outR;
logic [9:0] checker;
logic[23:0] threshold;

//load dataL and dataR with sample data
assign dataL = DINL[30:7];
assign dataR = DINR[30:7];

//checker is compared to the top 10 bits of the sample after the sign bit to check if sample value is within threshold
assign checker = 10'b1111111111 << (CLIP ^ 3'b111);

//the value the outgoing sample will be assigned if it exceeds the threshold, thus clipping the sample and distorting it
assign threshold = {1'b0, (checker ^ 10'b1111111111), 13'b1111111111111};


always_comb
begin

	//apply overdrive
	if (ENABLE)
	begin
		//sample is positive
		if (dataL[23] == 1'b0)
		begin 
			//sample is above positive threshold and thus clips
			if ((checker & dataL[22:13]) != 10'b0000000000)
				outL = threshold << CLIP;
			//sample is below threshold and passes through unaffected
			else
				outL = DINL << CLIP;
		end
		//sample is negative
		else
		begin
			//sample is below negative threshold and thus clips
			if (  ~(~checker | dataL[22:13]) != 10'b0000000000)
				outL = ~threshold << CLIP;
			//sample is above negative threshold and passes through unaffected
			else
				outL = DINL << CLIP;
		end
		
		
		
		//repeat above process for right sample
		if (dataR[23] == 1'b0)
		begin
		
			if ((checker & dataR[22:13]) != 10'b0000000000)
				outR = threshold << CLIP;
			else
				outR = DINR << CLIP;
		end
		else
		begin
		
			if ( ~(~checker | dataR[22:13]) != 10'b0000000000)
				outR = ~threshold << CLIP;
			else
				outR = DINR << CLIP;
		end

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