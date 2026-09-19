`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/24 16:34:40
// Design Name: 
// Module Name: week4_SW1_control
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

// 스위치로 LED O/F 제어
//module week4_SW1_control(
//    input wire i_sw,
//    output wire o_led
//    );
    
//assign o_led = i_sw;
//endmodule

//SW 16개로 LED각각 O/F 제어
//module week4_SW1_control(
//    input wire [15:0] i_sws,
//    output wire [15:0] o_leds
//);

//assign o_leds = i_sws;
//endmodule

// 스위치 하나로 LED 16개 제어
//module week4_SW1_control(
//    input wire [15:0] i_sw,
//    output wire [15:0] o_led
//);

//// 삼항 연산자 : A = (조건) ? B : C; -> 양자택일일때 사용하면 좋음
//assign o_led = (i_sw[0] == 1) ? 16'b1010_1010_1010_1010 : 16'b0101_0101_0101_0101;

//endmodule

// 4개 그대로 다음 4개 거꾸로 다음 4개 그대로 다음 4개 거꾸로
//module week4_SW1_control(
//    input wire [15:0] i_sws,
//    output wire [15:0] o_leds
//);

//assign o_leds[3:0] = i_sws[3:0];
//assign o_leds[7:4] = ~i_sws[7:4];         // ~ : not gate (신호 반대로 출력)
//assign o_leds[11:8] = i_sws[11:8];
//assign o_leds[15:12] = ~i_sws[15:12];
//endmodule