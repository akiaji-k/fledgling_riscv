`ifndef PKG_CSR_SV
`define PKG_CSR_SV
////////////////////////////////////////////////////////////////////////////////
// Engineer: akiaji-k 
//
// Create Date:   2025-05-17
// Description: 
//
// Revision:
// Revision 0.01 - File Created
//
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

package pkg_csr;
    import pkg_parameters::XLEN;

    localparam int NUM_CSR_REG = 4096;
    localparam int CSR_REG_ADDR_WIDTH = $clog2(NUM_CSR_REG);

    /* CSR register addresses */
    // Machine Information REgisters
    localparam MVENDORID = CSR_REG_ADDR_WIDTH'('hF11);
    localparam MARCHID   = CSR_REG_ADDR_WIDTH'('hF12);
    localparam MIMPID    = CSR_REG_ADDR_WIDTH'('hF13);
    localparam MHARTID   = CSR_REG_ADDR_WIDTH'('hF14);
    localparam MCONFIGPTR = CSR_REG_ADDR_WIDTH'('hF15);
//    // Machine Trap Setup
    localparam MSTATUS   = CSR_REG_ADDR_WIDTH'('h300);
    localparam MISA      = CSR_REG_ADDR_WIDTH'('h301);
//    localparam MEDELEG  = CSR_REG_ADDR_WIDTH'('h302);
//    localparam MIDELEG  = CSR_REG_ADDR_WIDTH'('h303);
//    localparam MIE      = CSR_REG_ADDR_WIDTH'('h304);
    localparam MTVEC    = CSR_REG_ADDR_WIDTH'('h305);
//    localparam MCOUNTEREN = CSR_REG_ADDR_WIDTH'('h306);
//    localparam MSTATUSH = CSR_REG_ADDR_WIDTH'('h310);       // RV32 only
//    localparam MEDELEGH = CSR_REG_ADDR_WIDTH'('h312);       // RV32 only
//    // Machine Trap Handling
//    localparam MSCRATCH = CSR_REG_ADDR_WIDTH'('h340);
    localparam MEPC     = CSR_REG_ADDR_WIDTH'('h341);
    localparam MCAUSE   = CSR_REG_ADDR_WIDTH'('h342);
    localparam MTVAL    = CSR_REG_ADDR_WIDTH'('h343);
