`timescale 1ns / 1ns
////////////////////////////////////////////////////////////////////////////////
// Engineer: akiaji-k
//
// Create Date:   2025-01-18
// Description: Interface definitions
//
// Revision:
// Revision 0.01 - File Created
//
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`include "pkg_parameters.sv"

`default_nettype none 

interface reg_file_if import pkg_parameters::REG_ADDR_WIDTH; #(
        parameter ADDR_WIDTH = REG_ADDR_WIDTH
    )(
        input logic clk,
        input logic rst 
    );

    import pkg_parameters::XLEN;

    logic [ADDR_WIDTH-1:0] addr;
    logic web;
    logic [XLEN-1:0] data;
    
    // source register (rs)
    modport rs_port_ctrl (input data, output addr);
    modport rs_port_rf (input addr, output data);

    // destination register (rd)
    modport rd_port_ctrl (output web, addr, data);
    modport rd_port_rf (input clk, rst, web, addr, data);


endinterface

`default_nettype wire 

