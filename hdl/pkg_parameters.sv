`ifndef PKG_PARAMETERS_SV
`define PKG_PARAMETERS_SV
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

package pkg_parameters;

    localparam int XLEN = 64;   // RV64
    localparam int ILEN = 32;
//    localparam int FLEN = 64;   // RV64D
    localparam int NUM_REG = 32;
    localparam int REG_ADDR_WIDTH = $clog2(NUM_REG);

    localparam int MEM_DATA_WIDTH = 8;  // byte addressing

    localparam int DMEM_CAPACITY_KiB = 8;
    localparam int DMEM_DATA_WIDTH = XLEN;     
    localparam int DMEM_DEPTH = byte_addr_mem_depth_from_capacity_kib(DMEM_CAPACITY_KiB, MEM_DATA_WIDTH);
    localparam int DMEM_ADDR_WIDTH = addr_width_from_capacity_kib(DMEM_CAPACITY_KiB, MEM_DATA_WIDTH);

    localparam int IMEM_CAPACITY_KiB = 8;
    localparam int IMEM_DATA_WIDTH = ILEN;
    localparam int IMEM_DEPTH = byte_addr_mem_depth_from_capacity_kib(IMEM_CAPACITY_KiB, MEM_DATA_WIDTH);
    localparam int IMEM_ADDR_WIDTH = addr_width_from_capacity_kib(IMEM_CAPACITY_KiB, MEM_DATA_WIDTH);

    localparam int SHAMT_WIDTH = $clog2(XLEN);   // shift amount for logical operations

    function automatic int byte_addr_mem_depth_from_capacity_kib(int mem_capacity_kib, int data_width);
        int mem_capacity_byte = mem_capacity_kib * 2 ** 10; // 2^10
        int mem_depth = mem_capacity_byte / data_width;   

        return mem_depth;
    endfunction

    function automatic int addr_width_from_capacity_kib(int mem_capacity_kib, int data_width);
        int mem_depth = byte_addr_mem_depth_from_capacity_kib(mem_capacity_kib, data_width);   
        int addr_width = $clog2(mem_depth);

        return addr_width;
    endfunction

endpackage
`endif

