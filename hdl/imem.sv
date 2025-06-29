`timescale 1ns / 1ns
////////////////////////////////////////////////////////////////////////////////
// Engineer: akiaji-k
//
// Create Date:   2025-01-02
// Description: Byte addressing single port ROM
//
// Revision:
// Revision 0.01 - File Created
//
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`include "pkg_parameters.sv"

`default_nettype none 

module imem #(
        parameter PRESET = 0
    )(
        imem_if.mem_port mif
    );

    import pkg_parameters::IMEM_DEPTH, pkg_parameters::IMEM_ADDR_WIDTH, pkg_parameters::IMEM_DATA_WIDTH, pkg_parameters::MEM_DATA_WIDTH;

    localparam LANE = IMEM_DATA_WIDTH / MEM_DATA_WIDTH;

    // $readmemh is supported only for unpacked array.
//    logic [IMEM_DEPTH-1:0][IMEM_DATA_WIDTH-1:0] mem = '{default : '0};
    logic [MEM_DATA_WIDTH-1:0] mem [IMEM_DEPTH-1:0] = '{default : '0};

    generate
        integer i;
        always_ff @ (posedge mif.clk or posedge mif.rst) begin
            if (mif.rst | !mif.ena) begin
                mif.dout <= '0;
            end
            else begin
                for(i = 0; i < LANE; i = i + 1) begin : GEN_LANE
                    mif.dout[((i+1)*MEM_DATA_WIDTH)-1 -: MEM_DATA_WIDTH] <= mem[mif.addr + $bits(mif.addr)'(i)];
                end
    //            mif.dout <= mem[mif.addr];
            end
        end
    endgenerate

    initial begin
        if (PRESET == '0)  begin
        end
        else if (PRESET == 'd1) begin
            $readmemh("../test/add/add_0x.mem", mem);
        end
        else if (PRESET == 'd2) begin
            //$readmemh("../test/load/load_0x.mem", mem);
            $readmemh("../test/load/load_all_0x.mem", mem);
        end
        else if (PRESET == 'd3) begin
            $readmemh("../test/data_hazard/data_hazard_0x.mem", mem);
        end
        else if (PRESET == 'd4) begin
            $readmemh("../test/store/store_0x.mem", mem);
        end
        else if (PRESET == 'd5) begin
            $readmemh("../test/branch/branch_0x.mem", mem);
        end
        else if (PRESET == 'd6) begin
            $readmemh("../test/branch/no_branch_0x.mem", mem);
        end
        else if (PRESET == 'd7) begin
            $readmemh("../test/jump/jump_0x.mem", mem);
        end
        else if (PRESET == 'd8) begin
            $readmemh("../test/load_imm/load_imm_0x.mem", mem);
        end
        else if (PRESET == 'd9) begin
            $readmemh("../test/int_reg_imm/int_reg_imm_0x.mem", mem);
        end
        else if (PRESET == 'd10) begin
            $readmemh("../test/int_reg_reg/int_reg_reg_0x.mem", mem);
        end
        else if (PRESET == 'd11) begin
            $readmemh("../test/csr/csr_0x.mem", mem);
        end
        else if (PRESET == 'd12) begin
            $readmemh("../test/ecall/ecall_0x.mem", mem);
        end
        else begin
        end
    end

endmodule

`default_nettype wire 

