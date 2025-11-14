`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2025 11:52:29
// Design Name: 
// Module Name: actuator_control
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


module actuator_control (
    input wire [7:0] temp,
    input wire [7:0] setpoint,
    output reg heater,
    output reg fan
);
    always @(*) begin
        if (temp < setpoint) begin
            heater = 1;
            fan = 0;
        end else if (temp > setpoint) begin
            heater = 0;
            fan = 1;
        end else begin
            heater = 0;
            fan = 0;
        end
    end
endmodule

