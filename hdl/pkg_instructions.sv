`ifndef PKG_INSTRUCTIONS_SV
`define PKG_INSTRUCTIONS_SV
////////////////////////////////////////////////////////////////////////////////
// Engineer: akiaji-k
//
// Create Date:   2025-01-01
// Description: 
//
// Revision:
// Revision 0.01 - File Created
//
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`include "pkg_parameters.sv"

// ref. [The RISC-V Instruction Set Manual Volume I, Unprivileged Architecture, Version 20240411](https://drive.google.com/file/d/1uviu1nH-tScFfgrovvFCrj7Omv8tFtkp/view)
package pkg_instructions;

    import pkg_parameters::ILEN;
    localparam OPCODE_BITS = 7;

    /* registers and immediates */
    localparam logic[4:0] _rs1 = 5'h??;
    localparam logic[4:0] _rs2 = 5'h??;
    localparam logic[4:0] _rs3 = 5'h??;
    localparam logic[4:0] _rd = 5'h??;
    localparam logic[4:0] _imm_5 = 5'h??;
    localparam logic[5:0] _imm_6 = 6'h??;
    localparam logic[6:0] _imm_7 = 7'h??;
    localparam logic[11:0] _imm_12 = 12'h???;
    localparam logic[19:0] _imm_20 = 20'h?_????;
    localparam logic[11:0] _csr = 12'h???;

    /* opcode (pp. 553) */
    // 32-bit instructions have their lowest two bits set to "11".
    // 16-bit instructions have their lowest two bits set to 00, 01 or 10.
    typedef enum logic[OPCODE_BITS-1:0] {
        LOAD =      7'b00_000_11,
        LOAD_FP =   7'b00_001_11,
    //    CUSTOM_0 =  7'b00_010_11,
        MISC_MEM =  7'b00_011_11,
        OP_IMM =    7'b00_100_11,
        AUIPC_OP =  7'b00_101_11,
        OP_IMM_32 = 7'b00_110_11,

        STORE =     7'b01_000_11,
        STORE_FP =  7'b01_001_11,
    //    CUSTOM_1 =  7'b01_010_11,
        AMO =       7'b01_011_11,
        OP =        7'b01_100_11,
        LUI_OP =    7'b01_101_11,
        OP_32 =     7'b01_110_11,

        MADD =      7'b10_000_11,
        MSUB =      7'b10_001_11,
        NMSUB =     7'b10_010_11,
        NMADD =     7'b10_011_11,
        OP_FP =     7'b10_100_11,
        OP_V =      7'b10_101_11,
    //    CUSTOM_2_RV128 = 7'b10_110_11,

        BRANCH =    7'b11_000_11,
        JALR_OP =   7'b11_001_11,
        RESERVED =  7'b11_010_11,
        JAL_OP =    7'b11_011_11,
        SYSTEM =    7'b11_100_11,
        OP_VE =     7'b11_101_11
    //    CUSTOM_#_RV128 =     7'b11_110_11,
    } opcode_e;

    /* Instruction Type */
    typedef enum logic[2:0] {
        R_TYPE,     // register (_rs1, _rs2, rd)
        R4_TYPE,    // 4-register (_rs1, _rs2, _rs3, rd)
        I_TYPE,     // immediate
        S_TYPE,     // store
        B_TYPE,     // branch
        U_TYPE,     // upper immediate
        J_TYPE      // jump
    } inst_type_e;


    /* Instructions */
    typedef enum logic[7:0] {       // 159 instructions for RV64IMAFD_Zifencei_Zicsr
        /* RV32I Base Instruction Set (pp. 554) */
        // load immediate 
        LUI,
        AUIPC,
        
        // Jumps
        JAL,
        JALR,

        // Conditional Branches
        BEQ,
        BNE,
        BLT,
        BGE,
        BLTU,
        BGEU,

        // Load
        LB,
        LH,
        LW,
        LBU,
        LHU,

        // Store
        SB,
        SH,
        SW,

        // Integer Register-Immediate
        ADDI,
        SLTI,
        SLTIU,
        XORI,
        ORI,
        ANDI,
    //    SLLI =      {7'b000_0000, _imm_5, _rs1, 3'b001, _rd, OP_IMM},        // 64-bit instruction is listed below.
    //    SRLI =      {7'b000_0000, _imm_5, _rs1, 3'b101, _rd, OP_IMM},
    //    SRAI =      {7'b010_0000, _imm_5, _rs1, 3'b101, _rd, OP_IMM},

        // Integer Register-Register Operations
        ADD,
        SUB,
        SLL,
        SLT,
        SLTU,
        XOR,
        SRL,
        SRA,
        OR,
        AND,

        // Memory Ordering
        FENCE,
        FENCE_TSO,
        PAUSE,

        // Environment Call and Breakpoints
        ECALL,
        EBREAK,

        // NOP
        NOP,

        /* RV64I Base Instruction Set (in addition to RV32I) (pp. 556) */
        // Load and Store
        LWU,
        LD,
        SD,

        // Integer Register-Immediate
        SLLI,
        SRLI,
        SRAI,
        ADDIW,
        SLLIW,
        SRLIW,
        SRAIW,

        // Integer Register-Register
        ADDW,
        SUBW,
        SLLW,
        SRLW,
        SRAW,

        /* RV32/RV64 Zifencei Standard Extension (pp. 44-45, 556) */
        FENCE_I,

        /* RV32/RV64 Zicsr Standard Extension (pp. 46-49, 556) */
        CSRRW,
        CSRRS,
        CSRRC,
        CSRRWI,
        CSRRSI,
        CSRRCI,

        /* RV32M Standard Extension (pp. 65-67, 556) */
        MUL,
        MULH,
        MULHSU,
        MULHU,
        DIV,
        DIVU,
        REM,
        REMU,

        /* RV64M Standard Extension (in addition to RV32M) (pp. 65-67, 557) */
        MULW,
        DIVW,
        DIVUW,
        REMW,
        REMUW,

        /* RV32A Standard Extension (pp. 68-76, 558) */
        LR_W,
        SC_W,
        AMOSWAP_W,
        AMOADD_W,
        AMOXOR_W,
        AMOAND_W,
        AMOOR_W,
        AMOMIN_W,
        AMOMAX_W,
        AMOMINU_W,
        AMOMAXU_W,

        /* RV64A Standard Extension (in addition to RV32A) (pp. 68-76, 558) */
        LR_D,
        SC_D,
        AMOSWAP_D,
        AMOADD_D,
        AMOXOR_D,
        AMOAND_D,
        AMOOR_D,
        AMOMIN_D,
        AMOMAX_D,
        AMOMINU_D,
        AMOMAXU_D,

        /* RV32F Standard Extension (pp. 111-119, 559) */
        FLW,
        FSW,
        FMADD_S,
        FMSUB_S,
        FNMSUB_S,
        FNMADD_S,
        FADD_S,
        FSUB_S,
        FMUL_S,
        FDIV_S,
        FSQRT_S,
        FSGNJ_S,
        FSGNJN_S,
        FSGNJX_S,
        FMIN_S,
        FMAX_S,
        FCVT_W_S,
        FCVT_WU_S,
        FMV_X_W,
        FEQ_S,
        FLT_S,
        FLE_S,
        FCLASS_S,
        FCVT_S_W,
        FCVT_S_WU,
        FMV_W_X,

        /* RV64F Standard Extension (in addition to RV32F) (pp. 68-76, 559) */
        FCVT_L_S,
        FCVT_LU_S,
        FCVT_S_L,
        FCVT_S_LU,

        /* RV32D Standard Extension (pp. 120-126, 560) */
        FLD,
        FSD,
        FMADD_D,
        FMSUB_D,
        FNMSUB_D,
        FNMADD_D,
        FADD_D,
        FSUB_D,
        FMUL_D,
        FDIV_D,
        FSQRT_D,
        FSGNJ_D,
        FSGNJN_D,
        FSGNJX_D,
        FMIN_D,
        FMAX_D,
        FCVT_S_D,
        FCVT_D_S,
        FEQ_D,
        FLT_D,
        FLE_D,
        FCLASS_D,
        FCVT_W_D,
        FCVT_WU_D,
        FCVT_D_W,
        FCVT_D_WU,

        /* RV64D Standard Extension (in addition to RV32D) (pp. 120-126, 560) */
        FCVT_L_D,
        FCVT_LU_D,
        FMV_X_D,
        FCVT_D_L,
        FCVT_D_LU,
        FMV_D_X

    } instruction_e;


    /* RV32I Base Instruction Set (pp. 554) */
    // load immediate 
    localparam logic[ILEN-1:0] LUI_VALUE =       {_imm_20, _rd, LUI_OP};
    localparam logic[ILEN-1:0] AUIPC_VALUE =     {_imm_20, _rd, AUIPC_OP};
    
    // Jumps
    localparam logic[ILEN-1:0] JAL_VALUE =       {_imm_20, _rd, JAL_OP};
    localparam logic[ILEN-1:0] JALR_VALUE =      {_imm_12, _rs1, 3'b000, _rd, JALR_OP};

    // Conditional Branches
    localparam logic[ILEN-1:0] BEQ_VALUE =       {_imm_7, _rs2, _rs1, 3'b000, _imm_5, BRANCH};
    localparam logic[ILEN-1:0] BNE_VALUE =       {_imm_7, _rs2, _rs1, 3'b001, _imm_5, BRANCH};
    localparam logic[ILEN-1:0] BLT_VALUE =       {_imm_7, _rs2, _rs1, 3'b100, _imm_5, BRANCH};
    localparam logic[ILEN-1:0] BGE_VALUE =       {_imm_7, _rs2, _rs1, 3'b101, _imm_5, BRANCH};
    localparam logic[ILEN-1:0] BLTU_VALUE =      {_imm_7, _rs2, _rs1, 3'b110, _imm_5, BRANCH};
    localparam logic[ILEN-1:0] BGEU_VALUE =      {_imm_7, _rs2, _rs1, 3'b111, _imm_5, BRANCH};

    // Load
    localparam logic[ILEN-1:0] LB_VALUE =        {_imm_12, _rs1, 3'b000, _rd, LOAD};
    localparam logic[ILEN-1:0] LH_VALUE =        {_imm_12, _rs1, 3'b001, _rd, LOAD};
    localparam logic[ILEN-1:0] LW_VALUE =        {_imm_12, _rs1, 3'b010, _rd, LOAD};
    localparam logic[ILEN-1:0] LBU_VALUE =       {_imm_12, _rs1, 3'b100, _rd, LOAD};
    localparam logic[ILEN-1:0] LHU_VALUE =       {_imm_12, _rs1, 3'b101, _rd, LOAD};

    // Store
    localparam logic[ILEN-1:0] SB_VALUE =        {_imm_7, _rs2, _rs1, 3'b000, _imm_5, STORE};
    localparam logic[ILEN-1:0] SH_VALUE =        {_imm_7, _rs2, _rs1, 3'b001, _imm_5, STORE};
    localparam logic[ILEN-1:0] SW_VALUE =        {_imm_7, _rs2, _rs1, 3'b010, _imm_5, STORE};

    // Integer Register-Immediate
    localparam logic[ILEN-1:0] ADDI_VALUE =      {_imm_12, _rs1, 3'b000, _rd, OP_IMM};
    localparam logic[ILEN-1:0] SLTI_VALUE =      {_imm_12, _rs1, 3'b010, _rd, OP_IMM};
    localparam logic[ILEN-1:0] SLTIU_VALUE =     {_imm_12, _rs1, 3'b011, _rd, OP_IMM};
    localparam logic[ILEN-1:0] XORI_VALUE =      {_imm_12, _rs1, 3'b100, _rd, OP_IMM};
    localparam logic[ILEN-1:0] ORI_VALUE =       {_imm_12, _rs1, 3'b110, _rd, OP_IMM};
    localparam logic[ILEN-1:0] ANDI_VALUE =      {_imm_12, _rs1, 3'b111, _rd, OP_IMM};
//    SLLI =      {7'b000_0000, _imm_5, _rs1, 3'b001, _rd, OP_IMM},        // 64-bit instruction is listed below.
//    SRLI =      {7'b000_0000, _imm_5, _rs1, 3'b101, _rd, OP_IMM},
//    SRAI =      {7'b010_0000, _imm_5, _rs1, 3'b101, _rd, OP_IMM},

    // Integer Register-Register Operations
    localparam logic[ILEN-1:0] ADD_VALUE =       {7'b000_0000, _rs2, _rs1, 3'b000, _rd, OP};
    localparam logic[ILEN-1:0] SUB_VALUE =       {7'b010_0000, _rs2, _rs1, 3'b000, _rd, OP};
    localparam logic[ILEN-1:0] SLL_VALUE =       {7'b000_0000, _rs2, _rs1, 3'b001, _rd, OP};
    localparam logic[ILEN-1:0] SLT_VALUE =       {7'b000_0000, _rs2, _rs1, 3'b010, _rd, OP};
    localparam logic[ILEN-1:0] SLTU_VALUE =      {7'b000_0000, _rs2, _rs1, 3'b011, _rd, OP};
    localparam logic[ILEN-1:0] XOR_VALUE =       {7'b000_0000, _rs2, _rs1, 3'b100, _rd, OP};
    localparam logic[ILEN-1:0] SRL_VALUE =       {7'b000_0000, _rs2, _rs1, 3'b101, _rd, OP};
    localparam logic[ILEN-1:0] SRA_VALUE =       {7'b010_0000, _rs2, _rs1, 3'b101, _rd, OP};
    localparam logic[ILEN-1:0] OR_VALUE =        {7'b000_0000, _rs2, _rs1, 3'b110, _rd, OP};
    localparam logic[ILEN-1:0] AND_VALUE =       {7'b000_0000, _rs2, _rs1, 3'b111, _rd, OP};

    // Memory Ordering
    localparam logic[ILEN-1:0] FENCE_VALUE =     {4'h?, 4'h?, 4'h?, _rs1, 3'b000, _rd, MISC_MEM};
    localparam logic[ILEN-1:0] FENCE_TSO_VALUE = {4'b1000, 4'b0011, 4'b0011, 5'h00, 3'b000, 5'h00, MISC_MEM};
    localparam logic[ILEN-1:0] PAUSE_VALUE =     {4'b0000, 4'b0001, 4'b0000, 5'h00, 3'b000, 5'h00, MISC_MEM};

    // Environment Call and Breakpoints
    localparam logic[ILEN-1:0] ECALL_VALUE =     {12'h000, 5'h00, 3'b000, 5'h00, SYSTEM};
    localparam logic[ILEN-1:0] EBREAK_VALUE =    {12'h001, 5'h00, 3'b000, 5'h00, SYSTEM};

    // NOP (ADDI x0, x0, 0)
    localparam logic[ILEN-1:0] NOP_VALUE =       {12'h000, 5'h00, 3'b000, 5'h00, OP_IMM};

    /* RV64I Base Instruction Set (in addition to RV32I) (pp. 556) */
    // Load and Store
    localparam logic[ILEN-1:0] LWU_VALUE =       {_imm_12, _rs1, 3'b110, _rd, LOAD};
    localparam logic[ILEN-1:0] LD_VALUE =        {_imm_12, _rs1, 3'b011, _rd, LOAD};
    localparam logic[ILEN-1:0] SD_VALUE =        {_imm_7, _rs2, _rs1, 3'b011, _imm_5, STORE};

    // Integer Register-Immediate
    localparam logic[ILEN-1:0] SLLI_VALUE =      {6'b00_0000, _imm_6, _rs1, 3'b001, _rd, OP_IMM};
    localparam logic[ILEN-1:0] SRLI_VALUE =      {6'b00_0000, _imm_6, _rs1, 3'b101, _rd, OP_IMM};
    localparam logic[ILEN-1:0] SRAI_VALUE =      {6'b01_0000, _imm_6, _rs1, 3'b101, _rd, OP_IMM};
    localparam logic[ILEN-1:0] ADDIW_VALUE =     {_imm_12, _rs1, 3'b000, _rd, OP_IMM_32};
    localparam logic[ILEN-1:0] SLLIW_VALUE =     {7'b000_0000, _imm_5, _rs1, 3'b001, _rd, OP_IMM_32};
    localparam logic[ILEN-1:0] SRLIW_VALUE =     {7'b000_0000, _imm_5, _rs1, 3'b101, _rd, OP_IMM_32};
    localparam logic[ILEN-1:0] SRAIW_VALUE =     {7'b010_0000, _imm_5, _rs1, 3'b101, _rd, OP_IMM_32};

    // Integer Register-Register
    localparam logic[ILEN-1:0] ADDW_VALUE =      {7'b000_0000, _rs2, _rs1, 3'b000, _rd, OP_32};
    localparam logic[ILEN-1:0] SUBW_VALUE =      {7'b010_0000, _rs2, _rs1, 3'b000, _rd, OP_32};
    localparam logic[ILEN-1:0] SLLW_VALUE =      {7'b000_0000, _rs2, _rs1, 3'b001, _rd, OP_32};
    localparam logic[ILEN-1:0] SRLW_VALUE =      {7'b000_0000, _rs2, _rs1, 3'b101, _rd, OP_32};
    localparam logic[ILEN-1:0] SRAW_VALUE =      {7'b010_0000, _rs2, _rs1, 3'b101, _rd, OP_32};

    /* RV32/RV64 Zifencei Standard Extension (pp. 44-45, 556) */
    localparam logic[ILEN-1:0] FENCE_I_VALUE =   {_imm_12, _rs1, 3'b001, _rd, MISC_MEM};

    /* RV32/RV64 Zicsr Standard Extension (pp. 46-49, 556) */
    localparam logic[ILEN-1:0] CSRRW_VALUE =     {_csr, _rs1, 3'b001, _rd, SYSTEM};
    localparam logic[ILEN-1:0] CSRRS_VALUE =     {_csr, _rs1, 3'b010, _rd, SYSTEM};
    localparam logic[ILEN-1:0] CSRRC_VALUE =     {_csr, _rs1, 3'b011, _rd, SYSTEM};
    localparam logic[ILEN-1:0] CSRRWI_VALUE =    {_csr, _imm_5, 3'b101, _rd, SYSTEM};
    localparam logic[ILEN-1:0] CSRRSI_VALUE =    {_csr, _imm_5, 3'b110, _rd, SYSTEM};
    localparam logic[ILEN-1:0] CSRRCI_VALUE =    {_csr, _imm_5, 3'b111, _rd, SYSTEM};

    /* RV32M Standard Extension (pp. 65-67, 556) */
    localparam logic[ILEN-1:0] MUL_VALUE =       {7'b000_0001, _rs2, _rs1, 3'b000, _rd, OP};
    localparam logic[ILEN-1:0] MULH_VALUE =      {7'b000_0001, _rs2, _rs1, 3'b001, _rd, OP};
    localparam logic[ILEN-1:0] MULHSU_VALUE =    {7'b000_0001, _rs2, _rs1, 3'b010, _rd, OP};
    localparam logic[ILEN-1:0] MULHU_VALUE =     {7'b000_0001, _rs2, _rs1, 3'b011, _rd, OP};
    localparam logic[ILEN-1:0] DIV_VALUE =       {7'b000_0001, _rs2, _rs1, 3'b100, _rd, OP};
    localparam logic[ILEN-1:0] DIVU_VALUE =      {7'b000_0001, _rs2, _rs1, 3'b101, _rd, OP};
    localparam logic[ILEN-1:0] REM_VALUE =       {7'b000_0001, _rs2, _rs1, 3'b110, _rd, OP};
    localparam logic[ILEN-1:0] REMU_VALUE =      {7'b000_0001, _rs2, _rs1, 3'b111, _rd, OP};

    /* RV64M Standard Extension (in addition to RV32M) (pp. 65-67, 557) */
    localparam logic[ILEN-1:0] MULW_VALUE =      {7'b000_0001, _rs2, _rs1, 3'b000, _rd, OP_32};
    localparam logic[ILEN-1:0] DIVW_VALUE =      {7'b000_0001, _rs2, _rs1, 3'b100, _rd, OP_32};
    localparam logic[ILEN-1:0] DIVUW_VALUE =     {7'b000_0001, _rs2, _rs1, 3'b101, _rd, OP_32};
    localparam logic[ILEN-1:0] REMW_VALUE =      {7'b000_0001, _rs2, _rs1, 3'b110, _rd, OP_32};
    localparam logic[ILEN-1:0] REMUW_VALUE =     {7'b000_0001, _rs2, _rs1, 3'b111, _rd, OP_32};

    /* RV32A Standard Extension (pp. 68-76, 558) */
    localparam logic[ILEN-1:0] LR_W_VALUE =      {5'b00010, 2'b??, 5'h00, _rs1, 3'b010, _rd, AMO};
    localparam logic[ILEN-1:0] SC_W_VALUE =      {5'b00011, 2'b??, _rs2, _rs1, 3'b010, _rd, AMO};
    localparam logic[ILEN-1:0] AMOSWAP_W_VALUE = {5'b00001, 2'b??, _rs2, _rs1, 3'b010, _rd, AMO};
    localparam logic[ILEN-1:0] AMOADD_W_VALUE =  {5'b00000, 2'b??, _rs2, _rs1, 3'b010, _rd, AMO};
    localparam logic[ILEN-1:0] AMOXOR_W_VALUE =  {5'b00100, 2'b??, _rs2, _rs1, 3'b010, _rd, AMO};
    localparam logic[ILEN-1:0] AMOAND_W_VALUE =  {5'b01100, 2'b??, _rs2, _rs1, 3'b010, _rd, AMO};
    localparam logic[ILEN-1:0] AMOOR_W_VALUE =   {5'b01000, 2'b??, _rs2, _rs1, 3'b010, _rd, AMO};
    localparam logic[ILEN-1:0] AMOMIN_W_VALUE =  {5'b10000, 2'b??, _rs2, _rs1, 3'b010, _rd, AMO};
    localparam logic[ILEN-1:0] AMOMAX_W_VALUE =  {5'b10100, 2'b??, _rs2, _rs1, 3'b010, _rd, AMO};
    localparam logic[ILEN-1:0] AMOMINU_W_VALUE = {5'b11000, 2'b??, _rs2, _rs1, 3'b010, _rd, AMO};
    localparam logic[ILEN-1:0] AMOMAXU_W_VALUE = {5'b11100, 2'b??, _rs2, _rs1, 3'b010, _rd, AMO};

    /* RV64A Standard Extension (in addition to RV32A) (pp. 68-76, 558) */
    localparam logic[ILEN-1:0] LR_D_VALUE =      {5'b00010, 2'b??, 5'h00, _rs1, 3'b011, _rd, AMO};
    localparam logic[ILEN-1:0] SC_D_VALUE =      {5'b00011, 2'b??, _rs2, _rs1, 3'b011, _rd, AMO};
    localparam logic[ILEN-1:0] AMOSWAP_D_VALUE = {5'b00001, 2'b??, _rs2, _rs1, 3'b011, _rd, AMO};
    localparam logic[ILEN-1:0] AMOADD_D_VALUE =  {5'b00000, 2'b??, _rs2, _rs1, 3'b011, _rd, AMO};
    localparam logic[ILEN-1:0] AMOXOR_D_VALUE =  {5'b00100, 2'b??, _rs2, _rs1, 3'b011, _rd, AMO};
    localparam logic[ILEN-1:0] AMOAND_D_VALUE =  {5'b01100, 2'b??, _rs2, _rs1, 3'b011, _rd, AMO};
    localparam logic[ILEN-1:0] AMOOR_D_VALUE =   {5'b01000, 2'b??, _rs2, _rs1, 3'b011, _rd, AMO};
    localparam logic[ILEN-1:0] AMOMIN_D_VALUE =  {5'b10000, 2'b??, _rs2, _rs1, 3'b011, _rd, AMO};
    localparam logic[ILEN-1:0] AMOMAX_D_VALUE =  {5'b10100, 2'b??, _rs2, _rs1, 3'b011, _rd, AMO};
    localparam logic[ILEN-1:0] AMOMINU_D_VALUE = {5'b11000, 2'b??, _rs2, _rs1, 3'b011, _rd, AMO};
    localparam logic[ILEN-1:0] AMOMAXU_D_VALUE = {5'b11100, 2'b??, _rs2, _rs1, 3'b011, _rd, AMO};

    /* RV32F Standard Extension (pp. 111-119, 559) */
    localparam logic[ILEN-1:0] FLW_VALUE =       {_imm_12, _rs1, 3'b010, _rd, LOAD_FP};
    localparam logic[ILEN-1:0] FSW_VALUE =       {_imm_7, _rs2, _rs1, 3'b010, _imm_5, STORE_FP};
    localparam logic[ILEN-1:0] FMADD_S_VALUE =   {_rs3, 2'b00, _rs2, _rs1, 3'b???, _rd, MADD};
    localparam logic[ILEN-1:0] FMSUB_S_VALUE =   {_rs3, 2'b00, _rs2, _rs1, 3'b???, _rd, MSUB};
    localparam logic[ILEN-1:0] FNMSUB_S_VALUE =  {_rs3, 2'b00, _rs2, _rs1, 3'b???, _rd, NMSUB};
    localparam logic[ILEN-1:0] FNMADD_S_VALUE =  {_rs3, 2'b00, _rs2, _rs1, 3'b???, _rd, NMADD};
    localparam logic[ILEN-1:0] FADD_S_VALUE =    {7'b000_0000, _rs2, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FSUB_S_VALUE =    {7'b000_0100, _rs2, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FMUL_S_VALUE =    {7'b000_1000, _rs2, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FDIV_S_VALUE =    {7'b000_1100, _rs2, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FSQRT_S_VALUE =   {7'b010_1100, 5'h00, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FSGNJ_S_VALUE =   {7'b001_0000, _rs2, _rs1, 3'b000, _rd, OP_FP};
    localparam logic[ILEN-1:0] FSGNJN_S_VALUE =  {7'b001_0000, _rs2, _rs1, 3'b001, _rd, OP_FP};
    localparam logic[ILEN-1:0] FSGNJX_S_VALUE =  {7'b001_0000, _rs2, _rs1, 3'b010, _rd, OP_FP};
    localparam logic[ILEN-1:0] FMIN_S_VALUE =    {7'b001_0100, _rs2, _rs1, 3'b000, _rd, OP_FP};
    localparam logic[ILEN-1:0] FMAX_S_VALUE =    {7'b001_0100, _rs2, _rs1, 3'b001, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_W_S_VALUE =  {7'b110_0000, 5'h00, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_WU_S_VALUE = {7'b110_0000, 5'h01, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FMV_X_W_VALUE =   {7'b111_0000, 5'h00, _rs1, 3'b000, _rd, OP_FP};
    localparam logic[ILEN-1:0] FEQ_S_VALUE =     {7'b101_0000, _rs2, _rs1, 3'b010, _rd, OP_FP};
    localparam logic[ILEN-1:0] FLT_S_VALUE =     {7'b101_0000, _rs2, _rs1, 3'b001, _rd, OP_FP};
    localparam logic[ILEN-1:0] FLE_S_VALUE =     {7'b101_0000, _rs2, _rs1, 3'b000, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCLASS_S_VALUE =  {7'b111_0000, 5'h00, _rs1, 3'b001, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_S_W_VALUE =  {7'b110_1000, 5'h00, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_S_WU_VALUE = {7'b110_1000, 5'h01, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FMV_W_X_VALUE =   {7'b111_1000, 5'h00, _rs1, 3'b000, _rd, OP_FP};

    /* RV64F Standard Extension (in addition to RV32F) (pp. 68-76, 559) */
    localparam logic[ILEN-1:0] FCVT_L_S_VALUE =  {7'b110_0000, 5'b00010, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_LU_S_VALUE = {7'b110_0000, 5'b00011, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_S_L_VALUE =  {7'b110_1000, 5'b00010, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_S_LU_VALUE = {7'b110_1000, 5'b00011, _rs1, 3'b???, _rd, OP_FP};

    /* RV32D Standard Extension (pp. 120-126, 560) */
    localparam logic[ILEN-1:0] FLD_VALUE =       {_imm_12, _rs1, 3'b011, _rd, LOAD_FP};
    localparam logic[ILEN-1:0] FSD_VALUE =       {_imm_7, _rs2, _rs1, 3'b011, _imm_5, STORE_FP};
    localparam logic[ILEN-1:0] FMADD_D_VALUE =   {_rs3, 2'b01, _rs2, _rs1, 3'b???, _rd, MADD};
    localparam logic[ILEN-1:0] FMSUB_D_VALUE =   {_rs3, 2'b01, _rs2, _rs1, 3'b???, _rd, MSUB};
    localparam logic[ILEN-1:0] FNMSUB_D_VALUE =  {_rs3, 2'b01, _rs2, _rs1, 3'b???, _rd, NMSUB};
    localparam logic[ILEN-1:0] FNMADD_D_VALUE =  {_rs3, 2'b01, _rs2, _rs1, 3'b???, _rd, NMADD};
    localparam logic[ILEN-1:0] FADD_D_VALUE =    {7'b000_0001, _rs2, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FSUB_D_VALUE =    {7'b000_0101, _rs2, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FMUL_D_VALUE =    {7'b000_1001, _rs2, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FDIV_D_VALUE =    {7'b000_1101, _rs2, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FSQRT_D_VALUE =   {7'b010_1101, 5'h00, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FSGNJ_D_VALUE =   {7'b001_0001, _rs2, _rs1, 3'b000, _rd, OP_FP};
    localparam logic[ILEN-1:0] FSGNJN_D_VALUE =  {7'b001_0001, _rs2, _rs1, 3'b001, _rd, OP_FP};
    localparam logic[ILEN-1:0] FSGNJX_D_VALUE =  {7'b001_0001, _rs2, _rs1, 3'b010, _rd, OP_FP};
    localparam logic[ILEN-1:0] FMIN_D_VALUE =    {7'b001_0101, _rs2, _rs1, 3'b000, _rd, OP_FP};
    localparam logic[ILEN-1:0] FMAX_D_VALUE =    {7'b001_0101, _rs2, _rs1, 3'b001, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_S_D_VALUE =  {7'b010_0000, 5'h01, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_D_S_VALUE = {7'b010_0001, 5'h00, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FEQ_D_VALUE =     {7'b101_0001, _rs2, _rs1, 3'b010, _rd, OP_FP};
    localparam logic[ILEN-1:0] FLT_D_VALUE =     {7'b101_0001, _rs2, _rs1, 3'b001, _rd, OP_FP};
    localparam logic[ILEN-1:0] FLE_D_VALUE =     {7'b101_0001, _rs2, _rs1, 3'b000, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCLASS_D_VALUE =  {7'b111_0001, 5'h00, _rs1, 3'b001, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_W_D_VALUE =  {7'b110_0001, 5'h00, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_WU_D_VALUE = {7'b110_0001, 5'h01, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_D_W_VALUE =  {7'b110_1001, 5'h00, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_D_WU_VALUE = {7'b110_1001, 5'h01, _rs1, 3'b???, _rd, OP_FP};

    /* RV64D Standard Extension (in addition to RV32D) (pp. 120-126, 560) */
    localparam logic[ILEN-1:0] FCVT_L_D_VALUE =  {7'b110_0001, 5'b00010, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_LU_D_VALUE = {7'b110_0001, 5'b00011, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FMV_X_D_VALUE =   {7'b111_0001, 5'h00, _rs1, 3'b000, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_D_L_VALUE =  {7'b110_1001, 5'b00010, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FCVT_D_LU_VALUE = {7'b110_1001, 5'b00011, _rs1, 3'b???, _rd, OP_FP};
    localparam logic[ILEN-1:0] FMV_D_X_VALUE =   {7'b111_1001, 5'h00, _rs1, 3'b000, _rd, OP_FP};

    /* OPERAND select */
    typedef enum logic[2:0] {       
        OPE_NOP,
        OPE_RS1_IMM,
        OPE_RS1_RS2,
        OPE_RS1_RS2_RS3,
        OPE_RS1_RS2_IMM,
        OPE_CSR_RS1,
        OPE_CSR_UIMM
    } ope_sel_e;

    /* ALU type */
    typedef enum logic[7:0] {       
        ALU_ADD,
        ALU_SUB,
        ALU_NOP,
        ALU_EQ,
        ALU_NE,
        ALU_LT,
        ALU_GE,
        ALU_LTU,
        ALU_GEU,
        ALU_JAL,
        ALU_JALR,
        ALU_LUI,
        ALU_AUIPC,
        ALU_AND,
        ALU_OR,
        ALU_XOR,
        ALU_SLL,
        ALU_SRL,
        ALU_SRA,
        ALU_CSR_RW,
        ALU_CSR_RS,
        ALU_CSR_RC
    } alu_e;

    /* Data size */
    typedef enum logic [2:0] {
        BYTE_S,     // 8-bit signed
        BYTE_U,     // 8-bit unsigned
        HALF_S,     // 16-bit signed
        HALF_U,     // 16-bit unsigned
        WORD_S,     // 32-bit signed
        WORD_U,     // 32-bit unsigned
        DOUBLE_S      // 64-bit
    } data_size_e;



endpackage
`endif
