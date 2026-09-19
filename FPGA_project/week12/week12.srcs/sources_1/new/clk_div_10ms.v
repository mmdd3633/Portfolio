`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/20 14:39:26
// Design Name: 
// Module Name: clk_div_10ms
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
// ============================================================
// 10ms Tick 생성기
// - 100MHz 입력 클럭 기준
// - 약 10ms마다 o_tick_10ms를 1클럭 동안 HIGH로 생성
// - 스톱워치 카운터/LED 러닝 패턴에 공용으로 사용
// ============================================================

module clk_div_10ms #(
    parameter P_CNT_MAX = 1_000_000 - 1   // 100MHz 기준 10ms = 1,000,000 클럭
    //parameter P_CNT_MAX = 10 - 1   // 시뮬레이션 용
)(
    input  wire i_clk,        // 100MHz 시스템 클럭
    input  wire i_rst_n,      // Active-Low reset

    output reg  o_tick_10ms   // 10ms마다 1클럭 HIGH 펄스
);

    // 1. 카운터 선언
    reg [19:0] r_cnt;

    // 2. 카운터 및 Tick 생성
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            r_cnt       <= 20'd0;
            o_tick_10ms <= 1'b0;
        end
        else begin
            if (r_cnt >= P_CNT_MAX) begin
                // 10ms 경과 시점: Tick 발생 후 카운터 리셋
                r_cnt       <= 20'd0;
                o_tick_10ms <= 1'b1;
            end
            else begin
                r_cnt       <= r_cnt + 1'b1;
                o_tick_10ms <= 1'b0;
            end
        end
    end

endmodule