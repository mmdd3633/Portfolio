`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/20 14:41:18
// Design Name: 
// Module Name: stopwatch_ctrl
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
// 스톱워치 상태 제어 모듈 (수정 버전)
// - 시작/중단 버튼(BTNC) : RUN/STOP 상태 토글
// - 초기화 버튼(BTND)    : 카운터/LED 초기화 + RUN=0 (정지 상태로 강제)
// - 리셋 시 : RUN = 0 (정지 상태에서 시작)
// ============================================================

module stopwatch_ctrl (
    input  wire i_clk,            // 100MHz 시스템 클럭
    input  wire i_rst_n,          // Active-Low reset

    input  wire i_start_posedge,  // BTNC의 상승엣지 (1클럭 펄스)
    input  wire i_clear_posedge,  // BTND의 상승엣지 (1클럭 펄스)

    output reg  o_run,            // 1: 스톱워치 RUN, 0: STOP
    output wire o_clear           // 카운터/LED 초기화용 1클럭 펄스
);

    // 1. RUN 상태 제어 - start_posedge 시   : 토글 (0→1, 1→0)
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_run <= 1'b0;          // 리셋 시 정지 상태
        end
        else begin
            if (i_clear_posedge) begin
                // 초기화 버튼을 누르면 언제나 정지 상태로
                o_run <= 1'b0;
            end
            else if (i_start_posedge) begin
                // 그 외에는 BTNC로 RUN/STOP 토글
                o_run <= ~o_run;
            end
        end
    end
    assign o_clear = i_clear_posedge;
endmodule