//    localparam MIP      = CSR_REG_ADDR_WIDTH'('h344);
//    localparam MTINST   = CSR_REG_ADDR_WIDTH'('h34A);
//    localparam MTVAL2   = CSR_REG_ADDR_WIDTH'('h34B);
//    // Machine Configuration
//    localparam MENVCFG  = CSR_REG_ADDR_WIDTH'('h30A);
//    localparam MENVCFGH = CSR_REG_ADDR_WIDTH'('h31A);       // RV32 only
//    localparam MSECCFG  = CSR_REG_ADDR_WIDTH'('h747);
//    localparam MSECCFGH = CSR_REG_ADDR_WIDTH'('h757);       // RV32 only
//    // Machine Memory Protection
//    localparam PMPCFG0  = CSR_REG_ADDR_WIDTH'('h3A0);
//    localparam PMPCFG1  = CSR_REG_ADDR_WIDTH'('h3A1);       // RV32 only
//    localparam PMPCFG2  = CSR_REG_ADDR_WIDTH'('h3A2);
//    localparam PMPCFG3  = CSR_REG_ADDR_WIDTH'('h3A3);       // RV32 only
//    localparam PMPCFG4  = CSR_REG_ADDR_WIDTH'('h3A4);
//    localparam PMPCFG5  = CSR_REG_ADDR_WIDTH'('h3A5);       // RV32 only
//    localparam PMPCFG6  = CSR_REG_ADDR_WIDTH'('h3A6);
//    localparam PMPCFG7  = CSR_REG_ADDR_WIDTH'('h3A7);       // RV32 only
//    localparam PMPCFG8  = CSR_REG_ADDR_WIDTH'('h3A8);
//    localparam PMPCFG9  = CSR_REG_ADDR_WIDTH'('h3A9);       // RV32 only
//    localparam PMPCFG10  = CSR_REG_ADDR_WIDTH'('h3AA);
//    localparam PMPCFG11  = CSR_REG_ADDR_WIDTH'('h3AB);       // RV32 only
//    localparam PMPCFG12  = CSR_REG_ADDR_WIDTH'('h3AC);
//    localparam PMPCFG13  = CSR_REG_ADDR_WIDTH'('h3AD);       // RV32 only
//    localparam PMPCFG14  = CSR_REG_ADDR_WIDTH'('h3AE);
//    localparam PMPCFG15  = CSR_REG_ADDR_WIDTH'('h3AF);       // RV32 only
//    localparam PMPADDR0  = CSR_REG_ADDR_WIDTH'('h3B0);
//    localparam PMPADDR1  = CSR_REG_ADDR_WIDTH'('h3B1);
//    localparam PMPADDR2  = CSR_REG_ADDR_WIDTH'('h3B2);
//    localparam PMPADDR3  = CSR_REG_ADDR_WIDTH'('h3B3);
//    localparam PMPADDR4  = CSR_REG_ADDR_WIDTH'('h3B4);
//    localparam PMPADDR5  = CSR_REG_ADDR_WIDTH'('h3B5);
//    localparam PMPADDR6  = CSR_REG_ADDR_WIDTH'('h3B6);
//    localparam PMPADDR7  = CSR_REG_ADDR_WIDTH'('h3B7);
//    localparam PMPADDR8  = CSR_REG_ADDR_WIDTH'('h3B8);
//    localparam PMPADDR9  = CSR_REG_ADDR_WIDTH'('h3B9);
//    localparam PMPADDR10  = CSR_REG_ADDR_WIDTH'('h3BA);
//    localparam PMPADDR11  = CSR_REG_ADDR_WIDTH'('h3BB);
//    localparam PMPADDR12  = CSR_REG_ADDR_WIDTH'('h3BC);
//    localparam PMPADDR13  = CSR_REG_ADDR_WIDTH'('h3BD);
//    localparam PMPADDR14  = CSR_REG_ADDR_WIDTH'('h3BE);
//    localparam PMPADDR15  = CSR_REG_ADDR_WIDTH'('h3BF);
//    localparam PMPADDR16  = CSR_REG_ADDR_WIDTH'('h3C0);
//    localparam PMPADDR17  = CSR_REG_ADDR_WIDTH'('h3C1);
//    localparam PMPADDR18  = CSR_REG_ADDR_WIDTH'('h3C2);
//    localparam PMPADDR19  = CSR_REG_ADDR_WIDTH'('h3C3);
//    localparam PMPADDR20  = CSR_REG_ADDR_WIDTH'('h3C4);
//    localparam PMPADDR21  = CSR_REG_ADDR_WIDTH'('h3C5);
//    localparam PMPADDR22  = CSR_REG_ADDR_WIDTH'('h3C6);
//    localparam PMPADDR23  = CSR_REG_ADDR_WIDTH'('h3C7);
//    localparam PMPADDR24  = CSR_REG_ADDR_WIDTH'('h3C8);
//    localparam PMPADDR25  = CSR_REG_ADDR_WIDTH'('h3C9);
//    localparam PMPADDR26  = CSR_REG_ADDR_WIDTH'('h3CA);
//    localparam PMPADDR27  = CSR_REG_ADDR_WIDTH'('h3CB);
//    localparam PMPADDR28  = CSR_REG_ADDR_WIDTH'('h3CC);
//    localparam PMPADDR29  = CSR_REG_ADDR_WIDTH'('h3CD);
//    localparam PMPADDR30  = CSR_REG_ADDR_WIDTH'('h3CE);
//    localparam PMPADDR31  = CSR_REG_ADDR_WIDTH'('h3CF);
//    localparam PMPADDR32  = CSR_REG_ADDR_WIDTH'('h3D0);
//    localparam PMPADDR33  = CSR_REG_ADDR_WIDTH'('h3D1);
//    localparam PMPADDR34  = CSR_REG_ADDR_WIDTH'('h3D2);
//    localparam PMPADDR35  = CSR_REG_ADDR_WIDTH'('h3D3);
//    localparam PMPADDR36  = CSR_REG_ADDR_WIDTH'('h3D4);
//    localparam PMPADDR37  = CSR_REG_ADDR_WIDTH'('h3D5);
//    localparam PMPADDR38  = CSR_REG_ADDR_WIDTH'('h3D6);
//    localparam PMPADDR39  = CSR_REG_ADDR_WIDTH'('h3D7);
//    localparam PMPADDR40  = CSR_REG_ADDR_WIDTH'('h3D8);
//    localparam PMPADDR41  = CSR_REG_ADDR_WIDTH'('h3D9);
//    localparam PMPADDR42  = CSR_REG_ADDR_WIDTH'('h3DA);
//    localparam PMPADDR43  = CSR_REG_ADDR_WIDTH'('h3DB);
//    localparam PMPADDR44  = CSR_REG_ADDR_WIDTH'('h3DC);
//    localparam PMPADDR45  = CSR_REG_ADDR_WIDTH'('h3DD);
//    localparam PMPADDR46  = CSR_REG_ADDR_WIDTH'('h3DE);
//    localparam PMPADDR47  = CSR_REG_ADDR_WIDTH'('h3DF);
//    localparam PMPADDR48  = CSR_REG_ADDR_WIDTH'('h3E0);
//    localparam PMPADDR49  = CSR_REG_ADDR_WIDTH'('h3E1);
//    localparam PMPADDR50  = CSR_REG_ADDR_WIDTH'('h3E2);
//    localparam PMPADDR51  = CSR_REG_ADDR_WIDTH'('h3E3);
//    localparam PMPADDR52  = CSR_REG_ADDR_WIDTH'('h3E4);
//    localparam PMPADDR53  = CSR_REG_ADDR_WIDTH'('h3E5);
//    localparam PMPADDR54  = CSR_REG_ADDR_WIDTH'('h3E6);
//    localparam PMPADDR55  = CSR_REG_ADDR_WIDTH'('h3E7);
//    localparam PMPADDR56  = CSR_REG_ADDR_WIDTH'('h3E8);
//    localparam PMPADDR57  = CSR_REG_ADDR_WIDTH'('h3E9);
//    localparam PMPADDR58  = CSR_REG_ADDR_WIDTH'('h3EA);
//    localparam PMPADDR59  = CSR_REG_ADDR_WIDTH'('h3EB);
//    localparam PMPADDR60  = CSR_REG_ADDR_WIDTH'('h3EC);
//    localparam PMPADDR61  = CSR_REG_ADDR_WIDTH'('h3ED);
//    localparam PMPADDR62  = CSR_REG_ADDR_WIDTH'('h3EE);
//    localparam PMPADDR63  = CSR_REG_ADDR_WIDTH'('h3EF);
//    // Machine State Enable Registers
//    localparam MSTATEEN0  = CSR_REG_ADDR_WIDTH'('h30C);
//    localparam MSTATEEN1  = CSR_REG_ADDR_WIDTH'('h30D);
//    localparam MSTATEEN2  = CSR_REG_ADDR_WIDTH'('h30E);
//    localparam MSTATEEN3  = CSR_REG_ADDR_WIDTH'('h30F);
//    localparam MSTATEEN0H = CSR_REG_ADDR_WIDTH'('h31C);     // RV32 only
//    localparam MSTATEEN1H = CSR_REG_ADDR_WIDTH'('h31D);     // RV32 only
//    localparam MSTATEEN2H = CSR_REG_ADDR_WIDTH'('h31E);     // RV32 only
//    localparam MSTATEEN3H = CSR_REG_ADDR_WIDTH'('h31F);     // RV32 only
//    // Machine Non-Maskable Interrupt Handling
//    localparam MNSCRATCH = CSR_REG_ADDR_WIDTH'('h740);
//    localparam MNEPC     = CSR_REG_ADDR_WIDTH'('h741);
//    localparam MNCAUSE   = CSR_REG_ADDR_WIDTH'('h742);
//    localparam MNSTATUS  = CSR_REG_ADDR_WIDTH'('h744);
//    // Machine Counter/Timers
    localparam MCYCLE    = CSR_REG_ADDR_WIDTH'('hB00);
