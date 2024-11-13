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
                default: begin $write("");
		end
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
assign READ = read;
assign WRITE = write;

// Control signals, same as in data_path.v
reg pc_load, pc_sel_1, pc_sel_2, pc_sel_3,
    ir_load, reg_r, reg_w,
    r1_sel_1, wa_sel_1, wa_sel_2, wa_sel_3,

    sp_load, op1_sel_1,
    op2_sel_1, op2_sel_2, op2_sel_3, op2_sel_4,

    wd_sel_1, wd_sel_2, wd_sel_3,
    ma_sel_1, ma_sel_2,
    md_sel_1;

reg [5:0] alu_oprn;

buf (CTRL[0], pc_load);
buf (CTRL[1], pc_sel_1);
buf (CTRL[2], pc_sel_2);
buf (CTRL[3], pc_sel_3);

buf (CTRL[4], ir_load);
buf (CTRL[5], reg_r);
buf (CTRL[6], reg_w);

buf (CTRL[7], r1_sel_1);
buf (CTRL[8], wa_sel_1);
buf (CTRL[9], wa_sel_2);
buf (CTRL[10], wa_sel_3);

buf (CTRL[11], sp_load);
buf (CTRL[12], op1_sel_1);

buf (CTRL[13], op2_sel_1);
buf (CTRL[14], op2_sel_2);
buf (CTRL[15], op2_sel_3);
buf (CTRL[16], op2_sel_4);

buf (CTRL[17], wd_sel_1);
buf (CTRL[18], wd_sel_2);
buf (CTRL[19], wd_sel_3);

buf (CTRL[20], ma_sel_1);
buf (CTRL[21], ma_sel_2);

buf (CTRL[22], md_sel_1);

buf alu_oprn_buf [5:0] (CTRL[28:23], alu_oprn);

// Parse the instruction data, same as in data_path.v
wire [5:0]   opcode;
wire [4:0]   rs;
wire [4:0]   rt;
wire [4:0]   rd;
wire [4:0]   shamt;
wire [5:0]   funct;
wire [15:0]  imm;
wire [25:0]  addr;

// common for all
buf opcode_buf [5:0] (opcode, INSTRUCTION[31:26]);
// common for R-type, I-type
buf rs_buf [4:0] (rs, INSTRUCTION[25:21]);
buf rt_buf [4:0] (rt, INSTRUCTION[20:16]);
// for R-type
buf rd_buf [4:0] (rd, INSTRUCTION[15:11]);
buf shamt_buf [4:0] (shamt, INSTRUCTION[10:6]);
buf funct_buf [5:0] (funct, INSTRUCTION[5:0]);
// for I-type
buf imm_buf [15:0] (imm, INSTRUCTION[15:0]);
// for J-type
buf addr_buf [25:0] (addr, INSTRUCTION[25:0]);

// State machine
wire [2:0] state;
PROC_SM proc_sm(state, CLK, RST);

