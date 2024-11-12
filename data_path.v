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

// variables
wire [31:0] ir; // Instruction Register
wire [31:0] r1, r2; // Register File
wire [31:0] pc, pc_inc; // Program Counter
wire [31:0] sp; // Stack Pointer
wire [31:0] alu_out; // ALU output

// TODO: Why?
buf ir_buf [31:0] (INSTRUCTION, ir);

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
buf opcode_buf [5:0] (opcode, ir[31:26]);
// common for R-type, I-type
buf rs_buf [4:0] (rs, ir[25:21]);
buf rt_buf [4:0] (rt, ir[20:16]);
// for R-type
buf rd_buf [4:0] (rd, ir[15:11]);
buf shamt_buf [4:0] (shamt, ir[10:6]);
buf funct_buf [5:0] (funct, ir[5:0]);
// for I-type
buf imm_buf [15:0] (imm, ir[15:0]);
// for J-type
buf addr_buf [25:0] (addr, ir[25:0]);


// Instruction Register input
// Instruction Register
REG32 ir_inst(.Q(ir), .D(DATA_IN), .LOAD(ir_load), .CLK(CLK), .RESET(RST));

// Register File Input
wire [31:0] r1_sel, wa_sel, wd_sel;
wire [31:0] wa_sel_p1, wa_sel_p2, wd_sel_p1, wd_sel_p2;
wire [31:0] imm_zx_lsb;
buf imm_zx_lsb_buf [31:0] (imm_zx_lsb, {imm, 16'b0});
MUX32_2x1 mux_r1_sel(r1_sel, rs, 32'b0, r1_sel_1);
MUX32_2x1 mux_wa_sel_p1(wa_sel_p1, rd, rt, wa_sel_1);
// TODO: Why 31?
MUX32_2x1 mux_wa_sel_p2(wa_sel_p2, 32'b0, 31, wa_sel_2);
MUX32_2x1 mux_wa_sel(wa_sel, wa_sel_p2, wa_sel_p1, wa_sel_3);
MUX32_2x1 mux_wd_sel_p1(wd_sel_p1, alu_out,DATA_IN, wd_sel_1);
MUX32_2x1 mux_wd_sel_p2(wd_sel_p2, wd_sel_p1, imm_zx_lsb, wd_sel_2);
MUX32_2x1 mux_wd_sel(wd_sel, pc_inc, wd_sel_p2, wd_sel_3);
// Register File
REGISTER_FILE_32x32 rf_inst(.DATA_R1(r1), .DATA_R2(r2), .ADDR_R1(r1_sel), .ADDR_R2(rt),
                            .DATA_W(wd_sel), .ADDR_W(wa_sel), .READ(reg_r), .WRITE(reg_w), .CLK(CLK), .RST(RST));

// ALU Input
wire [31:0] op1_sel, op2_sel;
wire [31:0] op2_sel_p1, op2_sel_p2, op2_sel_p3;
wire [31:0] shamt_zx, imm_sx, imm_zx;
buf shamt_zx_buf [31:0] (shamt_zx, {27'b0, shamt});
buf imm_sx_buf [31:0] (imm_sx, {{16{imm[15]}}, imm});
buf imm_zx_buf [31:0] (imm_zx, {16'b0, imm});
MUX32_2x1 mux_op1_sel(op1_sel, r1, sp, op1_sel_1);
MUX32_2x1 mux_op2_sel_p1(op2_sel_p1, 31'b1, shamt_zx, op2_sel_1);
MUX32_2x1 mux_op2_sel_p2(op2_sel_p2, imm_zx, imm_sx, op2_sel_2);
MUX32_2x1 mux_op2_sel_p3(op2_sel_p3, op2_sel_p2, op2_sel_p1, op2_sel_3);
MUX32_2x1 mux_op2_sel(op2_sel, op2_sel_p3, r2, op2_sel_4);
// ALU
ALU alu_inst(.Y(alu_out), .ZERO(ZERO), .OP1(op1_sel), .OP2(op2_sel), .OPRN(alu_oprn));

// Progam Counter Input
wire [31:0] pc_sel;
wire [31:0] pc_offset, pc_jump, pc_sel_p1, pc_sel_p2;
RC_ADD_SUB_32 pc_inc_inst(.Y(pc_inc), .A(pc), .B(32'b1), .SnA(1'b0));
MUX32_2x1 mux_pc_sel_p1(pc_sel_p1, r1, pc_inc, pc_sel_1);
RC_ADD_SUB_32 pc_sel_2_inst(.Y(pc_offset), .A(pc), .B(imm_sx), .SnA(1'b0));
MUX32_2x1 mux_pc_sel_p2(pc_sel_p2, pc_sel_p1, pc_offset, pc_sel_2);
buf pc_jump_buf [31:0] (pc_jump, {6'b0, addr});
MUX32_2x1 mux_pc_sel(pc_sel, pc_jump, pc_sel_p2, pc_sel_3);
// Program Counter
defparam pc_inst.PATTERN = `INST_START_ADDR;
REG32_PP pc_inst(.Q(pc), .D(pc_sel), .LOAD(pc_load), .CLK(CLK), .RESET(RST));

// Stack Pointer
defparam sp_inst.PATTERN = `INIT_STACK_POINTER;
REG32_PP sp_inst(.Q(sp), .D(alu_out), .LOAD(sp_load), .CLK(CLK), .RESET(RST));

// Data out
MUX32_2x1 mux_data_out(DATA_OUT, r2, r1, md_sel_1);

// Address out
wire [31:0] ma_sel_p1;
MUX32_2x1 mux_ma_sel_p1(ma_sel_p1, alu_out, sp, ma_sel_1);
// TODO: Check address calculation since it's 26 bit
MUX32_2x1 mux_ma_sel(ADDR, ma_sel_p1, pc, ma_sel_2);

endmodule
