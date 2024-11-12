// Name: data_path.v
// Module: DATA_PATH
// Output:  DATA : Data to be written at address ADDR
//          ADDR : Address of the memory location to be accessed
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - 32 bit processor implementing cs147sec05 instruction set
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module DATA_PATH(DATA_OUT, ADDR, ZERO, INSTRUCTION, DATA_IN, CTRL, CLK, RST);

// output list
output [`ADDRESS_INDEX_LIMIT:0] ADDR;
output ZERO;
output [`DATA_INDEX_LIMIT:0] DATA_OUT, INSTRUCTION;

// input list
input [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
input CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_IN;

wire pc_load, pc_sel_1, pc_sel_2, pc_sel_3,
    ir_load, reg_r, reg_w,
    r1_sel_1, wa_sel_1, wa_sel_2, wa_sel_3,

    sp_load, op1_sel_1,
    op2_sel_1, op2_sel_2, op2_sel_3, op2_sel_4,

    wd_sel_1, wd_sel_2, wd_sel_3,
    ma_sel_1, ma_sel_2,
    md_sel_1;

wire alu_oprn [5:0];

buf (pc_load, CTRL[0]);
buf (pc_sel_1, CTRL[1]);
buf (pc_sel_2, CTRL[2]);
buf (pc_sel_3, CTRL[3]);

buf (ir_load, CTRL[4]);
buf (reg_r, CTRL[5]);
buf (reg_w, CTRL[6]);

buf (r1_sel_1, CTRL[7]);
buf (wa_sel_1, CTRL[8]);
buf (wa_sel_2, CTRL[9]);
buf (wa_sel_3, CTRL[10]);

buf (sp_load, CTRL[11]);
buf (op1_sel_1, CTRL[12]);

buf (op2_sel_1, CTRL[13]);
buf (op2_sel_2, CTRL[14]);
buf (op2_sel_3, CTRL[15]);
buf (op2_sel_4, CTRL[16]);

buf (wd_sel_1, CTRL[17]);
buf (wd_sel_2, CTRL[18]);
buf (wd_sel_3, CTRL[19]);

buf (ma_sel_1, CTRL[20]);
buf (ma_sel_2, CTRL[21]);

buf (md_sel_1, CTRL[22]);

buf alu_oprn_buf [5:0] (alu_oprn, CTRL[28:23]);

// Parse the instruction data
wire [5:0]   opcode;
wire [4:0]   rs;
wire [4:0]   rt;
wire [4:0]   rd;
wire [4:0]   shamt;
wire [5:0]   funct;
wire [15:0]  imm;
wire [25:0]  addr;

// common for all
buf opcode_buf [5:0] (opcode, DATA_IN[31:26]);
// common for R-type, I-type
buf rs_buf [4:0] (rs, DATA_IN[25:21]);
buf rt_buf [4:0] (rt, DATA_IN[20:16]);
// for R-type
buf rd_buf [4:0] (rd, DATA_IN[15:11]);
buf shamt_buf [4:0] (shamt, DATA_IN[10:6]);
buf funct_buf [5:0] (funct, DATA_IN[5:0]);
// for I-type
buf imm_buf [15:0] (imm, DATA_IN[15:0]);
// for J-type
buf addr_buf [25:0] (addr, DATA_IN[25:0]);

endmodule
