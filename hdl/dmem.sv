`timescale 1ns / 1ns
////////////////////////////////////////////////////////////////////////////////
// Engineer: akiaji-k
//
// Create Date:   2025-01-02
// Description: Byte addressing single port RAM
//
// Revision:
// Revision 0.01 - File Created
//
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`include "pkg_parameters.sv"

`default_nettype none 

// avoiding to use parameter because generic interface is not supported by verilator 5.030
//module dmem #(
//        parameter MEM_CAPACITY_KiB = DMEM_CAPACITY_KiB
//    )(
//        interface mif
//    );
module dmem (
        dmem_if.mem_port mif
    );

    import pkg_parameters::DMEM_DEPTH, pkg_parameters::DMEM_ADDR_WIDTH, pkg_parameters::DMEM_DATA_WIDTH, pkg_parameters::MEM_DATA_WIDTH;
    localparam LANE = DMEM_DATA_WIDTH / MEM_DATA_WIDTH;

    // $readmemh is supported only for unpacked array.
//    logic [DMEM_DEPTH-1:0][DMEM_DATA_WIDTH-1:0] mem = '{default : '0};
    logic [MEM_DATA_WIDTH-1:0] mem [DMEM_DEPTH-1:0] = '{default : '0};

    generate
        integer i, j;

        always_ff @ (posedge mif.clk or posedge mif.rst) begin
            for(i = 0; i < LANE; i = i + 1) begin : WRITE_GEN_LANE
                if (mif.rst | !mif.ena | !mif.web) begin
                    mem[mif.addr + $bits(mif.addr)'(i)] <= mem[mif.addr + $bits(mif.addr)'(i)];
                end
                else begin
                    mem[mif.addr + $bits(mif.addr)'(i)] <= mif.din[((i+1)*MEM_DATA_WIDTH)-1 -: MEM_DATA_WIDTH];
                end
            end
        end

        always_ff @ (posedge mif.clk or posedge mif.rst) begin
            for(j = 0; j < LANE; j = j + 1) begin : READ_GEN_LANE
                if (mif.rst | !mif.ena) begin
                    mif.dout <= '0;
                end
                else begin
                    mif.dout[((j+1)*MEM_DATA_WIDTH)-1 -: MEM_DATA_WIDTH] <= mem[mif.addr + $bits(mif.addr)'(j)];
                end
            end
        end
    endgenerate

    initial begin
        //$readmemh("../test/dmem/serial.mem", mem);
        //$readmemh("../test/dmem/serial_large.mem", mem);
        $readmemh("../test/dmem/serial_large_0xf.mem", mem);
    end

endmodule

`default_nettype wire 

