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

// TBD

endmodule

module RC_ADD_SUB_32(Y, CO, A, B, SnA);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
output CO;
// input list
input [`DATA_INDEX_LIMIT:0] A;
input [`DATA_INDEX_LIMIT:0] B;
input SnA;

//wire C0, C1, C2, C3;
//assign C0 = SnA;
//FULL_ADDER b0(Y[0], C1, A[0], B[0], C0);

// module FULL_ADDER(S,CO,A,B, CI);

// carry-in bits for each 1 bit full adder
wire C[0:32];
assign C[0] = SnA;

genvar i;
generate
    for (i = 0; i < 32; i = i + 1)
    begin : add32_gen_loop
        FULL_ADDER add_inst(Y[i], C[i+1], A[i], B[i] ^ SnA, C[i]);
    end
endgenerate

assign CO = C[32];

endmodule
