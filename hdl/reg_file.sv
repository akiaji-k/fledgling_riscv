`timescale 1ns / 1ns
////////////////////////////////////////////////////////////////////////////////
// Engineer: akiaji-k
//
// Create Date:   2025-01-18
// Description: 
//
// Revision:
// Revision 0.01 - File Created
//
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`include "pkg_parameters.sv"

`default_nettype none 

module reg_file (
        reg_file_if.rs_port_rf rs1_if,
        reg_file_if.rs_port_rf rs2_if,
        reg_file_if.rs_port_rf rs3_if,
        reg_file_if.rd_port_rf rd_if
    );

    import pkg_parameters::XLEN;
    import pkg_parameters::NUM_REG;

    logic [NUM_REG-1:1][XLEN-1:0] reg_x = '0;   // NUM_REG can be 31 (not 32) because the value of xreg[0] is always 0 (zero-register)

    assign rs1_if.data = (rs1_if.addr == '0) ? '0 : reg_x[rs1_if.addr];
    assign rs2_if.data = (rs2_if.addr == '0) ? '0 : reg_x[rs2_if.addr];
    assign rs3_if.data = (rs3_if.addr == '0) ? '0 : reg_x[rs3_if.addr];

    always_ff @ (posedge rd_if.clk, posedge rd_if.rst) begin
        if (rd_if.rst) begin
            reg_x[rd_if.addr] <= '0;
        end
        else if (rd_if.addr == '0) begin
            reg_x[rd_if.addr] <= '0;
        end
        else if (rd_if.web) begin
            reg_x[rd_if.addr] <= rd_if.data;
        end
        else begin
            reg_x[rd_if.addr] <= reg_x[rd_if.addr];
        end
    end

endmodule

`default_nettype wire 

