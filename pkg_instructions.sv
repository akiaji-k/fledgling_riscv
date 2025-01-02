`ifndef PKG_INSTRUCTIONS_SV
`define PKG_INSTRUCTIONS_SV

// ref. [The RISC-V Instruction Set Manual Volume I, Unprivileged Architecture, Version 20240411](https://drive.google.com/file/d/1uviu1nH-tScFfgrovvFCrj7Omv8tFtkp/view)

localparam OPCODE_BITS = 7;
localparam INSTRUCTION_BITS = 32;


/* registers and immediates */
localparam logic[4:0] rs1 = 5'h??;
localparam logic[4:0] rs2 = 5'h??;
localparam logic[4:0] rs3 = 5'h??;
localparam logic[4:0] rd = 5'h??;
localparam logic[4:0] imm_5 = 5'h??;
localparam logic[5:0] imm_6 = 6'h??;
localparam logic[6:0] imm_7 = 7'h??;
localparam logic[11:0] imm_12 = 12'h???;
localparam logic[19:0] imm_20 = 20'h?_????;
localparam logic[11:0] csr = 12'h???;


/* opcode (pp. 553) */
// 32-bit instructions have their lowest two bits set to "11".
// 16-bit instructions have their lowest two bits set to 00, 01 or 10.
typedef enum logic[OPCODE_BITS - 1 : 0] {
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
//    RESERVED =  7'b11_010_11,
    JAL_OP =    7'b11_011_11,
    SYSTEM =    7'b11_100_11,
    OP_VE =     7'b11_101_11
//    CUSTOM_#_RV128 =     7'b11_110_11,
} opcode;


