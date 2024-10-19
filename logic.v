// Name: logic.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
// 64-bit two's complement
module TWOSCOMP64(Y,A);
//output list
output [63:0] Y;
//input list
input [63:0] A;

RC_ADD_SUB_64 twoscomp64_sub(.Y(Y), .A(64'b0), .B(A), .SnA(1'b1));

endmodule

// 32-bit two's complement
module TWOSCOMP32(Y,A);
//output list
output [31:0] Y;
//input list
input [31:0] A;

RC_ADD_SUB_32 twoscomp32_sub(.Y(Y), .A(0), .B(A), .SnA(1'b1));

endmodule

// 32-bit registere +ve edge, Reset on RESET=0
module REG32(Q, D, LOAD, CLK, RESET);
output [31:0] Q;

input CLK, LOAD;
input [31:0] D;
input RESET;

genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : reg_gen
        REG1 r(Q[i], _, D[i], LOAD, CLK, 1'b1, RESET);
    end
endgenerate

endmodule

// 1 bit register +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module REG1(Q, Qbar, D, L, C, nP, nR);
input D, C, L;
input nP, nR;
output Q,Qbar;

wire D_out;
MUX1_2x1 data(D_out, Q, D, L);

D_FF dff(Q, Qbar, D_out, C, nP, nR);

endmodule

// 1 bit flipflop +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_FF(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

wire Cbar, Y, Ybar;
not C_inv(Cbar, C);
D_LATCH dlatch(Y, Ybar, D, Cbar, nP, nR);

SR_LATCH srlatch(Q, Qbar, Y, Ybar, C, nP, nR);

endmodule

// 1 bit D latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_LATCH(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

wire Dbar;
not D_inv(Dbar, D);

SR_LATCH latch(Q, Qbar, D, Dbar, C, nP, nR);

endmodule

// 1 bit SR latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module SR_LATCH(Q,Qbar, S, R, C, nP, nR);
input S, R, C;
input nP, nR;
output Q,Qbar;

wire r1, r2;

nand n1(r1, C, S);
nand n2(r2, C, R);

nand n3(Q, nP, r1, Qbar);
nand n4(Qbar, nR, r2, Q);

endmodule

// 5x32 Line decoder
module DECODER_5x32(D,I);
// output
output [31:0] D;
// input
input [4:0] I;

wire [15:0] half;
wire I_not;
not I_inv(I_not, I[4]);

DECODER_4x16 d(half, I[3:0]);

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : d5_gen
        and msb0(D[i], I_not, half[i]);
        and msb1(D[i + 16], I[4], half[i]);
    end
endgenerate

endmodule

// 4x16 Line decoder
module DECODER_4x16(D,I);
// output
output [15:0] D;
// input
input [3:0] I;

wire [7:0] half;
wire I_not;
not I_inv(I_not, I[3]);

DECODER_3x8 d(half, I[2:0]);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : d4_gen
        and msb0(D[i], I_not, half[i]);
        and msb1(D[i + 8], I[3], half[i]);
    end
endgenerate


endmodule

// 3x8 Line decoder
module DECODER_3x8(D,I);
// output
output [7:0] D;
// input
input [2:0] I;

wire [3:0] half;
wire I_not;
not I_inv(I_not, I[2]);

DECODER_2x4 d(half, I[1:0]);

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : d3_gen
        and msb0(D[i], I_not, half[i]);
        and msb1(D[i + 4], I[2], half[i]);
    end
endgenerate

endmodule

// 2x4 Line decoder
module DECODER_2x4(D,I);
// output
output [3:0] D;
// input
input [1:0] I;

wire I_not [1:0];
not I_inv[1:0] (I_not, I);

and (D[0], I_not[1], I_not[0]);
and (D[1], I_not[1], I[0]);
and (D[2], I[1], I_not[0]);
and (D[3], I[1], I[0]);

endmodule
