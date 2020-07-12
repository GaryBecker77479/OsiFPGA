/* Hires mode is 64 * 8 dots x 32 * 8 lines
	It starts at address 0x8000 to 0x9FFF
	The last 16K of RAM

	Maybe read x16 for color
	Write upper 8 by reading lower 8? Each two bits
	per pixel would then be address of palette?
	Default Palette would be 00 is Black and 01 is White
	for compatibility?
	Also maybe add Palette support for forground and background colors.
*/
module VIDEO
(
CLK,						// Bit clock (25 MHz)
ADDRESS,					// Video RAM address
DATA,						// Video RAM data (16 bits wide)
MEMORY_ENABLE,				// Video RAM enable
RED,
GREEN,
BLUE,
H_SYNC,
V_SYNC,
VROM_ADDRESS,				// Video ROM address
VROM_DATA,					// Video ROM data
OSI_GRAPHICS,				// Graphics mode
CLOCK,					// CLOCK display switch (line 33)
CLK_1HZ
);
input				CLK;						// 37.5 MHz
output [10:0]		ADDRESS;
input  [15:0]		DATA;
output			MEMORY_ENABLE;
reg				MEMORY_ENABLE;
output			RED;
output			GREEN;
output			BLUE;
output			H_SYNC;
reg				H_SYNC;
output			V_SYNC;
reg				V_SYNC;
output [10:0]		VROM_ADDRESS;
input	 [7:0]		VROM_DATA;
input				OSI_GRAPHICS;
input				CLK_1HZ;
output			CLOCK;

reg				H_BLANKING;
reg				V_BLANKING;
reg	[15:0]		CHARACTER;
reg	[15:0]		PIXELS;
reg	[9:0]			H_ADD;
reg	[9:0]			V_LINE;
reg	[7:0]			V_ADD;
reg	[1:0]			LINE;
reg				CLOCK;
wire				DOT;
/*****************************************************************************
* READ Video RAM and latch the character
******************************************************************************/
assign ADDRESS = {V_ADD[7:3],H_ADD[8:3]};				// 64 x 32 = {v(32), h(64)}
always @(negedge CLK)
begin
//	Start RAM read, on pixel 0
	if(H_ADD[2:0] == 3'b000)
		MEMORY_ENABLE <= 1'b1;
	else
		MEMORY_ENABLE <= 1'b0;
// Capture RAM character, on pixel 1 which requires 40 nS or better memory
	if(MEMORY_ENABLE)
		CHARACTER <= DATA;
	else
		CHARACTER <= CHARACTER;
end
/*****************************************************************************
* Read the video ROM
******************************************************************************/
assign VROM_ADDRESS = {CHARACTER[7:0], V_ADD[2:0]};	// 256 characters x 8 lines
always @(negedge CLK)
begin
	if(H_ADD[2:0] == 3'b111)
	begin
		if(~OSI_GRAPHICS)
			PIXELS <= {CHARACTER[15:8], VROM_DATA};
	end
end
/*****************************************************************************
* Color Video Signals
*
*	PIXELS[7:0]		= Horizontal Dots
*	PIXELS[8] 		= Inverse video
*	PIXELS[11:9]	= Foreground color Blue, Green, Red
*	PIXELS[12]		= Blinking
*	PIXELS[15:13]	= Background color Blue, Green, Red
******************************************************************************/
assign DOT		=	PIXELS[H_ADD[2:0]];
assign RED		=	(V_BLANKING | H_BLANKING)				?	1'b0:			// Border (BLACK)
				(DOT ^ (PIXELS[8] ^ (PIXELS[12] & CLK_1HZ)))	?  	PIXELS[9]:		// Foreground
													PIXELS[13];		// Background

assign GREEN	=	(V_BLANKING | H_BLANKING)				?	1'b0:
				(DOT ^ (PIXELS[8] ^ (PIXELS[12] & CLK_1HZ)))	?	PIXELS[10]:
													PIXELS[14];

assign BLUE		=	(V_BLANKING | H_BLANKING)				?	1'b0:
				(DOT ^ (PIXELS[8] ^ (PIXELS[12] & CLK_1HZ)))	?	PIXELS[11]:
													PIXELS[15];
/****************************************************
* Horizontal
*****************************************************/
always @(negedge CLK)
	case(H_ADD)
		10'd7:								// 7 - First Pixel
		begin
			H_BLANKING <= 1'b0;					// Turn off blanking
			H_SYNC <= 1'b1;						// Not H Sync
			H_ADD  <= 10'd8;						// Next step
		end
		10'd519:								// 519 - First non-Pixel
		begin
			H_BLANKING <= 1'b1;					// Turn on blanking
			H_SYNC <= 1'b1;						// Not H Sync
			H_ADD  <= 10'd520;
		end
		10'd531:								// 605 = 660 - 55 = Start HSync
		begin
			H_BLANKING <= 1'b1;
			H_SYNC <= 1'b0;						// Start H Sync
			H_ADD  <= 10'd532;
		end
		10'd599:								// 701 = 756 - 55 = End HSync
		begin
			H_BLANKING <= 1'b1;
			H_SYNC <= 1'b1;						// End H Sync
			H_ADD  <= 10'd600;
		end
		10'd663:								//  End Frame
		begin
			H_BLANKING <= 1'b1;
			H_SYNC <= 1'b1;
			H_ADD  <= 10'd0;
		end
		default:
			H_ADD <= H_ADD + 1;
	endcase
/*******************************************************
* Verticle
********************************************************/
always @(negedge H_SYNC or posedge V_BLANKING)
begin
	if(V_BLANKING)
	begin
		LINE <= 2'b00;
		V_ADD <= 8'h00;
	end
	else
	begin
		case(LINE)
		2'b10:
		begin
			LINE <= 2'b00;
			V_ADD <= V_ADD + 1;
		end
		default:
		begin
			LINE <= LINE + 1;
		end
		endcase
	end
end

always @(negedge H_SYNC)
	case(V_LINE)
		10'd000:
		begin
			V_BLANKING <= 1'b0;					// Turn off blanking
			CLOCK <= 1'b0;
			V_SYNC <= 1'b1;						// No V Sync
			V_LINE  <= 10'd001;
		end
//		10'd759:
//		begin
//			V_BLANKING <= 1'b0;					// Turn off blanking
//			CLOCK <= 1'b1;
//			V_SYNC <= 1'b1;						// No V Sync
//			V_LINE  <= 10'd760;
//		end
		10'd767:
		begin
			V_BLANKING <= 1'b1;					// Turn on blanking
			CLOCK <= 1'b0;
			V_SYNC <= 1'b1;						// No V Sync
			V_LINE  <= 10'd768;
		end
		10'd770:
		begin
			V_BLANKING <= 1'b1;					// Turn on blanking
			CLOCK <= 1'b0;
			V_SYNC <= 1'b0;						// V Sync
			V_LINE  <= 10'd771;
		end
		10'd776:
		begin
			V_BLANKING <= 1'b1;					// Turn on blanking
			CLOCK <= 1'b0;
			V_SYNC <= 1'b1;						// No V Sync
			V_LINE  <= 10'd777;
		end
		10'd805:
		begin
			V_BLANKING <= 1'b0;					// Turn off blanking
			CLOCK <= 1'b0;
			V_SYNC <= 1'b1;						// No V Sync
			V_LINE  <= 10'd000;
		end
		default:
			V_LINE <= V_LINE + 1;
	endcase
endmodule