/* Instructions */
typedef enum logic[INSTRUCTION_BITS - 1 : 0] {
    /* RV32I Base Instruction Set (pp. 554) */
    // load immediate 
    LUI =       {imm_20, rd, LUI_OP},
    AUIPC =     {imm_20, rd, AUIPC_OP},
    
    // Jumps
    JAL =       {imm_20, rd, JAL_OP},
    JALR =      {imm_12, rs1, 3'b000, rd, JALR_OP},

    // Conditional Branches
    BEQ =       {imm_7, rs2, rs1, 3'b000, imm_5, BRANCH},
    BNE =       {imm_7, rs2, rs1, 3'b001, imm_5, BRANCH},
    BLT =       {imm_7, rs2, rs1, 3'b100, imm_5, BRANCH},
    BGE =       {imm_7, rs2, rs1, 3'b101, imm_5, BRANCH},
    BLTU =      {imm_7, rs2, rs1, 3'b110, imm_5, BRANCH},
    BGEU =      {imm_7, rs2, rs1, 3'b111, imm_5, BRANCH},

    // Load
    LB =        {imm_12, rs1, 3'b000, rd, LOAD},
    LH =        {imm_12, rs1, 3'b001, rd, LOAD},
    LW =        {imm_12, rs1, 3'b010, rd, LOAD},
    LBU =       {imm_12, rs1, 3'b100, rd, LOAD},
    LHU =       {imm_12, rs1, 3'b101, rd, LOAD},

    // Store
    SB =        {imm_7, rs2, rs1, 3'b000, imm_5, STORE},
    SH =        {imm_7, rs2, rs1, 3'b001, imm_5, STORE},
    SW =        {imm_7, rs2, rs1, 3'b010, imm_5, STORE},

    // Integer Register-Immediate
    ADDI =      {imm_12, rs1, 3'b000, rd, OP_IMM},
    SLTI =      {imm_12, rs1, 3'b010, rd, OP_IMM},
    SLTIU =     {imm_12, rs1, 3'b011, rd, OP_IMM},
    XORI =      {imm_12, rs1, 3'b100, rd, OP_IMM},
    ORI =       {imm_12, rs1, 3'b110, rd, OP_IMM},
    ANDI =      {imm_12, rs1, 3'b111, rd, OP_IMM},
//    SLLI =      {7'b000_0000, imm_5, rs1, 3'b001, rd, OP_IMM},        // 64-bit instruction is listed below.
//    SRLI =      {7'b000_0000, imm_5, rs1, 3'b101, rd, OP_IMM},
//    SRAI =      {7'b010_0000, imm_5, rs1, 3'b101, rd, OP_IMM},

    // Integer Register-Register Operations
    ADD =       {7'b000_0000, rs2, rs1, 3'b000, rd, OP},
    SUB =       {7'b010_0000, rs2, rs1, 3'b000, rd, OP},
    SLL =       {7'b000_0000, rs2, rs1, 3'b001, rd, OP},
    SLT =       {7'b000_0000, rs2, rs1, 3'b010, rd, OP},
    SLTU =      {7'b000_0000, rs2, rs1, 3'b011, rd, OP},
    XOR =       {7'b000_0000, rs2, rs1, 3'b100, rd, OP},
    SRL =       {7'b000_0000, rs2, rs1, 3'b101, rd, OP},
    SRA =       {7'b010_0000, rs2, rs1, 3'b101, rd, OP},
    OR =        {7'b000_0000, rs2, rs1, 3'b110, rd, OP},
    AND =       {7'b000_0000, rs2, rs1, 3'b111, rd, OP},

    // Memory Ordering
    FENCE =     {4'h?, 4'h?, 4'h?, rs1, 3'b000, rd, MISC_MEM},
    FENCE_TSO = {4'b1000, 4'b0011, 4'b0011, 5'h00, 3'b000, 5'h00, MISC_MEM},
    PAUSE =     {4'b0000, 4'b0001, 4'b0000, 5'h00, 3'b000, 5'h00, MISC_MEM},

    // Environment Call and Breakpoints
    ECALL =     {12'h000, 5'h00, 3'b000, 5'h00, SYSTEM},
    EBREAK =    {12'h001, 5'h00, 3'b000, 5'h00, SYSTEM},

    // NOP
    NOP =       {12'h000, 5'h00, 3'b000, 5'h00, OP_IMM},

    /* RV64I Base Instruction Set (in addition to RV32I) (pp. 556) */
    // Load and Store
    LWU =       {imm_12, rs1, 3'b110, rd, LOAD},
    LD =        {imm_12, rs1, 3'b011, rd, LOAD},
    SD =        {imm_7, rs2, rs1, 3'b011, imm_5, STORE},

    // Integer Register-Immediate
    SLLI =      {6'b00_0000, imm_6, rs1, 3'b001, rd, OP_IMM},
    SRLI =      {6'b00_0000, imm_6, rs1, 3'b101, rd, OP_IMM},
    SRAI =      {6'b01_0000, imm_6, rs1, 3'b101, rd, OP_IMM},
    ADDIW =     {imm_12, rs1, 3'b000, rd, OP_IMM_32},
    SLLIW =     {7'b000_0000, imm_5, rs1, 3'b001, rd, OP_IMM_32},
    SRLIW =     {7'b000_0000, imm_5, rs1, 3'b101, rd, OP_IMM_32},
    SRAIW =     {7'b010_0000, imm_5, rs1, 3'b101, rd, OP_IMM_32},

    // Integer Register-Register
    ADDW =      {7'b000_0000, rs2, rs1, 3'b000, rd, OP_32},
    SUBW =      {7'b010_0000, rs2, rs1, 3'b000, rd, OP_32},
    SLLW =      {7'b000_0000, rs2, rs1, 3'b001, rd, OP_32},
    SRLW =      {7'b000_0000, rs2, rs1, 3'b101, rd, OP_32},
    SRAW =      {7'b010_0000, rs2, rs1, 3'b101, rd, OP_32},

    /* RV32/RV64 Zifencei Standard Extension (pp. 44-45, 556) */
    FENCE_I =   {imm_12, rs1, 3'b001, rd, MISC_MEM},

    /* RV32/RV64 Zicsr Standard Extension (pp. 46-49, 556) */
    CSRRW =     {csr, rs1, 3'b001, rd, SYSTEM},
    CSRRS =     {csr, rs1, 3'b010, rd, SYSTEM},
    CSRRC =     {csr, rs1, 3'b011, rd, SYSTEM},
    CSRRWI =    {csr, imm_5, 3'b101, rd, SYSTEM},
    CSRRSI =    {csr, imm_5, 3'b110, rd, SYSTEM},
    CSRRCI =    {csr, imm_5, 3'b111, rd, SYSTEM},

    /* RV32M Standard Extension (pp. 65-67, 556) */
    MUL =       {7'b000_0001, rs2, rs1, 3'b000, rd, OP},
    MULH =      {7'b000_0001, rs2, rs1, 3'b001, rd, OP},
    MULHSU =    {7'b000_0001, rs2, rs1, 3'b010, rd, OP},
    MULHU =     {7'b000_0001, rs2, rs1, 3'b011, rd, OP},
    DIV =       {7'b000_0001, rs2, rs1, 3'b100, rd, OP},
    DIVU =      {7'b000_0001, rs2, rs1, 3'b101, rd, OP},
    REM =       {7'b000_0001, rs2, rs1, 3'b110, rd, OP},
    REMU =      {7'b000_0001, rs2, rs1, 3'b111, rd, OP},

    /* RV64M Standard Extension (in addition to RV32M) (pp. 65-67, 557) */
    MULW =      {7'b000_0001, rs2, rs1, 3'b000, rd, OP_32},
    DIVW =      {7'b000_0001, rs2, rs1, 3'b100, rd, OP_32},
    DIVUW =     {7'b000_0001, rs2, rs1, 3'b101, rd, OP_32},
    REMW =      {7'b000_0001, rs2, rs1, 3'b110, rd, OP_32},
    REMUW =     {7'b000_0001, rs2, rs1, 3'b111, rd, OP_32},

    /* RV32A Standard Extension (pp. 68-76, 558) */
    LR_W =      {5'b00010, 2'b??, 5'h00, rs1, 3'b010, rd, AMO},
    SC_W =      {5'b00011, 2'b??, rs2, rs1, 3'b010, rd, AMO},
    AMOSWAP_W = {5'b00001, 2'b??, rs2, rs1, 3'b010, rd, AMO},
    AMOADD_W =  {5'b00000, 2'b??, rs2, rs1, 3'b010, rd, AMO},
    AMOXOR_W =  {5'b00100, 2'b??, rs2, rs1, 3'b010, rd, AMO},
    AMOAND_W =  {5'b01100, 2'b??, rs2, rs1, 3'b010, rd, AMO},
    AMOOR_W =   {5'b01000, 2'b??, rs2, rs1, 3'b010, rd, AMO},
    AMOMIN_W =  {5'b10000, 2'b??, rs2, rs1, 3'b010, rd, AMO},
    AMOMAX_W =  {5'b10100, 2'b??, rs2, rs1, 3'b010, rd, AMO},
    AMOMINU_W = {5'b11000, 2'b??, rs2, rs1, 3'b010, rd, AMO},
    AMOMAXU_W = {5'b11100, 2'b??, rs2, rs1, 3'b010, rd, AMO},

    /* RV64A Standard Extension (in addition to RV32A) (pp. 68-76, 558) */
    LR_D =      {5'b00010, 2'b??, 5'h00, rs1, 3'b011, rd, AMO},
    SC_D =      {5'b00011, 2'b??, rs2, rs1, 3'b011, rd, AMO},
    AMOSWAP_D = {5'b00001, 2'b??, rs2, rs1, 3'b011, rd, AMO},
    AMOADD_D =  {5'b00000, 2'b??, rs2, rs1, 3'b011, rd, AMO},
    AMOXOR_D =  {5'b00100, 2'b??, rs2, rs1, 3'b011, rd, AMO},
    AMOAND_D =  {5'b01100, 2'b??, rs2, rs1, 3'b011, rd, AMO},
    AMOOR_D =   {5'b01000, 2'b??, rs2, rs1, 3'b011, rd, AMO},
    AMOMIN_D =  {5'b10000, 2'b??, rs2, rs1, 3'b011, rd, AMO},
    AMOMAX_D =  {5'b10100, 2'b??, rs2, rs1, 3'b011, rd, AMO},
    AMOMINU_D = {5'b11000, 2'b??, rs2, rs1, 3'b011, rd, AMO},
    AMOMAXU_D = {5'b11100, 2'b??, rs2, rs1, 3'b011, rd, AMO},

    /* RV32F Standard Extension (pp. 111-119, 559) */
    FLW =       {imm_12, rs1, 3'b010, rd, LOAD_FP},
    FSW =       {imm_7, rs2, rs1, 3'b010, imm_5, STORE_FP},
    FMADD_S =   {rs3, 2'b00, rs2, rs1, 3'b???, rd, MADD},
    FMSUB_S =   {rs3, 2'b00, rs2, rs1, 3'b???, rd, MSUB},
    FNMSUB_S =  {rs3, 2'b00, rs2, rs1, 3'b???, rd, NMSUB},
    FNMADD_S =  {rs3, 2'b00, rs2, rs1, 3'b???, rd, NMADD},
    FADD_S =    {7'b000_0000, rs2, rs1, 3'b???, rd, OP_FP},
    FSUB_S =    {7'b000_0100, rs2, rs1, 3'b???, rd, OP_FP},
    FMUL_S =    {7'b000_1000, rs2, rs1, 3'b???, rd, OP_FP},
    FDIV_S =    {7'b000_1100, rs2, rs1, 3'b???, rd, OP_FP},
    FSQRT_S =   {7'b010_1100, 5'h00, rs1, 3'b???, rd, OP_FP},
    FSGNJ_S =   {7'b001_0000, rs2, rs1, 3'b000, rd, OP_FP},
    FSGNJN_S =  {7'b001_0000, rs2, rs1, 3'b001, rd, OP_FP},
    FSGNJX_S =  {7'b001_0000, rs2, rs1, 3'b010, rd, OP_FP},
    FMIN_S =    {7'b001_0100, rs2, rs1, 3'b000, rd, OP_FP},
    FMAX_S =    {7'b001_0100, rs2, rs1, 3'b001, rd, OP_FP},
    FCVT_W_S =  {7'b110_0000, 5'h00, rs1, 3'b???, rd, OP_FP},
    FCVT_WU_S = {7'b110_0000, 5'h01, rs1, 3'b???, rd, OP_FP},
    FMV_X_W =   {7'b111_0000, 5'h00, rs1, 3'b000, rd, OP_FP},
    FEQ_S =     {7'b101_0000, rs2, rs1, 3'b010, rd, OP_FP},
    FLT_S =     {7'b101_0000, rs2, rs1, 3'b001, rd, OP_FP},
    FLE_S =     {7'b101_0000, rs2, rs1, 3'b000, rd, OP_FP},
    FCLASS_S =  {7'b111_0000, 5'h00, rs1, 3'b001, rd, OP_FP},
    FCVT_S_W =  {7'b110_1000, 5'h00, rs1, 3'b???, rd, OP_FP},
    FCVT_S_WU = {7'b110_1000, 5'h01, rs1, 3'b???, rd, OP_FP},
    FMV_W_X =   {7'b111_1000, 5'h00, rs1, 3'b000, rd, OP_FP}

    /* RV64F Standard Extension (in addition to RV32F) (pp. 68-76, 559) */
    FCVT_L_S =  {7'b110_0000, 5'b00010, rs1, 3'b???, rd, OP_FP},
    FCVT_LU_S = {7'b110_0000, 5'b00011, rs1, 3'b???, rd, OP_FP},
    FCVT_S_L =  {7'b110_1000, 5'b00010, rs1, 3'b???, rd, OP_FP},
    FCVT_S_LU = {7'b110_1000, 5'b00011, rs1, 3'b???, rd, OP_FP},

    /* RV32D Standard Extension (pp. 120-126, 560) */
    FLD =       {imm_12, rs1, 3'b011, rd, LOAD_FP},
    FSD =       {imm_7, rs2, rs1, 3'b011, imm_5, STORE_FP},
    FMADD_D =   {rs3, 2'b01, rs2, rs1, 3'b???, rd, MADD},
    FMSUB_D =   {rs3, 2'b01, rs2, rs1, 3'b???, rd, MSUB},
    FNMSUB_D =  {rs3, 2'b01, rs2, rs1, 3'b???, rd, NMSUB},
    FNMADD_D =  {rs3, 2'b01, rs2, rs1, 3'b???, rd, NMADD},
    FADD_D =    {7'b000_0001, rs2, rs1, 3'b???, rd, OP_FP},
    FSUB_D =    {7'b000_0101, rs2, rs1, 3'b???, rd, OP_FP},
    FMUL_D =    {7'b000_1001, rs2, rs1, 3'b???, rd, OP_FP},
    FDIV_D =    {7'b000_1101, rs2, rs1, 3'b???, rd, OP_FP},
    FSQRT_D =   {7'b010_1101, 5'h00, rs1, 3'b???, rd, OP_FP},
    FSGNJ_D =   {7'b001_0001, rs2, rs1, 3'b000, rd, OP_FP},
    FSGNJN_D =  {7'b001_0001, rs2, rs1, 3'b001, rd, OP_FP},
    FSGNJX_D =  {7'b001_0001, rs2, rs1, 3'b010, rd, OP_FP},
    FMIN_D =    {7'b001_0101, rs2, rs1, 3'b000, rd, OP_FP},
    FMAX_D =    {7'b001_0101, rs2, rs1, 3'b001, rd, OP_FP},
    FCVT_S_D =  {7'b010_0000, 5'h01, rs1, 3'b???, rd, OP_FP},
    FCVT_D_S = {7'b010_0001, 5'h00, rs1, 3'b???, rd, OP_FP},
    FEQ_D =     {7'b101_0001, rs2, rs1, 3'b010, rd, OP_FP},
    FLT_D =     {7'b101_0001, rs2, rs1, 3'b001, rd, OP_FP},
    FLE_D =     {7'b101_0001, rs2, rs1, 3'b000, rd, OP_FP},
    FCLASS_D =  {7'b111_0001, 5'h00, rs1, 3'b001, rd, OP_FP},
    FCVT_W_D =  {7'b110_0001, 5'h00, rs1, 3'b???, rd, OP_FP},
    FCVT_WU_D = {7'b110_0001, 5'h01, rs1, 3'b???, rd, OP_FP},
    FCVT_D_W =  {7'b110_1001, 5'h00, rs1, 3'b???, rd, OP_FP},
    FCVT_D_WU = {7'b110_1001, 5'h01, rs1, 3'b???, rd, OP_FP},

    /* RV64D Standard Extension (in addition to RV32D) (pp. 120-126, 560) */
    FCVT_L_D =  {7'b110_0001, 5'b00010, rs1, 3'b???, rd, OP_FP},
    FCVT_LU_D = {7'b110_0001, 5'b00011, rs1, 3'b???, rd, OP_FP},
    FMV_X_D =   {7'b111_0001, 5'h00, rs1, 3'b000, rd, OP_FP}
    FCVT_D_L =  {7'b110_1001, 5'b00010, rs1, 3'b???, rd, OP_FP},
    FCVT_D_LU = {7'b110_1001, 5'b00011, rs1, 3'b???, rd, OP_FP},
    FMV_D_X =   {7'b111_1001, 5'h00, rs1, 3'b000, rd, OP_FP}

} instruction;

`endif