// TBD - take action on each +ve edge of clock
always @ (state) begin
    // Print current state
    $write("@ %6dns -> ", $time);
    $write("STATE ", state, ": ");
    case (state)
        `PROC_FETCH: $write("FETCH");
        `PROC_DECODE: $write("DECODE");
        `PROC_EXE: $write("EXECUTE");
        `PROC_MEM: $write("MEMORY");
        `PROC_WB: $write("WRITE BACK");
        default: $write("INVALID");
    endcase

    case (state)
        // fetch - next instruction from memory at PC
        `PROC_FETCH: begin
            // loaded in previous state, set to 0
            pc_load = 1'b0;
            reg_r = 1'b0;
            reg_w = 1'b0;
            // load now
            ir_load = 1'b1;
            read = 1'b1;
            write = 1'b0;
            // selections
            // ma_sel_2 - load data from mem[PC]
            ma_sel_2 = 1'b1;
        end
        // decode - parse instruction and read values from register file
        `PROC_DECODE: begin
            // loaded in previous state, set to 0
            ir_load = 1'b0;
            sp_load = 1'b0;
            read = 1'b0;
            // load now
            reg_r = 1'b1;
            reg_w = 1'b0;
            // selections
            // r1_sel_1: push - store value of r0 at stack pointer
            r1_sel_1 = opcode != 6'h1b ? 1'b0 : 1'b1;
            // wa_sel_1: R-type - write to rd, I-type - write to rt
            wa_sel_1 = opcode == 6'h00 ? 1'b0 : 1'b1;
            // wa_sel_2: jal - write to r31, pop - write to r0
            wa_sel_2 = opcode == 6'h03 ? 1'b1 : 1'b0;
            // wa_sel_3: push or pop - wa_sel_2, else wa_sel_1
            wa_sel_3 = opcode == 6'h03 || opcode == 6'h1c ? 1'b0 : 1'b1;
            // jr - jump to address in register
            pc_sel_1 = opcode == 6'h00 && funct == 6'h08 ? 1'b0 : 1'b1;
            // beq, bne - branch if equal or not equal
            // TODO: this should only be selected if the condition is met
            // pc_sel_2 = opcode == 6'h04 || opcode == 6'h05 ? 1'b1 : 1'b0;
            // jmp, jal - jump to address
            pc_sel_3 = opcode == 6'h02 || opcode == 6'h03 ? 1'b0 : 1'b1;

            // alu_oprn - operation to be performed by ALU
            // R-type
            if (opcode == 6'h00) begin
                case (funct)
                    6'h20: alu_oprn = 6'h01; // add
                    6'h22: alu_oprn = 6'h02; // sub
                    6'h2c: alu_oprn = 6'h03; // mul
                    6'h02: alu_oprn = 6'h04; // srl
                    6'h01: alu_oprn = 6'h05; // sll
                    6'h24: alu_oprn = 6'h06; // and
                    6'h25: alu_oprn = 6'h07; // or
                    6'h27: alu_oprn = 6'h08; // nor
                    6'h2a: alu_oprn = 6'h09; // slt
                    default: alu_oprn = 6'hxx;
                endcase
            end
            // I-type and J-type
            else begin
                case (opcode)
                    // I-type
                    6'h08: alu_oprn = 6'h01; // addi
                    6'h1d: alu_oprn = 6'h03; // muli
                    6'h0c: alu_oprn = 6'h06; // andi
                    6'h0d: alu_oprn = 6'h07; // ori
                    6'h0a: alu_oprn = 6'h09; // slti
                    6'h04: alu_oprn = 6'h02; // beq - sub
                    6'h05: alu_oprn = 6'h02; // bne - sub
                    6'h23: alu_oprn = 6'h01; // lw - add
                    6'h2b: alu_oprn = 6'h01; // sw - add
                    // J-type
                    6'h1b: alu_oprn = 6'h02; // push - sub
                    6'h1c: alu_oprn = 6'h01; // pop - add
                    default: alu_oprn = 6'hxx;
                endcase
            end
            // op1_sel_1 - select r1 or sp based on opcode
            // push or pop - sp, else r1
            op1_sel_1 = opcode == 6'h1b || opcode == 6'h1c ? 1'b1 : 1'b0;
            // op2_sel_1 - select 1 or shamt based on alu_oprn
            // sll or srl - shamt, else 1 (for increments/decrements)
            op2_sel_1 = alu_oprn == 6'h04 || alu_oprn == 6'h05 ? 1'b1 : 1'b0;
            // op2_sel_2 - select imm_zx or imm_sx based on alu_oprn
            // logical (and, or) - imm_zx, else imm_sx; ('nor' not availble in I-type)
            op2_sel_2 = alu_oprn == 6'h06 || alu_oprn == 6'h07 ? 1'b0 : 1'b1;
            // op2_sel_3 - select op2_sel_2 or op2_sel_1 based on alu_oprn
            // R-type - op2_sel_1, I-type - op2_sel_2
            op2_sel_3 = opcode == 6'h00 ? 1'b1 : 1'b0;
            // op2_sel_4 - select op2_sel_3 or r2
            // I-type or shift or inc/dec - op2_sel_3, else r2
            // i.e. r2 only if R-type and not shift
            op2_sel_4 = opcode != 6'h00 || alu_oprn == 6'h04 || alu_oprn == 6'h05 ? 1'b0 : 1'b1;
        end
        // execute - perform operation based on instruction
        `PROC_EXE: begin
            // selections
            // wd_sel_1 - alu_out or DATA_IN
            wd_sel_1 = 1'b0;
            // wd_sel_2 - wd_sel_1 or imm_zx_lsb
            // lui - imm_zx_lsb, else wd_sel_1
            wd_sel_2 = opcode == 6'h0f ? 1'b1 : 1'b0;
            // wd_sel_3 - pc_inc or wd_sel_2
            // jal - pc_inc, else wd_sel_2
            wd_sel_3 = opcode == 6'h03 ? 1'b0 : 1'b1;
            // md_sel_1 - r1 for push, r2 for sw
            md_sel_1 = opcode == 6'h1b ? 1'b1 : 1'b0;
        end
        `PROC_MEM: begin
            // load now
            // push or sw - write to memory
            if (opcode == 6'h1b || opcode == 6'h2b) begin
                read = 1'b0;
                write = 1'b1;
            end
            else begin
                read = 1'b1;
                write = 1'b0;
            end
        end
        `PROC_WB: begin
            // loaded in previous state, set to 0
            read = 1'b0;
            write = 1'b0;
            // load now
            pc_load = 1'b1;
            // write to register file if
            // R-type (except jr) or I-type (except beq, bne, sw) or pop or jal
            reg_w = (opcode == 6'h00 && funct != 6'h08) // R-type (except jr)
                    || (opcode == 6'h08 || opcode == 6'h1d || opcode == 6'h0c || opcode == 6'h0d
                    || opcode == 6'h0f || opcode == 6'h0a || opcode == 6'h23) // I-type (except beq, bne, sw)
                    || (opcode == 6'h1c || opcode == 6'h03) // pop or jal
                    ? 1'b1 : 1'b0;
            // selections
            // ma_sel_2 - load data from mem[PC]
            ma_sel_2 = 1'b1;
            // pc_sel_2 - branch if equal or not equal
            pc_sel_2 = (opcode == 6'h04 && ZERO) || (opcode == 6'h05 && ~ZERO) ? 1'b1 : 1'b0;

        end
        default: begin
            $write("@ %6dns -> ", $time);
            $write("STATE ", state, ": ");
            $write("INVALID");
            print_instruction(INSTRUCTION);
        end
    endcase

    // TBD - assign control signals based on instruction
    print_instruction(INSTRUCTION);
    // TBD - assign READ and WRITE signals based on instruction
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
