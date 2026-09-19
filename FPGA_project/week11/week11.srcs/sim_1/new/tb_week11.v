`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/23 09:41:25
// Design Name: 
// Module Name: tb_week11
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

module tb_week11;

    reg         i_clk;
    reg         i_rst_n;
    reg         i_btn;
    wire [7:0]  o_seg;
    wire [7:0]  o_an;

    // DUT
    week11 dut (
        .i_clk   (i_clk),
        .i_rst_n (i_rst_n),
        .i_btn   (i_btn),
        .o_seg   (o_seg),
        .o_an    (o_an)
    );

    // 100 MHz 클럭 (10 ns)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

    initial begin
        // 초기값
        i_rst_n = 0;
        i_btn   = 0;

        // 리셋 해제
        #100;
        i_rst_n = 1;

        // --- 1번째 버튼 눌림 : 바운싱 구간 ---
        #500;
        repeat(10) begin
            #40;
            i_btn = ~i_btn;    // 0/1 빠르게 토글 → 바운싱 흉내
        end

        // 안정적으로 HIGH 유지 (진짜 눌린 상태)
        i_btn = 1;
        #500;

        // --- 1번째 버튼 뗌 : 바운싱 구간 ---
        repeat(10) begin
            #40;
            i_btn = ~i_btn;
        end

        // 안정적으로 LOW 유지 (완전히 뗀 상태)
        i_btn = 0;
        #100_0;

        // 시뮬레이션 종료
        #1000;
        $finish;
    end

    // 파형 확인용 (필요 없으면 이것도 지워도 됨)
    initial begin
        $dumpfile("week11_tb.vcd");
        $dumpvars(0, tb_week11);
    end

endmodule



