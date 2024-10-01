// Name: logic_32_bit_tb.v
// Module: NOR32_2x1_TB
//	   AND32_2x1_TB
//         INV32_1x1_TB
//	   OR32_2x1_TB
//
// Notes: - Testbench for shift module
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "../prj_definition.v"

module NOR32_2x1_TB;
//Driver 
reg [31:0] A, B;
// Obsrver
wire [31:0] Y;

// result
integer i;
reg [31:0] result [0:4];

NOR32_2x1 nor32_2x1_inst(.Y(Y), .A(A), .B(B));

initial
begin
i=0;
A=32'hFFFF0000; B=32'h0000FFFF; // Y = 32'h00000000
#1 result[i] = Y; i=i+1;
#1 A=32'h00000000; B=32'h00000000; // Y=32'hFFFFFFFF
#1 result[i] = Y; i=i+1;
#1 A=32'hA5A5A5A5; B=32'h5A5A5A5A; // Y = 32'h00000000
#1 result[i] = Y; i=i+1;
#1 A=32'hFFFF0000; B=32'hFFFF0000; // Y = 32'h0000FFFF
#1 result[i] = Y; i=i+1;
#1 A=32'h0000FFFF; B=32'h0000FFFF; // Y = 32'hFFFF0000
#1 result[i] = Y; i=i+1;
#1
$writememh("./OUTPUT/NOR32_2x1_TB.out",result);
$stop;
end

endmodule

module AND32_2x1_TB;
//Driver 
reg [31:0] A, B;
// Obsrver
wire [31:0] Y;

// result
integer i;
reg [31:0] result [0:4];

AND32_2x1 and32_2x1_inst(.Y(Y), .A(A), .B(B));

initial
begin
i=0;
A=32'hFFFF0000; B=32'h0000FFFF; // Y = 32'h00000000
#1 result[i] = Y; i=i+1;
#1 A=32'h00000000; B=32'h00000000; // Y=32'h00000000
#1 result[i] = Y; i=i+1;
#1 A=32'hA5A5A5A5; B=32'h5A5A5A5A; // Y = 32'h00000000
#1 result[i] = Y; i=i+1;
#1 A=32'hFFFF0000; B=32'hFFFF0000; // Y = 32'hFFFF0000
#1 result[i] = Y; i=i+1;
#1 A=32'h0000FFFF; B=32'h0000FFFF; // Y = 32'h0000FFFF
#1 result[i] = Y; i=i+1;
#1
$writememh("./OUTPUT/AND32_2x1_TB.out",result);
$stop;
end

endmodule

module INV32_1x1_TB;

//Driver 
reg [31:0] A;
// Obsrver
wire [31:0] Y;

// result
integer i;
reg [31:0] result [0:4];

INV32_1x1 inv32_1x1_inst(.Y(Y), .A(A));

initial
begin
i=0;
A=32'hFFFF0000; // Y = 32'h0000FFFF
#1 result[i] = Y; i=i+1;
#1 A=32'h00000000; // Y=32'hFFFFFFFF
#1 result[i] = Y; i=i+1;
#1 A=32'hA5A5A5A5;  // Y = 32'h5A5A5A5A
#1 result[i] = Y; i=i+1;
#1 A=32'hFFFF0000;  // Y = 32'h0000FFFF
#1 result[i] = Y; i=i+1;
#1 A=32'h0000FFFF;  // Y = 32'hFFFF0000
#1 result[i] = Y; i=i+1;
#1
$writememh("./OUTPUT/INV32_1x1_TB.out",result);
$stop;
end

endmodule

module OR32_2x1_TB;
//Driver 
reg [31:0] A, B;
// Obsrver
wire [31:0] Y;

// result
integer i;
reg [31:0] result [0:4];

OR32_2x1 or32_2x1_inst(.Y(Y), .A(A), .B(B));

initial
begin
i=0;
A=32'hFFFF0000; B=32'h0000FFFF; // Y = 32'hFFFFFFFF
#1 result[i] = Y; i=i+1;
#1 A=32'h00000000; B=32'h00000000; // Y=32'h00000000
#1 result[i] = Y; i=i+1;
#1 A=32'hA5A5A5A5; B=32'h5A5A5A5A; // Y = 32'hFFFFFFFF
#1 result[i] = Y; i=i+1;
#1 A=32'hFFFF0000; B=32'hFFFF0000; // Y = 32'hFFFF0000
#1 result[i] = Y; i=i+1;
#1 A=32'h0000FFFF; B=32'h0000FFFF; // Y = 32'h0000FFFF
#1 result[i] = Y; i=i+1;
#1
$writememh("./OUTPUT/OR32_2x1_TB.out",result);
$stop;
end

endmodule