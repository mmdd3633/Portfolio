`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/04 10:41:33
// Design Name: 
// Module Name: segment
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


module segment(
    input   wire    [15:0]  i_sw, 
    output  wire     [7:0]   o_an,
    output  wire     [7:0]   o_ca
    );
    
 assign o_an = i_sw[15:8];
 assign oca = i_sw[7:0];
endmodule
