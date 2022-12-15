module i2s_in (input CLK, SCLK, LRCLK, DIN, 
	output [31:0] DOUTL, DOUTR);


logic [31:0] data;

//every positive edge of serial clk we shift in the value on the DIN pin
always_ff @ (posedge SCLK)
begin
	data <= {data[30:0], DIN};	
end

//at positive edge of LRCLK, data variable contains 32 bits corresponding to a left sample, and we send the sample out. first bit is junk bit so we set it to zero because we can.

always_ff @ (posedge LRCLK)
begin
	DOUTL <= {1'b0, data[30:0]};
end

//at negative edge of LRCLK, data variable contains 32 bits corresponding to a right sample, and we send the sample out. first bit is junk bit so we set it to zero because we can.
always_ff @ (negedge LRCLK)
begin
	DOUTR <= {1'b0, data[30:0]};
end


endmodule