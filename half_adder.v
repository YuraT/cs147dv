// Name: half_adder.v
// Module: HALF_ADDER
//
// Output: Y : Sum
//         C : Carry
//
// Input: A : Bit 1
//        B : Bit 2
//
// Notes: 1-bit half adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module HALF_ADDER(Y,C,A,B);
output Y,C;
input A,B;

// this
assign Y = A ^ B;
assign C = A & B;

// or this
//xor digit(Y, A, B);
//and carry(C, A, B);

endmodule
