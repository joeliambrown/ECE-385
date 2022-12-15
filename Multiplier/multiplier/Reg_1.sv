module reg_1  (input  logic Clk, Reset, Load, Shift_En, D,
              output logic Data_Out);

	logic Data_Next;
	 
    always_ff @ (posedge Clk)
    begin
	 	 Data_Out <= Data_Next;
	 end
			  
		
	always_comb 
	begin
		Data_Next = Data_Out;
		if (Reset)
			Data_Next = 1'b0;
		else if (Load)
			Data_Next = D;
		else if (Shift_En)
			Data_Next = 1'b0;
	end


endmodule
