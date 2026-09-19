`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/02 22:48:05
// Design Name: 
// Module Name: tb_top_stopwatch
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
module tb_top_stopwatch;

    // ==========================
    // DUT 입출력
    // ==========================
    reg         i_clk;
    reg         i_rst_n;

    reg         BTNC;   // start/stop
    reg         BTNL;   // left
    reg         BTNR;   // right
    reg         BTND;   // clear

    wire [15:0] o_led;
    wire [7:0]  o_an;
    wire [6:0]  o_cn;
    wire        o_dp;

    // ==========================
    // DUT 인스턴스
    //  - 내부에서 시간 파라미터들을 10으로 설정했다고 가정
    // ==========================
    top_stopwatch dut (
        .i_clk (i_clk),
        .i_rst_n (i_rst_n),
        .BTNC (BTNC),
        .BTNL (BTNL),
        .BTNR (BTNR),
        .BTND (BTND),
        .o_led (o_led),
        .o_an  (o_an),
        .o_cn  (o_cn),
        .o_dp  (o_dp)
    );

    // ==========================
    // 100 MHz 클럭 (10 ns 주기)
    // ==========================
    initial i_clk = 1'b0;
    always  #5 i_clk = ~i_clk;

    // ==========================
    // 유틸: N 클럭 기다리기
    // ==========================
    task wait_cycles(input integer n);
        integer k;
        begin
            for (k = 0; k < n; k = k + 1)
                @(posedge i_clk);
        end
    endtask

    // ==========================
    // 디바운스/카운트 파라미터(시뮬 기준)
    //  - P_DEBOUNCE_MAX = 10
    //  - P_CNT_MAX      = 10 (tick 주기)
    // ==========================
    localparam integer BTN_PRESS_CYC = 20;    // 디바운스 10보다 크게
    localparam integer BTN_GAP_CYC   = 20;    // 버튼 사이 최소 간격

    // 20초 이상 올라가도록 띄워주는 구간
    // P_CNT_MAX = 10이면 tick은 ~11클럭마다 한 번
    // 0.01초 * 2000tick = 20초 → 대략 2000 * 11 ? 22000클럭 필요
    localparam integer RUN_WAIT1_CYC = 10_000; // 첫 RUN 후 ~9초 정도
    localparam integer RUN_WAIT2_CYC = 10_000; // 왼쪽표시 후 ~9초 정도 → 합계 ~18초
    localparam integer RUN_WAIT3_CYC = 5_000;  // 오른쪽표시 후 ~4.5초 → 합계 ~22초

    localparam integer OBS_STOP_CYC  = 1_000;  // 정지 상태 관찰
    localparam integer OBS_CLR_CYC   = 1_000;  // 초기화 상태 관찰

    // ==========================
    // 버튼 동작 task들
    // ==========================
    task press_center;  // RUN 토글
        begin
            BTNC = 1'b1;
            wait_cycles(BTN_PRESS_CYC);
            BTNC = 1'b0;
            wait_cycles(BTN_GAP_CYC);
        end
    endtask

    task press_left;    // 왼쪽 그룹 선택
        begin
            BTNL = 1'b1;
            wait_cycles(BTN_PRESS_CYC);
            BTNL = 1'b0;
            wait_cycles(BTN_GAP_CYC);
        end
    endtask

    task press_right;   // 오른쪽 그룹 선택
        begin
            BTNR = 1'b1;
            wait_cycles(BTN_PRESS_CYC);
            BTNR = 1'b0;
            wait_cycles(BTN_GAP_CYC);
        end
    endtask

    task press_down;    // clear
        begin
            BTND = 1'b1;
            wait_cycles(BTN_PRESS_CYC);
            BTND = 1'b0;
            wait_cycles(BTN_GAP_CYC);
        end
    endtask

    // ==========================
    // 한 사이클: 시작→왼쪽→오른쪽→정지→초기화
    // ==========================
    task one_run_cycle;
        begin
            // 1) RUN 시작 (BTNC)
            press_center();
            //    → RUN=1, 카운터/LED 동작 시작
            wait_cycles(RUN_WAIT1_CYC);

            // 2) 왼쪽 그룹으로 표시 위치 변경 (BTNL)
            press_left();
            //    → group_sel=1, 왼쪽 세그먼트 그룹 사용
            wait_cycles(RUN_WAIT2_CYC);

            // 3) 오른쪽 그룹으로 다시 변경 (BTNR)
            press_right();
            //    → group_sel=0, 오른쪽 세그먼트 그룹 사용
            wait_cycles(RUN_WAIT3_CYC);

            // 4) RUN 정지 (BTNC)
            press_center();
            //    → RUN=0, 카운터/LED 멈춤
            wait_cycles(OBS_STOP_CYC);

            // 5) CLEAR (BTND)
            press_down();
            //    → 카운터 00.00, LED 0x0000
            wait_cycles(OBS_CLR_CYC);
        end
    endtask

    // ==========================
    // 메인 시뮬레이션
    //  - 리셋 후 one_run_cycle을 두 번 반복
    // ==========================
    initial begin
        // 초기 상태
        i_rst_n = 1'b0;
        BTNC = 1'b0;
        BTNL = 1'b0;
        BTNR = 1'b0;
        BTND = 1'b0;

        // 리셋 유지
        wait_cycles(10);
        i_rst_n = 1'b1;

        // 안정화 시간
        wait_cycles(20);

        // 두 사이클 실행
        one_run_cycle();
        one_run_cycle();

        $stop;
    end

endmodule


