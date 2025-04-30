`timescale 1ns / 1ns
////////////////////////////////////////////////////////////////////////////////
// Engineer: akiaji-k
//
// Create Date:   2025-01-02
// Description: Interface definitions
//
// Revision:
// Revision 0.01 - File Created
//
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`default_nettype none 

/* byte addressing memory interface */
interface imem_if (
    input logic clk,
    input logic rst 
);

    import pkg_parameters::IMEM_ADDR_WIDTH, pkg_parameters::IMEM_DATA_WIDTH;

    logic ena;
    logic [IMEM_ADDR_WIDTH-1:0] addr;
    logic [IMEM_DATA_WIDTH-1:0] dout;

    modport ctrl_port (input dout, output ena, addr);
    modport mem_port (input clk, rst, ena, addr, output dout);


endinterface

`default_nettype wire 


`default_nettype wire 
