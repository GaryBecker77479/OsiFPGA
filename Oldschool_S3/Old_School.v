/**************************************************************************
* Old School
* Gary Becker
****************************************************************************/

//add 31 line 128x124 graphics mode
//with 1 line of text at the bottom.


module Old_School(
CLK50MHZ,

// RAM, ROM, and Peripherials
RAM_DATA0,				// 16 bit data bus to RAM 0
RAM_DATA1,				// 16 bit data bus to RAM 1
RAM_ADDRESS,			// Common address
RAM_RW_N,				// Common RW
RAM0_CS_N,				// Output Enable for RAM 0
RAM1_CS_N,				// Output Enable for RAM 1
RAM0_BE0_N,				// Byte Enable for RAM 0
RAM1_BE0_N,				// Byte Enable for RAM 1
RAM0_BE1_N,				// Byte Enable for RAM 0
RAM1_BE1_N,				// Byte Enable for RAM 1
// VGA
RED,
GREEN,
BLUE,
H_SYNC,
V_SYNC,

// PS/2
ps2_clk,
ps2_data,

//Serial Ports
TXD1,
RXD1,
//TXD2,
//RXD2,
CTS,
RTS,
// Display
DIGIT_N,
SEGMENT_N,
// LEDs
LED,
// Debug
//a,
//x,
//y,
//sr,
//sp,
//pc,
//SYNC,
//ADDRESS,
//DATA_IN,

//DATA_OUT,
// CPU_VIDEO,
//RESET_N,
// Extra Buttons and Switches
SWITCH,
BUTTON
//PH_2
);

input				CLK50MHZ;

// Main RAM Common
output [17:0]	RAM_ADDRESS;
output			RAM_RW_N;
reg				RAM_RW_N;

// Main RAM bank 0
inout	[15:0]	RAM_DATA0;
output			RAM0_CS_N;
output			RAM0_BE0_N;
output			RAM0_BE1_N;

// Main RAM bank 1
inout	[15:0]	RAM_DATA1;
output			RAM1_CS_N;
output			RAM1_BE0_N;
output			RAM1_BE1_N;

// VGA
output	[0:3]		RED;
output	[0:3]		GREEN;
output	[0:3]		BLUE;
output			H_SYNC;
output			V_SYNC;

// PS/2
input 			ps2_clk;
input				ps2_data;

// Serial Ports
output			TXD1;
input				RXD1;
//output			TXD2;
//input				RXD2;
input				CTS;
output			RTS;

// Display
output [3:0]	DIGIT_N;
output [7:0]	SEGMENT_N;


// LEDs
output [7:0]	LED;			//		reg [7:0] LED;

wire		REDX;
wire		GREENX;
wire		BLUEX;

// Debug
//output [7:0]	a;
//output [7:0]	x;
//output [7:0]	y;
//output [7:0]	sr;
//output [7:0]	sp;
//output [7:0]	pc;
//output				SYNC;
//output	[15:0]	ADDRESS;
//output	[7:0]		DATA_IN;
//output	[7:0]		DATA_OUT;
// output				CPU_VIDEO;
//output				RESET_N;

// assign TXD2 = RXD2;

// Extra Buttons and Switches
input [7:0]		SWITCH;				//  7 APPLE_OSI_N
											//  6 STOP
											//  5 COM 2 BAUD[1]
											//  4 COM 2 BAUD[0]
											//  3 COM 1 BAUD[1]
											//  2 COM 1 BAUD[0]
											//  1 CPU_SPEED[1]
											//  0 CPU_SPEED[0]

input [3:0]		BUTTON;				//  3 RESET
											//  2
											//  1
											//  0
// output	PH_2;

reg	[5:0]		CLK;
wire				VGA_CLK;
wire				CLK25MHZ;
// reg	[7:0]		DATA_IN;
reg	[11:0]	COM1_CLOCK;
// reg	[11:0]	COM2_CLOCK;
reg				RESET_N;
reg	[13:0]		RESET_REG;
reg				PH_2;
reg				COM1_CLK;
// Processor
wire				IRQ;
wire				NMI;
wire				RW_N;
wire				READY;
wire				SYNC;					//	: out std_logic;
wire	[7:0]		DATA_IN;				//	: in std_logic_vector(7 downto 0);
wire	[7:0]		DATA_OUT;			//	: out std_logic_vector(7 downto 0)
wire	[15:0]	ADDRESS;
wire	[7:0]		BANK;
// wire				CPU_VIDEO;
wire			  	MEMORY;				// RAM address bus source
wire				ENA_F8;
wire				ENA_F0;
wire				ENA_E8;
wire				ENA_E0;
wire				ENA_D8;
wire				ENA_D0;
wire				ENA_C8;
wire				ENA_C0;
wire				ENA_B8;
wire				ENA_B0;
wire				ENA_A8;
wire				ENA_A0;
wire	[7:0]		DOA_F8;
wire	[7:0]		DOA_F0;
wire	[7:0]		DOA_E8;
wire	[7:0]		DOA_E0;
wire	[7:0]		DOA_D8;
wire	[7:0]		DOA_D0;
wire	[7:0]		DOA_C8;
wire	[7:0]		DOA_C0;
wire	[7:0]		DOA_B8;
wire	[7:0]		DOA_B0;
wire	[7:0]		DOA_A8;
wire	[7:0]		DOA_A0;
wire				ROM_RW;
wire	[7:0]		VRAM_DATA0;
wire	[7:0]		VRAM_DATA1;
wire	[10:0]	VRAM_ADDRESS;
wire	[7:0]		VROM_DATA;
wire				INT1_N;
reg	[63:0]	KEY;
reg				CAPS_CLK;
reg				CAPS;
reg	[7:0]		KB_ROW_LATCH;
wire	[7:0]		KEYBOARD_IN;
wire	[7:0]		SCAN;
wire				PRESS;
wire				EXTENDED;
//reg				KEYBOARD_WRITE;
//reg	[7:0]		KEYBOARD_WRITE_DATA;
// wire				KEYBOARD_ACK;
//wire				KEYBOARD_NOACK;
reg				CPU_RESET_N;
wire	[10:0]	VROM_ADDRESS;
wire	[7:0]		DATA_COM1;
wire				COM1_EN;

