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

module top (
        input logic clk_i,
        input logic rst_i
    );

    import pkg_parameters::XLEN, pkg_parameters::ILEN;
    import pkg_parameters::DMEM_CAPACITY_KiB, pkg_parameters::IMEM_CAPACITY_KiB;

    /* Data memory */
    dmem_if dmem_if (
        .clk(clk_i),
        .rst(rst_i)
    );

    dmem dmem (
        .mif(dmem_if)
    );

    /* Instruction memory */
    imem_if imem_if (
        .clk(clk_i),
        .rst(rst_i)
    );

    imem #(
//        .PRESET(0)      // '0 filled
//        .PRESET(1)      // add
//        .PRESET(2)      // load 
//        .PRESET(3)      // data hazard 
//        .PRESET(4)      // store 
//        .PRESET(5)      // branch 
//        .PRESET(6)      // no-branch 
//        .PRESET(7)      // jump 
//        .PRESET(8)      // load immediate 
//        .PRESET(9)        // integer register-immediate 
        .PRESET(10)        // integer register-register
    ) imem (
        .mif(imem_if)
    );

    cpu cpu (
        .clk_i,
        .rst_i,
        .imem_if,
        .dmem_if
    );



endmodule

`default_nettype wire 


