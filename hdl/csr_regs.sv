`timescale 1ns / 1ns
////////////////////////////////////////////////////////////////////////////////
// Engineer: akiaji-k
//
// Create Date:   2025-05-10
// Description: 
//
// Revision:
// Revision 0.01 - File Created
//
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`include "pkg_parameters.sv"
`include "pkg_csr.sv"

`default_nettype none 

module csr_regs import pkg_parameters::XLEN; import pkg_csr::*;(
        reg_file_if.rs_port_rf csr_read,
        reg_file_if.rd_port_rf csr_write,

        input logic exeception_event_i,
        input exception_code_e exeception_cause_i,
        input logic [XLEN-1:0] exeception_pc_i,
        input logic [XLEN-1:0] exeception_tval_i,
        input logic [1:0] exception_priv_mode_i
    );

    always_ff @ (exeception_event_i, exeception_cause_i, exeception_pc_i, exeception_tval_i, exception_priv_mode_i) begin
    end

    /* CSR register array */
    logic [NUM_CSR_REG-1:0][XLEN-1:0] csr = '{default : '0};   
    logic [63:0] mcycle = '0; // cycle counter has to be 64-bit even if XLEN is 32-bit

    initial begin
//        csr[MISA] = {2'b10, {(XLEN-28){1'b0}}, 26'b00_0000_0000_0000_0000_0001_0000_0000}; // only RV64I is supported
        csr[MISA][(XLEN-1):(XLEN-2)] = 2'b10;   // XLEN == 64
        csr[MISA][8] = 1'b1; // only RV64I is supported

        csr[MVENDORID] = '0;    // non-commercial implementation
        csr[MARCHID] = 'd100;   // non-commercial open-source
        csr[MIMPID] = "AK";      
        csr[MHARTID] = '0;    // only one hart is supported
        csr[MCONFIGPTR] = '0; // the configration data structure does not exist (riscv-privileged.pdf, 3.1.17) (it's read-only)

        csr[MEPC] = '0; // machine exception program counter
        csr[MCAUSE] = '0; // machine cause register
        csr[MTVAL] = '0; // machine trap value register
        csr[MTVEC] = '0;  // machine trap vector register
    end


    /* R/W interfaces */
//    assign csr_read.data = csr[csr_read.addr];
    always_comb begin : CSR_READ 
        unique case(csr_read.addr)
            MCYCLE: begin : XLEN64
                csr_read.data = mcycle;
            end
            default: begin
                csr_read.data = csr[csr_read.addr];
            end
        endcase
    end

    always_ff @ (posedge csr_write.clk, posedge csr_write.rst) begin
        if (csr_write.rst) begin
            csr[csr_write.addr] <= '0;
        end
        else begin
            if (exeception_event_i) begin : EXCEPTION
                // if an exception occurs, the CSR write is ignored
//                csr[csr_write.addr] <= csr[csr_write.addr];
                csr[MCAUSE] <= exeception_cause_i; 
                csr[MEPC] <= {exeception_pc_i[XLEN-1:2], 2'b00}; 
                csr[MTVAL] <= exeception_tval_i; 

                csr[MSTATUS][7] <= csr[MSTATUS][3]; // MSTATUS.MPIE <- MSTATUS.MIE
                csr[MSTATUS][3] <= 1'b0;        // MIE (Global Interrupt Enable) is disabled
                csr[MSTATUS][12:11] <= exception_priv_mode_i; // MSTATUS.MPP <- exception_priv_mode_i
            end
            else if (csr_write.web == 1'b0) begin
                csr[csr_write.addr] <= csr[csr_write.addr];
            end
            // web == 1
            else if (csr_write.addr inside {MCONFIGPTR}) begin : READ_ONLY
                csr[csr_write.addr] <= csr[csr_write.addr];
            end
            else if (csr_write.addr inside {MISA, MVENDORID, MARCHID, MIMPID, MHARTID, MTVAL, MSTATUS, MTVEC} ) begin : WARL
                // Validation should be needed, but not implemented. That is, the write to WLRL registers is ignored.
                csr[csr_write.addr] <= csr[csr_write.addr];
            end
            else if (csr_write.addr inside {MCAUSE} ) begin : WLRL
                // Validation should be needed, but not implemented. That is, the write to WLRL registers is ignored.
                csr[csr_write.addr] <= csr[csr_write.addr];
            end
            else begin
                csr[csr_write.addr] <= csr_write.data;
            end
        end
    end

    /* clock-cycle counter */
    always_ff @ (posedge csr_write.clk, posedge csr_write.rst) begin
        if (csr_write.rst) begin
            mcycle <= '0;
        end
        else if ((csr_write.addr == MCYCLE) && (csr_write.web == 1'b1)) begin
            mcycle <= csr_write.data;
        end
        else begin
            mcycle <= mcycle + 'd1;
        end
    end

endmodule

`default_nettype wire 


