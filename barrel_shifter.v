// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [31:0] S;
input LnR;

// check if upper bits are nonzero
wire oob [31:5];
buf (oob[5], S[5]);
genvar i;
generate
    for (i = 6; i < 32; i = i + 1) begin : shift_oob_gen
        or (oob[i], oob[i-1], S[i]);
    end
endgenerate

wire [31:0] shifted;
BARREL_SHIFTER32 shifter(shifted, D, S[4:0], LnR);

// return 0 if S >= 32
MUX32_2x1 mux_oob(Y, shifted, 32'b0, oob[31]);

endmodule

// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
input LnR;

wire [31:0] shifters [1:0];
SHIFT32_R shifter_r(shifters[0], D, S);
SHIFT32_L shifter_l(shifters[1], D, S);

MUX32_2x1 mux_lnr(Y, shifters[0], shifters[1], LnR);

endmodule

// Right shifter
module SHIFT32_R(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

wire [31:0] stages [5:0];
buf stage0[31:0] (stages[0], D);

genvar i, j;
generate
    for (i = 0; i < 5; i = i + 1) begin : shift_stage_gen
        for (j = 0; j < 32; j = j + 1) begin : stage_mux_gen
            if (j < 32 - (2 ** i))
                MUX1_2x1 mux_stage(stages[i+1][j], stages[i][j], stages[i][j + (2 ** i)], S[i]);
            else
                MUX1_2x1 mux_stage(stages[i+1][j], stages[i][j], 1'b0, S[i]);
        end
    end
endgenerate

buf out[31:0] (Y, stages[5]);

endmodule

// Left shifter
module SHIFT32_L(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;


wire [31:0] stages [5:0];
buf stage0[31:0] (stages[0], D);

genvar i, j;
generate
    for (i = 0; i < 5; i = i + 1) begin : shift_stage_gen
        for (j = 0; j < 32; j = j + 1) begin : stage_mux_gen
            if (j >= (2 ** i))
                MUX1_2x1 mux_stage(stages[i+1][j], stages[i][j], stages[i][j - (2 ** i)], S[i]);
            else
                MUX1_2x1 mux_stage(stages[i+1][j], stages[i][j], 1'b0, S[i]);
        end
    end
endgenerate

buf out[31:0] (Y, stages[5]);

endmodule
