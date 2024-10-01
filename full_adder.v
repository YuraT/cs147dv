// Name: full_adder.v
// Module: FULL_ADDER
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module FULL_ADDER(S,CO,A,B, CI);
output S,CO;
input A,B, CI;

// half adder 1
//assign Y = A ^ B;
//assign CO1 = A & B;

// half adder 2
//assign S = Y ^ CI;
//assign CO2 = Y & CI;

//assign CO = CO1 | CO2;

wire Y, CO1, CO2;
HALF_ADDER ha1(.Y(Y), .C(CO1), .A(A), .B(B));
HALF_ADDER ha2(.Y(S), .C(CO2), .A(Y), .B(CI));
assign CO = CO1 | CO2;

endmodule
