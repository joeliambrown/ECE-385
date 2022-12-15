//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab62 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_2, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] DrawX, DrawY, BallX, BallY, ballsizesig;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	
	always_comb
	begin
		if (SW[9:7] == 3'b111 || SW[9:7] == 3'b110)
			hex_num_2 = 4'b1111;
		else
			hex_num_2 = {1'b0, SW[9:7]};
	end
	
	HexDriver hex_driver2 (hex_num_2, HEX2[6:0]);
	assign HEX2[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX4 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX3 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX1 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};

	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
//	assign VGA_R = Red[7:4];
//	assign VGA_B = Blue[7:4];
//	assign VGA_G = Green[7:4];
	
	//i2c shit
	logic I2C_SDA_IN, I2C_SCL_IN, I2C_SDA_OUT, I2C_SCL_OUT;
	 assign I2C_SDA_IN = ARDUINO_IO[14];
	 assign ARDUINO_IO[14] = I2C_SDA_OUT ? 1'b0 : 1'bz; 
	 assign I2C_SCL_IN = ARDUINO_IO[15];
	 assign ARDUINO_IO[15] = I2C_SCL_OUT ? 1'b0 : 1'bz;
	
	
	lab62_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, whateva}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode),
		
		//I2C
		.i2c_wire_sda_in(I2C_SDA_IN),                
		.i2c_wire_scl_in(I2C_SCL_IN),                
		.i2c_wire_sda_oe(I2C_SDA_OUT),              
		.i2c_wire_scl_oe(I2C_SCL_OUT),
		
		.vga_port_red(VGA_R),                   //                vga_port.red
		.vga_port_green(VGA_G),                 //                        .green
		.vga_port_blue(VGA_B),                  //                        .blue
		.vga_port_hs(VGA_HS),                    //                        .hs
		.vga_port_vs(VGA_VS),
		
		.key0_wire_export(KEY[0]),               //               key0_wire.export
		.key1_wire_export(KEY[1]),
		.sw_wire_export(SW)
		
	 );


	//instantiate a vga_controller, ball, and color_mapper here with the ports.
//	vga_controller vga_cont(.Clk(MAX10_CLK1_50), .Reset(Reset_h),
// .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(pixel_clk), .blank(blank), .sync(sync),.DrawX(DrawX),.DrawY(DrawY));
//												  
//	ball my_ball( .Reset(Reset_h), .frame_clk(VGA_VS),.keycode(keycode),
//               .BallX(BallX), .BallY(BallY), .BallS(ballsizesig));
//					
//	color_mapper color_mapper_1(.BallX(BallX), .BallY(BallY), .DrawX(DrawX), .DrawY(DrawY), .Ball_size(ballsizesig),
//                       .Red(Red), .Green(Green), .Blue(Blue));
//							  
//							  
							  
	//AUDIO PROCESSING SECTION STARTS HERE
	
	logic [31:0] sample_in_L, sample_in_R, sample_processed_L, sample_processed_R, gainstageoutL, gainstageoutR, bitcrusheroutL, bitcrusheroutR;
	logic [31:0] overdriveoutL, overdriveoutR, delayoutL, delayoutR, tremolooutL, tremolooutR;
	logic [2:0] bitdepth, clip, delaytime;
	logic [1:0] gain, tremfreq, cutoff;
	logic dout;
	
	//this bad boy lets us tune
	controlpanel controlpan3l(.CLK(MAX10_CLK1_50), .SELECT(SW[9:7]), .BUTTON(KEY), .GAIN(gain), .BITDEPTH(bitdepth), .CLIP(clip), .DELAYTIME(delaytime), .TREM(tremfreq), .CUTOFF(cutoff), .HEX(hex_num_0));
	
	//i2s module to convert serial data to parallel data
	i2s_in itwos_in(.CLK(MAX10_CLK1_50), .SCLK(ARDUINO_IO[5]), .LRCLK(ARDUINO_IO[4]), .DIN(ARDUINO_IO[1]), .DOUTL(sample_in_L), .DOUTR(sample_in_R));
	
	//gain staging
	gainstager gainstag3r(.ENABLE(SW[0]), .LRCLK(ARDUINO_IO[4]), .GAIN(gain),  .DINL(sample_in_L), .DINR(sample_in_R), .DOUTL(gainstageoutL), .DOUTR(gainstageoutR));
	
	//bitcrusher effect pedal (resolution reduction)
   bitcrusher bitcrush3r(.ENABLE(SW[1]), .LRCLK(ARDUINO_IO[4]), .BITDEPTH(bitdepth),  .DINL(gainstageoutL), .DINR(gainstageoutR), .DOUTL(bitcrusheroutL), .DOUTR(bitcrusheroutR));
	
	//overdrive effect pedal (clipping)
	overdrive overdriv3(.ENABLE(SW[2]), .LRCLK(ARDUINO_IO[4]), .CLIP(clip),  .DINL(bitcrusheroutL), .DINR(bitcrusheroutR), .DOUTL(overdriveoutL), .DOUTR(overdriveoutR));
	
	//delay pedal
	delay d3lay(.ENABLE(SW[3]), .CLK(MAX10_CLK1_50), .LRCLK(ARDUINO_IO[4]), .FEEDBACK(SW[6]), .DELAYTIME(delaytime),  .DINL(overdriveoutL), .DINR(overdriveoutR), .DOUTL(delayoutL), .DOUTR(delayoutR));
	
	//square wave tremolo
	tremolo tr3molo(.ENABLE(SW[4]), .LRCLK(ARDUINO_IO[4]), .TREMFREQ(tremfreq),  .DINL(delayoutL), .DINR(delayoutR), .DOUTL(tremolooutL), .DOUTR(tremolooutR));
	
	//lpf to eliminate clicks from tremolo
	lowpassfilter lpf(.ENABLE(SW[5]),  .LRCLK(ARDUINO_IO[4]), .CUTOFF(cutoff), .DINL(tremolooutL), .DINR(tremolooutR), .DOUTL(sample_processed_L), .DOUTR(sample_processed_R));
	
	//i2s module to convert processed parallel data back to serial before sending it out through arduino_io[2]
	i2s_out itwos_out(.CLK(MAX10_CLK1_50), .SCLK(ARDUINO_IO[5]), .LRCLK(ARDUINO_IO[4]), .DINL(sample_processed_L), .DINR(sample_processed_R), .DOUT(dout));
	
	//send what we recieve straight back out
	//assign ARDUINO_IO[2] = ARDUINO_IO[1];
	
	//to do: make better controls for tuning. maybe add more tuning parameters. fix the insane gain on some of this shit. delay? vga? maybe go into i2c to reduce volume.
	
	//set up tremolo, overdrive, bitcrusher
	
	//send processed data back out
	assign ARDUINO_IO[2] = dout;
	
	
	//allows us to use ARDUINO_IO[1] as an input, ensures we dont send anything out on accident
	assign ARDUINO_IO[1] = 1'bZ;

	 
	//make 12.5 MHz clock and send it to SGTL5000
	logic [1:0] aud_mclk_ctrl;
	assign ARDUINO_IO[3] = aud_mclk_ctrl[1];
	always_ff @(posedge MAX10_CLK1_50) 
	begin
		aud_mclk_ctrl <= aud_mclk_ctrl + 1;
	end

endmodule