//    localparam MINSTRET  = CSR_REG_ADDR_WIDTH'('hB02);
//    localparam MHPMCOUTNER3  = CSR_REG_ADDR_WIDTH'('hB03);
//    localparam MHPMCOUTNER4  = CSR_REG_ADDR_WIDTH'('hB04);
//    localparam MHPMCOUTNER5  = CSR_REG_ADDR_WIDTH'('hB05);
//    localparam MHPMCOUTNER6  = CSR_REG_ADDR_WIDTH'('hB06);
//    localparam MHPMCOUTNER7  = CSR_REG_ADDR_WIDTH'('hB07);
//    localparam MHPMCOUTNER8  = CSR_REG_ADDR_WIDTH'('hB08);
//    localparam MHPMCOUTNER9  = CSR_REG_ADDR_WIDTH'('hB09);
//    localparam MHPMCOUTNER10  = CSR_REG_ADDR_WIDTH'('hB0A);
//    localparam MHPMCOUTNER11  = CSR_REG_ADDR_WIDTH'('hB0B);
//    localparam MHPMCOUTNER12  = CSR_REG_ADDR_WIDTH'('hB0C);
//    localparam MHPMCOUTNER13  = CSR_REG_ADDR_WIDTH'('hB0D);
//    localparam MHPMCOUTNER14  = CSR_REG_ADDR_WIDTH'('hB0E);
//    localparam MHPMCOUTNER15  = CSR_REG_ADDR_WIDTH'('hB0F);
//    localparam MHPMCOUTNER16  = CSR_REG_ADDR_WIDTH'('hB10);
//    localparam MHPMCOUTNER17  = CSR_REG_ADDR_WIDTH'('hB11);
//    localparam MHPMCOUTNER18  = CSR_REG_ADDR_WIDTH'('hB12);
//    localparam MHPMCOUTNER19  = CSR_REG_ADDR_WIDTH'('hB13);
//    localparam MHPMCOUTNER20  = CSR_REG_ADDR_WIDTH'('hB14);
//    localparam MHPMCOUTNER21  = CSR_REG_ADDR_WIDTH'('hB15);
//    localparam MHPMCOUTNER22  = CSR_REG_ADDR_WIDTH'('hB16);
//    localparam MHPMCOUTNER23  = CSR_REG_ADDR_WIDTH'('hB17);
//    localparam MHPMCOUTNER24  = CSR_REG_ADDR_WIDTH'('hB18);
//    localparam MHPMCOUTNER25  = CSR_REG_ADDR_WIDTH'('hB19);
//    localparam MHPMCOUTNER26  = CSR_REG_ADDR_WIDTH'('hB1A);
//    localparam MHPMCOUTNER27  = CSR_REG_ADDR_WIDTH'('hB1B);
//    localparam MHPMCOUTNER28  = CSR_REG_ADDR_WIDTH'('hB1C);
//    localparam MHPMCOUTNER29  = CSR_REG_ADDR_WIDTH'('hB1D);
//    localparam MHPMCOUTNER30  = CSR_REG_ADDR_WIDTH'('hB1E);
//    localparam MHPMCOUTNER31  = CSR_REG_ADDR_WIDTH'('hB1F);
//    localparam MCYCLEH   = CSR_REG_ADDR_WIDTH'('hB80);
//    localparam MINSTRETH = CSR_REG_ADDR_WIDTH'('hB82);
//    localparam MHPMCOUTNER3H = CSR_REG_ADDR_WIDTH'('hB83);
//    localparam MHPMCOUTNER4H = CSR_REG_ADDR_WIDTH'('hB84);
//    localparam MHPMCOUTNER5H = CSR_REG_ADDR_WIDTH'('hB85);
//    localparam MHPMCOUTNER6H = CSR_REG_ADDR_WIDTH'('hB86);
//    localparam MHPMCOUTNER7H = CSR_REG_ADDR_WIDTH'('hB87);
//    localparam MHPMCOUTNER8H = CSR_REG_ADDR_WIDTH'('hB88);
//    localparam MHPMCOUTNER9H = CSR_REG_ADDR_WIDTH'('hB89);
//    localparam MHPMCOUTNER10H = CSR_REG_ADDR_WIDTH'('hB8A);
//    localparam MHPMCOUTNER11H = CSR_REG_ADDR_WIDTH'('hB8B);
//    localparam MHPMCOUTNER12H = CSR_REG_ADDR_WIDTH'('hB8C);
//    localparam MHPMCOUTNER13H = CSR_REG_ADDR_WIDTH'('hB8D);
//    localparam MHPMCOUTNER14H = CSR_REG_ADDR_WIDTH'('hB8E);
//    localparam MHPMCOUTNER15H = CSR_REG_ADDR_WIDTH'('hB8F);
//    localparam MHPMCOUTNER16H = CSR_REG_ADDR_WIDTH'('hB90);
//    localparam MHPMCOUTNER17H = CSR_REG_ADDR_WIDTH'('hB91);
//    localparam MHPMCOUTNER18H = CSR_REG_ADDR_WIDTH'('hB92);
//    localparam MHPMCOUTNER19H = CSR_REG_ADDR_WIDTH'('hB93);
//    localparam MHPMCOUTNER20H = CSR_REG_ADDR_WIDTH'('hB94);
//    localparam MHPMCOUTNER21H = CSR_REG_ADDR_WIDTH'('hB95);
//    localparam MHPMCOUTNER22H = CSR_REG_ADDR_WIDTH'('hB96);
//    localparam MHPMCOUTNER23H = CSR_REG_ADDR_WIDTH'('hB97);
//    localparam MHPMCOUTNER24H = CSR_REG_ADDR_WIDTH'('hB98);
//    localparam MHPMCOUTNER25H = CSR_REG_ADDR_WIDTH'('hB99);
//    localparam MHPMCOUTNER26H = CSR_REG_ADDR_WIDTH'('hB9A);
//    localparam MHPMCOUTNER27H = CSR_REG_ADDR_WIDTH'('hB9B);
//    localparam MHPMCOUTNER28H = CSR_REG_ADDR_WIDTH'('hB9C);
//    localparam MHPMCOUTNER29H = CSR_REG_ADDR_WIDTH'('hB9D);
//    localparam MHPMCOUTNER30H = CSR_REG_ADDR_WIDTH'('hB9E);
//    localparam MHPMCOUTNER31H = CSR_REG_ADDR_WIDTH'('hB9F);
//    // Debug/Trace Registers (shared with Debug Mode)
//    localparam TSELECT = CSR_REG_ADDR_WIDTH'('h7A0);
//    localparam TDATA1  = CSR_REG_ADDR_WIDTH'('h7A1);
//    localparam TDATA2  = CSR_REG_ADDR_WIDTH'('h7A2);
//    localparam TDATA3  = CSR_REG_ADDR_WIDTH'('h7A3);
//    localparam MCONTEXT = CSR_REG_ADDR_WIDTH'('h7A8);
//    // Debug Mode Registers
//    localparam DCSR     = CSR_REG_ADDR_WIDTH'('h7B0);
//    localparam DPC      = CSR_REG_ADDR_WIDTH'('h7B1);
//    localparam DSCRATCH0 = CSR_REG_ADDR_WIDTH'('h7B2);
//    localparam DSCRATCH1 = CSR_REG_ADDR_WIDTH'('h7B3);

    typedef enum logic[XLEN-1:0] {
        RESERVED_EXCEPTION = {1'b1, {(XLEN-1){1'b0}}},
        SUPERVISOR_SOFTWARE_INTERRUPT = ( (XLEN'(1) << (XLEN - 1)) | 'd1 ),
        MACHINE_SOFTWARE_INTERRUPT = ( (XLEN'(1) << (XLEN - 1)) | 'd3 ),
        SUPERVISOR_TIMER_INTERRUPT = ( (XLEN'(1) << (XLEN - 1)) | 'd5 ),
        MACHINE_TIMER_INTERRUPT = ( (XLEN'(1) << (XLEN - 1)) | 'd7 ),
        SUPERVISOR_EXTERNAL_INTERRUPT = ( (XLEN'(1) << (XLEN - 1)) | 'd9 ),
        MACHINE_EXTERNAL_INTERRUPT = ( (XLEN'(1) << (XLEN - 1)) | 'd11 ),
        COUNTER_OVERFLOW_INTERRUPT = ( (XLEN'(1) << (XLEN - 1)) | 'd13 ),
        INSTRUCTION_ADDRESS_MISALIGNED = 'd0,
        INSTRUCTION_ACCESS_FAULT = 'd1,
        ILLEGAL_INSTRUCTION = 'd2,
        BREAKPOINT = 'd3,
        LOAD_ADDRESS_MISALIGNED = 'd4,
        LOAD_ACCESS_FAULT = 'd5,
        STORE_AMO_ADDRESS_MISALIGNED = 'd6,
        STORE_AMO_ACCESS_FAULT = 'd7,
        ENVIRONMENT_CALL_FROM_U_MODE = 'd8,
        ENVIRONMENT_CALL_FROM_S_MODE = 'd9,
        ENVIRONMENT_CALL_FROM_M_MODE = 'd11,
        INSTRUCTION_PAGE_FAULT = 'd12,
        LOAD_PAGE_FAULT = 'd13,
        STORE_AMO_PAGE_FAULT = 'd15,
        DOUBLE_TRAP = 'd16,
        SOFTWARE_CHECK = 'd18,
        HARDWARE_CHECK = 'd19
    //    CUSTOM_#_RV128 =     7'b11_110_1,
    } exception_code_e;

endpackage
`endif


