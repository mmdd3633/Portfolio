`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/30 20:52:55
// Design Name: 
// Module Name: seg_out
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


module seg_out (
    input  wire [15:0] i_led,
    input  wire [7:0]  i_an,
    input  wire [6:0]  i_seg,
    input  wire        i_dp,
    output wire [15:0] o_led,
    output wire [7:0]  o_an,
    output wire [6:0]  o_cn,
    output wire        o_dp
);
    assign o_led = i_led;
    assign o_an  = i_an;
    assign o_cn  = i_seg;
    assign o_dp  = i_dp;
endmodule