reg [3:0]	DIGIT_N;
reg [2:0]	KB_CLK;
reg [1:0]	HOURS_TENS;
reg [3:0]	HOURS_ONES;
reg [2:0]	MINUTES_TENS;
reg [3:0]	MINUTES_ONES;
reg [2:0]	SECONDS_TENS;
reg [3:0]	SECONDS_ONES;
reg [7:0]	DEB_COUNTER;
reg [15:0]	TIME;
reg	[20:0]	TIME_SET;
wire	[7:0]	CLK_IN;
wire			CLOCK;
wire	[7:0]	CLOCK_MUX;
wire			ENA_CLK;
wire	[15:0]	VRAM_DATA_MUX;
reg			ROM_WR_EN;
reg	[7:0]	USER_C;
wire			USER_C_EN;
wire	[3:0]	HEXX;

assign IRQ = 1'b1;
assign NMI = 1'b1;
assign READY = 1'b1;

always @ (posedge H_SYNC)					// Anything > 200 HZ
 case(DIGIT_N)
  4'b1110:	DIGIT_N <= 4'b1101;
  4'b1101:	DIGIT_N <= 4'b1011;
  4'b1011:	DIGIT_N <= 4'b0111;
  default:  DIGIT_N <= 4'b1110;
 endcase
/*
assign SEGMENT_N = (HEXX == 4'h0)	?	{RESET_N, 7'b0000001}:
						 (HEXX == 4'h1)	?	{RESET_N, 7'b1001111}:
						 (HEXX == 4'h2)	?	{RESET_N, 7'b0010010}:
						 (HEXX == 4'h3)	?	{RESET_N, 7'b0000110}:
						 (HEXX == 4'h4)	?	{RESET_N, 7'b1001100}:
						 (HEXX == 4'h5)	?	{RESET_N, 7'b0100100}:
						 (HEXX == 4'h6)	?	{RESET_N, 7'b0100000}:
						 (HEXX == 4'h7)	?	{RESET_N, 7'b0001111}:
						 (HEXX == 4'h8)	?	{RESET_N, 7'b0000000}:
						 (HEXX == 4'h9)	?	{RESET_N, 7'b0001100}:
 						 (HEXX == 4'hA)	?	{RESET_N, 7'b0001000}:
						 (HEXX == 4'hB)	?	{RESET_N, 7'b1100000}:
						 (HEXX == 4'hC)	?	{RESET_N, 7'b0110001}:
						 (HEXX == 4'hD)	?	{RESET_N, 7'b1000010}:
						 (HEXX == 4'hE)	?	{RESET_N, 7'b0110000}:
						 						{RESET_N, 7'b0111000};

assign HEXX	=	({SWITCH[6],DIGIT_N} == 5'b00111)	?	ADDRESS[15:12]:
					({SWITCH[6],DIGIT_N} == 5'b01011)	?	ADDRESS[11:8]:
					({SWITCH[6],DIGIT_N} == 5'b01101)	?	ADDRESS[7:4]:
					({SWITCH[6],DIGIT_N} == 5'b01110)	?	ADDRESS[3:0]:
					({SWITCH[6],DIGIT_N} == 5'b10111)	?	DATA_IN[7:4]:
					({SWITCH[6],DIGIT_N} == 5'b11011)	?	DATA_IN[3:0]:
					({SWITCH[6],DIGIT_N} == 5'b11101)	?	DATA_OUT[7:4]:
																		DATA_OUT[3:0];
*/


