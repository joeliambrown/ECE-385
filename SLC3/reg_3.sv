module reg_3 (input  logic Clk, Reset, Load,
              input  logic [2:0]  D,
              output logic [2:0]  Data_Out);

    logic [2:0] Data_Next;
	 
    always_ff @ (posedge Clk)
    begin
	 	 Data_Out <= Data_Next;
	 end
			  
		
	always_comb 
	begin
		Data_Next = Data_Out;
		if (Reset)
			Data_Next = 3'b000;
		else if (Load)
			Data_Next = D;
	end

endmodule