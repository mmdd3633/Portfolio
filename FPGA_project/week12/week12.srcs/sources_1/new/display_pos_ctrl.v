`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/20 14:45:43
// Design Name: 
// Module Name: display_pos_ctrl
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
// 표시 위치 제어 모듈
// - BTNL : 왼쪽 4자리 세그먼트 그룹 선택
// - BTNR : 오른쪽 4자리 세그먼트 그룹 선택
// - 리셋 시 기본값 : 오른쪽 그룹 (o_group_sel = 0)
// ============================================================

module display_pos_ctrl (
    input  wire i_clk,            // 100MHz 시스템 클럭
    input  wire i_rst_n,          // Active-Low reset

    input  wire i_left_posedge,   // BTNL  상승엣지 (1클럭 펄스)
    input  wire i_right_posedge,  // BTNR  상승엣지 (1클럭 펄스)

    output reg  o_group_sel       // 0: 오른쪽 4자리, 1: 왼쪽 4자리
);

    // 그룹 선택 상태 레지스터
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_group_sel <= 1'b0;                                    // 기본값: 오른쪽 그룹
        end
        else begin
            if (i_left_posedge) begin                               // 왼쪽 버튼이 눌리면 왼쪽 그룹 선택
                o_group_sel <= 1'b1;
            end
            else if (i_right_posedge) begin                         // 오른쪽 버튼이 눌리면 오른쪽 그룹 선택
                o_group_sel <= 1'b0;
            end
        end
    end
endmodule