assign SEGMENT_N = (DIGIT_N == 4'b0111) ?	{1'b1, 7'b0000001}:			// O
						 (DIGIT_N == 4'b1011) ?	{1'b1, 7'b0100100}:			// S
						 (DIGIT_N == 4'b1101) ?	{1'b1, 7'b1001111}:			// I
						 								{1'b0, 7'b1011111};			// !


//always @(posedge TXD1 or negedge RESET_N)
//	if(!RESET_N)
//		LED <= 8'H01;
//	else
//		LED <= {LED[6:0], LED[7]};
assign LED = {CAPS,7'h00};
/*****************************************************************
* Generates the Clocks from the 50 MHz clock 
*
* VGA_CLK is 25 MHz (VGA pixel clock)
*
* Switch [1:0] = 2'b11  PH_2 = 25.0 MHz
* Switch [1:0] = 2'b10  PH_2 = 12.5  MHz
* Switch [1:0] = 2'b01  PH_2 =  4.17 MHz
* Switch [1:0] = 2'b00  PH_2 =  1.0  MHz
******************************************************************

always @(negedge CLK50MHZ)
	VGA_CLK <= !VGA_CLK;
*/
always @(posedge CLK50MHZ)
begin
		case (CLK)
		6'b000000:
		begin
			PH_2 <= 1'b1;
			CLK <= 6'b000001;
			RAM_RW_N <= RW_N;
		end
		6'b000001:
		begin
			PH_2 <= 1'b0;
			RAM_RW_N <= 1'b1;
			if(SWITCH[1:0] == 2'b11)
				CLK <= 6'b000000;
			else
				CLK <= 6'b000010;
		end
		6'b000011:										// 50/4 = 12.5
		begin
			if(SWITCH[1:0] == 2'b10)
				CLK <= 6'b000000;
			else
				CLK <= 6'b000100;
		end
		6'b001011:										// 50/12 = 4.17
		begin
			if(SWITCH[1:0] == 2'b01)
				CLK <= 6'b000000;
			else
				CLK <= 6'b001100;
		end
		6'b110001:										// 50/50 = 0.78
		begin
			CLK <= 6'b000000;
		end
		default:
		begin
			PH_2 <= 1'b0;
			CLK <= CLK + 1'b1;
		end
		endcase
	end

always @(posedge CLK25MHZ)							// 25 MHz
	begin
		case (COM1_CLOCK)
		12'h000:
		begin
			COM1_CLK <= !COM1_CLK;
			COM1_CLOCK <= 12'h001;
		end
//		12'h050:											// 25/(81*2) = 154320.00 153600/16 = 9600
//		begin
//			if(SWITCH[3:2] == 2'b11)
//				COM1_CLOCK <= 12'h000;
//			else
//				COM1_CLOCK <= 12'h051;
//		end
		12'h0A2:											// 25/(163*2) = 76687.12 76800/16 = 4800
		begin
			if(SWITCH[3:2] == 2'b11)
				COM1_CLOCK <= 12'h000;
			else
				COM1_CLOCK <= 12'h0A3;
		end
		12'h28A:										// 25/(651*2) = 19201.2   19200/16 = 1200
		begin
			if(SWITCH[3:2] == 2'b10)
				COM1_CLOCK <= 12'h000;
			else
				COM1_CLOCK <= 12'h28B;
		end
		12'h515:										// 25/(1302*2) = 9600.6	9600/16 = 600
		begin
			if(SWITCH[3:2] == 2'b01)
				COM1_CLOCK <= 12'h000;
			else
				COM1_CLOCK <= 12'h516;
		end
		12'hA2B:										// 25/(2604*2) = 4800.3	4800/16 = 300
		begin
			COM1_CLOCK <= 12'h000;
		end
		default:
			COM1_CLOCK <= COM1_CLOCK + 1'b1;
		endcase
	end
/*
always @(posedge VGA_CLK)						// 25 MHz
	begin
		case (COM2_CLOCK)
		12'h000:
		begin
			COM2_CLK <= !COM1_CLK;
			COM2_CLOCK <= 12'h001;
		end
		12'h050:										// 25/(81*2)
		begin
			if(SWITCH[5:4] == 2'b11)
				COM2_CLOCK <= 12'h000;
			else
				COM2_CLOCK <= 12'h051;
		end
		12'h28A:										// 25/(651*2)
		begin
			if(SWITCH[5:4] == 2'b10)
				COM2_CLOCK <= 12'h000;
			else
				COM2_CLOCK <= 12'h28B;
		end
		12'h515:										// 25/(1302*2)
		begin
			if(SWITCH[5:4] == 2'b01)
				COM2_CLOCK <= 12'h000;
			else
				COM2_CLOCK <= 12'h516;
		end
		12'hA2B:										// 25/(2604*2)
		begin
			COM2_CLOCK <= 12'h000;
		end
		default:
			COM2_CLOCK <= COM2_CLOCK + 1'b1;
		endcase
	end
*/
always @(negedge CLK50MHZ or posedge BUTTON[3])
begin
	if(BUTTON[3])
	begin
		RESET_REG <= 14'h0000;
		CPU_RESET_N <= 1'b0;
		RESET_N <= 1'b0;
	end
	else
	begin
		case (RESET_REG)
		14'h3800:								// 0x3800 = 14336 * (32 / 50 MHz) = 9.175 mS
		begin
			RESET_N <= 1'b1;
			CPU_RESET_N <= 1'b0;
			RESET_REG <= 14'h3801;
		end
		14'h3FFF:								// 0x3FFF = 16383 * (32 / 50 MHz) = 10.485 mS
		begin
			RESET_N <= 1'b1;
			CPU_RESET_N <= 1'b1;
			RESET_REG <= 14'h3FFF;
		end
		default:
			RESET_REG <= RESET_REG + 1'b1;
		endcase
	end
end

/*****************************************************************************
* 6502 Processor 
******************************************************************************/

T65 GLB6502(
  .Clk(~PH_2),
  .Abort_n(1'b1),
  .NMI_n(NMI),
  .Rdy(1'b1),
  .Enable(1'b1),
  .Res_n(CPU_RESET_N),
  .SO_n(1'b1),
  .IRQ_n(IRQ),
  .EF(EF),
  .R_W_n(RW_N),
  .VDA(VDA),
  .MF(MF),
  .VPA(VPA),
  .ML_n(ML_N),
  .XF(XF),
  .Sync(SYNC),
  .VP_n(VP_N),
  .DI(DATA_IN),
  .Mode(2'b00),
  .DO(DATA_OUT),
  .A({BANK, ADDRESS})
);

/*****************************************************************************
* Memory enables
******************************************************************************/
// assign	CPU_VIDEO = CLK_MOD;
//	2K Monitor ROM F8-FF
assign ENA_F8 = 	(ADDRESS[15:11] == 5'b11111)	?		1'b1:
																		1'b0;

assign COM1_EN = 	(ADDRESS[15:1] == 15'b111100000000000)	?	1'b1:
																				1'b0;

// 2K-2 (F002-F7FF)
assign ENA_F0 = 	(ADDRESS[15:8] == 8'b11110000) ?		~COM1_EN:
						(ADDRESS[15:8] == 8'b11110001) ?		1'b1:
					 	(ADDRESS[15:8] == 8'b11110010) ?		1'b1:
					 	(ADDRESS[15:8] == 8'b11110011) ?		1'b1:
					 	(ADDRESS[15:8] == 8'b11110100) ?		1'b1:
					 	(ADDRESS[15:8] == 8'b11110101) ?		1'b1:
					 	(ADDRESS[15:8] == 8'b11110110) ?		1'b1:
					 	(ADDRESS[15:8] == 8'b11110111) ?		1'b1:
																		1'b0;

// 2K Extended Monitor / Disassembler
assign ENA_E8 = 	(ADDRESS[15:11] == 5'b11101)	?		1'b1:
																		1'b0;
// 2K Video Color memory
assign ENA_E0 =	(ADDRESS[15:11] == 5'b11100)	?		1'b1:
																		1'b0;

// 2K-256 (D800-DEFF)
assign ENA_D8 = (ADDRESS[15:8] == 8'hD8)	?				1'b1:
					 (ADDRESS[15:8] == 8'hD9)	?				1'b1:
					 (ADDRESS[15:8] == 8'hDA)	?				1'b1:
					 (ADDRESS[15:8] == 8'hDB)	?				1'b1:
					 (ADDRESS[15:8] == 8'hDC)	?				1'b1:
					 (ADDRESS[15:8] == 8'hDD)	?				1'b1:
					 (ADDRESS[15:8] == 8'hDE)	?				1'b1:
					 (ADDRESS[15:7] == 9'b110111111)		?	1'b1:		// DF80-DFFF
					 (ADDRESS[15:6] == 10'b1101111101)	?	1'b1:		// DF40-DF7F
					 (ADDRESS[15:5] == 11'b11011111001)	?	1'b1:		// DF20-DF3F
																		1'b0;

// 2K Video Character nemory
assign ENA_D0 = (ADDRESS[15:11] == 5'b11010) ?			1'b1:
																		1'b0;

// 2K Tape utility and etc
assign ENA_C8 =	(ADDRESS[15:11] ==  5'b11001)	?		1'b1:	//~(ENA_CLK):
																		1'b0;

// 2K Character Generator "ROM" user modifiable
assign ENA_C0 = (ADDRESS[15:11] == 5'b11000) ?			1'b1:
																		1'b0;

// 2K BASIC ROM 4
assign ENA_B8 = (ADDRESS[15:11] == 5'b10111) ?			1'b1:
																		1'b0;

// 2K BASIC ROM 3
assign ENA_B0 = (ADDRESS[15:11] == 5'b10110) ?			1'b1:
																		1'b0;

// 2K BASIC ROM 2
assign ENA_A8 = (ADDRESS[15:11] == 5'b10101) ?			1'b1:
																		1'b0;

// 2K BASIC ROM 1
assign ENA_A0 = (ADDRESS[15:11] == 5'b10100) ?			1'b1:
																		1'b0;

assign ENA_KB	=	(ADDRESS[15:0] == 16'hDF00)	?		1'b1:
																		1'b0;

assign ENA_CLK	=	(ADDRESS[15:0] == 16'hDF10)	?		1'b1:
						(ADDRESS[15:0] == 16'hDF11)	?		1'b1:
						(ADDRESS[15:0] == 16'hDF12)	?		1'b1:
						(ADDRESS[15:0] == 16'hDF13)	?		1'b1:
						(ADDRESS[15:0] == 16'hDF14)	?		1'b1:
						(ADDRESS[15:0] == 16'hDF15)	?		1'b1:
						(ADDRESS[15:0] == 16'hDF16)	?		1'b1:
																		1'b0;

assign USER_C_EN	=	(ADDRESS[15:0] == 16'HDF0A)	?	1'b1:
																		1'b0;

// DF0A-DF0B
always @ (negedge PH_2 or negedge RESET_N)
begin
	if(!RESET_N)
	begin
		USER_C <= 8'h04;
		ROM_WR_EN <= 1'b0;
	end
	else
	case ({RW_N, ADDRESS})
	17'h0DF0A:
			USER_C <= DATA_OUT;
	17'h0DF0B:
			ROM_WR_EN <= DATA_OUT[0];
	endcase
end

/*****************************************************************************
* Data bus mux
******************************************************************************/
assign DATA_IN	=		(ENA_F8)			?	DOA_F8:
                		(ENA_F0)			?	DOA_F0:
					 		(ENA_E8)			?	DOA_E8:
					 		(ENA_E0)			?	DOA_E0:
					 		(ENA_D8)			?	DOA_D8:
					 		(ENA_D0)			?	DOA_D0:
					 		(ENA_C8)			?	DOA_C8:
					 		(ENA_C0)			?	DOA_C0:
					 		(ENA_B8)			?	DOA_B8:
					 		(ENA_B0)			?	DOA_B0:
					 		(ENA_A8)			?	DOA_A8:
					 		(ENA_A0)			?	DOA_A0:
							(COM1_EN)		?	DATA_COM1:
							(ENA_KB)			?	KEYBOARD_IN:
							(ENA_CLK)		?	CLK_IN:
							(USER_C_EN)		?	USER_C:
						 							RAM_DATA0[7:0];

// assign DATA_OUTx = DATA_OUT;
bufif0(RAM_DATA0[0], DATA_OUT[0], !PH_2 | RW_N);
bufif0(RAM_DATA0[1], DATA_OUT[1], !PH_2 | RW_N);
bufif0(RAM_DATA0[2], DATA_OUT[2], !PH_2 | RW_N);
bufif0(RAM_DATA0[3], DATA_OUT[3], !PH_2 | RW_N);
bufif0(RAM_DATA0[4], DATA_OUT[4], !PH_2 | RW_N);
bufif0(RAM_DATA0[5], DATA_OUT[5], !PH_2 | RW_N);
bufif0(RAM_DATA0[6], DATA_OUT[6], !PH_2 | RW_N);
bufif0(RAM_DATA0[7], DATA_OUT[7], !PH_2 | RW_N);
bufif0(RAM_DATA0[8], 1'b0, !PH_2 | RW_N);
bufif0(RAM_DATA0[9], 1'b0, !PH_2 | RW_N);
bufif0(RAM_DATA0[10], 1'b0, !PH_2 | RW_N);
bufif0(RAM_DATA0[11], 1'b0, !PH_2 | RW_N);
bufif0(RAM_DATA0[12], 1'b0, !PH_2 | RW_N);
bufif0(RAM_DATA0[13], 1'b0, !PH_2 | RW_N);
bufif0(RAM_DATA0[14], 1'b0, !PH_2 | RW_N);
bufif0(RAM_DATA0[15], 1'b0, !PH_2 | RW_N);

assign RAM_ADDRESS = {2'b00, ADDRESS[15:0]};

// Not enabled when upper addresses
assign RAM0_CS_N = 	({ADDRESS[15]}		== 1'b0)		?	1'b0:		// 0-32K
							({ADDRESS[15:13]}	== 3'b100)	?	1'b0:		// 32K-40k
					 													1'b1;

assign RAM1_CS_N =	1'b1;			// Not Used YET
assign RAM0_BE0_N =	1'b0;			// Byte Enable for RAM 0
assign RAM1_BE0_N =	1'b1;			// Byte Enable for RAM 1
assign RAM0_BE1_N =	1'b1;			// Byte Enable for RAM 0
assign RAM1_BE1_N =	1'b1;			// Byte Enable for RAM 1

assign RAM_DATA1 = 16'bZZZZZZZZZZZZZZZZ;	// Not Used

assign ROM_RW = ROM_WR_EN & ~RW_N;
/*****************************************************************************
* Single Port RAM
* List Groups
******************************************************************************/
`include "rom_f8.v"
`include "rom_f0.v"
`include "rom_e8.v"
`include "rom_d8.v"
`include "rom_c8.v"
`include "rom_b8.v"
`include "rom_b0.v"
`include "rom_a8.v"
`include "rom_a0.v"

/*****************************************************************************
* Three 2k groups of dual port RAM
*		1:	E000-E7FF	Video Color Memory (OSI uses x4, This is X8 for OSI + GLB
*		2:	D000-D7FF	Video Memory
*		3: C000-C7FF	Programmable Character Generator (extended feature)
******************************************************************************/
`include "ram_e0.v"
`include "ram_d0.v"
`include "ram_c0.v"

/*****************************************************************************
* Hardware Clock
******************************************************************************/
assign CLK_IN =	({ENA_CLK, ADDRESS[2:0]} == 4'b1000) ?	{DEB_COUNTER}:
						({ENA_CLK, ADDRESS[2:0]} == 4'b1001) ?	{4'h0,  SECONDS_ONES}:
						({ENA_CLK, ADDRESS[2:0]} == 4'b1010) ?	{5'h00, SECONDS_TENS}:
						({ENA_CLK, ADDRESS[2:0]} == 4'b1011) ?	{4'h0,  MINUTES_ONES}:
						({ENA_CLK, ADDRESS[2:0]} == 4'b1100) ?	{5'h00, MINUTES_TENS}:
						({ENA_CLK, ADDRESS[2:0]} == 4'b1101) ?	{4'h0,  HOURS_ONES}:
						({ENA_CLK, ADDRESS[2:0]} == 4'b1110) ?	{6'h00, HOURS_TENS}:
																				8'hFF;

always @ (negedge PH_2 or negedge RESET_N)
begin
	if(~RESET_N)
		TIME_SET <= 21'h00000;
	else
		case({ENA_CLK, RW_N, ADDRESS[2:0]})
		5'b10001:	TIME_SET[3:0] <= DATA_OUT[3:0];
		5'b10010:	TIME_SET[6:4] <= DATA_OUT[2:0];
		5'b10011:	TIME_SET[10:7] <= DATA_OUT[3:0];
		5'b10100:	TIME_SET[13:11] <= DATA_OUT[2:0];
		5'b10101:	TIME_SET[17:14] <= DATA_OUT[3:0];
		5'b10110:	TIME_SET[20:18] <= {DATA_OUT[7], DATA_OUT[1:0]};
		endcase
end
always @ (posedge H_SYNC)
begin
	case(TIME)
	16'HDC9B:	TIME <= 16'H0000;
	default:	TIME <= TIME + 1;
	endcase
end

always @ (posedge TIME[0])						// counter used for software
	DEB_COUNTER <= DEB_COUNTER + 1;			// debounce of keyboard

always @ (negedge TIME[15])
begin
	if(TIME_SET[20])
	begin
		SECONDS_ONES <= TIME_SET[3:0];
		SECONDS_TENS <= TIME_SET[6:4];
		MINUTES_ONES <= TIME_SET[10:7];
		MINUTES_TENS <= TIME_SET[13:11];
		HOURS_ONES <= TIME_SET[17:14];
		HOURS_TENS <= TIME_SET[19:18];
	end
	else
	begin
		case(SECONDS_ONES)
		4'D9:	SECONDS_ONES <= 4'D0;
		default:	SECONDS_ONES <= SECONDS_ONES + 1;
		endcase

		case(SECONDS_TENS)
		3'D5:
			if(SECONDS_ONES == 4'H9)
				SECONDS_TENS <= 3'D0;
		default:
			if(SECONDS_ONES == 4'H9)
				SECONDS_TENS <= SECONDS_TENS + 1;
		endcase

		case(MINUTES_ONES)
		4'D9:
			if({SECONDS_TENS, SECONDS_ONES} == 7'H59)
				MINUTES_ONES <= 4'D0;
		default:
			if({SECONDS_TENS, SECONDS_ONES} == 7'H59)
				MINUTES_ONES <= MINUTES_ONES + 1;
		endcase

		case(MINUTES_TENS)
		3'D5:
			if({MINUTES_ONES, SECONDS_TENS, SECONDS_ONES} == 11'H4D9)
				MINUTES_TENS <= 3'D0;
		default:
			if({MINUTES_ONES, SECONDS_TENS, SECONDS_ONES} == 11'H4D9)
				MINUTES_TENS <= MINUTES_TENS + 1;
		endcase

		case(HOURS_ONES)
		4'D9:
			if({MINUTES_TENS, MINUTES_ONES, SECONDS_TENS, SECONDS_ONES} == 14'H2CD9)
				HOURS_ONES <= 4'D0;
		4'D3:
			if({MINUTES_TENS, MINUTES_ONES, SECONDS_TENS, SECONDS_ONES} == 14'H2CD9)
				if(HOURS_TENS == 2'D2)
					HOURS_ONES <= 4'D0;
				else
					HOURS_ONES <= 4'D4;
		default:
			if({MINUTES_TENS, MINUTES_ONES, SECONDS_TENS, SECONDS_ONES} == 14'H2CD9)
				HOURS_ONES <= HOURS_ONES + 1;
		endcase

		case(HOURS_TENS)
		2'D2:
			if({HOURS_ONES, MINUTES_TENS, MINUTES_ONES, SECONDS_TENS, SECONDS_ONES} == 18'H0ECD9)
				HOURS_TENS <= 2'D0;
		default:
			if({HOURS_ONES, MINUTES_TENS, MINUTES_ONES, SECONDS_TENS, SECONDS_ONES} == 18'H26CD9)
				HOURS_TENS <= HOURS_TENS + 1;
		endcase
	end
end
/*****************************************************************************
* Convert PS/2 keyboard to OSI keyboard
******************************************************************************/
always @(negedge PH_2 or negedge RESET_N)
begin
	if(~RESET_N)
	begin
		KB_ROW_LATCH <= 8'hff;
	end
	else
	begin
		if(ENA_KB & ~RW_N)
			KB_ROW_LATCH <= DATA_OUT;
	end
end

assign KEYBOARD_IN[0] =  ((KB_ROW_LATCH[0] & CAPS)
								 |(KB_ROW_LATCH[1] & KEY[8])
								 |(KB_ROW_LATCH[2] & KEY[16])
								 |(KB_ROW_LATCH[3] & KEY[24])
								 |(KB_ROW_LATCH[4] & KEY[32])
								 |(KB_ROW_LATCH[5] & KEY[40])
								 |(KB_ROW_LATCH[6] & KEY[48])
								 |(KB_ROW_LATCH[7] & KEY[56]));
assign KEYBOARD_IN[1] =	 ((KB_ROW_LATCH[0] & KEY[1])
								 |(KB_ROW_LATCH[1] & KEY[9])
								 |(KB_ROW_LATCH[2] & KEY[17])
								 |(KB_ROW_LATCH[3] & KEY[25])
								 |(KB_ROW_LATCH[4] & KEY[33])
								 |(KB_ROW_LATCH[5] & KEY[41])
								 |(KB_ROW_LATCH[6] & KEY[49])
								 |(KB_ROW_LATCH[7] & KEY[57]));
assign KEYBOARD_IN[2] =	 ((KB_ROW_LATCH[0] & KEY[2])
								 |(KB_ROW_LATCH[1] & KEY[10])
								 |(KB_ROW_LATCH[2] & KEY[18])
								 |(KB_ROW_LATCH[3] & KEY[26])
								 |(KB_ROW_LATCH[4] & KEY[34])
								 |(KB_ROW_LATCH[5] & KEY[42])
								 |(KB_ROW_LATCH[6] & KEY[50])
								 |(KB_ROW_LATCH[7] & KEY[58]));
assign KEYBOARD_IN[3] =	 ((KB_ROW_LATCH[0] & KEY[3])
								 |(KB_ROW_LATCH[1] & KEY[11])
								 |(KB_ROW_LATCH[2] & KEY[19])
								 |(KB_ROW_LATCH[3] & KEY[27])
								 |(KB_ROW_LATCH[4] & KEY[35])
								 |(KB_ROW_LATCH[5] & KEY[43])
								 |(KB_ROW_LATCH[6] & KEY[51])
								 |(KB_ROW_LATCH[7] & KEY[59]));
assign KEYBOARD_IN[4] =	 ((KB_ROW_LATCH[0] & KEY[4])
								 |(KB_ROW_LATCH[1] & KEY[12])
								 |(KB_ROW_LATCH[2] & KEY[20])
								 |(KB_ROW_LATCH[3] & KEY[28])
								 |(KB_ROW_LATCH[4] & KEY[36])
								 |(KB_ROW_LATCH[5] & KEY[44])
								 |(KB_ROW_LATCH[6] & KEY[52])
								 |(KB_ROW_LATCH[7] & KEY[60]));
assign KEYBOARD_IN[5] =	 ((KB_ROW_LATCH[0] & KEY[5])
								 |(KB_ROW_LATCH[1] & KEY[13])
								 |(KB_ROW_LATCH[2] & KEY[21])
								 |(KB_ROW_LATCH[3] & KEY[29])
								 |(KB_ROW_LATCH[4] & KEY[37])
								 |(KB_ROW_LATCH[5] & KEY[45])
								 |(KB_ROW_LATCH[6] & KEY[53])
								 |(KB_ROW_LATCH[7] & KEY[61]));
assign KEYBOARD_IN[6] =	 ((KB_ROW_LATCH[0] & KEY[6])
								 |(KB_ROW_LATCH[1] & KEY[14])
								 |(KB_ROW_LATCH[2] & KEY[22])
								 |(KB_ROW_LATCH[3] & KEY[30])
								 |(KB_ROW_LATCH[4] & KEY[38])
								 |(KB_ROW_LATCH[5] & KEY[46])
								 |(KB_ROW_LATCH[6] & KEY[54])
								 |(KB_ROW_LATCH[7] & KEY[62]));
assign KEYBOARD_IN[7] =	 ((KB_ROW_LATCH[0] & KEY[7])
								 |(KB_ROW_LATCH[1] & KEY[15])
								 |(KB_ROW_LATCH[2] & KEY[23])
								 |(KB_ROW_LATCH[3] & KEY[31])
								 |(KB_ROW_LATCH[4] & KEY[39])
								 |(KB_ROW_LATCH[5] & KEY[47])
								 |(KB_ROW_LATCH[6] & KEY[55])
								 |(KB_ROW_LATCH[7] & KEY[63]));

always @(posedge KB_CLK[2] or negedge RESET_N)
begin
	if(~RESET_N)
	begin
		KEY <= 64'h1;
		CAPS_CLK <= 1'b0;
	end
	else
	begin
		KEY[0] <= CAPS;
		case(SCAN)
		8'h16:		KEY[63] <= PRESS;	// 1 !
		8'h1E:		KEY[62] <= PRESS;	// 2 @
		8'h26:		KEY[61] <= PRESS;	// 3 #
		8'h25:		KEY[60] <= PRESS;	// 4 $
		8'h2E:		KEY[59] <= PRESS;	// 5 %
		8'h36:		KEY[58] <= PRESS;	// 6 ^
		8'h3D:		KEY[57] <= PRESS;	// 7 &
		8'h0D:		KEY[56] <= PRESS;	// TAB
		8'h3E:		KEY[55] <= PRESS;	// 8 *
		8'h46:		KEY[54] <= PRESS;	// 9 (
		8'h45:		KEY[53] <= PRESS;	// 0 )
		8'h4E:		KEY[52] <= PRESS;	// - _
		8'h55:		KEY[51] <= PRESS;	// = +
		8'h66:		KEY[50] <= PRESS;	// backspace
		8'h0E:		KEY[49] <= PRESS;	// ` ~
		8'h5D:		KEY[48] <= PRESS;	// \ |
		8'h49:		KEY[47] <= PRESS;	// . >
		8'h4b:		KEY[46] <= PRESS;	// L
		8'h44:		KEY[45] <= PRESS;	// O
//		8'h11			KEY[44] <= PRESS; // line feed (really right ALT (Extended) see below
		8'h5A:		KEY[43] <= PRESS;	// CR
		8'h54:		KEY[42] <= PRESS;	// [ {
		8'h5B:		KEY[41] <= PRESS;	// ] }
		8'h52:		KEY[40] <= PRESS;	// ' "
		8'h1D:		KEY[39] <= PRESS;	// W
		8'h24:		KEY[38] <= PRESS;	// E
		8'h2D:		KEY[37] <= PRESS;	// R
		8'h2C:		KEY[36] <= PRESS;	// T
		8'h35:		KEY[35] <= PRESS;	// Y
		8'h3C:		KEY[34] <= PRESS;	// U
		8'h43:		KEY[33] <= PRESS;	// I
		8'h75:		KEY[32] <= PRESS;	// up
		8'h1B:		KEY[31] <= PRESS;	// S
		8'h23:		KEY[30] <= PRESS;	// D
		8'h2B:		KEY[29] <= PRESS;	// F
		8'h34:		KEY[28] <= PRESS;	// G
		8'h33:		KEY[27] <= PRESS;	// H
		8'h3B:		KEY[26] <= PRESS;	// J
		8'h42:		KEY[25] <= PRESS;	// K
		8'h74:		KEY[24] <= PRESS;	// right
		8'h22:		KEY[23] <= PRESS;	// X
		8'h21:		KEY[22] <= PRESS;	// C
	8'h2a:		KEY[21] <= PRESS;	// V
		8'h32:		KEY[20] <= PRESS;	// B
		8'h31:		KEY[19] <= PRESS;	// N
		8'h3a:		KEY[18] <= PRESS;	// M
		8'h41:		KEY[17] <= PRESS;	// ,
		8'h6B:		KEY[16] <= PRESS;	// left
		8'h15:		KEY[15] <= PRESS;	// Q
		8'h1C:		KEY[14] <= PRESS;	// A
		8'h1A:		KEY[13] <= PRESS;	// Z
		8'h29:		KEY[12] <= PRESS;	// Space
		8'h4A:		KEY[11] <= PRESS;	// / ?
		8'h4C:		KEY[10] <= PRESS;	// ; :
		8'h4D:		KEY[9] <= PRESS;	// P
		8'h72:		KEY[8] <= PRESS;	// down
		8'h11:
		begin
			if(~EXTENDED)
						KEY[7] <= PRESS;	// Repeat really left ALT
			else
						KEY[44] <= PRESS;	// LF really right ALT
		end
		8'h14:		KEY[6] <= PRESS;	// Ctrl either left or right
		8'h76:		KEY[5] <= PRESS;	// Esc
//		8'h2C:		KEY[4] <= PRESS;	// na
//		8'h35:		KEY[3] <= PRESS;	// na
		8'h12:		KEY[2] <= PRESS;	// L-Shift
		8'h59:		KEY[1] <= PRESS;	// R-Shift
		8'h58:		CAPS_CLK <= PRESS;	// Caps
		endcase
	end
end

always @(posedge CAPS_CLK or negedge RESET_N)
begin
	if(~RESET_N)
		CAPS <= 1'b1;
	else
		CAPS <= ~CAPS;
end

always @ (posedge COM1_CLOCK[0])				//6.25 MHz
	KB_CLK <= KB_CLK + 1'b1;

ps2_keyboard KEYBOARD(
		.RESET_N(RESET_N),
		.CLK(KB_CLK[2]),
		.PS2_CLK(ps2_clk),
		.PS2_DATA(ps2_data),
		.RX_SCAN(SCAN),
		.RX_PRESSED(PRESS),
		.RX_EXTENDED(EXTENDED)
);

/*****************************************************************************
* Serial Ports
******************************************************************************/
glb6850 COM1(
.RESET_N(RESET_N),
.RX_CLK(COM1_CLK),
.TX_CLK(COM1_CLK),
.IRQ(INT1_N),
.E(PH_2),
.DI(DATA_OUT),
.DO(DATA_COM1),
.CS(COM1_EN),
.RW_N(RW_N),
.RS(ADDRESS[0]),
.TXDATA(TXD1),
.RXDATA(RXD1),
.RTS(RTS),
.CTS(CTS),
.DCD(RTS)
);

assign VRAM_DATA_MUX = (CLOCK) ? {8'h04, CLOCK_MUX}:
											{VRAM_DATA1, VRAM_DATA0};

assign CLOCK_MUX =	(VRAM_ADDRESS[5:0] == 6'd28) ?	{6'b001100, HOURS_TENS}:
							(VRAM_ADDRESS[5:0] == 6'd29) ?	{4'b0011, HOURS_ONES}:
							(VRAM_ADDRESS[5:0] == 6'd30) ?	 8'h3A:
							(VRAM_ADDRESS[5:0] == 6'd31) ?	{5'b00110, MINUTES_TENS}:
							(VRAM_ADDRESS[5:0] == 6'd32) ?	{4'b0011, MINUTES_ONES}:
							(VRAM_ADDRESS[5:0] == 6'd33) ?	 8'h3A:
							(VRAM_ADDRESS[5:0] == 6'd34) ?	{5'b00110, SECONDS_TENS}:
							(VRAM_ADDRESS[5:0] == 6'd35) ?	{4'b0011, SECONDS_ONES}:
																		 8'h20;

assign RED = {REDX, REDX, REDX, REDX};
assign GREEN = {GREENX, GREENX, GREENX, GREENX};
assign BLUE = {BLUEX, BLUEX, BLUEX, BLUEX};

VIDEO VGA(
		.CLK(VGA_CLK),
		.ADDRESS(VRAM_ADDRESS),
		.DATA(VRAM_DATA_MUX),
		.MEMORY_ENABLE(MEMORY),
		.RED(REDX),
		.GREEN(GREENX),
		.BLUE(BLUEX),
		.H_SYNC(H_SYNC),
		.V_SYNC(V_SYNC),
		.VROM_ADDRESS(VROM_ADDRESS),
		.VROM_DATA(VROM_DATA),
		.OSI_GRAPHICS(1'b0),
		.CLOCK(CLOCK),
		.CLK_1HZ(TIME[15]));


   DCM #(
      .SIM_MODE("SAFE"),  // Simulation: "SAFE" vs. "FAST", see "Synthesis and Simulation Design Guide" for details
      .CLKDV_DIVIDE(2.0), // Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                          //   7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      .CLKFX_DIVIDE(4),   // Can be any integer from 1 to 32
      .CLKFX_MULTIPLY(3), // Can be any integer from 2 to 32
      .CLKIN_DIVIDE_BY_2("FALSE"), // TRUE/FALSE to enable CLKIN divide by two feature
      .CLKIN_PERIOD(20.0),  // Specify period of input clock
      .CLKOUT_PHASE_SHIFT("NONE"), // Specify phase shift of NONE, FIXED or VARIABLE
      .CLK_FEEDBACK("1X"),  // Specify clock feedback of NONE, 1X or 2X
      .DESKEW_ADJUST("SOURCE_SYNCHRONOUS"), // SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                            //   an integer from 0 to 15
      .DFS_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for frequency synthesis
      .DLL_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for DLL
      .DUTY_CYCLE_CORRECTION("TRUE"), // Duty cycle correction, TRUE or FALSE
      .FACTORY_JF(16'hC080),   // FACTORY JF values
      .PHASE_SHIFT(0),     // Amount of fixed phase shift from -255 to 255
      .STARTUP_WAIT("TRUE")   // Delay configuration DONE until DCM LOCK, TRUE/FALSE
   ) DCM_inst (
//      .CLK0(CLK0),     // 0 degree DCM CLK output
//      .CLK180(CLK180), // 180 degree DCM CLK output
//      .CLK270(CLK270), // 270 degree DCM CLK output
//      .CLK2X(CLK2X),   // 2X DCM CLK output
//      .CLK2X180(CLK2X180), // 2X, 180 degree DCM CLK out
//      .CLK90(CLK90),   // 90 degree DCM CLK output
      .CLKDV(CLK25MHZ),   // Divided DCM CLK out (CLKDV_DIVIDE)
      .CLKFX(VGA_CLK),   // DCM CLK synthesis out (M/D)
      .CLKFX180(CLKFX180), // 180 degree CLK synthesis out
      .LOCKED(LOCKED), // DCM LOCK status output
      .PSDONE(PSDONE), // Dynamic phase adjust done output
      .STATUS(STATUS), // 8-bit DCM status bits output
      .CLKFB(CLKFX180),   // DCM clock feedback
      .CLKIN(CLK50MHZ),   // Clock input (from IBUFG, BUFG or DCM)
      .PSCLK(PSCLK),   // Dynamic phase adjust clock input
      .PSEN(PSEN),     // Dynamic phase adjust enable input
      .PSINCDEC(PSINCDEC), // Dynamic phase adjust increment/decrement
      .RST(BUTTON[3])        // DCM asynchronous reset input
   );

   // End of DCM_inst instantiation

/*DCM1 VGA_37_5MHZ(
	.CLKIN(CLK50MHZ),
	.CLK0(CLK0),
	.CLKFX(VGA_CLK),
	.CLKDV(CLK25MHZ),
	.LOCKED(LOCKED));
*/
endmodule
