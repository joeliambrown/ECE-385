module reg_8 (input  logic Clk, Reset, Load,
              input  logic [7:0]  D,
              output logic [7:0]  Data_Out);

    logic [7:0] Data_Next;
	 
    always_ff @ (posedge Clk)
    begin
	 	 Data_Out <= Data_Next;
	 end
			  
		
	always_comb 
	begin
		Data_Next = Data_Out;
		if (Reset)
			Data_Next = 8'b00000000;
		else if (Load)
			Data_Next = D;
	end

endmodule
