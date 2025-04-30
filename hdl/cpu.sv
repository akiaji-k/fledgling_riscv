`timescale 1ns / 1ns
////////////////////////////////////////////////////////////////////////////////
// Engineer: akiaji-k
//
// Create Date:   2025-01-02
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

module cpu (
        input logic clk_i,
        input logic rst_i,
        imem_if.ctrl_port imem_if,
        dmem_if.ctrl_port dmem_if
    );

    import pkg_parameters::XLEN;
    import pkg_parameters::NUM_REG, pkg_parameters::REG_ADDR_WIDTH;
    import pkg_parameters::IMEM_ADDR_WIDTH, pkg_parameters::IMEM_DATA_WIDTH;
    import pkg_parameters::DMEM_ADDR_WIDTH, pkg_parameters::DMEM_DATA_WIDTH;
    import pkg_instructions::*;

    /* Memories */
    // Instruction memory
    logic [IMEM_ADDR_WIDTH-1:0] imem_addr = '0;
    logic imem_ena = '0;
    logic [IMEM_DATA_WIDTH-1:0] imem_rdata = '0;
    assign imem_if.ena = imem_ena;
    assign imem_if.addr = imem_addr;
    assign imem_rdata = imem_if.dout;

    // Data memory
    logic [DMEM_ADDR_WIDTH-1:0] dmem_addr = '0;
    logic dmem_ena = '0;
    logic dmem_web;
    logic [DMEM_DATA_WIDTH-1:0] dmem_rdata = '0;
    logic [DMEM_DATA_WIDTH-1:0] dmem_wdata;
    assign dmem_if.ena = dmem_ena;
    assign dmem_if.web = dmem_web;
    assign dmem_if.addr = dmem_addr;
    assign dmem_rdata = dmem_if.dout;
    assign dmem_if.din = dmem_wdata;

    // hazard
    logic [2:0] data_hazard_stall = '0;
    logic data_hazard_stall_d = '0;

    // ============================
    //  Register file
    // ============================
    reg_file_if rs1_if(
        .clk(clk_i),
        .rst(rst_i)
    );

    reg_file_if rs2_if(
        .clk(clk_i),
        .rst(rst_i)
    );

    reg_file_if rs3_if(
        .clk(clk_i),
        .rst(rst_i)
    );

    reg_file_if rd_if(
        .clk(clk_i),
        .rst(rst_i)
    );

    reg_file reg_file (
        .rs1_if,
        .rs2_if,
        .rs3_if,
        .rd_if
    );


    // ============================
    //  IF: Instruction fetch
    // ============================
    logic [XLEN-1:0] pc = '0;
    logic [XLEN-1:0] next_pc;
    logic [XLEN-1:0] pc_branch;
    // pipeline registers
    logic [XLEN-1:0] imem2if_pc = '0;
    logic [XLEN-1:0] if2id_pc = '0;
    logic [IMEM_DATA_WIDTH-1:0] if2id_imem_rdata = '0;
    logic [IMEM_DATA_WIDTH-1:0] if2id_imem_rdata_stall = '0;


    // program counter (PC)
//    assign next_pc = (data_hazard_stall != '0) ? pc : pc + 'd4;
    always_comb begin   : NEXT_PC
        // Jump and branch instructions have higher priority than data hazard stalls.
        if (branch_flag == 'b1) begin
            next_pc = pc_branch;    // it's one of the outputs from ALU 
        end
        else if (data_hazard_stall != '0) begin
            next_pc = pc;
        end
        else begin
            next_pc = pc + 'd4;
        end
    end

    always_ff @ (posedge clk_i, posedge rst_i) begin
        if (rst_i) begin
            pc <= '0;
        end
        else if (data_hazard_stall != '0) begin
            pc <= pc;
        end
        else begin
            pc <= next_pc;
        end
    end

    // Instruction memory
    assign imem_ena = !rst_i;
    assign imem_addr = IMEM_ADDR_WIDTH'(pc);

    // pipeline
    always_ff @ (posedge clk_i, posedge rst_i) begin
        imem2if_pc <= pc;
        if2id_pc<= imem2if_pc;

        if (rst_i) begin
            if2id_imem_rdata <= '0;
        end
        else if (branch_flag == 'b1) begin : IF2ID_BRANCH_HAZARD
            if2id_imem_rdata <= NOP_VALUE;
        end
        else if (branch_flag_d == 'b1) begin : IF2ID_BRANCH_HAZARD_DELAYED
            if2id_imem_rdata <= NOP_VALUE;
        end
        else if ((data_hazard_stall == '0) && (data_hazard_stall_d == 1'b1)) begin : NEGEDGE_OF_DATA_HAZARD_STALL
            if2id_imem_rdata <= if2id_imem_rdata_stall;
        end
        else if (data_hazard_stall != '0) begin : DATA_HAZARD_STALL_OCCURRED
            if2id_imem_rdata <= if2id_imem_rdata;
            if2id_imem_rdata_stall <= imem_rdata;
        end
        else begin
            if2id_imem_rdata <= imem_rdata;
        end
    end


    // =============================================
    //  ID: Instruction decode (and register fetch)
    // =============================================
    logic [REG_ADDR_WIDTH-1:0] rs1_addr, rs2_addr, rs3_addr, wb_addr;
    logic [XLEN-1:0] rs1_val, rs2_val, rs3_val, res_val;
    logic [XLEN-1:0] imm;
    logic [XLEN-1:0] ope_1, ope_2, ope_3;
    opcode_e opcode;
    alu_e alu_type;
    ope_sel_e ope_sel;
    data_size_e data_size;
    logic is_load;
    logic is_store;
    logic is_op32;
    logic is_branch;
    /* verilator lint_off UNDRIVEN */
    typedef enum logic[1:0] {
        NONE,
        FROM_EX,
        FROM_MEM,
        FROM_WB
    } forwarding_e;
    forwarding_e forwarding1, forwarding2, forwarding3;  // debug signals
    /* verilator lint_on UNDRIVEN */
    // pipeline registers
    logic [XLEN-1:0] id2exe_pc = '0;
    logic [XLEN-1:0] id2exe_ope_1 = '0;
    logic [XLEN-1:0] id2exe_ope_2 = '0;
    logic [XLEN-1:0] id2exe_ope_3 = '0;
    logic [XLEN-1:0] id2exe_rs2_val;
    logic [REG_ADDR_WIDTH-1:0] id2exe_wb_addr;
    logic id2exe_is_load;
    logic id2exe_is_store;
    logic id2exe_is_op32;
    logic id2exe_is_branch;
    alu_e  id2exe_alu_type;
    data_size_e id2exe_data_size;

    decoder decoder (
        .inst_i(if2id_imem_rdata),
        .rs1_addr_o(rs1_addr),
        .rs2_addr_o(rs2_addr),
        .rs3_addr_o(rs3_addr),
        .rd_addr_o(wb_addr),
        .imm_o(imm),
        .opcode_o(opcode),
        .alu_type_o(alu_type),
        .ope_sel_o(ope_sel),
        .data_size_o(data_size)
    );

    /* register fetch */
    assign rs1_if.addr = rs1_addr;
    assign rs2_if.addr = rs2_addr;
    assign rs3_if.addr = rs3_addr;

    always_comb begin : RS1
        if ((rs1_addr == id2exe_wb_addr) && (id2exe_is_load == '0)) begin : FORWADING_FROM_EX
            forwarding1 = FROM_EX;
            rs1_val = res_val;
        end
        else if (rs1_addr == exe2mem_wb_addr) begin : FORWADING_FROM_MEM
            forwarding1 = FROM_MEM;
            rs1_val = mem_out;
        end
        else if (rs1_addr == mem2wb_wb_addr ) begin : FORWADING_FROM_WB
            forwarding1 = FROM_WB;
            rs1_val = mem2wb_mem_out;
        end
        else begin
            forwarding1 = NONE;
            rs1_val = rs1_if.data;
        end
    end

    always_comb begin : RS2
        if ((rs2_addr == id2exe_wb_addr) && (id2exe_is_load == '0)) begin : FORWADING_FROM_EX
            forwarding2 = FROM_EX;
            rs2_val = res_val;
        end
        else if (rs2_addr == exe2mem_wb_addr) begin : FORWADING_FROM_MEM
            forwarding2 = FROM_MEM;
            rs2_val = mem_out;
        end
        else if (rs2_addr == mem2wb_wb_addr ) begin : FORWADING_FROM_WB
            forwarding2 = FROM_WB;
            rs2_val = mem2wb_mem_out;
        end
        else begin
            forwarding2 = NONE;
            rs2_val = rs2_if.data;
        end
    end

    always_comb begin : RS3
        if ((rs3_addr == id2exe_wb_addr) && (id2exe_is_load == '0)) begin : FORWADING_FROM_EX
            forwarding3 = FROM_EX;
            rs3_val = res_val;
        end
        else if (rs3_addr == exe2mem_wb_addr) begin : FORWADING_FROM_MEM
            forwarding3 = FROM_MEM;
            rs3_val = mem_out;
        end
        else if (rs3_addr == mem2wb_wb_addr ) begin : FORWADING_FROM_WB
            forwarding3 = FROM_WB;
            rs3_val = mem2wb_mem_out;
        end
        else begin
            forwarding3 = NONE;
            rs3_val = rs3_if.data;
        end
    end

    /* data hazard signal */
    assign data_hazard_stall[0] = ((rs1_addr == id2exe_wb_addr) && (id2exe_is_load == '1) && (ope_sel != OPE_NOP)) ? 1'b1 : 1'b0;
    assign data_hazard_stall[1] = ((rs2_addr == id2exe_wb_addr) && (id2exe_is_load == '1) && ((ope_sel == OPE_RS1_RS2) || (ope_sel == OPE_RS1_RS2_RS3))) ? 1'b1 : 1'b0;
    assign data_hazard_stall[2] = ((rs3_addr == id2exe_wb_addr) && (id2exe_is_load == '1) && (ope_sel == OPE_RS1_RS2_RS3)) ? 1'b1 : 1'b0;

    always_ff @ (posedge clk_i, posedge rst_i) begin
        if (rst_i) begin
            data_hazard_stall_d <= 1'b0;
        end
        else begin
            data_hazard_stall_d <= |data_hazard_stall;
        end
    end

    always_ff @ (forwarding1, forwarding2, forwarding3) begin
    end

    /* operand select */
    always_comb begin : OPERAND_SELECT 
        unique case(ope_sel)
            OPE_NOP: begin
                ope_1 = '0;
                ope_2 = '0;
                ope_3 = '0;
            end
            OPE_RS1_IMM: begin
                ope_1 = rs1_val;
                ope_2 = imm;
                ope_3 = '0;
            end
            OPE_RS1_RS2: begin
                ope_1 = rs1_val;
                ope_2 = rs2_val;
                ope_3 = '0;
            end
            OPE_RS1_RS2_RS3: begin
                ope_1 = rs1_val;
                ope_2 = rs2_val;
                ope_3 = rs3_val;
            end
            OPE_RS1_RS2_IMM: begin
                ope_1 = rs1_val;
                ope_2 = rs2_val;
                ope_3 = imm;    // for BRANCH and JAL instructions 
            end
            default: begin
                ope_1 = '0;
                ope_2 = '0;
                ope_3 = '0;
            end
        endcase
    end


    always_comb begin : INST_LOAD_STORE
        if(opcode == LOAD) begin
            is_load = '1;
            is_store = '0;
            is_op32 = '0;
            is_branch = '0;
        end
        else if (opcode == STORE) begin
            is_load = '0;
            is_store = '1;
            is_op32 = '0;
            is_branch = '0;
        end
        else if (opcode inside {OP_32, OP_IMM_32}) begin
            is_load = '0;
            is_store = '0;
            is_op32 = '1;
            is_branch = '0;
        end
        else if (opcode inside {BRANCH, JAL_OP, JALR_OP}) begin
            is_load = '0;
            is_store = '0;
            is_op32 = '0;
            is_branch = '1;
        end
        else begin
            is_load = '0;
            is_store = '0;
            is_op32 = '0;
            is_branch = '0;
        end
    end


    // pipeline
    always_ff @ (posedge clk_i, posedge rst_i) begin
        id2exe_pc <= if2id_pc;

        if (rst_i) begin
            id2exe_ope_1 <= '0;
            id2exe_ope_2 <= '0;
            id2exe_ope_3 <= '0;
            id2exe_alu_type <= id2exe_alu_type;
//            id2exe_ope_sel <= id2exe_ope_sel;
            id2exe_data_size <= id2exe_data_size;
            id2exe_wb_addr <= '0;
            id2exe_is_load <= '0;
            id2exe_is_store <= '0;
            id2exe_is_op32 <= '0;
            id2exe_is_branch <= '0;
            id2exe_rs2_val <= '0;
        end
        else if (branch_flag == 'b1) begin : ID2EXE_BRANCH_HAZARD 
            id2exe_ope_1 <= '0;
            id2exe_ope_2 <= '0;
            id2exe_ope_3 <= '0;
            id2exe_alu_type <= ALU_NOP;
//            id2exe_ope_sel <= id2exe_ope_sel;
            id2exe_data_size <= id2exe_data_size;
            id2exe_wb_addr <= '0;
            id2exe_is_load <= '0;
            id2exe_is_store <= '0;
            id2exe_is_op32 <= '0;
            id2exe_is_branch <= '0;
            id2exe_rs2_val <= '0;
        end
        else if (data_hazard_stall != '0) begin : DATA_HAZARD
            id2exe_ope_1 <= '0;
            id2exe_ope_2 <= '0;
            id2exe_ope_3 <= '0;
            id2exe_alu_type <= ALU_NOP;
//            id2exe_ope_sel <= id2exe_ope_sel;
            id2exe_data_size <= id2exe_data_size;
            id2exe_wb_addr <= '0;
            id2exe_is_load <= '0;
            id2exe_is_store <= '0;
            id2exe_is_op32 <= '0;
            id2exe_is_branch <= '0;
            id2exe_rs2_val <= '0;
        end
        else begin  : USUAL
            id2exe_ope_1 <= ope_1;
            id2exe_ope_2 <= ope_2;
            id2exe_ope_3 <= ope_3;
            id2exe_alu_type <= alu_type;
            id2exe_data_size <= data_size;
            id2exe_wb_addr <= wb_addr;
            id2exe_is_load <= is_load;
            id2exe_is_store <= is_store;
            id2exe_is_op32 <= is_op32;
            id2exe_is_branch <= is_branch;
            id2exe_rs2_val <= rs2_val;
        end
    end

    // ============================
    //  EX: Instruction execute 
    // ============================
    logic branch_flag;
    logic branch_flag_d;
    // pipeline registers
    logic [XLEN-1:0] exe2mem_rs2_val = '0;
    logic [REG_ADDR_WIDTH-1:0] exe2mem_wb_addr = '0;
    logic exe2mem_is_load;
    logic exe2mem_is_store;
    data_size_e exe2mem_data_size;
    logic [XLEN-1:0] exe2mem_res_val;

    alu alu (
        .alu_type_i(id2exe_alu_type),
        .src1_val_i(id2exe_ope_1),
        .src2_val_i(id2exe_ope_2),
        .src3_val_i(id2exe_ope_3),
        .pc_i(id2exe_pc),
        .is_op32_i(id2exe_is_op32),
        .is_branch_i(id2exe_is_branch),
        .dest_val_o(res_val),
        .pc_branch_o(pc_branch),
        .branch_flag_o(branch_flag)
    );

    always_ff @ (posedge clk_i) begin
        branch_flag_d <= branch_flag;
    end

    // pipeline
    always_ff @ (posedge clk_i, posedge rst_i) begin
        if (rst_i) begin
            exe2mem_res_val <= '0;
            exe2mem_wb_addr <= '0;
            exe2mem_is_load <= '0;
            exe2mem_is_store <= '0;
            exe2mem_rs2_val <= '0;
        end
        else begin
            exe2mem_res_val <= res_val;
            exe2mem_wb_addr <= id2exe_wb_addr;
            exe2mem_is_load <= id2exe_is_load;
            exe2mem_is_store <= id2exe_is_store;
            exe2mem_rs2_val <= id2exe_rs2_val;
        end

        exe2mem_data_size <= id2exe_data_size; 
    end

    // ============================
    //  MEM: Memory access
    // ============================
    logic [XLEN-1:0] load_val;
    logic [XLEN-1:0] mem_out;
    // pipeline registers
    logic [REG_ADDR_WIDTH-1:0] mem2wb_wb_addr = '0;
    logic mem2wb_is_store;
    logic [DMEM_DATA_WIDTH-1:0] mem2wb_mem_out = '0;

    /* Data memory */
    assign dmem_ena = !rst_i;
//    assign dmem_addr = $bits(dmem_addr)'(exe2mem_res_val);
    assign dmem_addr = $bits(dmem_addr)'(res_val); // read latency of dmem is 1-clock-cycle

    /* store */
    assign dmem_web = exe2mem_is_store;

    always_comb begin : STORE_DATA_SIZE
        unique case(exe2mem_data_size)
            BYTE_U: begin
                dmem_wdata = XLEN'($unsigned(exe2mem_rs2_val[7:0]));
            end
            HALF_U: begin
                dmem_wdata = XLEN'($unsigned(exe2mem_rs2_val[15:0]));
            end
            WORD_U: begin
                dmem_wdata = XLEN'($unsigned(exe2mem_rs2_val[31:0]));
            end
            DOUBLE_S: begin
                dmem_wdata = exe2mem_rs2_val;
            end
            default: begin
                dmem_wdata = exe2mem_rs2_val;
            end
        endcase
    end
    
    /* load */
    always_comb begin : DMEM_DATA_SIZE
        unique case(exe2mem_data_size)
            BYTE_S: begin
                load_val = XLEN'($signed(dmem_rdata[7:0]));
            end
            BYTE_U: begin
                load_val = XLEN'($unsigned(dmem_rdata[7:0]));
            end
            HALF_S: begin
                load_val = XLEN'($signed(dmem_rdata[15:0]));
            end
            HALF_U: begin
                load_val = XLEN'($unsigned(dmem_rdata[15:0]));
            end
            WORD_S: begin
                load_val = XLEN'($signed(dmem_rdata[31:0]));
            end
            WORD_U: begin
                load_val = XLEN'($unsigned(dmem_rdata[31:0]));
            end
            DOUBLE_S: begin
                load_val = dmem_rdata;
            end
            default: begin
                load_val = dmem_rdata;
            end
        endcase
    end

    /* output signals from MEM stage */
    assign mem_out = (exe2mem_is_load) ? load_val : exe2mem_res_val;

    // pipeline
    always_ff @ (posedge clk_i, posedge rst_i) begin
        if (rst_i) begin
            mem2wb_mem_out <= '0;
            mem2wb_wb_addr <= '0;
            mem2wb_is_store <= '0;
        end
        else begin
            mem2wb_mem_out <= mem_out;
            mem2wb_wb_addr <= exe2mem_wb_addr;
            mem2wb_is_store <= exe2mem_is_store;
        end
    end


    // ============================
    //  WB: Write back
    // ============================
    always_comb begin : WB
        if (mem2wb_wb_addr == '0) begin
            rd_if.web = '0;
        end
        else if (mem2wb_is_store == 1'b1) begin : STORE
            rd_if.web = '0;
        end
        else begin
            rd_if.web = '1;
        end
    end

    assign rd_if.addr = mem2wb_wb_addr;
    assign rd_if.data = mem2wb_mem_out;



endmodule

`default_nettype wire 



