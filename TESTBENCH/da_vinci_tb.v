// Name: da_vinci_tb.v
// Module: DA_VINCI_TB
// 
// Outputs are for testbench observations only
//
// Monitors:  DATA : Data to be written at address ADDR
//            ADDR : Address of the memory location to be accessed
//            READ : Read signal
//            WRITE: Write signal
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - Testbench for DA_VINCI system
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "../prj_definition.v"
module DA_VINCI_TB;
// output list
wire [`ADDRESS_INDEX_LIMIT:0] ADDR;
wire READ, WRITE, CLK;
// inout list
wire [`DATA_INDEX_LIMIT:0] MEM_DATA_OUT, MEM_DATA_IN;

// reset
reg RST;
integer t1=1, t2=1, t3=1, t4=1, t5=1, t6=1;
//integer t1=0, t2=0, t3=0, t4=0, t5=0, t6=1;

// Clock generator instance
CLK_GENERATOR clk_gen_inst(.CLK(CLK));

// DA_VINCI v1.0 instance
defparam da_vinci_inst.mem_init_file = "./TESTPROGRAM/fibonacci.dat";
//defparam da_vinci_inst.mem_init_file = "RevFib.dat";
DA_VINCI da_vinci_inst(.MEM_DATA_OUT(MEM_DATA_OUT), 
                       .MEM_DATA_IN(MEM_DATA_IN), 
                       .ADDR(ADDR), .READ(READ), 
                       .WRITE(WRITE), .CLK(CLK), .RST(RST));

initial
begin



	RST=1'b1;

if (t1 === 1)
begin
/* START : test 1*/
#5 	RST=1'b0;
#5 	RST=1'b1;
        $write("\n");	
	$write("===> Simulating fibonacci.dat\n", "");
	$write("\n");
        $readmemh("./TESTPROGRAM/fibonacci.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m);
#5000   $write("\n");	
	$write("===> Done simulating fibonacci.dat\n", "");
	$write("\n");
	$writememh("./OUTPUT/fibonacci_mem_dump.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m, 'h00040000, 'h0004000f);
/* END : test 1*/
end

if (t2 === 1)
begin
/* START : test 2*/
#5	RST=1'b0;
#5 	RST=1'b1;
        $write("\n");
	$write("===> Simulating RevFib.dat\n", "");
	$write("\n");
	$readmemh("./TESTPROGRAM/RevFib.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m);
#5000  	$write("\n");	
	$write("===> Done simulating RevFib.dat\n", "");
	$write("\n");
	$writememh("./OUTPUT/RevFib_mem_dump.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m, `INIT_STACK_POINTER - 'h0f, `INIT_STACK_POINTER);
/* END : test 2*/
end

if (t3 === 1)
begin
/* START : test 3*/
#5	RST=1'b0;
#5 	RST=1'b1;
        $write("\n");
	$write("===> Simulating CS147_SP17_HW01_02.dat\n", "");
	$write("\n");
	$readmemh("./TESTPROGRAM/CS147_SP17_HW01_02.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m);
#5000  	$write("\n");	
	$write("===> Done simulating CS147_SP17_HW01_02.dat\n", "");
	$write("\n");
	$writememh("./OUTPUT/CS147_SP17_HW01_02_mem_dump.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m, 'h00048000, 'h0004800A);
/* END : test 3*/
end

if (t4 === 1)
begin
/* START : test 4*/
#5	RST=1'b0;
#5 	RST=1'b1;
        $write("\n");
	$write("===> Simulating CS147_FL15_HW01_02.dat\n", "");
	$write("\n");
	$readmemh("./TESTPROGRAM/CS147_FL15_HW01_02.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m);
#6000  	$write("\n");	
	$write("===> Done simulating CS147_FL15_HW01_02.dat\n", "");
	$write("\n");
	$writememh("./OUTPUT/CS147_FL15_HW01_02_mem_dump.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m, `INIT_STACK_POINTER - 9, `INIT_STACK_POINTER);
/* END : test 4*/
end

if (t5 === 1)
begin
/* START : test 5*/
#5	RST=1'b0;
#5 	RST=1'b1;
        $write("\n");
	$write("===> Simulating CS147_SP15_HW01_02.dat\n", "");
	$write("\n");
	$readmemh("./TESTPROGRAM/CS147_SP15_HW01_02.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m);
#5000  	$write("\n");	
	$write("===> Done simulating CS147_SP15_HW01_02.dat\n", "");
	$write("\n");
	$writememh("./OUTPUT/CS147_SP15_HW01_02_mem_dump_01.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m, 'h00048000, 'h00048005);
	$writememh("./OUTPUT/CS147_SP15_HW01_02_mem_dump_02.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m, `INIT_STACK_POINTER - 5, `INIT_STACK_POINTER);
/* END : test 5*/
end

if (t6 === 1)
begin
/* START : test 6*/
#5	RST=1'b0;
#5 	RST=1'b1;
        $write("\n");
	$write("===> Simulating all_test.dat\n", "");
	$write("\n");
	$readmemh("./TESTPROGRAM/all_test.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m);
#5000  	$write("\n");
	$write("===> Done simulating all_test.dat\n", "");
	$write("\n");
	$writememh("./OUTPUT/all_test_mem_dump_01.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m, 'h00048000, 'h00048011);
	$writememh("./OUTPUT/all_test_mem_dump_02.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m, `INIT_STACK_POINTER - 5, `INIT_STACK_POINTER);
/* END : test 6*/
end
	$stop;

end
endmodule;

