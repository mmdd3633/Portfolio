`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/20 14:54:50
// Design Name: 
// Module Name: top_stopwatch
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
// Top Module : Nexys A7 Stopwatch + LED Runner
// - BTN : BTNC(시작/중단), BTND(초기화), BTNL/BTNR(왼쪽/오른쪽 그룹 선택)
// - 7-Segment : 시간 표시 (d3 d2 . d1 d0 = XX.XX)
// - LED : RUN 중일 때만 러닝 라이트, STOP 시 패턴 유지, CLEAR 시 OFF
// ============================================================

module top_stopwatch (
    input  wire        i_clk,   // 보드 기본 클럭
    input  wire        i_rst_n,  // Reset 버튼 (Active-Low)

    input  wire        BTNC,        // Center : 시작/중단
    input  wire        BTNL,        // Left   : 왼쪽 그룹 선택
    input  wire        BTNR,        // Right  : 오른쪽 그룹 선택
    input  wire        BTND,        // Down   : 초기화

    output wire [15:0] o_led,         // 16개 LED
    output wire [7:0]  o_an,          // 7-Segment Anode (AN0~AN7)
    output wire [6:0]  o_cn,
    output wire        o_dp
);

    // ========================================================
    // 1. 버튼 디바운스 + 상승엣지 검출
    //    - 각 버튼마다 하나씩 사용
    // ========================================================
    wire w_btnc_deb, w_btnc_posedge;
    wire w_btnl_deb, w_btnl_posedge;
    wire w_btnr_deb, w_btnr_posedge;
    wire w_btnd_deb, w_btnd_posedge;

    // 시작/중단 버튼 (BTNC)
    btn_deb_posedge #(
        .P_DEBOUNCE_MAX(1_000_000)           // 약 10ms 디바운스
        //.P_DEBOUNCE_MAX(10)           // 시뮬레이션 용
    ) u_btnc (
        .i_clk     (i_clk),
        .i_rst_n   (i_rst_n),
        .i_btn     (BTNC),
        .o_btn_deb (w_btnc_deb),
        .o_posedge (w_btnc_posedge)
    );

    // 왼쪽 선택 버튼 (BTNL)
    btn_deb_posedge #(
        .P_DEBOUNCE_MAX(1_000_000)
        //.P_DEBOUNCE_MAX(10)           // 시뮬레이션 용
    ) u_btnl (
        .i_clk     (i_clk),
        .i_rst_n   (i_rst_n),
        .i_btn     (BTNL),
        .o_btn_deb (w_btnl_deb),
        .o_posedge (w_btnl_posedge)
    );

    // 오른쪽 선택 버튼 (BTNR)
    btn_deb_posedge #(
        .P_DEBOUNCE_MAX(1_000_000)
        //.P_DEBOUNCE_MAX(10)           // 시뮬레이션 용
    ) u_btnr (
        .i_clk     (i_clk),
        .i_rst_n   (i_rst_n),
        .i_btn     (BTNR),
        .o_btn_deb (w_btnr_deb),
        .o_posedge (w_btnr_posedge)
    );

    // 초기화 버튼 (BTND)
    btn_deb_posedge #(
        .P_DEBOUNCE_MAX(1_000_000)
        //.P_DEBOUNCE_MAX(10)           // 시뮬레이션 용
    ) u_btnd (
        .i_clk     (i_clk),
        .i_rst_n   (i_rst_n),
        .i_btn     (BTND),
        .o_btn_deb (w_btnd_deb),
        .o_posedge (w_btnd_posedge)
    );

    // ========================================================
    // 2. 10ms Tick 생성기
    // ========================================================
    wire w_tick_10ms;

    clk_div_10ms u_clk_div_10ms (
        .i_clk       (i_clk),
        .i_rst_n     (i_rst_n),
        .o_tick_10ms (w_tick_10ms)
    );

    // ========================================================
    // 3. 스톱워치 상태 제어 (RUN / CLEAR)
    // ========================================================
    wire w_run;
    wire w_clear;

    stopwatch_ctrl u_stopwatch_ctrl (
        .i_clk           (i_clk),
        .i_rst_n         (i_rst_n),
        .i_start_posedge (w_btnc_posedge),  // BTNC : 시작/중단
        .i_clear_posedge (w_btnd_posedge),  // BTND : 초기화
        .o_run           (w_run),
        .o_clear         (w_clear)
    );

    // ========================================================
    // 4. 스톱워치 카운터 (00.00 ~ 99.99, 10ms 단위)
    // ========================================================
    wire [3:0] w_d3;   // 십초 자리
    wire [3:0] w_d2;   //  초  자리
    wire [3:0] w_d1;   // 0.1초
    wire [3:0] w_d0;   // 0.01초

    stopwatch_counter u_stopwatch_counter (
        .i_clk       (i_clk),
        .i_rst_n     (i_rst_n),
        .i_tick_10ms (w_tick_10ms),
        .i_run       (w_run),
        .i_clear     (w_clear),
        .o_d3        (w_d3),
        .o_d2        (w_d2),
        .o_d1        (w_d1),
        .o_d0        (w_d0)
    );

    // ========================================================
    // 5. 표시 위치 제어 (왼쪽/오른쪽 그룹 선택)
    // ========================================================
    wire w_group_sel;   // 0: 오른쪽 그룹, 1: 왼쪽 그룹

    display_pos_ctrl u_display_pos_ctrl (
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_left_posedge (w_btnl_posedge),   // BTNL
        .i_right_posedge(w_btnr_posedge),   // BTNR
        .o_group_sel    (w_group_sel)
    );

    // ========================================================
    // 6. 7-Segment 드라이버
    //    - BCD 4자리 + 그룹 선택 → AN, SEG, DP
    // ========================================================
    wire [7:0] w_an;
    wire [6:0] w_seg;   // {g,f,e,d,c,b,a}
    wire       w_dp;

    seg_driver u_seg_driver (
        .i_clk       (i_clk),
        .i_rst_n     (i_rst_n),
        .i_d3        (w_d3),
        .i_d2        (w_d2),
        .i_d1        (w_d1),
        .i_d0        (w_d0),
        .i_group_sel (w_group_sel),
        .o_an        (w_an),
        .o_seg       (w_seg),
        .o_dp        (w_dp)
    );

    // ========================================================
    // 7. LED 러닝 라이트
    //    - RUN 상태에서만 패턴 진행
    //    - STOP 시 현재 패턴 유지
    //    - CLEAR 시 LED 전체 OFF
    // ========================================================
    wire [15:0] w_led;

    led_runner u_led_runner (
        .i_clk       (i_clk),
        .i_rst_n     (i_rst_n),
        .i_run       (w_run),
        .i_clear     (w_clear),
        .o_led       (w_led)
    );

    // ========================================================
    // 8. 최종 출력 매핑
    //    - LED / AN / SEG / DP를 실제 포트에 연결
    //    - SEG는 {g,f,e,d,c,b,a} 순서이므로 개별 CA~CG에 매핑
    // ========================================================
    assign o_led = w_led;
    assign o_an  = w_an;
    
    assign o_cn[6:0] = w_seg[6:0];
    assign o_dp = w_dp;

endmodule