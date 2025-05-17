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

`default_nettype none 

module decoder import pkg_instructions::*;(
        input logic[ILEN-1:0] inst_i,
        output logic [4:0] rs1_addr_o, 
        output logic [4:0] rs2_addr_o, 
        output logic [4:0] rs3_addr_o, 
        output logic [4:0] rd_addr_o, 
//        output logic [2:0] funct3,
//        output logic [6:0] funct7,
        output logic [XLEN-1:0] imm_o,
        output opcode_e opcode_o,
        output alu_e alu_type_o,
        output ope_sel_e ope_sel_o,
        output data_size_e data_size_o
    );

    import pkg_parameters::ILEN, pkg_parameters::XLEN;

//    logic inst_compressed = '0;
    logic [OPCODE_BITS-1:0] opcode = '0;
    inst_type_e inst_type;
    instruction_e inst;
    alu_e alu_type;
    ope_sel_e ope_sel;
    data_size_e data_size;
//    logic [4:0] rs1_addr, rs2_addr, rs3_addr, rd_addr;
//    logic [2:0] funct3;
//    logic [6:0] funct7;
    logic [XLEN-1:0] imm;

//    assign funct7 = inst_i[31:25];
    assign rs3_addr_o = inst_i[31:27];
    assign rs2_addr_o = inst_i[24:20];
    assign rs1_addr_o = inst_i[19:15];
//    assign funct3 = inst_i[14:12];
    assign rd_addr_o = (opcode_o inside {STORE, STORE_FP, BRANCH}) ? '0 : inst_i[11:7];
    assign opcode = inst_i[OPCODE_BITS-1:0];
//    assign inst_compressed = (opcode[1:0] == 2'b11) ? 1'b0 : 1'b1;
    assign imm_o = imm;
    assign alu_type_o = alu_type;
    assign ope_sel_o = ope_sel;
    assign data_size_o = data_size;

    always_comb begin : ASSIGN_OPCODE 
        unique case (opcode)
            7'b00_000_11: begin
                opcode_o = LOAD;
            end
            7'b00_001_11: begin
                opcode_o = LOAD_FP;
            end
        //    CUSTOM_0 =  7'b00_010_11,
            7'b00_011_11: begin
                opcode_o = MISC_MEM;
            end
            7'b00_100_11: begin
                opcode_o = OP_IMM;
            end
            7'b00_101_11: begin
                opcode_o = AUIPC_OP;
            end
            7'b00_110_11: begin
                opcode_o = OP_IMM_32;
            end
            7'b01_000_11: begin
                opcode_o = STORE;
            end
            7'b01_001_11: begin
                opcode_o = STORE_FP;
            end
        //    CUSTOM_1 =  7'b01_010_11,
            7'b01_011_11: begin
                opcode_o = AMO;
            end
            7'b01_100_11: begin
                opcode_o = OP;
            end
            7'b01_101_11: begin
                opcode_o = LUI_OP;
            end
            7'b01_110_11: begin
                opcode_o = OP_32;
            end
            7'b10_000_11: begin
                opcode_o = MADD;
            end
            7'b10_001_11: begin
                opcode_o = MSUB;
            end
            7'b10_010_11: begin
                opcode_o = NMSUB;
            end
            7'b10_011_11: begin
                opcode_o = NMADD;
            end
            7'b10_100_11: begin
                opcode_o = OP_FP;
            end
            7'b10_101_11: begin
                opcode_o = OP_V;
            end
        //    CUSTOM_2_RV128 = 7'b10_110_11,
            7'b11_000_11: begin
                opcode_o = BRANCH;
            end
            7'b11_001_11: begin
                opcode_o = JALR_OP;
            end
        //    RESERVED =  7'b11_010_11,
            7'b11_011_11: begin
                opcode_o = JAL_OP;
            end
            7'b11_100_11: begin
                opcode_o = SYSTEM;
            end
            7'b11_101_11: begin
                opcode_o = OP_VE;
            end
            default : begin
                opcode_o = RESERVED;
            end
        endcase
    end

    // to avoid Warning-UNUSEDSIGNAL
    always_ff @ (inst) begin
    end

    always_comb begin : IMMEDIATE 
        unique case(inst_type)
            R_TYPE: begin     // register (_rs2, _rs2, rd)
                imm = '0;
            end
            R4_TYPE: begin    // 4-register (_rs1, _rs2, _rs3, rd)
                imm = '0;
            end
            I_TYPE: begin     // immediate
                imm = XLEN'($signed(inst_i[31:20]));
            end
            S_TYPE: begin     // store
                imm = XLEN'($signed({inst_i[31:25], inst_i[11:7]}));
            end
            B_TYPE: begin     // branch
                imm = XLEN'($signed({inst_i[31], inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0}));
            end
            U_TYPE: begin     // upper immediate
                imm = XLEN'($signed({inst_i[31:12], 12'd0}));
            end
            J_TYPE: begin      // jump
                imm = XLEN'($signed({inst_i[31], inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0}));
            end
            default: begin   
                imm = '0;
            end
        endcase
    end

    always_comb begin : INSTRUCTION 
        unique casez(inst_i)
            // load immediate 
            LUI_VALUE: begin
                inst_type = U_TYPE;
                inst = LUI;
                alu_type = ALU_LUI;
                ope_sel = OPE_RS1_RS2_IMM;
            end
            AUIPC_VALUE: begin
                inst_type = U_TYPE;
                inst = AUIPC;
                alu_type = ALU_AUIPC;
                ope_sel = OPE_RS1_RS2_IMM;
            end
            // Jumps
            JAL_VALUE: begin
                inst_type = J_TYPE;
                inst = JAL;
                alu_type = ALU_JAL;
                ope_sel = OPE_RS1_RS2_IMM;  // same as BRANCH instructions
            end
            JALR_VALUE: begin
                inst_type = I_TYPE;
                inst = JALR;
                alu_type = ALU_JALR;
                ope_sel = OPE_RS1_IMM;
            end
            // Conditional Branches
            BEQ_VALUE: begin
                inst_type = B_TYPE;
                inst = BEQ;
                alu_type = ALU_EQ;
                ope_sel = OPE_RS1_RS2_IMM;
            end
            BNE_VALUE: begin
                inst_type = B_TYPE;
                inst = BNE;
                alu_type = ALU_NE;
                ope_sel = OPE_RS1_RS2_IMM;
            end
            BLT_VALUE: begin
                inst_type = B_TYPE;
                inst = BLT;
                alu_type = ALU_LT;
                ope_sel = OPE_RS1_RS2_IMM;
            end
            BGE_VALUE: begin
                inst_type = B_TYPE;
                inst = BGE;
                alu_type = ALU_GE;
                ope_sel = OPE_RS1_RS2_IMM;
            end
            BLTU_VALUE: begin
                inst_type = B_TYPE;
                inst = BLTU;
                alu_type = ALU_LTU;
                ope_sel = OPE_RS1_RS2_IMM;
            end
            BGEU_VALUE: begin
                inst_type = B_TYPE;
                inst = BGEU;
                alu_type = ALU_GEU;
                ope_sel = OPE_RS1_RS2_IMM;
            end
            // Load
            LB_VALUE: begin
                inst_type = I_TYPE;
                inst = LB;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_IMM;
                data_size = BYTE_S;
            end
            LH_VALUE: begin
                inst_type = I_TYPE;
                inst = LH;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_IMM;
                data_size = HALF_S;
            end
            LW_VALUE: begin
                inst_type = I_TYPE;
                inst = LW;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_IMM;
                data_size = WORD_S;
            end
            LBU_VALUE: begin
                inst_type = I_TYPE;
                inst = LBU;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_IMM;
                data_size = BYTE_U;
            end
            LHU_VALUE: begin
                inst_type = I_TYPE;
                inst = LHU;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_IMM;
                data_size = HALF_U;
            end
            // Store
            SB_VALUE: begin
                inst_type = S_TYPE;
                inst = SB;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_IMM;
                data_size = BYTE_U;
            end
            SH_VALUE: begin
                inst_type = S_TYPE;
                inst = SH;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_IMM;
                data_size = HALF_U;
            end
            SW_VALUE: begin
                inst_type = S_TYPE;
                inst = SW;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_IMM;
                data_size = WORD_U;
            end
            // Integer Register-Immediate
            ADDI_VALUE: begin
                inst_type = I_TYPE;
                inst = ADDI;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_IMM;
            end
            SLTI_VALUE: begin
                inst_type = I_TYPE;
                inst = SLTI;
                alu_type = ALU_LT;
                ope_sel = OPE_RS1_IMM;
            end
            SLTIU_VALUE: begin
                inst_type = I_TYPE;
                inst = SLTIU;
                alu_type = ALU_LTU;
                ope_sel = OPE_RS1_IMM;
            end
            XORI_VALUE: begin
                inst_type = I_TYPE;
                inst = XORI;
                alu_type = ALU_XOR;
                ope_sel = OPE_RS1_IMM;
            end
            ORI_VALUE: begin
                inst_type = I_TYPE;
                inst = ORI;
                alu_type = ALU_OR;
                ope_sel = OPE_RS1_IMM;
            end
            ANDI_VALUE: begin
                inst_type = I_TYPE;
                inst = ANDI;
                alu_type = ALU_AND;
                ope_sel = OPE_RS1_IMM;
            end
            //    SLLI =      {7'b000_0000, imm_5, rs1, 3'b001, rd, OP_IMM},        // 64-bit instruction is listed below.
            //    SRLI =      {7'b000_0000, imm_5, rs1, 3'b101, rd, OP_IMM},
            //    SRAI =      {7'b010_0000, imm_5, rs1, 3'b101, rd, OP_IMM},
            // Integer Register-Register Operations
            ADD_VALUE: begin
                inst_type = R_TYPE;
                inst = ADD;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_RS2;
            end
            SUB_VALUE: begin
                inst_type = R_TYPE;
                inst = SUB;
                alu_type = ALU_SUB;
                ope_sel = OPE_RS1_RS2;
            end
            SLT_VALUE: begin
                inst_type = R_TYPE;
                inst = SLT;
                alu_type = ALU_LT;
                ope_sel = OPE_RS1_RS2;
            end
            SLTU_VALUE: begin
                inst_type = R_TYPE;
                inst = SLTU;
                alu_type = ALU_LTU;
                ope_sel = OPE_RS1_RS2;
            end
            SLL_VALUE: begin
                inst_type = R_TYPE;
                inst = SLL;
                alu_type = ALU_SLL;
                ope_sel = OPE_RS1_RS2;
            end
            SRL_VALUE: begin
                inst_type = R_TYPE;
                inst = SRL;
                alu_type = ALU_SRL;
                ope_sel = OPE_RS1_RS2;
            end
            SRA_VALUE: begin
                inst_type = R_TYPE;
                inst = SRA;
                alu_type = ALU_SRA;
                ope_sel = OPE_RS1_RS2;
            end
            XOR_VALUE: begin
                inst_type = R_TYPE;
                inst = XOR;
                alu_type = ALU_XOR;
                ope_sel = OPE_RS1_RS2;
            end
            OR_VALUE: begin
                inst_type = R_TYPE;
                inst = OR;
                alu_type = ALU_OR;
                ope_sel = OPE_RS1_RS2;
            end
            AND_VALUE: begin
                inst_type = R_TYPE;
                inst = AND;
                alu_type = ALU_AND;
                ope_sel = OPE_RS1_RS2;
            end
            // Memory Ordering
            FENCE_VALUE: begin
                inst_type = I_TYPE;
                inst = FENCE;
            end
            FENCE_TSO_VALUE: begin
                inst_type = I_TYPE;
                inst = FENCE_TSO;
            end
            PAUSE_VALUE: begin
                inst_type = I_TYPE;
                inst = PAUSE;
            end
            // Environment Call and Breakpoints
            ECALL_VALUE: begin
                inst_type = I_TYPE;
                inst = ECALL;
            end
            EBREAK_VALUE: begin
                inst_type = I_TYPE;
                inst = EBREAK;
            end
            // NOP (NOP is same as ADDI_VALUE. If NOP is here, it will violate the unique casez rule.)
//            NOP_VALUE: begin
//                inst_type = I_TYPE;
//                inst = NOP;
//                alu_type = ALU_NOP;
//                ope_sel = OPE_NOP;
//            end

            /* RV64I Base Instruction Set (in addition to RV32I) (pp. 556) */
            // Load and Store
            LWU_VALUE: begin
                inst_type = I_TYPE;
                inst = LWU;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_IMM;
            end
            LD_VALUE: begin
                inst_type = I_TYPE;
                inst = LD;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_IMM;
            end
            SD_VALUE: begin
                inst_type = S_TYPE;
                inst = SD;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_IMM;
            end
            // Integer Register-Immediate
            SLLI_VALUE: begin
                inst_type = I_TYPE;
                inst = SLLI;
                alu_type = ALU_SLL;
                ope_sel = OPE_RS1_IMM;
            end
            SRLI_VALUE: begin
                inst_type = I_TYPE;
                inst = SRLI;
                alu_type = ALU_SRL;
                ope_sel = OPE_RS1_IMM;
            end
            SRAI_VALUE: begin
                inst_type = I_TYPE;
                inst = SRAI;
                alu_type = ALU_SRA;
                ope_sel = OPE_RS1_IMM;
            end
            ADDIW_VALUE: begin
                inst_type = I_TYPE;
                inst = ADDIW;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_IMM;
            end
            SLLIW_VALUE: begin
                inst_type = I_TYPE;
                inst = SLLIW;
                alu_type = ALU_SLL;
                ope_sel = OPE_RS1_IMM;
            end
            SRLIW_VALUE: begin
                inst_type = I_TYPE;
                inst = SRLIW;
                alu_type = ALU_SRL;
                ope_sel = OPE_RS1_IMM;
            end
            SRAIW_VALUE: begin
                inst_type = I_TYPE;
                inst = SRAIW;
                alu_type = ALU_SRA;
                ope_sel = OPE_RS1_IMM;
            end
            // Integer Register-Register
            ADDW_VALUE: begin
                inst_type = R_TYPE;
                inst = ADDW;
                alu_type = ALU_ADD;
                ope_sel = OPE_RS1_RS2;
            end
            SUBW_VALUE: begin
                inst_type = R_TYPE;
                inst = SUBW;
                alu_type = ALU_SUB;
                ope_sel = OPE_RS1_RS2;
            end
            SLLW_VALUE: begin
                inst_type = R_TYPE;
                inst = SLLW;
                alu_type = ALU_SLL;
                ope_sel = OPE_RS1_RS2;
            end
            SRLW_VALUE: begin
                inst_type = R_TYPE;
                inst = SRLW;
                alu_type = ALU_SRL;
                ope_sel = OPE_RS1_RS2;
            end
            SRAW_VALUE: begin
                inst_type = R_TYPE;
                inst = SRAW;
                alu_type = ALU_SRA;
                ope_sel = OPE_RS1_RS2;
            end
            /* RV32/RV64 Zifencei Standard Extension (pp. 44-45, 556) */
            FENCE_I_VALUE: begin
                inst_type = R_TYPE;
                inst = FENCE_I;
            end

            /* RV32/RV64 Zicsr Standard Extension (pp. 46-49, 556) */
            CSRRW_VALUE: begin
                inst_type = I_TYPE;
                inst = CSRRW;
                alu_type = ALU_CSR_RW;
                ope_sel = OPE_CSR_RS1;
            end
            CSRRS_VALUE: begin
                inst_type = I_TYPE;
                inst = CSRRS;
                alu_type = ALU_CSR_RS;
                ope_sel = OPE_CSR_RS1;
            end
            CSRRC_VALUE: begin
                inst_type = I_TYPE;
                inst = CSRRC;
                alu_type = ALU_CSR_RC;
                ope_sel = OPE_CSR_RS1;
            end
            CSRRWI_VALUE: begin
                inst_type = I_TYPE;
                inst = CSRRWI;
                alu_type = ALU_CSR_RW;
                ope_sel = OPE_CSR_UIMM;
            end
            CSRRSI_VALUE: begin
                inst_type = I_TYPE;
                inst = CSRRSI;
                alu_type = ALU_CSR_RS;
                ope_sel = OPE_CSR_UIMM;
            end
            CSRRCI_VALUE: begin
                inst_type = I_TYPE;
                inst = CSRRCI;
                alu_type = ALU_CSR_RC;
                ope_sel = OPE_CSR_UIMM;
            end

            /* RV32M Standard Extension (pp. 65-67, 556) */
            MUL_VALUE: begin
                inst_type = R_TYPE;
                inst = MUL;
            end
            MULH_VALUE: begin
                inst_type = R_TYPE;
                inst = MULH;
            end
            MULHSU_VALUE: begin
                inst_type = R_TYPE;
                inst = MULHSU;
            end
            MULHU_VALUE: begin
                inst_type = R_TYPE;
                inst = MULHU;
            end
            DIV_VALUE: begin
                inst_type = R_TYPE;
                inst = DIV;
            end
            DIVU_VALUE: begin
                inst_type = R_TYPE;
                inst = DIVU;
            end
            REM_VALUE: begin
                inst_type = R_TYPE;
                inst = REM;
            end
            REMU_VALUE: begin
                inst_type = R_TYPE;
                inst = REMU;
            end

            /* RV64M Standard Extension (in addition to RV32M) (pp. 65-67, 557) */
            MULW_VALUE: begin
                inst_type = R_TYPE;
                inst = MULW;
            end
            DIVW_VALUE: begin
                inst_type = R_TYPE;
                inst = DIVW;
            end
            DIVUW_VALUE: begin
                inst_type = R_TYPE;
                inst = DIVUW;
            end
            REMW_VALUE: begin
                inst_type = R_TYPE;
                inst = REMW;
            end
            REMUW_VALUE: begin
                inst_type = R_TYPE;
                inst = REMUW;
            end

            /* RV32A Standard Extension (pp. 68-76, 558) */
            LR_W_VALUE: begin
                inst_type = R_TYPE;
                inst = LR_W;
            end
            SC_W_VALUE: begin
                inst_type = R_TYPE;
                inst = SC_W;
            end
            AMOSWAP_W_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOSWAP_W;
            end
            AMOADD_W_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOADD_W;
            end
            AMOXOR_W_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOXOR_W;
            end
            AMOAND_W_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOAND_W;
            end
            AMOOR_W_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOOR_W;
            end
            AMOMIN_W_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOMIN_W;
            end
            AMOMAX_W_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOMAX_W;
            end
            AMOMINU_W_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOMINU_W;
            end
            AMOMAXU_W_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOMAXU_W;
            end

            /* RV64A Standard Extension (in addition to RV32A) (pp. 68-76, 558) */
            LR_D_VALUE: begin
                inst_type = R_TYPE;
                inst = LR_D;
            end
            SC_D_VALUE: begin
                inst_type = R_TYPE;
                inst = SC_D;
            end
            AMOSWAP_D_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOSWAP_D;
            end
            AMOADD_D_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOADD_D;
            end
            AMOXOR_D_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOXOR_D;
            end
            AMOAND_D_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOAND_D;
            end
            AMOOR_D_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOOR_D;
            end
            AMOMIN_D_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOMIN_D;
            end
            AMOMAX_D_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOMAX_D;
            end
            AMOMINU_D_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOMINU_D;
            end
            AMOMAXU_D_VALUE: begin
                inst_type = R_TYPE;
                inst = AMOMAXU_D;
            end

            /* RV32F Standard Extension (pp. 111-119, 559) */
            FLW_VALUE: begin
                inst_type = I_TYPE;
                inst = FLW;
            end
            FSW_VALUE: begin
                inst_type = S_TYPE;
                inst = FSW;
            end
            FMADD_S_VALUE: begin
                inst_type = R4_TYPE;
                inst = FMADD_S;
            end
            FMSUB_S_VALUE: begin
                inst_type = R4_TYPE;
                inst = FMSUB_S;
            end
            FNMSUB_S_VALUE: begin
                inst_type = R4_TYPE;
                inst = FNMSUB_S;
            end
            FNMADD_S_VALUE: begin
                inst_type = R4_TYPE;
                inst = FNMADD_S;
            end
            FADD_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FADD_S;
            end
            FSUB_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FSUB_S;
            end
            FMUL_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FMUL_S;
            end
            FDIV_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FDIV_S;
            end
            FSQRT_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FSQRT_S;
            end
            FSGNJ_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FSGNJ_S;
            end
            FSGNJN_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FSGNJN_S;
            end
            FSGNJX_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FSGNJX_S;
            end
            FMIN_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FMIN_S;
            end
            FMAX_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FMAX_S;
            end
            FCVT_W_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_W_S;
            end
            FCVT_WU_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_WU_S;
            end
            FMV_X_W_VALUE: begin
                inst_type = R_TYPE;
                inst = FMV_X_W;
            end
            FEQ_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FEQ_S;
            end
            FLT_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FLT_S;
            end
            FLE_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FLE_S;
            end
            FCLASS_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FCLASS_S;
            end
            FCVT_S_W_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_S_W;
            end
            FCVT_S_WU_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_S_WU;
            end
            FMV_W_X_VALUE: begin
                inst_type = R_TYPE;
                inst = FMV_W_X;
            end

            /* RV64F Standard Extension (in addition to RV32F) (pp. 68-76, 559) */
            FCVT_L_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_L_S;
            end
            FCVT_LU_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_LU_S;
            end
            FCVT_S_L_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_S_L;
            end
            FCVT_S_LU_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_S_LU;
            end

            /* RV32D Standard Extension (pp. 120-126, 560) */
            FLD_VALUE: begin
                inst_type = I_TYPE;
                inst = FLD;
            end
            FSD_VALUE: begin
                inst_type = S_TYPE;
                inst = FSD;
            end
            FMADD_D_VALUE: begin
                inst_type = R4_TYPE;
                inst = FMADD_D;
            end
            FMSUB_D_VALUE: begin
                inst_type = R4_TYPE;
                inst = FMSUB_D;
            end
            FNMSUB_D_VALUE: begin
                inst_type = R4_TYPE;
                inst = FNMSUB_D;
            end
            FNMADD_D_VALUE: begin
                inst_type = R4_TYPE;
                inst = FNMADD_D;
            end
            FADD_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FADD_D;
            end
            FSUB_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FSUB_D;
            end
            FMUL_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FMUL_D;
            end
            FDIV_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FDIV_D;
            end
            FSQRT_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FSQRT_D;
            end
            FSGNJ_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FSGNJ_D;
            end
            FSGNJN_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FSGNJN_D;
            end
            FSGNJX_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FSGNJX_D;
            end
            FMIN_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FMIN_D;
            end
            FMAX_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FMAX_D;
            end
            FCVT_S_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_S_D;
            end
            FCVT_D_S_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_D_S;
            end
            FEQ_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FEQ_D;
            end
            FLT_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FLT_D;
            end
            FLE_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FLE_D;
            end
            FCLASS_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FCLASS_D;
            end
            FCVT_W_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_W_D;
            end
            FCVT_WU_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_WU_D;
            end
            FCVT_D_W_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_D_W;
            end
            FCVT_D_WU_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_D_WU;
            end

            /* RV64D Standard Extension (in addition to RV32D) (pp. 120-126, 560) */
            FCVT_L_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_L_D;
            end
            FCVT_LU_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_LU_D;
            end
            FMV_X_D_VALUE: begin
                inst_type = R_TYPE;
                inst = FMV_X_D;
            end
            FCVT_D_L_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_D_L;
            end
            FCVT_D_LU_VALUE: begin
                inst_type = R_TYPE;
                inst = FCVT_D_LU;
            end
            FMV_D_X_VALUE: begin
                inst_type = R_TYPE;
                inst = FMV_D_X;
            end        
            default: begin
                inst_type = I_TYPE; // same as NOP
                inst = NOP;
                alu_type = ALU_NOP;
                ope_sel = OPE_NOP;
            end
        endcase
    end


endmodule

`default_nettype wire 




