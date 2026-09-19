`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/20 14:43:17
// Design Name: 
// Module Name: stopwatch_counter
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
// 스톱워치 카운터 모듈
// - 단위 : 10ms (0.01초)
// - 표시 : 00.00 ~ 99.99
// - 출력 : 4자리 BCD (o_d3 o_d2 . o_d1 o_d0)
//           o_d3 : 십초(10초 자리)
//           o_d2 : 1초 자리
//           o_d1 : 0.1초 자리
//           o_d0 : 0.01초 자리
// ============================================================

module stopwatch_counter (
    input  wire       i_clk,        // 100MHz 시스템 클럭
    input  wire       i_rst_n,      // Active-Low reset

    input  wire       i_tick_10ms,  // 10ms Tick (1클럭 펄스)
    input  wire       i_run,        // 1: 카운트 진행, 0: 정지
    input  wire       i_clear,      // 1클럭 펄스, 카운터 00.00으로 초기화

    output reg  [3:0] o_d3,         // 십초 자리 (10s)
    output reg  [3:0] o_d2,         // 초 자리 (1s)
    output reg  [3:0] o_d1,         // 0.1s 자리
    output reg  [3:0] o_d0          // 0.01s 자리
);

    // ========================================================
    // 1. 카운터 동작
    //    - 리셋 또는 clear 시 00.00으로 초기화
    //    - run 상태 & 10ms tick 발생 시 자리올림 처리
    // ========================================================
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin                             // 비동기 리셋 : 모두 0
            o_d3 <= 4'd0;
            o_d2 <= 4'd0;
            o_d1 <= 4'd0;
            o_d0 <= 4'd0;
        end
        else begin
            if (i_clear) begin                          // clear 버튼 : 스톱워치 00.00으로 초기화
                o_d3 <= 4'd0;
                o_d2 <= 4'd0;
                o_d1 <= 4'd0;
                o_d0 <= 4'd0;
            end
            else if (i_tick_10ms && i_run) begin
                if (o_d0 == 4'd9) begin                 // 0.01초 자리 올림
                    o_d0 <= 4'd0;
                    if (o_d1 == 4'd9) begin             // 0.1초 자리 올림
                        o_d1 <= 4'd0;
                        if (o_d2 == 4'd9) begin         // 1초 자리 올림
                            o_d2 <= 4'd0;
                            if (o_d3 == 4'd9) begin     // 99.99 → 00.00 롤오버
                                o_d3 <= 4'd0;
                            end
                            else begin
                                o_d3 <= o_d3 + 1'b1;
                            end
                        end
                        else begin
                            o_d2 <= o_d2 + 1'b1;
                        end
                    end
                    else begin
                        o_d1 <= o_d1 + 1'b1;
                    end
                end
                else begin                              // 0.01초 자리만 +1 (아직 9가 아니면)
                    o_d0 <= o_d0 + 1'b1;
                end
            end                                         // else : run=0 이거나 tick=0 이면 값 유지
        end
    end

endmodule