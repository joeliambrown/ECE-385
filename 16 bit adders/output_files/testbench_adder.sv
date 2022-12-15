module testbench_adder();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

logic [15:0] A, B, S;
logic cin, cout;

		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
//multiplier multiplier0(.*);	
ripple_adder adder0(.*);

 //Toggle the clock
 //#1 means wait for a delay of 1 timeunit
//always begin : CLOCK_GENERATION
//#1 Clk = ~Clk;
//end
//
//initial begin: CLOCK_INITIALIZATION
//    Clk = 0;
//end 

//Testing begins here. Everything within initial block happens sequentially.
initial begin: TEST_VECTORS
A = 16'h0007;
B = 16'h000f;
cin =0;

$display("%d", A);

$display("%d", B);

$display("%d", cin);

//#1 Reset_Clear=1;
//#2 Reset_Clear=0;
//
//
////(7*59)
//	SW = 8'b00000111;
//
//#2 Run_Accumulate= 1;
//#2 Run_Accumulate = 0;
//
//   SW = 8'b00000001;
//	
//#2 Run_Accumulate= 1;
//#2 Run_Accumulate = 0;
//
//   SW = 8'b00000010;
//
//#2 Run_Accumulate= 1;
//#2 Run_Accumulate = 0;
//
//
end
endmodule 