module datapath(input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED, 
	GatePC, GateMDR, GateALU, GateMARMUX,
	SR2MUX, ADDR1MUX, MARMUX,
	MIO_EN, DRMUX, SR1MUX,
	Clk, Reset,
	input logic [1:0] PCMUX, ADDR2MUX, ALUK,
	input logic [15:0] MDR_In,
	output logic [15:0] MDR, MAR, PC, IR,
	output logic BEN,
	output logic [9:0] LED
	);
	logic [15:0] IR_6_SE, IR_9_SE, IR_11_SE, IR_5_SE;
	//sign extended inputs to ADDR2MUX
	assign IR_6_SE = {IR[5],IR[5],IR[5],IR[5],IR[5],IR[5],IR[5],IR[5],IR[5],IR[5],IR[5:0]};
	assign IR_5_SE = {IR[4],IR[4],IR[4],IR[4],IR[4],IR[4],IR[4],IR[4],IR[4],IR[4],IR[4],IR[4:0]};
	assign IR_9_SE = {IR[8],IR[8],IR[8],IR[8],IR[8],IR[8],IR[8],IR[8:0]};
	assign IR_11_SE = {IR[10],IR[10],IR[10],IR[10],IR[10],IR[10:0]};
	logic [15:0] BUSMUX_Out, ALU, MDRMUX_Out, PCMUX_Out, ADDR2MUX_Out, ADDR1MUX_Out, SR2MUX_Out, SR1_Out, SR2_Out;
	logic [2:0] SR1MUX_Out, DRMUX_Out;
	logic [2:0] NZP_in, NZP_out;
	logic BEN_in;
	
	
	always_comb
	begin
	 if (BUSMUX_Out == 16'b0000000000000000)
		NZP_in = 3'b010;
	 else if (~BUSMUX_Out[15])
		NZP_in = 3'b001;
	 else if (BUSMUX_Out[15])
		NZP_in = 3'b100;
	 else
		NZP_in = 3'bxxx;
		
		
	 if ((IR[11] & NZP_out[2]) | (IR[10] & NZP_out[1]) | (IR[9] & NZP_out[0]))
		BEN_in = 1'b1;
	 else 
		BEN_in = 1'b0;
	
	end
	
	
	
	Reg_File RegFile(.Clk(Clk), .Reset(Reset), .D_In(BUSMUX_Out), .LD_REG(LD_REG), .SR1(SR1MUX_Out), .SR2(IR[2:0]), .DR(DRMUX_Out), .SR1_Out(SR1_Out), .SR2_Out(SR2_Out));
	ALU Sys_ALU(.A(SR1_Out), .B(SR2MUX_Out), .ALUK(ALUK), .D_Out(ALU));
	
	//MUXes 
	MUX_4 ADDR2MUX_4(.D(16'h0000), .D1(IR_6_SE), .D2(IR_9_SE), .D3(IR_11_SE), .S(ADDR2MUX), .D_Out(ADDR2MUX_Out));
	MUX_2 ADDR1_MUX(.D(PC), .D1(SR1_Out), .S(ADDR1MUX), .D_Out(ADDR1MUX_Out));
	
	
	MUX_2 MDR_MUX(.D(BUSMUX_Out), .D1(MDR_In), .S(MIO_EN), .D_Out(MDRMUX_Out));
	
	MUX_2 SR2_MUX(.D(SR2_Out), .D1(IR_5_SE), .S(IR[5]), .D_Out(SR2MUX_Out));
	
	MUX_4_3bit DRMUX_mux(.D(IR[11:9]), .D1(3'b111), .S(DRMUX), .D_Out(DRMUX_Out));
	MUX_4_3bit SR1MUX_mux(.D(IR[11:9]), .D1(IR[8:6]), .S(SR1MUX), .D_Out(SR1MUX_Out));
	
	//zero extended input to MARMUX
	
	MUX_4 PCMUX_4(.D(PC + 16'b0000000000000001), .D1(BUSMUX_Out), .D2(ADDR2MUX_Out + ADDR1MUX_Out), .D3(dontcare),.S(PCMUX), .D_Out(PCMUX_Out));
	
	reg_3 NZP(.Clk(Clk), .Reset(Reset), .Load(LD_CC), .D(NZP_in), .Data_Out(NZP_out));
	reg_1 BEN_reg(.Clk(Clk), .Reset(Reset), .Load(LD_BEN), .D(BEN_in), .Data_Out(BEN));
	
	reg_16 reg_PC(.Clk(Clk), .Reset(Reset), .Load(LD_PC), .D(PCMUX_Out), .Data_Out(PC));
	reg_16 reg_MAR(.Clk(Clk), .Reset(Reset), .Load(LD_MAR), .D(BUSMUX_Out), .Data_Out(MAR));
	reg_16 reg_MDR(.Clk(Clk), .Reset(Reset), .Load(LD_MDR), .D(MDRMUX_Out), .Data_Out(MDR));
	reg_16 reg_IR(.Clk(Clk), .Reset(Reset), .Load(LD_IR), .D(BUSMUX_Out), .Data_Out(IR));
	BUSMUX BUS_MUX(.*, .ADDR2MUXplusADDR1MUX(ADDR2MUX_Out + ADDR1MUX_Out));
	
	//registers for fetch
	
	always_ff @ (posedge Clk) 
	begin
	if (LD_LED)
		LED <= IR[9:0];
	else
		LED <= 10'b0;
	end
	
	
	
endmodule 