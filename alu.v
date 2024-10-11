// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
// Output: OUT[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
// input list
input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

// output list
output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
output ZERO;

wire [31:0] res,
            res_addsub, res_slt,
            res_shift,
            res_mul,
            res_and, res_or, res_nor;

// add = xx0001
// sub = xx0010
// slt = xx1001
//         ^ ^ these bits
// can use oprn[1] or oprn[3] for SnA
wire SnA;
or (SnA, OPRN[1], OPRN[3]);
RC_ADD_SUB_32 addsub(.Y(res_addsub), .A(OP1), .B(OP2), .SnA(SnA));
buf slt [31:0] (res_slt, {31'b0,res_addsub[31]});

// shift_r = xx0100
// shift_l = xx0101
//                ^ this bit
// can use oprn[0] for LnR
SHIFT32 shift(res_shift, OP1, OP2, OPRN[0]);

// mul = xx0011
MULT32 mul(.LO(res_mul), .A(OP1), .B(OP2));

// and = xx0110
// or  = xx0111
// nor = xx1000
AND32_2x1 and32(res_and, OP1, OP2);
OR32_2x1 or32(res_or, OP1, OP2);
NOR32_2x1 nor32(res_nor, OP1, OP2);

MUX32_16x1 out(.Y(res), .S(OPRN[3:0]),
               .I1(res_addsub), .I2(res_addsub), .I3(res_mul),
               .I4(res_shift),.I5(res_shift),
               .I6(res_and), .I7(res_or), .I8(res_nor),
               .I9(res_slt)
);

// or bits of result for zero flag
wire nzf [31:0];
buf (nzf[0], res[0]);
genvar i;
generate
    for (i = 1; i < 32; i = i + 1) begin : zf_gen
        or (nzf[i], nzf[i-1], res[i]);
    end
endgenerate

not (ZERO, nzf[31]);
buf res_out [31:0] (OUT, res);

endmodule
