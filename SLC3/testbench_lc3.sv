module testbench_lc3;

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

logic   Clk=0;
logic Run, Continue;     // Internal                
logic [9:0]  SW;      
logic [6:0]  HEX0, HEX1, HEX2, HEX3;
logic [9:0] LED;



		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
slc3_testtop test_top(.SW(SW), .Clk(Clk), .Run(Run), .Continue(Continue), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .LED(whocares));


// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

//Testing begins here. Everything within initial block happens sequentially.
initial begin: TEST_VECTORS
//Basic IO test 1//
//SW = 10'b0000000011;
//Run = 0;
//Continue = 0;
//#4 Run = 1;
//Continue = 1;
//
//#4 Run = 0;

//Basic IO test 2
//SW = 10'b0000000110;
//Run = 0;
//Continue = 0;
//#4 Run = 1;
//Continue = 1;
//
//#4 Run = 0;
//
//#40 Run =1;
//SW = 10'b0000000001;
//#40 Continue = 0;
//#10 Continue = 1;

//Self modifying code
SW = 10'b0000001011;
Run = 0;
Continue = 0;
LED = 10'b00000000000;
#4 Run = 1;
Continue = 1;

#4 Run = 0;

#74 Continue =0; 
Run = 0;
#8 Continue =1;
#4 LED = 10'b0000000001;
#34 Continue = 0;
#4 Continue =1 ;
#4 LED = 10'b0000000010;
#34 Continue = 0;
#4 Continue =1 ;
#4 LED = 10'b0000000011;
#34 Continue = 0;
#4 Continue =1 ;
#4 LED = 10'b0000000100;
#34 Continue = 0;
#4 Continue =1 ;
#4 LED = 10'b0000000101;

//XOR test 
//SW = 10'b0000010101;
//Run = 0;
//Continue = 0;
//#4 Run = 1;
//Continue = 1;
//
//#4 Run = 0;
//#4 Run = 1;
//#80 Continue = 0;
//SW = 10'b0000000101;
//#2 Continue = 1; 
//#40 Continue = 0;
//SW = 10'b0000001010;
//#2 Continue =1;

//multiply test
//SW = 10'b0000110001;
//Run = 0;
//Continue = 0;
//#4 Run = 1;
//Continue = 1;
//
//#4 Run = 0;
//#4 Run = 1;
//
//#150 Continue = 0;
//SW = 10'b0000000010;
//#4 Continue = 1;
//#60 Continue = 0;
//#4 Continue = 1;

end


endmodule 