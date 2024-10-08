// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;

wire [31:0] A_neg, B_neg;
TWOSCOMP32 A_twoscomp(A_neg, A);
TWOSCOMP32 B_twoscomp(B_neg, B);

wire [31:0] A_abs, B_abs;
MUX32_2x1 A_mux(A_abs, A, A_neg, A[31]);
MUX32_2x1 B_mux(B_abs, B, B_neg, B[31]);

wire [31:0] HI_abs, LO_abs;
MULT32_U mult_abs(HI_abs, LO_abs, A_abs, B_abs);

wire [31:0] HI_neg, LO_neg;
TWOSCOMP64 mult_neg({HI_neg,LO_neg}, {HI_abs,LO_abs});

wire sign;
xor (sign, A[31], B[31]);

MUX32_2x1 HI_mux(HI, HI_abs, HI_neg, sign);
MUX32_2x1 LO_mux(LO, LO_abs, LO_neg, sign);

endmodule

module MULT32_U(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;

// partial sums
wire [31:0] Y [31:0];

// first partial is just
AND32_2x1 partial_1(Y[0], A, {32{B[0]}});
// put lowest bit from first partial into result
buf (LO[0], Y[0][0]);


// carries from partial adders
wire CI[31:0];
// first carry is always 0
buf (CI[0], 0);

genvar i;
generate
    for (i = 0; i < 31; i = i + 1)
    begin : mult32u_gen_loop
        // multiply A by a single digit in B
        wire [31:0] A_and;
        AND32_2x1 partial_and_inst(A_and, A, {32{B[i+1]}});

        // calc the next partial and carry (i + 1)
        RC_ADD_SUB_32 partial_add_inst(.Y(Y[i+1]), .CO(CI[i+1]), .A(A_and), .B({CI[i],Y[i][31:1]}), .SnA(1'b0));

        // put lowest bit from calc into result
        buf (LO[i+1], Y[i+1][0]);
    end
endgenerate

// last carry and partial is HI
BUF32_1x1 buf_hi(HI, {CI[31],Y[31][31:1]});

endmodule
