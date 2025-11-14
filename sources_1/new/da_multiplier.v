`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2025 18:07:28
// Design Name: 
// Module Name: da_multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module da_multiplier #(parameter signed [15:0] K = 16'sd2048) (
    input clk,
    input signed [15:0] x,
    output reg signed [31:0] result
);
    integer i;
    reg signed [31:0] acc;

    always @(posedge clk) begin
        acc = 0;
        for (i = 0; i < 16; i = i + 1) begin
            if (x[i])
                acc = acc + (K <<< i);
        end
        result <= acc;
    end
endmodule

