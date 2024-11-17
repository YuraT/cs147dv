// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: CTRL  : Control signal for data path
//         READ  : Memory read signal
//         WRITE : Memory Write signal
//
// Input:  ZERO : Zero status from ALU
//         CLK  : Clock signal
//         RST  : Reset Signal
//
// Notes: - Control unit synchronize operations of a processor
//          Assign each bit of control signal to control one part of data path
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// Control signals, same as in data_path.v
`define pc_load   0
`define pc_sel_1  1
`define pc_sel_2  2
`define pc_sel_3  3

`define ir_load   4

`define r1_sel_1  5
`define reg_r     6
`define reg_w     7

`define sp_load   8

`define op1_sel_1 9
`define op2_sel_1 10
`define op2_sel_2 11
`define op2_sel_3 12
`define op2_sel_4 13

`define alu_oprn  19:14

`define ma_sel_1  20
`define ma_sel_2  21

`define md_sel_1  22

`define wd_sel_1  23
`define wd_sel_2  24
`define wd_sel_3  25

`define wa_sel_1  26
`define wa_sel_2  27
`define wa_sel_3  28

// ALU operation codes
`define ALU_NOP 6'h00
`define ALU_ADD 6'h01
`define ALU_SUB 6'h02
`define ALU_MUL 6'h03
`define ALU_SRL 6'h04
`define ALU_SLL 6'h05
`define ALU_AND 6'h06
`define ALU_OR  6'h07
`define ALU_NOR 6'h08
`define ALU_SLT 6'h09

// Instruction opcodes
// R-type
`define OP_RTYPE 6'h00
`define FN_ADD   6'h20
`define FN_SUB   6'h22
`define FN_MUL   6'h2c
`define FN_AND   6'h24
`define FN_OR    6'h25
`define FN_NOR   6'h27
`define FN_SLT   6'h2a
`define FN_SLL   6'h01
`define FN_SRL   6'h02
`define FN_JR    6'h08
// I-type
`define OP_ADDI 6'h08
`define OP_MULI 6'h1d
`define OP_ANDI 6'h0c
`define OP_ORI  6'h0d
`define OP_LUI  6'h0f
`define OP_SLTI 6'h0a
`define OP_BEQ  6'h04
`define OP_BNE  6'h05
`define OP_LW   6'h23
`define OP_SW   6'h2b
// J-type
`define OP_JMP  6'h02
`define OP_JAL  6'h03
`define OP_PUSH 6'h1b
`define OP_POP  6'h1c

module CONTROL_UNIT(CTRL, READ, WRITE, ZERO, INSTRUCTION, CLK, RST);
// Output signals
output [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
output READ, WRITE;

// input signals
input ZERO, CLK, RST;
input [`DATA_INDEX_LIMIT:0] INSTRUCTION;

