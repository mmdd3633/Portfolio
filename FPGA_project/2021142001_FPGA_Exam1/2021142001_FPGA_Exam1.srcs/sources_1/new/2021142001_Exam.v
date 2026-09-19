`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/29 15:38:01
// Design Name: 
// Module Name: 2021142001_Exam
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


module Exam1(
    input  wire        i_clk,    // 100 MHz
    input  wire        i_rst_n,  // active-low
    input  wire [15:0] i_sw,     // SW[15:12]=SEG3 ... SW[3:0]=SEG0
    output reg  [7:0]  o_ca,     // a~g,dot  (active-low)
    output reg  [7:0]  o_an      // AN7..AN0 (active-low)
);

    // ==========================================================
    // 1. 클럭 분주기 (4ms tick 생성)
    // ==========================================================
    // 4ms 분주기 (100MHz * 0.004s = 400,000)
    reg [18:0] r_cnt;             // 0..399,999
    wire w_tick_4ms;
    assign w_tick_4ms = (r_cnt == 19'd399_999); // 틱 발생 조건

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n)
            r_cnt <= 19'd0;
        else begin
            if (w_tick_4ms) r_cnt <= 19'd0;
            else            r_cnt <= r_cnt + 19'd1;
        end
    end

    // ==========================================================
    // 2. 자리 인덱스 순환 및 AN(Active-Low) 조합 논리
    // ==========================================================
    // 자리 인덱스(0→1→2→3)
    reg [1:0] r_idx;          // 0:SEG0, 1:SEG1, 2:SEG2, 3:SEG3
    
    // AN 출력값 (하위 4자리) - r_idx에 의해 결정되는 조합 논리
    wire [3:0] w_an_low4;

    // r_idx 순환 (4ms마다)
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_idx  <= 2'd0;
        end else if (w_tick_4ms) begin
            // 인덱스 순환 (0, 1, 2, 3, 0...)
            if (r_idx == 2'd3) r_idx <= 2'd0;
            else               r_idx <= r_idx + 2'd1;
        end
    end

    // 현재 r_idx에 해당하는 자리만 0(Active-Low)으로 설정
    assign w_an_low4 = (r_idx == 2'd0) ? 4'b1110 : // SEG0 켜짐
                       (r_idx == 2'd1) ? 4'b1101 : // SEG1 켜짐
                       (r_idx == 2'd2) ? 4'b1011 : // SEG2 켜짐
                                         4'b0111;  // SEG3 켜짐

    // ==========================================================
    // 3. 현재 자리의 4비트 값 선택 (MUX)
    // ==========================================================
    reg [3:0] r_digit;        // 7-세그 디코더 입력 (현재 표시할 값)
    always @(*) begin
        if (!i_rst_n)
            r_digit = 4'd0;               // 리셋 동안 0
        else if (r_idx == 2'd0)
            r_digit = i_sw[3:0];          // SEG0 값
        else if (r_idx == 2'd1)
            r_digit = i_sw[7:4];          // SEG1 값
        else if (r_idx == 2'd2)
            r_digit = i_sw[11:8];         // SEG2 값
        else // r_idx == 2'd3
            r_digit = i_sw[15:12];        // SEG3 값
    end

    // ==========================================================
    // 4. 7-세그 디코더 (Combination Logic)
    // ==========================================================
    // r_digit에 따라 7-세그먼트(a~g) 출력 결정
    reg [6:0] r_ca7; // a~g
    always @(*) begin
        case (r_digit)
            4'h0: r_ca7 = 7'b1000000; // 0
            4'h1: r_ca7 = 7'b1111001; // 1
            4'h2: r_ca7 = 7'b0100100; // 2
            4'h3: r_ca7 = 7'b0110000; // 3
            4'h4: r_ca7 = 7'b0011001; // 4
            4'h5: r_ca7 = 7'b0010010; // 5
            4'h6: r_ca7 = 7'b0000010; // 6
            4'h7: r_ca7 = 7'b1111000; // 7
            4'h8: r_ca7 = 7'b0000000; // 8
            4'h9: r_ca7 = 7'b0010000; // 9
            4'hA: r_ca7 = 7'b0001000; // A
            4'hB: r_ca7 = 7'b0000011; // b
            4'hC: r_ca7 = 7'b0100111; // C 
            4'hD: r_ca7 = 7'b0100001; // d
            4'hE: r_ca7 = 7'b0000110; // E
            4'hF: r_ca7 = 7'b0001110; // F
            default: r_ca7 = 7'b1111111; // OFF
        endcase
    end

    // ==========================================================
    // 5. 최종 출력 레지스터 업데이트
    // ==========================================================
    always @(*) begin
        // CA: a..g + dot(OFF)
        o_ca[6:0] = r_ca7;
        o_ca[7]   = 1'b1;     // DOT 끔 (Active-High)

        // AN: 상위 4자리는 항상 OFF(=1), 하위 4자리는 스캔
        if (!i_rst_n) begin
            // 리셋 중: 모든 자리 켜서 디버그 (4'b0000)
            o_an[7:4] = 4'b1111;
            o_an[3:0] = 4'b0000;
        end 
        else begin
            o_an[7:4] = 4'b1111;
            o_an[3:0] = w_an_low4; // 조합 논리로 결정된 현재 자리 AN 값 사용
        end
    end

endmodule