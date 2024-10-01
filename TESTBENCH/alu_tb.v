// Name: alu_tb.v
// Module: ALU_TB
//
// Notes: - Testbench for ALU
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "../prj_definition.v"

module ALU_TB;
// reg list
reg [`DATA_INDEX_LIMIT:0] OP1; // operand 1
reg [`DATA_INDEX_LIMIT:0] OP2; // operand 2
reg [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

// output list
wire [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
wire ZERO;

// results
integer ridx;
reg [`DATA_INDEX_LIMIT:0] result[199:0];

// Testcases
integer oprnd_idx, oprn_idx;
integer NumSet01[0:7];
integer NumSet02[0:7];
integer OpCode[0:8];

ALU	alu_inst(.OUT(OUT), .ZERO(ZERO), .OP1(OP1), .OP2(OP2), .OPRN(OPRN));

initial
begin
// Initialize number sets
NumSet01[0] = 10;  NumSet01[1] = -15; NumSet01[2] =  25; NumSet01[3] = -30; NumSet01[4] = 0; NumSet01[5] = -15; NumSet01[6] = 23; NumSet01[7] =  0;
NumSet02[0] = 10;  NumSet02[1] =  15; NumSet02[2] = -25; NumSet02[3] = -30; NumSet02[4] = 0; NumSet02[5] =  42; NumSet02[6] =  0; NumSet02[7] = 70;
ridx = 0;

// Set of operation
OpCode[0] = 1; // add 
OpCode[1] = 2; // sub 
OpCode[2] = 3; // mult
OpCode[3] = 4; // shiftR
OpCode[4] = 5; // shiftL
OpCode[5] = 6; // and
OpCode[6] = 7; // or
OpCode[7] = 8; // nor
OpCode[8] = 9; // slt

// Loop through operands and operation
for(oprnd_idx=0; oprnd_idx<8; oprnd_idx=oprnd_idx+1)
begin
    for(oprn_idx=0; oprn_idx<9; oprn_idx=oprn_idx+1)
    begin
        #1 OP1=NumSet01[oprnd_idx]; OP2=NumSet02[oprnd_idx]; OPRN=OpCode[oprn_idx];
        #1 
           $write("===> %0d ",$signed(OP1));
           case(OPRN)
               1: $write("+");
               2: $write("-");
               3: $write("*");
               4: $write(">>");
               5: $write("<<");
               6: $write("&");
               7: $write("|");
               8: $write("|~");
               9: $write("slt");
           endcase
           $write(" %0d = %0d [%d]\n", $signed(OP2), $signed(OUT), ZERO);
	   result[ridx] = OUT; ridx = ridx + 1;
           result[ridx] = ZERO; ridx = ridx + 1;
    end
end

#1
$writememh("./OUTPUT/alu_tb.out", result, 0, (ridx-1));
$stop;

end

endmodule
