`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/20 14:47:51
// Design Name: 
// Module Name: seg_driver
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
// 4자리 7-Segment 드라이버 모듈
// - 입력 BCD 4자리 (d3 d2 . d1 d0)를 7세그에 표시
// - i_group_sel = 0 : 오른쪽 4자리 그룹 (AN[3:0])
// - i_group_sel = 1 : 왼쪽  4자리 그룹 (AN[7:4])
// - Common Anode 기준, active-low 출력
// - 소수점 위치 : d2 자리 DP ON (d3 d2 . d1 d0)
// ============================================================

module seg_driver #(
    parameter P_SCAN_MAX = 100_000 - 1   // 스캔 속도 조절 (100MHz 기준 약 1kHz 정도)
    //parameter P_SCAN_MAX = 10 - 1   // 스캔 속도 조절 (100MHz 기준 약 1kHz 정도)
)(
    input  wire       i_clk,        // 100MHz 시스템 클럭
    input  wire       i_rst_n,      // Active-Low reset

    input  wire [3:0] i_d3,         // 십초 자리 (10s)
    input  wire [3:0] i_d2,         // 초 자리 (1s)
    input  wire [3:0] i_d1,         // 0.1s 자리
    input  wire [3:0] i_d0,         // 0.01s 자리

    input  wire       i_group_sel,  // 0: 오른쪽 그룹(AN[3:0]), 1: 왼쪽 그룹(AN[7:4])

    output reg  [7:0] o_an,         // AN7 ~ AN0 (active-low)
    output reg  [6:0] o_seg,        // g f e d c b a (active-low)
    output reg        o_dp          // DP (active-low)
);

    // 1. 스캔용 카운터 및 현재 자리 인덱스 (0~3)
    reg [16:0] r_scan_cnt;
    reg [1:0]  r_digit_idx;  // 0~3 : 현재 표시 중인 자리 인덱스

    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            r_scan_cnt  <= 17'd0;
            r_digit_idx <= 2'd0;
        end
        else begin
            if (r_scan_cnt >= P_SCAN_MAX) begin
                r_scan_cnt  <= 17'd0;
                r_digit_idx <= r_digit_idx + 1'b1;
            end
            else begin
                r_scan_cnt  <= r_scan_cnt + 1'b1;
            end
        end
    end

    // 2. 현재 자리 인덱스에 따라 선택된 BCD 값 선택
    reg [3:0] r_curr_bcd;

    always @(*) begin
        case (r_digit_idx)
            2'd0: r_curr_bcd = i_d0;
            2'd1: r_curr_bcd = i_d1;
            2'd2: r_curr_bcd = i_d2;
            2'd3: r_curr_bcd = i_d3;
            default: r_curr_bcd = 4'd0;
        endcase
    end

    // 3. BCD → 7-Segment 디코더 (Common Anode, active-low)
    always @(*) begin
        case (r_curr_bcd)
            4'd0: o_seg = 7'b1000000; // 0
            4'd1: o_seg = 7'b1111001; // 1
            4'd2: o_seg = 7'b0100100; // 2
            4'd3: o_seg = 7'b0110000; // 3
            4'd4: o_seg = 7'b0011001; // 4
            4'd5: o_seg = 7'b0010010; // 5
            4'd6: o_seg = 7'b0000010; // 6
            4'd7: o_seg = 7'b1111000; // 7
            4'd8: o_seg = 7'b0000000; // 8
            4'd9: o_seg = 7'b0010000; // 9
            default: o_seg = 7'b1111111; // 모두 OFF (blank)
        endcase
    end

    // 4. AN 제어 (어느 자리 켤지 + 어느 그룹을 쓸지)
    always @(*) begin                                               // 기본값: 전부 OFF (1)
        o_an = 8'b1111_1111;

        if (i_group_sel == 1'b0) begin                              // 오른쪽 그룹 사용 (AN3~AN0)
            case (r_digit_idx)
                2'd0: o_an = 8'b1111_1110; // AN0 ON
                2'd1: o_an = 8'b1111_1101; // AN1 ON
                2'd2: o_an = 8'b1111_1011; // AN2 ON
                2'd3: o_an = 8'b1111_0111; // AN3 ON
                default: o_an = 8'b1111_1111;
            endcase
        end
        else begin                                                  // 왼쪽 그룹 사용 (AN7~AN4)
            case (r_digit_idx)
                2'd0: o_an = 8'b1110_1111; // AN4 ON
                2'd1: o_an = 8'b1101_1111; // AN5 ON
                2'd2: o_an = 8'b1011_1111; // AN6 ON
                2'd3: o_an = 8'b0111_1111; // AN7 ON
                default: o_an = 8'b1111_1111;
            endcase
        end
    end

    // 5. DP 제어 (소수점)
    always @(*) begin                                               // 기본: OFF (1)
        o_dp = 1'b1;
        if (r_digit_idx == 2'd2) begin                              // d2 자리일 때만 DP ON
            o_dp = 1'b0;
        end
    end

endmodule