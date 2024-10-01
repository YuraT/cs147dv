// Name: half_adder_tb.v
// Module: HALF_ADDER_TB
//
// Notes: - Testbench for half adder
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "../prj_definition.v"

module HALF_ADDER_TB;
reg A, B;
wire Y, C;

reg [`DATA_INDEX_LIMIT:0] results[0:3];

HALF_ADDER ha_inst(.Y(Y), .C(C), .A(A), .B(B));

initial
begin
A=1'b0; B=1'b0;
#1 results[0] = 32'h00000000 | {C,Y};

#1 A=1'b0; B=1'b1;
#1 results[1] = 32'h00000000 | {C,Y};

#1 A=1'b1; B=1'b0;
#1 results[2] = 32'h00000000 | {C,Y};

#1 A=1'b1; B=1'b1;
#1 results[3] = 32'h00000000 | {C,Y};

#5 
$writememh("./OUTPUT/half_adder.out",results,0,3);
$stop;
end

endmodule
