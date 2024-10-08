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

// TBD

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

// last partial is HI

// multiply A by a most significant digit in B
//wire [31:0] A_and;
//AND32_2x1 partial32_and(A_and, A, {32{B[31]}});

// calc HI
//RC_ADD_SUB_32 partial32_add(.Y(HI), .A(A_and), .B({CI[30],Y[30][31:1]}), .SnA(1'b0));

// put lowest bit from calc into result
//buf (LO[31], HI[0]);

// last partial is HI
BUF32_1x1 buf_hi(HI, {CI[31],Y[31][31:1]});

endmodule
