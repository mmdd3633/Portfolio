`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/20 14:36:18
// Design Name: 
// Module Name: btn_deb_posedge
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
// 버튼 디바운스 + 상승엣지 검출 모듈
// - 100MHz 기준, P_DEBOUNCE_MAX로 디바운스 시간 조절
// - o_btn_deb  : 디바운싱된 버튼 값 (레벨)
// - o_posedge  : 상승엣지 1클럭 펄스
// ============================================================

module btn_deb_posedge #(
    parameter P_DEBOUNCE_MAX = 20_0000    // 대략 2ms 정도(100MHz 기준)
    // 필요하면 1_000_000(10ms), 2_000_000(20ms) 등으로 조정해서 사용
)(
    input  wire i_clk,       // 100MHz 시스템 클럭
    input  wire i_rst_n,     // Active-Low reset
    input  wire i_btn,       // 원본 버튼 입력

    output wire o_btn_deb,   // 디바운싱된 버튼 값
    output wire o_posedge    // 상승엣지 1클럭 펄스
);

    // ========================================================
    // 1. 내부 신호 선언
    // ========================================================
    reg        r_sync_0;       // 1단 동기화
    reg        r_sync_1;       // 2단 동기화 (실제 디바운스 입력)
    reg        r_btn_deb;      // 디바운싱된 버튼 값(레벨)
    reg        r_btn_deb_prev; // 이전 디바운싱 값 (엣지 검출용)

    reg [21:0] r_deb_cnt;      // 디바운스 카운터 (크기는 P_DEBOUNCE_MAX에 맞춰 여유있게)

    // 2. 비동기 버튼 입력 → 클럭 도메인 동기화 (2-FF)
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            r_sync_0 <= 1'b0;
            r_sync_1 <= 1'b0;
        end
        else begin
            r_sync_0 <= i_btn;
            r_sync_1 <= r_sync_0;
        end
    end

    // 3. 디바운스 로직 - 카운터가 P_DEBOUNCE_MAX까지 도달하면 그때 안정값 갱신
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            r_deb_cnt   <= 22'd0;
            r_btn_deb   <= 1'b0;
        end
        else begin
            if (r_sync_1 != r_btn_deb) begin
                r_deb_cnt <= 22'd0;
            end
            else begin
                if (r_deb_cnt < P_DEBOUNCE_MAX) begin
                    r_deb_cnt <= r_deb_cnt + 1'b1;
                end
            end
            if (r_deb_cnt == P_DEBOUNCE_MAX) begin
                r_btn_deb <= r_sync_1;
            end
        end
    end
    assign o_btn_deb = r_btn_deb;

    // 4. 상승엣지 검출 (디바운싱된 값 기준)
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            r_btn_deb_prev <= 1'b0;
        end
        else begin
            r_btn_deb_prev <= r_btn_deb;
        end
    end
    assign o_posedge = (r_btn_deb == 1'b1) && (r_btn_deb_prev == 1'b0);
endmodule