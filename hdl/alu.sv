`timescale 1ns / 1ns
////////////////////////////////////////////////////////////////////////////////
// Engineer: akiaji-k
//
// Create Date:   2025-01-05
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

`default_nettype none 

module alu import pkg_instructions::*;(
//        input logic clk_i,
//        input logic rst_i,
        input alu_e alu_type_i,
        input logic[XLEN-1:0] src1_val_i,
        input logic[XLEN-1:0] src2_val_i,
        input logic[XLEN-1:0] src3_val_i,
        input logic[XLEN-1:0] pc_i,
        input logic is_op32_i,
        input logic is_branch_i,
        output logic[XLEN-1:0] dest_val_o,
        output logic[XLEN-1:0] pc_branch_o,
        output logic branch_flag_o
    );

    import pkg_parameters::XLEN, pkg_parameters::SHAMT_WIDTH;
    import pkg_instructions::alu_e;

    logic[XLEN-1:0] src1_val;
    logic[XLEN-1:0] src2_val;
    logic[XLEN-1:0] src3_val;
    logic[XLEN-1:0] dest_val;
    logic[XLEN-1:0] pc;
    logic[XLEN-1:0] pc_branch;
    logic branch_flag;
//    logic [SHAMT_WIDTH-1:0] shamt;
    assign src1_val = (is_op32_i == 1'b1) ? {{(XLEN-32){1'b0}}, src1_val_i[31:0]} : src1_val_i;
    assign src2_val = (is_op32_i == 1'b1) ? {{(XLEN-32){1'b0}}, src2_val_i[31:0]} : src2_val_i;
    assign src3_val = (is_op32_i == 1'b1) ? {{(XLEN-32){1'b0}}, src3_val_i[31:0]} : src3_val_i;
    assign dest_val_o = (is_op32_i == 1'b1) ? XLEN'($signed(dest_val[31:0]))  : dest_val;
    assign pc = pc_i;
    assign pc_branch_o = (alu_type_i == ALU_JALR) ? {pc_branch[XLEN-1:1], 1'b0} : pc_branch;    // JALR instruction should be aligned to 2-byte boundary
    assign branch_flag_o = is_branch_i & branch_flag;
//    assign shamt = (is_op32_i == 1'b1) ? 'd4 : $bits(shamt_bit_pos)'(SHAMT_WIDTH - 1);

    // branch target address
    always_comb begin : PC_BRANCH
        unique case(alu_type_i)
            ALU_JALR: begin     
                pc_branch = src1_val + src2_val;    // OPE_RS1_IMM is selected for JALR instructions
            end
            default : begin : FOR_BRANCH_AND_JAL_INSTRUCTIONS
                pc_branch = pc + src3_val;   // src3_val is the immediate value if ope_sel == OPE_RS1_RS2_IMM
            end
        endcase
    end

    always_comb begin : OPE 
        unique case(alu_type_i)
            // arithmetic
            ALU_ADD: begin     
                dest_val = src1_val + src2_val;
            end
            ALU_SUB: begin     
                dest_val = src1_val - src2_val;
            end
            ALU_NOP: begin     
                dest_val = '0;
            end
            // comparison
            ALU_EQ: begin
                dest_val = (src1_val == src2_val) ? 'd1 : 'd0;
            end
            ALU_NE: begin
                dest_val = (src1_val != src2_val) ? 'd1 : 'd0;
            end
            ALU_LT: begin
                dest_val = ($signed(src1_val) < $signed(src2_val)) ? 'd1 : 'd0;
            end
            ALU_GE: begin
                dest_val = ($signed(src1_val) >= $signed(src2_val)) ? 'd1 : 'd0;
            end
            ALU_LTU: begin
                dest_val = ($unsigned(src1_val) < $unsigned(src2_val)) ? 'd1 : 'd0;
            end
            ALU_GEU: begin
                dest_val = ($unsigned(src1_val) >= $unsigned(src2_val)) ? 'd1 : 'd0;
            end
            // PC etc...
            ALU_JAL: begin
                dest_val = pc + 'd4;
            end
            ALU_JALR: begin
                dest_val = pc + 'd4;
            end
            ALU_LUI: begin
                dest_val = src3_val;
            end
            ALU_AUIPC: begin
                dest_val = pc + src3_val;
            end
            // bitwise
            ALU_XOR: begin
                dest_val = src1_val ^ src2_val;
            end
            ALU_OR: begin
                dest_val = src1_val | src2_val;
            end
            ALU_AND: begin
                dest_val = src1_val & src2_val;
            end
            // shift
            ALU_SLL: begin
                dest_val = (is_op32_i == 1'b1) ?  src1_val << src2_val[4:0] : src1_val << src2_val[SHAMT_WIDTH-1:0];
            end
            ALU_SRL: begin
                dest_val = (is_op32_i == 1'b1) ?  src1_val >> src2_val[4:0] : src1_val >> src2_val[SHAMT_WIDTH-1:0];
            end
            ALU_SRA: begin
                // if opcode is 32-bit calculation, its lower 32-bit value is arithmetically shifted and upper 32-bit value is 0-padding (thrown away later). 
                dest_val = (is_op32_i == 1'b1) ? 
                             ({{(XLEN-32){1'b0}}, ($signed(src1_val[31:0]) >>> src2_val[4:0])}) :
                              ($signed(src1_val) >>> src2_val[SHAMT_WIDTH-1:0]);
            end
            ALU_CSR_RW : begin
                // CSR read/write
                dest_val = src2_val;        // src2_val is regx[rs1] or uimm
            end
            ALU_CSR_RS: begin
                // CSR read and set
                dest_val = src1_val | src2_val;
            end
            ALU_CSR_RC: begin
                // CSR read and clear
                dest_val = src1_val & ~src2_val;        // src1_val is CSR, src2_val is reg_x[rs1] or uimm 
            end
            default: begin
                dest_val = '0;
            end
        endcase
    end

    always_comb begin : BRANCH
        if (alu_type_i inside {ALU_EQ, ALU_NE, ALU_LT, ALU_GE, ALU_LTU, ALU_GEU}) begin
            branch_flag = dest_val[0];
        end
        else if (alu_type_i inside {ALU_JAL, ALU_JALR}) begin
            branch_flag = '1;
        end
        else begin
            branch_flag = '0;
        end
    end


endmodule

`default_nettype wire 




