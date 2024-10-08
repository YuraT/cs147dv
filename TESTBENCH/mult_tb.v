// Name: mult_tb.v
// Module: MULT_U_TB, MULT_TB
//
// Notes: - Testbench for multiplier
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "../prj_definition.v"

module MULT_U_TB;
// driver
reg [`DATA_INDEX_LIMIT:0] A;
reg [`DATA_INDEX_LIMIT:0] B;

// outputs to observe
wire [`DATA_INDEX_LIMIT:0] HI, LO;

// result registers
integer i;
reg [`DOUBLE_DATA_INDEX_LIMIT:0] result[0:4]; 

MULT32_U mult32_u_inst_0(.HI(HI), .LO(LO), .A(A), .B(B));

initial
begin
i=0;
A=10; B=20;     // Y = 10 * 20 = 200
#1 result[i] = {HI,LO}; i=i+1;
#1 A=3; B=15;  	// Y =  3 * 15 = 45
#1 result[i] = {HI,LO}; i=i+1;
#1 A=16; B=7;  	// Y = 16 *  7 = 112
#1 result[i] = {HI,LO}; i=i+1;
#1 A=10; B=19; 	// Y = 10 * 19 = 190
#1 result[i] = {HI,LO}; i=i+1;
#1 A=32'h00d96027; B=32'h7c32b43c; 	// Y = 0x0d96027 * 0x7c32b43c = 0x 006975a0 b62bf524
#1 result[i] = {HI,LO}; i=i+1;
#1 A=32'h70000000; B=32'h70000000; 
#1 result[i] = {HI,LO}; i=i+1;
#1 
$writememh("./OUTPUT/mult32_u_tb.out", result);
$stop;
end

endmodule

module MULT_TB;
// driver
reg [`DATA_INDEX_LIMIT:0] A;
reg [`DATA_INDEX_LIMIT:0] B;

// outputs to observe
wire [`DATA_INDEX_LIMIT:0] HI, LO;

// result registers
integer i;
reg [`DOUBLE_DATA_INDEX_LIMIT:0] result[0:7]; 

MULT32 mult32_inst_0(.HI(HI), .LO(LO), .A(A), .B(B));

initial
begin
i=0;
A=10; B=20;     	// Y = 10 * 20 = 200
#1 result[i] = {HI,LO}; i=i+1;
#1 A=-3; B=-15;  	// Y =  3 * 15 = 45
#1 result[i] = {HI,LO}; i=i+1;
#1 A=-16; B=7;  	// Y = 16 *  7 = -112
#1 result[i] = {HI,LO}; i=i+1;
#1 A=10; B=-19; 	// Y = 10 * 19 = -190
#1 result[i] = {HI,LO}; i=i+1;
#1 A=32'h70000000; B=32'h70000000; 
#1 result[i] = {HI,LO}; i=i+1;
#1 A=32'h90000000; B=32'h70000000; 
#1 result[i] = {HI,LO}; i=i+1;
#1 A=32'h70000000; B=32'h90000000; 
#1 result[i] = {HI,LO}; i=i+1;
#1 A=32'h90000000; B=32'h90000000; 
#1 result[i] = {HI,LO}; i=i+1;
#1 
$writememh("./OUTPUT/mult32_tb.out", result);
$stop;
end

endmodule
