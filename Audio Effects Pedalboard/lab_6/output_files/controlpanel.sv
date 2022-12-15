module controlpanel (input CLK, 
							input [2:0] SELECT, BUTTON,
							output [2:0] BITDEPTH, CLIP, DELAYTIME,
							output [1:0] GAIN, TREM, CUTOFF,
							output [3:0] HEX
);


logic [1:0] gain, trem, cutoff;
logic [2:0] bitdepth, clip, delaytime;
logic up1, down1, up2, down2;
logic up, down;
logic add, subtract;

assign GAIN = gain;
assign BITDEPTH = bitdepth;
assign CLIP = clip;
assign DELAYTIME = delaytime;
assign TREM = trem;
assign CUTOFF = cutoff;

assign up = ~BUTTON[0];
assign down = ~BUTTON[1];

assign add = up1 && ~up2;
assign subtract = down1 && ~down2;

always_ff @ (posedge CLK)
begin
	if (up)
	begin
		up1 <= 1'b1;
		up2 <= up1;
	end
	else
	begin
		up1 <= 1'b0;
		up2 <= 1'b0;
	end
	
	if (down)
	begin
		down1 <= 1'b1;
		down2 <= down1;
	end
	else
	begin
		down1 <= 1'b0;
		down2 <= 1'b0;
	end


	unique case (SELECT)
	3'b000:
	begin
		if (add && (gain != 2'b11))
			gain <= gain + 1'b1;
		if (subtract && (gain != 2'b00))
			gain <= gain - 1'b1;
	end
	3'b001:
	begin
		if (add && (bitdepth != 3'b111))
			bitdepth <= bitdepth + 1'b1;
		if (subtract && (bitdepth != 3'b000))
			bitdepth <= bitdepth - 1'b1;
	end
	3'b010:
	begin
		if (add && (clip != 3'b111))
			clip <= clip + 1'b1;
		if (subtract && (clip != 3'b000))
			clip <= clip - 1'b1;
	end
	3'b011:
	begin
		if (add && (delaytime != 3'b111))
			delaytime <= delaytime + 1'b1;
		if (subtract && (delaytime != 3'b000))
			delaytime <= delaytime - 1'b1;
	end
	3'b100:
	begin
	if (add && (trem != 2'b11))
		trem <= trem + 1'b1;
	if (subtract && (trem != 2'b00))
		trem <= trem - 1'b1;
	end
	3'b101:
	begin
	if (add && (cutoff != 2'b11))
		cutoff <= cutoff + 1'b1;
	if (subtract && (cutoff != 2'b00))
		cutoff <= cutoff - 1'b1;
	end
	
	endcase
	
	if ((up && down))
	begin
		unique case (SELECT)
		3'b000: gain <= 2'b00;
		3'b001: bitdepth <= 3'b000;
		3'b010: clip <= 3'b000;
		3'b011: delaytime <= 3'b000;
		3'b100: trem <= 2'b00;
		3'b101: cutoff <= 2'b00;
		endcase
	end

end

always_comb
begin
	unique case (SELECT)
	3'b000: HEX = {2'b00, gain};
	3'b001: HEX = {1'b0, bitdepth} + 1;
	3'b010: HEX = {1'b0, clip} + 1;
	3'b011: HEX = {1'b0, delaytime} + 1;
	3'b100: HEX = {2'b00, trem} + 1;
	3'b101: HEX = {2'b00, cutoff} + 1;
	3'b110: HEX = {4'b1111};
	3'b111: HEX = {4'b1111};
	
	endcase
end

endmodule