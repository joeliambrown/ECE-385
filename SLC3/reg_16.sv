module reg_16 (input  logic Clk, Reset, Load,
              input  logic [15:0]  D,
              output logic [15:0]  Data_Out);
reg_8 top_bits(.Clk(Clk), .Reset(Reset), .Load(Load), .D(D[15:8]), .Data_Out(Data_Out[15:8]));
reg_8 low_bits(.Clk(Clk), .Reset(Reset), .Load(Load), .D(D[7:0]), .Data_Out(Data_Out[7:0]));

endmodule 