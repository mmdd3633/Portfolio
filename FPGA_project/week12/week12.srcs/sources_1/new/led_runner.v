`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/20 14:51:35
// Design Name: 
// Module Name: led_runner
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
// LED 러닝 라이트 모듈 (3개짜리 꼬리 패턴 버전)
// - 16개의 LED를 하나의 웨이브로 사용
// - 웨이브는 맨 오른쪽(LED[0])에서 시작하여 왼쪽(LED[15])으로 이동
// - 가운데 구간에서는 항상 "1이 3개"가 같이 이동하는 형태
//   예) 0000_0001 -> 0000_0011 -> 0000_0111 -> ...
//       ... -> 1110_0000 -> 1100_0000 -> 1000_0000
// - i_run = 1 : 패턴 진행
// - i_run = 0 : 현재 패턴 유지 (LED 그대로 멈춤)
// - i_clear = 1 : 패턴 및 LED 모두 0으로 초기화
// ============================================================

module led_runner (
    input  wire       i_clk,    // 100MHz 시스템 클럭
    input  wire       i_rst_n,  // Active-Low reset

    input  wire       i_run,    // 1: 패턴 진행, 0: 정지 상태(패턴 유지)
    input  wire       i_clear,  // 1클럭 펄스, 패턴 초기화

    output reg [15:0] o_led     // 16개 LED 출력
);

    // ========================================================
    // 1. 내부 상태
    // ========================================================
    // 100ms 카운터: 100MHz * 0.1s = 10,000,000 cycle
    // 2^24 = 16,777,216 > 10,000,000 → 24비트면 충분
    reg [23:0] r_tick_cnt;      // 0 ~ 9_999_999
    reg [4:0]  r_head;          // 웨이브 머리 위치 인덱스 (0 ~ 17 사용)
    reg [15:0] r_pat16;         // 계산된 16비트 패턴

    localparam integer P_TAIL_LEN  = 3;   // 꼬리 길이 = 3개 LED
    localparam integer P_NUM_LED   = 16;
    localparam integer P_HEAD_MAX  = (P_NUM_LED - 1) + (P_TAIL_LEN - 1); // 15 + 2 = 17

    localparam integer CYCLE_100MS = 10_000_000; // 100MHz 기준 100ms
    //localparam integer CYCLE_100MS = 10; // 시뮬레이션용

    // 2. 100ms 카운터 / head 인덱스 업데이트
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            r_tick_cnt <= 24'd0;
            r_head     <= 5'd0;
        end
        else begin
            if (i_clear) begin                                                  // 초기화 시 : 패턴 진행용 상태도 모두 리셋
                r_tick_cnt <= 24'd0;
                r_head     <= 5'd0;
            end
            else if (i_run) begin
                if (r_tick_cnt >= (CYCLE_100MS - 1)) begin
                    r_tick_cnt <= 24'd0;
                    if (r_head >= P_HEAD_MAX[4:0]) begin                        // head 인덱스를 한 칸 진행
                        r_head <= 5'd0;                                         // 다시 처음 위치로
                    end
                    else begin
                        r_head <= r_head + 1'b1;
                    end
                end
                else begin
                    r_tick_cnt <= r_tick_cnt + 1'b1;
                end
            end                                                                 // i_run == 0 이면 r_tick_cnt, r_head 모두 그대로 유지 → 패턴도 그대로 유지
        end
    end

    // 3. head 인덱스를 기준으로 16비트 패턴 생성 (조합 논리)
    integer i;
    always @(*) begin
        r_pat16 = 16'h0000;
        for (i = 0; i < P_NUM_LED; i = i + 1) begin
            if ((i <= r_head) && ((i + (P_TAIL_LEN - 1)) >= r_head)) begin
                r_pat16[i] = 1'b1;
            end
        end
    end

    // ========================================================
    // 4. 최종 LED 출력
    //    - 리셋/clear 시 0
    //    - RUN=1일 때만 r_pat16을 래치해서 업데이트
    //    - RUN=0이면 o_led를 건드리지 않음 → 정지 시 패턴 유지
    // ========================================================
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_led <= 16'h0000;
        end
        else begin
            if (i_clear) begin
                o_led <= 16'h0000;
            end
            else if (i_run) begin
                o_led <= r_pat16;
            end
            // i_run == 0 이면 o_led에 대한 대입이 없으므로
            // 직전 패턴 그대로 유지 (정지 시 LED 고정)
        end
    end

endmodule
