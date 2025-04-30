`timescale 1ns / 1ns
////////////////////////////////////////////////////////////////////////////////
// Engineer: akiaji-k
//
// Create Date:   2025-04-19
// Description: 
//
// Revision:
// Revision 0.01 - File Created
//
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`default_nettype none 

module lifo #(
    parameter DATA_WIDTH = 64,  
    parameter DEPTH = 3       
) (
    input logic clk_i,          
    input logic rst_o,       
    input logic push_i,       
    input logic pop_i,       
    input logic [DATA_WIDTH-1:0] data_i,
    output logic [DATA_WIDTH-1:0] data_o, 
    output logic full_o,         
    output logic empty_o        
);

    logic [DATA_WIDTH-1:0] stack [0:DEPTH-1]; // stack memory 
    logic [$clog2(DEPTH):0] pointer;               // stack pointer 
    logic push, pop, full, empty;
    assign push = push_i;
    assign pop = pop_i;
    assign full_o = full;
    assign empty_o = empty;

    /* pointer control & write data */
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            pointer <= 0;
        end 
        else begin : PUSH_AND_POP
            if (push && !full) begin : PUSH
                stack[pointer] <= data_i; 
                pointer <= pointer + 1;
            end 
            else if (pop && !empty) begin : POP
                pointer <= pointer - 1;   
            end
        end
    end

    /* read data (top of stack is always output) */
//    assign data_o = (pop && !empty) ? stack[pointer-1] : '0;
    assign data_o = (empty) ? '0 : stack[pointer-1];   // if the LIFO is empty, "pointer - 1" will be '1 (wrap around).

    /* full, empty flag */
    assign full = (pointer == DEPTH);
    assign empty = (pointer == '0);

endmodule

`default_nettype wire 




