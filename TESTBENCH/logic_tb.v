// Name: logic_tb.v
// Module: TWOSCOMP32_TB, 
//	   TWOSCOMP64_TB,
//	   SR_LATCH_TB,
//	   D_LATCH_TB,
//         D_FF_PE_TB,
//         REG1_TB,
//         REG32_TB,
//         DECODER_5x32_TB
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

module DECODER_5x32_TB;
// observer
wire [31:0] D;
// driver
reg [4:0] I;

// result
integer i, idx;
reg [31:0] result[0:31];

DECODER_5x32    decoder_5x32_inst0(.D(D),.I(I));

initial
begin
i=0;

for(idx=0; idx<32; idx = idx + 1)
begin
#1 I=idx;
#1 result[i] = D; i=i+1;
end

#1
$writememb("./OUTPUT/decoder_5x32_tb.out",result);
$stop;

end

endmodule

module REG32_TB;
//driver
reg [`DATA_INDEX_LIMIT:0] D; 
reg LOAD, RESET;
// oberver
wire [`DATA_INDEX_LIMIT:0] Q;
// clock
wire clk;

// Result
integer i;
reg [`DATA_INDEX_LIMIT:0] result[0:7];

CLK_GENERATOR clk_gen_inst(.CLK(clk));
REG32 reg32_inst(.Q(Q), .CLK(clk), .LOAD(LOAD), .D(D), .RESET(RESET));

initial
begin
i=0; RESET=1; D=32'ha5a5a5a5; LOAD=0;
// Reset
#1  D=32'ha5a5a5a5; LOAD=0; RESET=0;
#1  result[i] = Q; i=i+1;
// Hold
#1  D=32'ha5a5a5a5; LOAD=0; RESET=1;
#1  result[i] = Q; i=i+1;
// Normal operation
#6 D=32'ha5a5a5a5; LOAD=1; RESET=1;
#5 result[i] = Q; i=i+1;
#5 D=32'hffff0000; LOAD=1; RESET=1;
#5 result[i] = Q; i=i+1;
// Reset
#1 D=32'h0000ffff; LOAD=1; RESET=0;
#1 result[i] = Q; i=i+1;
// Normal operation
#9 D=32'h0000ffff; LOAD=1; RESET=1;
#1 result[i] = Q; i=i+1;
#10 result[i] = Q; i=i+1;
#10 D=32'h5a5a5a5a; LOAD=0; RESET=1;

#10
result[i] = Q; i=i+1;
$writememh("./OUTPUT/d_reg32_tb.out",result);
$stop;
end

endmodule

module REG1_TB;
//driver
reg D, L, nP, nR;
// oberver
wire Q,Qbar;
// clock
wire clk;

// Result
integer i;
reg [`DATA_INDEX_LIMIT:0] result[0:6];

CLK_GENERATOR clk_gen_inst(.CLK(clk));
REG1 reg1_inst(.Q(Q), .Qbar(Qbar), .C(clk), 
                  .L(L), .D(D), .nP(nP), .nR(nR));
initial
begin
i=0; nP=1; nR=1; D=0; L=0;
// Preset
#1  D=0; L=0; nP=0; nR=1;
#1  result[i] = {Q,Qbar,D,L,nR,nP}; i=i+1;
// Hold
#1  D=0; L=0; nP=1; nR=1;
#1  result[i] = {Q,Qbar,D,L,nR,nP}; i=i+1;
// Normal operation
#6 D=0; L=1; nP=1; nR=1;
#5 result[i] = {Q,Qbar,D,nR,nP}; i=i+1;
#5 D=1; L=1; nP=1; nR=1;
#5 result[i] = {Q,Qbar,D,L,nR,nP}; i=i+1;
// Reset
#1 D=1; L=1; nP=1; nR=0;
#1 result[i] = {Q,Qbar,D,L,nR,nP}; i=i+1;
// Normal operation
#9 D=1; L=1; nP=1; nR=1;
#1 result[i] = {Q,Qbar,D,L,nR,nP}; i=i+1;
#10 D=0; L=0; nP=1; nR=1;

#10
result[i] = {Q,Qbar,D,L,nR,nP}; i=i+1;
$writememh("./OUTPUT/d_reg1_tb.out",result);
$stop;
end

endmodule

module D_FF_TB;
//driver
reg D, nP, nR;
// oberver
wire Q,Qbar;
// clock
wire clk;

// Result
integer i;
reg [`DATA_INDEX_LIMIT:0] result[0:6];

CLK_GENERATOR clk_gen_inst(.CLK(clk));
D_FF d_ff_inst(.Q(Q), .Qbar(Qbar), .C(clk), 
                  .D(D), .nP(nP), .nR(nR));
initial
begin
i=0; nP=1; nR=1; D=0;
// Preset
#1  D=0; nP=0; nR=1;
#1  result[i] = {Q,Qbar,D,nR,nP}; i=i+1;
// Hold
#1  D=0; nP=1; nR=1;
#1  result[i] = {Q,Qbar,D,nR,nP}; i=i+1;
// Normal operation
#6 D=0; nP=1; nR=1;
#5 result[i] = {Q,Qbar,D,nR,nP}; i=i+1;
#5 D=1; nP=1; nR=1;
#5 result[i] = {Q,Qbar,D,nR,nP}; i=i+1;
// Reset
#1 D=1; nP=1; nR=0;
#1 result[i] = {Q,Qbar,D,nR,nP}; i=i+1;
// Normal operation
#9 D=1; nP=1; nR=1;
#1 result[i] = {Q,Qbar,D,nR,nP}; i=i+1;

#10
result[i] = {Q,Qbar,D,nR,nP}; i=i+1;
$writememh("./OUTPUT/d_ff_tb.out",result);
$stop;
end

endmodule

module D_LATCH_TB;
// driver
reg D, C, nP, nR;
// oberver
wire Q,Qbar;

// Result
integer i;
reg [`DATA_INDEX_LIMIT:0] result[0:7];

