/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [11:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

logic [31:0] LOCAL_REG       [8]; // Registers
//put other local variables here
logic pixel_clk, blank, sync;
logic [10:0] font_addr;
logic [7:0] font_data, cur_char;
logic [9:0] DrawX, DrawY;
logic [6:0] char_x;
logic [5:0] char_y;
logic [11:0] char_idx;
logic [3:0] fgd_idx, bkd_idx, red_fgd, green_fgd, blue_fgd, red_bkd, green_bkd, blue_bkd;
logic [31:0] VGA_READDATA, AVL_READ_PAL, AVL_READ_CHAR;

logic [10:0] VGA_ADDR;

always_comb
begin
	
	char_x = DrawX[9:3];
	char_y = DrawY[9:4];
	char_idx = (80 * char_y) + char_x;
	VGA_ADDR = char_idx[11:1];

	unique case(char_idx[0])
		1'b0 :
		begin
		cur_char = VGA_READDATA[15:8];
		fgd_idx = VGA_READDATA[7:4];
		bkd_idx = VGA_READDATA[3:0];
		end	
		1'b1 :
		begin
		cur_char = VGA_READDATA[31:24];
		fgd_idx = VGA_READDATA[23:20];
		bkd_idx = VGA_READDATA[19:16];
		end
	endcase
	
	font_addr = (16*cur_char[6:0]) + DrawY[3:0];
	
	
	unique case (fgd_idx[0])
	1'b0:
	begin
	red_fgd = LOCAL_REG[fgd_idx[3:1]][12:9];
	green_fgd = LOCAL_REG[fgd_idx[3:1]][8:5];
	blue_fgd = LOCAL_REG[fgd_idx[3:1]][4:1];
	end
	1'b1:
	begin
	red_fgd = LOCAL_REG[fgd_idx[3:1]][24:21];
	green_fgd = LOCAL_REG[fgd_idx[3:1]][20:17];
	blue_fgd = LOCAL_REG[fgd_idx[3:1]][16:13];
	end
	endcase
	
	unique case (bkd_idx[0])
	1'b0:
	begin
	red_bkd = LOCAL_REG[bkd_idx[3:1]][12:9];
	green_bkd = LOCAL_REG[bkd_idx[3:1]][8:5];
	blue_bkd = LOCAL_REG[bkd_idx[3:1]][4:1];
	end
	1'b1:
	begin
	red_bkd = LOCAL_REG[bkd_idx[3:1]][24:21];
	green_bkd = LOCAL_REG[bkd_idx[3:1]][20:17];
	blue_bkd = LOCAL_REG[bkd_idx[3:1]][16:13];
	end
	endcase
	
	
end

always_ff @(posedge CLK)
begin

if (AVL_WRITE && AVL_CS && AVL_ADDR[11])
begin
	LOCAL_REG[AVL_ADDR[2:0]] <= AVL_WRITEDATA;
end
end
//always_comb
//begin
//LOCAL_REG[0] = {7'b0, 4'h0, 4'h0, 4'ha,   4'h0, 4'h0, 4'h0, 1'b0};
//LOCAL_REG[1] = {7'b0, 4'h0, 4'ha, 4'ha,   4'h0, 4'ha, 4'h0, 1'b0};
//LOCAL_REG[2] = {7'b0, 4'ha, 4'h0, 4'ha,   4'ha, 4'h0, 4'h0, 1'b0};
//LOCAL_REG[3] = {7'b0, 4'ha, 4'ha, 4'ha,   4'ha, 4'h5, 4'h0, 1'b0};
//LOCAL_REG[4] = {7'b0, 4'h5, 4'h5, 4'hf,   4'h5, 4'h5, 4'h5, 1'b0};
//LOCAL_REG[5] = {7'b0, 4'h5, 4'hf, 4'hf,   4'h5, 4'hf, 4'h5, 1'b0};
//LOCAL_REG[6] = {7'b0, 4'hf, 4'h5, 4'hf,   4'hf, 4'h5, 4'h5, 1'b0};
//LOCAL_REG[7] = {7'b0, 4'hf, 4'hf, 4'hf,   4'hf, 4'hf, 4'h5, 1'b0};
//end


always_ff  @(posedge pixel_clk)
begin
	
	if (!blank)
	begin
		red <= 4'b0000;
		green <= 4'b0000;
		blue <= 4'b0000;
	end
	
	else if (font_data[7 - DrawX[2:0]] == 1'b1 && cur_char[7] == 1'b0)
	begin
		red <= red_fgd;
		green <= green_fgd;
		blue <= blue_fgd;
	end

	else if (font_data[7 - DrawX[2:0]] == 1'b1 && cur_char[7] == 1'b1)
	begin
		red <= red_bkd;
		green <= green_bkd;
		blue <= blue_bkd;
	end

	else if (font_data[7 - DrawX[2:0]] == 1'b0 && cur_char[7] == 1'b1)
	begin
		red <= red_fgd;
		green <= green_fgd;
		blue <= blue_fgd;
	end

	else
	begin
		red <= red_bkd;
		green <= green_bkd;
		blue <= blue_bkd;
	end

end
	
	
	
// use char_idx[1:0] to pick
//Declare submodules..e.g. VGA controller, ROMS, etc
font_rom font_rom0(.addr(font_addr), .data(font_data));
vga_controller vga_controller0(.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), .pixel_clk(pixel_clk), .blank(blank), .sync(sync), .DrawX(DrawX), .DrawY(DrawY));
ram_jb ram0(.byteena_a(AVL_BYTE_EN), .byteena_b(), .clock(CLK), .data_a(AVL_WRITEDATA),  .data_b(32'h00000000), .rden_a(AVL_READ && AVL_CS), .rden_b(1'b1), .wren_a(AVL_WRITE && AVL_CS), .wren_b(1'b0), .q_a(AVL_READDATA), .q_b(VGA_READDATA), .address_a(AVL_ADDR), .address_b(VGA_ADDR));



//handle drawing (may either be combinational or sequential - or both).
		

endmodule
