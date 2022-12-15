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
	input  logic [9:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

logic [31:0] LOCAL_REG       [`NUM_REGS]; // Registers
//put other local variables here
logic [10:0] font_addr;
logic [7:0] font_data, cur_char;
logic [9:0] DrawX, DrawY;
logic [9:0] char_x, char_y;
logic [11:0] char_idx;
assign char_x = DrawX/8;
assign char_y = DrawY/16;
assign char_idx = (80*char_y)+char_x;//row major
assign cur_char = LOCAL_REG[char_idx/4];
// use char_idx[1:0] to pick
//Declare submodules..e.g. VGA controller, ROMS, etc
font_rom font_rom0(.addr(cur_char+DrawY[3:0]), .data(font_data));
vga_controller vga_controller0(.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), .pixel_clk(), .blank(), .sync(dontcare), .DrawX(DrawX), .DrawY(DrawY));


// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
always_ff @(posedge CLK) begin

if(AVL_WRITE)begin
LOCAL_REG[AVL_ADDR][AVL_BYTE_EN] = AVL_WRITEDATA;
end

if(AVL_READ)begin
AVL_READDATA = LOCAL_REG[AVL_ADDR][AVL_BYTE_EN];
end

end


//handle drawing (may either be combinational or sequential - or both).
		

endmodule