D_LATCH    d_latch_inst(.Q(Q), .Qbar(Qbar), .D(D), 
                        .C(C), .nP(nP), .nR(nR));

initial
begin
i=0;
// Normal preset
#1 C=0; D=0; nR=1; nP=0; // Q=1
#1 result[i] = {Q,Qbar,C,D,nR,nP}; i=i+1;
// Hold 1 on C=0
#1 C=0; D=0; nR=1; nP=1; // Q=1
#1 result[i] = {Q,Qbar,C,D,nR,nP}; i=i+1;
#1 C=0; D=1; nR=1; nP=1; // Q=1
#1 result[i] = {Q,Qbar,C,D,nR,nP}; i=i+1;
// Normal reset
#1 C=0; D=0; nR=0; nP=1; // Q=0
#1 result[i] = {Q,Qbar,C,D,nR,nP}; i=i+1;
// Hold 0 on C=0
#1 C=0; D=0; nR=1; nP=1; // Q=0
#1 result[i] = {Q,Qbar,C,D,nR,nP}; i=i+1;
#1 C=0; D=1; nR=1; nP=1; // Q=0
#1 result[i] = {Q,Qbar,C,D,nR,nP}; i=i+1;
// Set on clock 
#1 C=1; D=1; nR=1; nP=1; // Q=1
#1 result[i] = {Q,Qbar,C,D,nR,nP}; i=i+1;
// Reset on clock
#1 C=1; D=0; nR=1; nP=1; // Q=0
#1 result[i] = {Q,Qbar,C,D,nR,nP}; i=i+1;

#1
$writememh("./OUTPUT/d_latch_tb.out",result);
$stop;
end

endmodule

module SR_LATCH_TB;
// driver
reg S, R, C, nP, nR;
// oberver
wire Q,Qbar;

// Result
integer i;
reg [`DATA_INDEX_LIMIT:0] result[0:13];

SR_LATCH    sr_latch_inst(.Q(Q), .Qbar(Qbar), .S(S), 
                          .R(R), .C(C), .nP(nP), .nR(nR));

initial
begin
i=0;
// Normal reset preset
#1 C=0; S=0; R=0; nR=1; nP=0; // Q=1
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;
// Hold 1 on C=0
#1 C=0; S=0; R=0; nR=1; nP=1; // Q=1
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;
#1 C=0; S=0; R=1; nR=1; nP=1; // Q=1
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;
#1 C=0; S=1; R=0; nR=1; nP=1; // Q=1
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;
#1 C=0; S=1; R=1; nR=1; nP=1; // Q=1
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;
// Normal reset
#1 C=0; S=0; R=0; nR=0; nP=1; // Q=0
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;
// Hold 0 on C=0
#1 C=0; S=0; R=0; nR=1; nP=1; // Q=0
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;
#1 C=0; S=0; R=1; nR=1; nP=1; // Q=0
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;
#1 C=0; S=1; R=0; nR=1; nP=1; // Q=0
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;
#1 C=0; S=1; R=1; nR=1; nP=1; // Q=0
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;
// Set on clock 
#1 C=1; S=1; R=0; nR=1; nP=1; // Q=1
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;
// Hold
#1 C=1; S=0; R=0; nR=1; nP=1; // Q=1
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;
// Reset on clock
#1 C=1; S=0; R=1; nR=1; nP=1; // Q=0
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;
// Hold
#1 C=1; S=0; R=0; nR=1; nP=1; // Q=0
#1 result[i] = {Q,Qbar,C,S,R,nR,nP}; i=i+1;

#1
$writememh("./OUTPUT/sr_latch_tb.out",result);
$stop;
end

endmodule

module TWOSCOMP32_TB;
// driver
reg [`DATA_INDEX_LIMIT:0] A;
// wire 
wire [`DATA_INDEX_LIMIT:0] Y;

// result
integer i;
reg [`DATA_INDEX_LIMIT:0] result[0:1];

TWOSCOMP32 inst_2scomp_01(.Y(Y), .A(A));

initial
begin
i=0;
A = 10;
#1 result[i] = Y; i = i + 1;
#1 A=-5;
#1 result[i] = Y; i = i + 1;
#1
$writememh("./OUTPUT/twoscomp32_tb.out",result);
$stop;
end

endmodule

module TWOSCOMP64_TB;
// driver
reg [`DOUBLE_DATA_INDEX_LIMIT:0] A;
// wire 
wire [`DOUBLE_DATA_INDEX_LIMIT:0] Y;

// result
integer i;
reg [`DOUBLE_DATA_INDEX_LIMIT:0] result[0:1];

TWOSCOMP64 inst_2scomp_01(.Y(Y), .A(A));

initial
begin
i=0;
A = 10;
#1 result[i] = Y; i = i + 1;
#1 A=-5;
#1 result[i] = Y; i = i + 1;
#1
$writememh("./OUTPUT/twoscomp64_tb.out",result);
$stop;
end

endmodule