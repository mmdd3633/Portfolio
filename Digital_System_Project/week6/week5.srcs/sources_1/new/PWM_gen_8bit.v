`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/03 14:04:33
// Design Name: 
// Module Name: PWM_gen_8bit
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
`timescale 1ns / 1ps

module PWM_gen_8bit(
    input i_clk,
    input i_rst,
    input [23:0] i_duty,   // PS에서 AXI GPIO(24비트)를 통해 전달받는 통합 값
    output reg o_pwm_r,    // Red LED 연결용
    output reg o_pwm_g,    // Green LED 연결용
    output reg o_pwm_b     // Blue LED 연결용
);
    // 0~255까지 세는 공통 카운터
    reg [7:0] cnt;

    // 1. 8비트 카운터 설계 (R, G, B 공통 사용)
    always @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            cnt <= 8'd0;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

    // 2. 각 채널별 Duty 값 비교를 통한 PWM 생성
    // i_duty[23:16] = Red
    // i_duty[15:8]  = Green
    // i_duty[7:0]   = Blue
    always @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            o_pwm_r <= 1'b0;
            o_pwm_g <= 1'b0;
            o_pwm_b <= 1'b0;
        end else begin
            // 각 색상 영역의 비트와 카운터를 비교하여 출력 결정
            o_pwm_r <= (cnt < i_duty[23:16]) ? 1'b1 : 1'b0;
            o_pwm_g <= (cnt < i_duty[15:8])  ? 1'b1 : 1'b0;
            o_pwm_b <= (cnt < i_duty[7:0])   ? 1'b1 : 1'b0;
        end
    end
endmodule