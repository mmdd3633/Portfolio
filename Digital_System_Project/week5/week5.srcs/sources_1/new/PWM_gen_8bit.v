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
module PWM_gen_8bit(
    input i_clk,
    input i_rst,
    input [7:0] i_duty,    // PS에서 AXI GPIO를 통해 전달받는 값 (0~255)
    output reg o_pwm
);
    // counter - 0~255까지 세는 카운터
    reg [7:0] cnt;

    // 8비트 카운터 설계
    always @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            cnt <= 8'd0;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

    // Duty 값과 카운터 비교를 통한 PWM 생성
    always @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            o_pwm <= 1'b0;
        end else begin
            // 카운터 값이 설정된 duty보다 작을 때 High 출력
            o_pwm <= (cnt < i_duty) ? 1'b1 : 1'b0;
        end
    end
endmodule