task print_instruction;
input  [`DATA_INDEX_LIMIT:0] inst;
reg [5:0]   opcode2;
reg [4:0]   rs2;
reg [4:0]   rt2;
reg [4:0]   rd2;
reg [4:0]   shamt2;
reg [5:0]   funct2;
reg [15:0]  immediate2;
reg [25:0]  address2;
begin
// parse the instruction
// R-type
{opcode2, rs2, rt2, rd2, shamt2, funct2} = inst;
// I-type
{opcode2, rs2, rt2, immediate2 } = inst;
// J-type
{opcode2, address2} = inst;

$write("@ %6dns -> [0X%08h] ", $time, inst);

case(opcode2)
// R-Type
    6'h00 : begin
        case(funct2)
            6'h20: $write("add  r[%02d], r[%02d], r[%02d];", rd2, rs2, rt2);
            6'h22: $write("sub  r[%02d], r[%02d], r[%02d];", rd2, rs2, rt2);
            6'h2c: $write("mul  r[%02d], r[%02d], r[%02d];", rd2, rs2, rt2);
            6'h24: $write("and  r[%02d], r[%02d], r[%02d];", rd2, rs2, rt2);
            6'h25: $write("or   r[%02d], r[%02d], r[%02d];", rd2, rs2, rt2);
            6'h27: $write("nor  r[%02d], r[%02d], r[%02d];", rd2, rs2, rt2);
            6'h2a: $write("slt  r[%02d], r[%02d], r[%02d];", rd2, rs2, rt2);
            6'h01: $write("sll  r[%02d], r[%02d], %2d;", rd2, rs2, shamt2);
            6'h02: $write("srl  r[%02d], 0X%02h, r[%02d];", rd2, rs2, shamt2);
            6'h08: $write("jr   r[%02d];", rs2);
            default: $write("");
        endcase
    end
    // I-type
    6'h08 : $write("addi  r[%02d], r[%02d], 0X%04h;", rt2, rs2, immediate2);
    6'h1d : $write("muli  r[%02d], r[%02d], 0X%04h;", rt2, rs2, immediate2);
    6'h0c : $write("andi  r[%02d], r[%02d], 0X%04h;", rt2, rs2, immediate2);
    6'h0d : $write("ori   r[%02d], r[%02d], 0X%04h;", rt2, rs2, immediate2);
    6'h0f : $write("lui   r[%02d], 0X%04h;", rt2, immediate2);
    6'h0a : $write("slti  r[%02d], r[%02d], 0X%04h;", rt2, rs2, immediate2);
    6'h04 : $write("beq   r[%02d], r[%02d], 0X%04h;", rt2, rs2, immediate2);
    6'h05 : $write("bne   r[%02d], r[%02d], 0X%04h;", rt2, rs2, immediate2);
    6'h23 : $write("lw    r[%02d], r[%02d], 0X%04h;", rt2, rs2, immediate2);
    6'h2b : $write("sw    r[%02d], r[%02d], 0X%04h;", rt2, rs2, immediate2);
    // J-Type
    6'h02 : $write("jmp   0X%07h;", address2);
    6'h03 : $write("jal   0X%07h;", address2);
    6'h1b : $write("push;");
    6'h1c : $write("pop;");
    default: $write("");
endcase

$write("\n");
end
endtask
//------------------------------------- END ---------------------------------------//


reg read, write;
buf (READ, read);
buf (WRITE, write);

reg [31:0] C;

buf ctrl_buf [31:0] (CTRL, C);

// Parse the instruction data
reg [5:0]   opcode;
reg [4:0]   rs;
reg [4:0]   rt;
reg [4:0]   rd;
reg [4:0]   shamt;
reg [5:0]   funct;
reg [15:0]  imm;
reg [25:0]  addr;

// State machine
wire [2:0] state;
PROC_SM proc_sm(state, CLK, RST);

// TBD - take action on each +ve edge of clock
always @ (state) begin
    // R-type
    {opcode, rs, rt, rd, shamt, funct} = INSTRUCTION;
    // I-type
    {opcode, rs, rt, imm} = INSTRUCTION;
    // J-type
    {opcode, addr} = INSTRUCTION;

    // Print current state
//    $write("@ %6dns -> ", $time);
//    $write("STATE ", state, ": ");
//    case (state)
//        `PROC_FETCH: $write("FETCH");
//        `PROC_DECODE: $write("DECODE");
//        `PROC_EXE: $write("EXECUTE");
//        `PROC_MEM: $write("MEMORY");
//        `PROC_WB: $write("WRITE BACK");
//        default: $write("INVALID");
//    endcase
//    $write("\n");

    case (state)
        // fetch - next instruction from memory at PC
        `PROC_FETCH: begin
            // set everything in ctrl to 0
            C = 32'b0;
            // memory
            read = 1'b1;
            write = 1'b0;
            // selections
            C[`ma_sel_2] = 1'b1; // load data from mem[PC]
        end
        // decode - parse instruction and read values from register file
        `PROC_DECODE: begin
            // loaded in previous state, set to 0
            read = 1'b0;
            // load now
            C[`ir_load] = 1'b1;
            C[`reg_r] = 1'b1;
        end
        // execute - perform operation based on instruction
        `PROC_EXE: begin
            print_instruction(INSTRUCTION);
            // loaded in previous state, set to 0
            C[`ir_load] = 1'b0;
            // selections
            // r1_sel_1: push - store value of r0 at stack pointer
            C[`r1_sel_1] = opcode != 6'h1b ? 1'b0 : 1'b1;
            // wa_sel_1: R-type - write to rd, I-type - write to rt
            C[`wa_sel_1] = opcode == 6'h00 ? 1'b0 : 1'b1;
            // wa_sel_2: jal - write to r31, pop - write to r0
            C[`wa_sel_2] = opcode == 6'h03 ? 1'b1 : 1'b0;
            // wa_sel_3: push or pop - wa_sel_2, else wa_sel_1
            C[`wa_sel_3] = opcode == 6'h03 || opcode == 6'h1c ? 1'b0 : 1'b1;
            // jr - jump to address in register
            C[`pc_sel_1] = opcode == 6'h00 && funct == 6'h08 ? 1'b0 : 1'b1;
            // beq, bne - branch if equal or not equal
            // TODO: this should only be selected if the condition is met
            // pc_sel_2 = opcode == 6'h04 || opcode == 6'h05 ? 1'b1 : 1'b0;
            // jmp, jal - jump to address
            C[`pc_sel_3] = opcode == `OP_JMP || opcode == `OP_JAL ? 1'b0 : 1'b1;

            // alu_oprn - operation to be performed by ALU
            // R-type
            if (opcode == `OP_RTYPE) begin
                case (funct)
                    `FN_ADD: C[`alu_oprn] = `ALU_ADD;
                    `FN_SUB: C[`alu_oprn] = `ALU_SUB;
                    `FN_MUL: C[`alu_oprn] = `ALU_MUL;
                    `FN_SRL: C[`alu_oprn] = `ALU_SRL;
                    `FN_SLL: C[`alu_oprn] = `ALU_SLL;
                    `FN_AND: C[`alu_oprn] = `ALU_AND;
                    `FN_OR: C[`alu_oprn] = `ALU_OR;
                    `FN_NOR: C[`alu_oprn] = `ALU_NOR;
                    `FN_SLT: C[`alu_oprn] = `ALU_SLT;
                    default: C[`alu_oprn] = `ALU_NOP;
                endcase
            end
            // I-type and J-type
            else begin
                case (opcode)
                    // I-type
                    `OP_ADDI: C[`alu_oprn] = `ALU_ADD;  // addi
                    `OP_MULI: C[`alu_oprn] = `ALU_MUL;  // muli
                    `OP_ANDI: C[`alu_oprn] = `ALU_AND;  // andi
                    `OP_ORI: C[`alu_oprn] = `ALU_OR;   // ori
                    `OP_SLTI: C[`alu_oprn] = `ALU_SLT;  // slti
                    `OP_BEQ: C[`alu_oprn] = `ALU_SUB;  // beq - sub
                    `OP_BNE: C[`alu_oprn] = `ALU_SUB;  // bne - sub
                    `OP_LW: C[`alu_oprn] = `ALU_ADD;  // lw - add
                    `OP_SW: C[`alu_oprn] = `ALU_ADD;  // sw - add
                    // J-type
                    `OP_PUSH: C[`alu_oprn] = `ALU_SUB;  // push - sub
                    `OP_POP: C[`alu_oprn] = `ALU_ADD;  // pop - add
                    default: C[`alu_oprn] = `ALU_NOP;
                endcase
            end
            // op1_sel_1 - select r1 or sp based on opcode
            // push or pop - sp, else r1
            C[`op1_sel_1] = opcode == 6'h1b || opcode == 6'h1c ? 1'b1 : 1'b0;
            // op2_sel_1 - select 1 or shamt based on alu_oprn
            // sll or srl - shamt, else 1 (for increments/decrements)
            C[`op2_sel_1] = C[`alu_oprn] == 6'h04 || C[`alu_oprn] == 6'h05 ? 1'b1 : 1'b0;
            // op2_sel_2 - select imm_zx or imm_sx based on alu_oprn
            // logical (and, or) - imm_zx, else imm_sx; ('nor' not availble in I-type)
            C[`op2_sel_2] = C[`alu_oprn] == 6'h06 || C[`alu_oprn] == 6'h07 ? 1'b0 : 1'b1;
            // op2_sel_3 - select op2_sel_2 or op2_sel_1 based on alu_oprn
            // R-type - op2_sel_1, I-type - op2_sel_2
            C[`op2_sel_3] = opcode == 6'h00 ? 1'b1 : 1'b0;
            // op2_sel_4 - select op2_sel_3 or r2
            // I-type or shift or inc/dec - op2_sel_3, else r2
            // i.e. r2 only if R-type and not shift
            C[`op2_sel_4] = opcode != 6'h00 || C[`alu_oprn] == 6'h04 || C[`alu_oprn] == 6'h05 ? 1'b0 : 1'b1;

            // wd_sel_1 - alu_out or DATA_IN
            C[`wd_sel_1] = 1'b0;
            // wd_sel_2 - wd_sel_1 or imm_zx_lsb
            // lui - imm_zx_lsb, else wd_sel_1
            C[`wd_sel_2] = opcode == 6'h0f ? 1'b1 : 1'b0;
            // wd_sel_3 - pc_inc or wd_sel_2
            // jal - pc_inc, else wd_sel_2
            C[`wd_sel_3] = opcode == 6'h03 ? 1'b0 : 1'b1;
            // md_sel_1 - r1 for push, r2 for sw
            C[`md_sel_1] = opcode == 6'h1b ? 1'b1 : 1'b0;
        end
        `PROC_MEM: begin
            // load now
            // push or sw - write to memory
            if (opcode == 6'h1b || opcode == 6'h2b) begin
                read = 1'b0;
                write = 1'b1;
            end
            else begin
//                read = 1'b1;
//                write = 1'b0;
            end
        end
        `PROC_WB: begin
            // loaded in previous state, set to 0
            read = 1'b0;
            write = 1'b0;
            // load now
            C[`pc_load] = 1'b1;
            // write to register file if
            // R-type (except jr) or I-type (except beq, bne, sw) or pop or jal
            C[`reg_w] = (opcode == 6'h00 && funct != 6'h08) // R-type (except jr)
                    || (opcode == 6'h08 || opcode == 6'h1d || opcode == 6'h0c || opcode == 6'h0d
                    || opcode == 6'h0f || opcode == 6'h0a || opcode == 6'h23) // I-type (except beq, bne, sw)
                    || (opcode == 6'h1c || opcode == 6'h03) // pop or jal
                    ? 1'b1 : 1'b0;
            // selections
            // pc_sel_2 - branch if equal or not equal
            C[`pc_sel_2] = (opcode == 6'h04 && ZERO) || (opcode == 6'h05 && ~ZERO) ? 1'b1 : 1'b0;

        end
    endcase
end
endmodule


//------------------------------------------------------------------------------------------
// Module: PROC_SM
// Output: STATE      : State of the processor
//
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute,
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
module PROC_SM(STATE,CLK,RST);
// list of inputs
input CLK, RST;
// list of outputs
output [2:0] STATE;

reg [2:0] state_sel = 3'bxxx;

always @ (negedge RST) begin
    // set to invalid value, so that it defaults to fetch
    state_sel = 3'bxxx;
end

// TBD - take action on each +ve edge of clock
always @ (posedge CLK) begin
    case (state_sel)
        `PROC_FETCH: state_sel = `PROC_DECODE;
        `PROC_DECODE: state_sel = `PROC_EXE;
        `PROC_EXE: state_sel = `PROC_MEM;
        `PROC_MEM: state_sel = `PROC_WB;
        `PROC_WB: state_sel = `PROC_FETCH;
        default: state_sel = `PROC_FETCH;
    endcase
end

assign STATE = state_sel;
endmodule
