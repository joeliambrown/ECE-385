module tremolo (input ENABLE, LRCLK,
	input [1:0] TREMFREQ,
	input  [31:0] DINL, DINR,
	output [31:0] DOUTL, DOUTR);
	
logic [23:0] dataL, dataR; 
logic [31:0] outL, outR;
logic [14:0] squarewave;
logic tremclk;

always_comb
begin

	dataL = DINL[30:7] <<  tremclk;
   dataR = DINR[30:7] <<  tremclk;
	
	unique case (TREMFREQ)
	2'b00: tremclk = squarewave[14];
	2'b01: tremclk = squarewave[13];
	2'b10: tremclk = squarewave[12];
	2'b11: tremclk = squarewave[11];
	endcase
	
	//apply tremolo
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

always_ff @(posedge LRCLK) 
begin
	squarewave <= squarewave + 1;
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