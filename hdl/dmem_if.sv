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
`include "pkg_parameters.sv"

`default_nettype none 

/* byte addressing memory interface */
// generic interface is not supported by Verilator 5.030
//interface mem_if #(
//    parameter ADDR_WIDTH = 10,
//    parameter DATA_WIDTH = 64
//) (
//    input logic clk,
//    input logic rst 
//);
interface dmem_if (
    input logic clk,
    input logic rst 
);

    import pkg_parameters::DMEM_ADDR_WIDTH, pkg_parameters::DMEM_DATA_WIDTH;

    logic ena;
    logic web;
    logic [DMEM_ADDR_WIDTH-1:0] addr;
    logic [DMEM_DATA_WIDTH-1:0] din;
    logic [DMEM_DATA_WIDTH-1:0] dout;

    modport ctrl_port (input dout, output ena, web, addr, din);
    modport mem_port (input clk, rst, ena, web, addr, din, output dout);


endinterface

`default_nettype wire 
