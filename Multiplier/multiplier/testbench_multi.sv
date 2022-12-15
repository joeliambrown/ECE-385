module testbench_multi();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

logic   Clk=0;
logic Reset_Load_Clear,Run, Reset;     // Internal                
logic [7:0]  SW;     
logic [7:0]  Aval, Bval;   
logic [6:0]  HEX1, HEX0, HEX3, HEX2;
logic  Xval;

		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
multiplier multiplier0(.*);	
//ripple_adder_9 adder0(.*);

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
Aval = 8'b00000000;
Reset = 1;
Reset_Load_Clear = 0;
Run = 0;

#2 Reset = 0;


//(7*59)
	SW = 8'b11111001;

#2 Reset_Load_Clear = 1;
#2 Reset_Load_Clear = 0;
	SW = 8'b11000101;

#2 Run= 1;
#2 Run=0;


end


endmodule 