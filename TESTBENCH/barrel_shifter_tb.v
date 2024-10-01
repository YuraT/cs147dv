// Name: barrel_shifter_tb.v
// Module: BARREL_SHIFTER32_TB
//
// Notes: - Testbench for shift module
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "../prj_definition.v"

module BARREL_SHIFTER32_TB;
reg [31:0] D;
reg [31:0] S;
reg LnR;
wire [31:0] Y;

integer reg_idx;
reg [`DATA_INDEX_LIMIT:0] result[0:63];

integer i, e;
integer no_of_test=0;
integer no_of_pass=0;

SHIFT32 shift_inst(.Y(Y), .D(D), .S(S), .LnR(LnR));

initial
begin
reg_idx=0;
D=32'ha5a5a5a5;
S=32'h00000000;
LnR=1'b1; // left shift

for(i=1; i<33; i=i+1)
begin
#5 
no_of_test = no_of_test + 1;
S=i; 
e = D << S; 
#5
if (e !== Y)
begin
   $write("[TEST %2d] (%8x << %8x) = %8x, got %8x ... FAILED\n", no_of_test, D, S, e, Y);
end
else
  no_of_pass = no_of_pass + 1;
result[reg_idx] = Y; reg_idx=reg_idx+1;
end 

#5 LnR=1'b0; // right shift

for(i=1; i<33; i=i+1)
begin
#5 
no_of_test = no_of_test + 1;
S=i; 
e = D >> S; 
#5
if (e !== Y)
begin
   $write("[TEST %2d] (%8x >> %8x) = %8x, got %8x ... FAILED\n", no_of_test, D, S, e, Y);
end
else
  no_of_pass = no_of_pass + 1;
result[reg_idx] = Y; reg_idx=reg_idx+1;
end 

$write("\n");
$write("\tTotal number of tests %d\n", no_of_test);
$write("\tTotal number of pass  %d\n", no_of_pass);
$write("\n");

$writememh("./OUTPUT/barret_shifter_tb.out",result);

$stop;
end

endmodule
