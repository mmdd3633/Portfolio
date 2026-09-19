`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/24 15:45:18
// Design Name: 
// Module Name: week4_SW16
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

// module (모듈 이름)
module week4_SW16(
    // [n-1:0] n비트
    output wire [15:0] o_led
    );
// assign (변수) 변수의 값 지정
assign o_led = 16'b1010_1010_1010_1010; // 2진수 : b, 10진수 : d, 16진수 : h
endmodule
