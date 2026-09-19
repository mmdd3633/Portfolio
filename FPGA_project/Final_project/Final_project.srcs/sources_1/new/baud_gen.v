`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/10 17:36:34
// Design Name: 
// Module Name: baud_gen
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

module baud_gen #(
    parameter integer CLK_FREQ  = 100_000_000,
    parameter integer BAUD_RATE = 115200
)(
    input  wire clk,
    input  wire rst,
    output reg  baud_tick
);
    // 100MHz / 115200 = 약 868 클럭마다 1번 틱 발생
    localparam integer DIVISOR = CLK_FREQ / BAUD_RATE;
    reg [15:0] cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt       <= 16'd0;
            baud_tick <= 1'b0;
        end else begin
            if (cnt == DIVISOR - 1) begin
                cnt       <= 16'd0;
                baud_tick <= 1'b1; // 1클럭 동안 High
            end else begin
                cnt       <= cnt + 16'd1;
                baud_tick <= 1'b0;
            end
        end
    end
endmodule