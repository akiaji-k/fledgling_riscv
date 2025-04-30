`timescale 1ns / 1ns
////////////////////////////////////////////////////////////////////////////////
// Engineer: akiaji-k
//
// Create Date:   2025-01-04
// Description: 
//
// Revision:
// Revision 0.01 - File Created
//
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`include "pkg_parameters.sv"
`include "pkg_instructions.sv"

module tb_top;

    import pkg_parameters::IMEM_DEPTH, pkg_parameters::IMEM_ADDR_WIDTH, pkg_parameters::DMEM_DEPTH, pkg_parameters::DMEM_ADDR_WIDTH;

    /* Port declaration */
    // Parameters
// params extractor will be implemented in the future.

    // Input Ports
    bit clk_i;
	bit rst_i;

    // Output Ports
//	logic [BIT_WIDTH : 0] out_o;


    /* Instantiate the Unit Under Test (UUT) */
    top top (
        .clk_i,
        .rst_i
    );


    /* Making Clock */
    parameter PERIOD = 10 /* 100MHz */;    // ns unit
        
//    bit sim_clk;
    always #(PERIOD/2) clk_i <= ~clk_i;
    
    // set default clocking block
    default clocking cb @ (posedge clk_i); endclocking

    /* dump FST file (not VCD) */
    //initial $dumpfile("../fst/tb.fst");
    initial $dumpfile("./tb/fst/tb.fst");
    initial $dumpvars();


    /* Process */
    //localparam int IMEM_CAPACITY_KiB = 8;
    //localparam int IMEM_DEPTH = byte_addr_mem_depth_from_capacity_kib(IMEM_CAPACITY_KiB);
    //localparam int IMEM_ADDR_WIDTH = addr_width_from_capacity_kib(IMEM_CAPACITY_KiB);
    //localparam int IMEM_DATA_WIDTH = 32;

    /* verilator lint_off SYNCASYNCNET */
//    always @(top.cpu.imem_rdata) begin
//    always @(top.cpu.pc) begin
    always @(top.cpu.pc, top.cpu.data_hazard_stall) begin
    //always @(top.cpu.decoder.inst) begin
        $display("-------------------------\n",
                "@%0t\n", $realtime,
                "pc = %0d, next_pc = %0d\n", top.cpu.pc, top.cpu.next_pc,
                "imem2if_pc = %0d, if2id_pc = %0d, id2exe_pc = %0d\n", top.cpu.imem2if_pc, top.cpu.if2id_pc, top.cpu.id2exe_pc,
                "IF: Instruction Fetch\n", 
                "\timem_rdata: 0x%x\n", top.cpu.imem_rdata,
                "\timem_rdata: 0x%b\n", top.cpu.imem_rdata,
                "ID: Instruction Decode and register fetch\n", 
                "\tInstruction: %s\n", top.cpu.decoder.inst.name, 
                "\trs1_addr: %0d, rs2_addr: %0d, rs3_addr: %0d, wb_addr: %0d\n", top.cpu.rs1_addr, top.cpu.rs2_addr, top.cpu.rs3_addr, top.cpu.wb_addr,
                "\trs1_val: %0d, rs2_val: %0d, rs3_val: %0d\n", top.cpu.rs1_val, top.cpu.rs2_val, top.cpu.rs3_val,
                "\timm: %0d (0x%x)\n", $signed(top.cpu.imm), top.cpu.imm, 
                "\tALU_TYPE: %s,\toperand select: %s\n", top.cpu.alu_type.name, top.cpu.ope_sel.name,
                "\tope_1: %0d, ope_2: %0d, ope_3: %0d, res: %0d\n", $signed(top.cpu.ope_1), $signed(top.cpu.ope_2), $signed(top.cpu.ope_3), $signed(top.cpu.res_val), 
                "EX: Instruction Execute\n", 
                "\tALU_TYPE: %s\n", top.cpu.id2exe_alu_type.name,
                "\tsrc1_val: %0d, src2_val: %0d, src3_val: %0d, dest_val: %0d\n", $signed(top.cpu.id2exe_ope_1), $signed(top.cpu.id2exe_ope_2), $signed(top.cpu.id2exe_ope_3), $signed(top.cpu.res_val), 
                "\tbranch_flag: %0d\n", top.cpu.branch_flag,
                "MEM: Memory access\n", 
                "\tdmem_addr: %0d, exe2mem_is_load: 0b%0b, mem_out: 0x%0x\n", top.cpu.dmem_addr, top.cpu.exe2mem_is_load, top.cpu.mem_out,
                "WB: Write back\n", 
                "\tmem2wb_wb_addr: %0d, mem2wb_mem_out: 0x%0x\n", top.cpu.mem2wb_wb_addr, top.cpu.mem2wb_mem_out,
                "-------------------------\n");
    end
    /* verilator lint_on SYNCASYNCNET */

    initial begin

        $display ("IMEM_DEPTH: %0d, IMEM_ADDR_WIDTH: %0d, DMEM_DEPTH: %0d, DMEM_ADDR_WIDTH: %0d", IMEM_DEPTH, IMEM_ADDR_WIDTH, DMEM_DEPTH, DMEM_ADDR_WIDTH);
        $display ("The # of instructions: %0d", top.cpu.decoder.inst.num);
/* verilator lint_off SYNCASYNCNET */
//        $monitor("-------------------------\n",
//                "@%0t\n", $realtime,
//                "imem_rdata: 0x%x\n", top.cpu.imem_rdata,
//                "imem_rdata: 0x%b\n", top.cpu.imem_rdata,
//                "Instruction: %s\n", top.cpu.decoder.inst.name, 
//                "rs1_addr: %0d, rs2_addr: %0d, rs3_addr: %0d, wb_addr: %0d\n", top.cpu.rs1_addr, top.cpu.rs2_addr, top.cpu.rs3_addr, top.cpu.wb_addr,
//                "imm: %0d (0x%x)\n", $signed(top.cpu.imm), top.cpu.imm, 
//                "ALU_TYPE: %s,\toperand select: %s\n", top.cpu.alu_type.name, top.cpu.ope_sel.name,
//                "ope_1: %0d, ope_2: %0d, ope_3: %0d, res: %0d\n", $signed(top.cpu.ope_1), $signed(top.cpu.ope_2), $signed(top.cpu.ope_3), $signed(top.cpu.res_val), 
//                "-------------------------\n");
/* verilator lint_on SYNCASYNCNET */


        // Initialize input ports
        $display ("@%0t: assert rst_i", $realtime);
        rst_i = #11 1'b1;
        $display ("@%0t: negate rst_i", $realtime);
        rst_i = #11 1'b0;

        $display ("// %%%%%%%%%%%%%%%%%%%%%%%%%%%");
        $display ("//   Running the testbench");
        $display ("// %%%%%%%%%%%%%%%%%%%%%%%%%%%");
        
        /* time interval manipulation and verification */
//        ##10;    // 10-clock-cycle of sim_clk
        ##20;    // 20-clock-cycle of sim_clk
//        assert(out_o == 'd51);
//            else $fatal(0, "10 + 30 should be 51 but out_o is %d", out_o);
        $finish;
/* verilator lint_on SYNCASYNCNET */
    end
endmodule

