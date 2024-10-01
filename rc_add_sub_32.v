// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module RC_ADD_SUB_64(Y, CO, A, B, SnA);
// output list
output [63:0] Y;
output CO;
// input list
input [63:0] A;
input [63:0] B;
input SnA;

// carry-in bits for each 1-bit full adder
wire C[0:64];
buf (C[0], SnA);

genvar i;
generate
    for (i = 0; i < 64; i = i + 1)
    begin : add64_gen_loop
        wire B_xor;
        xor (B_xor, B[i], SnA);
        FULL_ADDER add64_inst(Y[i], C[i+1], A[i], B_xor, C[i]);
    end
endgenerate

buf (CO, C[64]);

endmodule

module RC_ADD_SUB_32(Y, CO, A, B, SnA);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
output CO;
// input list
input [`DATA_INDEX_LIMIT:0] A;
input [`DATA_INDEX_LIMIT:0] B;
input SnA;

// carry-in bits for each 1-bit full adder
wire C[0:32];
buf (C[0], SnA);

genvar i;
generate
    for (i = 0; i < 32; i = i + 1)
    begin : add32_gen_loop
        wire B_xor;
        xor (B_xor, B[i], SnA);
        FULL_ADDER add32_inst(Y[i], C[i+1], A[i], B_xor, C[i]);
    end
endgenerate

buf (CO, C[32]);

endmodule
