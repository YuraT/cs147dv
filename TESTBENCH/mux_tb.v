// Name: mux32_tb.v
// Module: MUX32_2x1_TB
//         MUX32_16x1_TB
//         MUX32_32x1_TB
//
// Notes: - Testbench for different multiplexer
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "../prj_definition.v"

module MUX32_32x1_TB;

reg [31:0] I [0:31];
reg [4:0]  S;
wire [31:0] Y;

integer i;
reg [31:0] result [0:31];

MUX32_32x1 mux_inst_01(.Y(Y), 
                       .I0(I[0]),   .I1(I[1]),   .I2(I[2]),   .I3(I[3]),
		       .I4(I[4]),   .I5(I[5]),   .I6(I[6]),   .I7(I[7]),
		       .I8(I[8]),   .I9(I[9]),   .I10(I[10]), .I11(I[11]),
		       .I12(I[12]), .I13(I[13]), .I14(I[14]), .I15(I[15]),
                       .I16(I[16]), .I17(I[17]), .I18(I[18]), .I19(I[19]),
                       .I20(I[20]), .I21(I[21]), .I22(I[22]), .I23(I[23]),
                       .I24(I[24]), .I25(I[25]), .I26(I[26]), .I27(I[27]),
                       .I28(I[28]), .I29(I[29]), .I30(I[30]), .I31(I[31]),
                       .S(S));

initial
begin
for(i=0;i<32;i=i+1)
	I[i]=i;

for(i=0;i<32;i=i+1)
begin
#1    S = i; 
#1    result[i]=Y;
end

#1
$writememh("./OUTPUT/mux32_32x1_tb.out", result);
$stop;
end

endmodule

module MUX32_16x1_TB;

reg [31:0] I [0:15];
reg [3:0]  S;
wire [31:0] Y;

integer i;
reg [31:0] result [0:15];

MUX32_16x1 mux_inst_01(.Y(Y), 
                       .I0(I[0]),   .I1(I[1]),   .I2(I[2]),   .I3(I[3]),
		       .I4(I[4]),   .I5(I[5]),   .I6(I[6]),   .I7(I[7]),
		       .I8(I[8]),   .I9(I[9]),   .I10(I[10]), .I11(I[11]),
		       .I12(I[12]), .I13(I[13]), .I14(I[14]), .I15(I[15]),
                       .S(S));

initial
begin
for(i=0;i<16;i=i+1)
	I[i]=i;

for(i=0;i<16;i=i+1)
begin
#1    S = i; 
#1    result[i]=Y;
end

#1
$writememh("./OUTPUT/mux32_16x1_tb.out", result);
$stop;
end

endmodule

module MUX32_2x1_TB;

reg [31:0] I0, I1;
reg S;
wire [31:0] Y;

reg [31:0] result [0:1];

MUX32_2x1 mux_inst_01(.Y(Y), .I0(I0), .I1(I1), .S(S));

initial
begin
I0 = 32'hA5A5A5A5; I1 = 32'h5A5A5A5A; S=1'b0;
#1 result[0] = Y;
#1 S=1'b1;
#1 result[1] = Y;
#1
$writememh("./OUTPUT/mux32_2x1_tb.out", result);
$stop;
end

endmodule
