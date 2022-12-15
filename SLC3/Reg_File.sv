module Reg_File(input logic Clk, Reset,
					input logic [15:0] D_In,
					input logic LD_REG,
					input logic [2:0] SR1, SR2, DR,
					output logic [15:0] SR1_Out, SR2_Out);
					
					logic [15:0] Reg0_Out, Reg1_Out, Reg2_Out, Reg3_Out, Reg4_Out, Reg5_Out, Reg6_Out, Reg7_Out;
					
					
					reg_16 reg0(.Clk(Clk), .Reset(Reset), .D(D_In), .Load(LD_REG & ~DR[2] & ~DR[1] & ~DR[0]), .Data_Out(Reg0_Out));
					reg_16 reg1(.Clk(Clk), .Reset(Reset), .D(D_In), .Load(LD_REG & ~DR[2] & ~DR[1] & DR[0]), .Data_Out(Reg1_Out));
					reg_16 reg2(.Clk(Clk), .Reset(Reset), .D(D_In), .Load(LD_REG & ~DR[2] & DR[1] & ~DR[0]), .Data_Out(Reg2_Out));
					reg_16 reg3(.Clk(Clk), .Reset(Reset), .D(D_In), .Load(LD_REG & ~DR[2] & DR[1] & DR[0]), .Data_Out(Reg3_Out));
					reg_16 reg4(.Clk(Clk), .Reset(Reset), .D(D_In), .Load(LD_REG & DR[2] & ~DR[1] & ~DR[0]), .Data_Out(Reg4_Out));
					reg_16 reg5(.Clk(Clk), .Reset(Reset), .D(D_In), .Load(LD_REG & DR[2] & ~DR[1] & DR[0]), .Data_Out(Reg5_Out));
					reg_16 reg6(.Clk(Clk), .Reset(Reset), .D(D_In), .Load(LD_REG & DR[2] & DR[1] & ~DR[0]), .Data_Out(Reg6_Out));
					reg_16 reg7(.Clk(Clk), .Reset(Reset), .D(D_In), .Load(LD_REG & DR[2] & DR[1] & DR[0]), .Data_Out(Reg7_Out));
					
					
					always_comb
					begin
					unique case(SR1) 
							3'b000: SR1_Out = Reg0_Out;
							3'b001: SR1_Out = Reg1_Out;
							3'b010: SR1_Out = Reg2_Out;
							3'b011: SR1_Out = Reg3_Out;
							3'b100: SR1_Out = Reg4_Out;
							3'b101: SR1_Out = Reg5_Out;
							3'b110: SR1_Out = Reg6_Out;
							3'b111: SR1_Out = Reg7_Out;
							default: ;
						endcase
						
					unique case(SR2) 
							3'b000: SR2_Out = Reg0_Out;
							3'b001: SR2_Out = Reg1_Out;
							3'b010: SR2_Out = Reg2_Out;
							3'b011: SR2_Out = Reg3_Out;
							3'b100: SR2_Out = Reg4_Out;
							3'b101: SR2_Out = Reg5_Out;
							3'b110: SR2_Out = Reg6_Out;
							3'b111: SR2_Out = Reg7_Out;
							default: ;
						endcase
					end
							
endmodule
