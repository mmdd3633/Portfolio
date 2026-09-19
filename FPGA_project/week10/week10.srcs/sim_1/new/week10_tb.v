`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/16 13:16:54
// Design Name: 
// Module Name: week10_tb
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

//// 버튼 제어하기1 테스트 벤치
//module week10_tb;

//reg  i_clk;
//reg  i_rst_n;
//reg  i_btn;
//wire o_led;

//// DUT 인스턴스
//week10 dut (
//    .i_clk   (i_clk),
//    .i_rst_n (i_rst_n),
//    .i_btn   (i_btn),
//    .o_led   (o_led)
//);

//// DUT 내부 신호를 TB에서 바로 보기
//wire btn_dly   = dut.r_btn_dly;       // 지연된 버튼
//wire btn_pe    = dut.w_btn_posedge;   // 버튼 상승엣지 검출

//// 클럭: 10ns 주기
//initial begin
//    i_clk = 0;
//    forever #5 i_clk = ~i_clk;        // 5ns마다 토글 → 10ns period
//end

//// VCD 덤프
//initial begin
//    $dumpfile("week10_tb.vcd");
//    $dumpvars(0, week10_tb);
//end

//// 자극 시나리오
//initial begin
//    i_rst_n = 0;
//    i_btn   = 0;

//    // 리셋 해제 (클럭과 애매하게 어긋나게)
//    #12;
//    i_rst_n = 1;

//    // 조금 기다리기 (클럭 2개)
//    repeat (2) @(posedge i_clk);

//    // ============================
//    // 1번째 버튼: 클럭 중간에 누르고 2클럭 정도 유지
//    // ============================
//    // 현재 posedge에서 2ns 뒤 (클럭 중간쯤) 버튼 올림
//    #2;
//    i_btn = 1;           // 예: t ? 17ns쯤
//    #20;                 // 20ns 유지 → 2클럭 정도
//    i_btn = 0;

//    // 이 때 LED는 1번 토글되어야 한다.

//    // 클럭 3개 기다리기
//    repeat (3) @(posedge i_clk);

//    // ============================
//    // 2번째 버튼: 또 다른 타이밍에서 1.5클럭 정도 유지
//    // ============================
//    #4;
//    i_btn = 1;
//    #15;                 // 1.5클럭 정도
//    i_btn = 0;

//    i_rst_n = 0;
    
    
//    // 조금 기다리기 (클럭 2개)
//    repeat (2) @(posedge i_clk);

//    // ============================
//    // 1번째 버튼: 클럭 중간에 누르고 2클럭 정도 유지
//    // ============================
//    // 현재 posedge에서 2ns 뒤 (클럭 중간쯤) 버튼 올림
//    #2;
//    i_btn = 1;           // 예: t ? 17ns쯤
//    #20;                 // 20ns 유지 → 2클럭 정도
//    i_btn = 0;

//    // 이 때 LED는 1번 토글되어야 한다.

//    // 클럭 3개 기다리기
//    repeat (3) @(posedge i_clk);

//    // ============================
//    // 2번째 버튼: 또 다른 타이밍에서 1.5클럭 정도 유지
//    // ============================
//    #4;
//    i_btn = 1;
//    #15;                 // 1.5클럭 정도
//    i_btn = 0;

//    // 마지막 여유 시간
//    #100;
//    $finish;
//end

//// 매 클럭마다 상태 모니터링
//always @(posedge i_clk) begin
//    $display("[%0t] rst=%0b  btn=%0b  btn_dly=%0b  btn_pe=%0b  led=%0b",
//             $time, i_rst_n, i_btn, btn_dly, btn_pe, o_led);
//end

//endmodule

//// 버튼 제어하기 2 테스트 벤치
//module tb_week10;

//    reg         i_clk;
//    reg         i_rst_n;
//    reg         i_btn;
//    wire [7:0]  o_seg;
//    wire [7:0]  o_an;

//    // DUT
//    week10 dut (
//        .i_clk  (i_clk  ),
//        .i_rst_n(i_rst_n),
//        .i_btn  (i_btn  ),
//        .o_seg  (o_seg  ),
//        .o_an   (o_an   )
//    );

//    // 내부 신호 확인용
//    wire        w_btn_posedge = dut.w_btn_posedge;
//    wire [3:0]  r_cnt         = dut.r_cnt;
//    wire        r_btn_dly     = dut.r_btn_dly;

//    // 클럭 100MHz (10ns 주기)
//    initial begin
//        i_clk = 0;
//        forever #5 i_clk = ~i_clk;
//    end

//    // 버튼 태스크
//    task press_button;
//        input integer pre_delay_ns;   // 버튼을 누르기 전 대기 시간
//        input integer press_width_ns; // 버튼을 누르고 있는 시간
//        begin
//            #(pre_delay_ns);
//            i_btn = 1;
//            #(press_width_ns);
//            i_btn = 0;
//        end
//    endtask

//    initial begin
//        i_rst_n = 0;
//        i_btn   = 0;

//        $dumpfile("week10_tb.vcd");
//        $dumpvars(0, tb_week10);

//        // 초기 리셋
//        #20;
//        i_rst_n = 1;

//        // 첫 번째 카운트 시퀀스 (0~9, 다시 0)
//        // 모든 pre_delay >= 11ns 로 해서 버튼 low 구간마다 클럭 엣지가 최소 1번은 들어가도록 함
//        press_button(12, 17);  // 0 -> 1
//        press_button(13, 19);  // 1 -> 2
//        press_button(15, 13);  // 2 -> 3
//        press_button(11, 22);  // 3 -> 4
//        press_button(18, 15);  // 4 -> 5
//        press_button(13, 17);  // 5 -> 6
//        press_button(16, 14);  // 6 -> 7
//        press_button(11, 21);  // 7 -> 8
//        press_button(15, 18);  // 8 -> 9
//        press_button(12, 13);  // 9 -> 0

//        // 추가로 몇 번 더 눌러서 0,1,2,... 로 계속 도는 것도 확인
//        press_button(14, 16);  // 0 -> 1
//        press_button(11, 20);  // 1 -> 2

//        #100;

//        // 두 번째 리셋
//        i_rst_n = 0;

//        // 두 번째 카운트 시퀀스 (다른 타이밍 패턴)
//        press_button(13, 18);  // 0 -> 1
//        press_button(16, 14);  // 1 -> 2
//        press_button(11, 23);  // 2 -> 3
//        press_button(19, 15);  // 3 -> 4
//        press_button(12, 19);  // 4 -> 5
//        press_button(17, 13);  // 5 -> 6
//        press_button(11, 21);  // 6 -> 7
//        press_button(14, 16);  // 7 -> 8
//        press_button(18, 15);  // 8 -> 9
//        press_button(11, 22);  // 9 -> 0

//        press_button(15, 17);  // 0 -> 1
//        press_button(12, 18);  // 1 -> 2

//        #100;
//        $finish;
//    end

//endmodule

module tb_week10;

    reg         i_clk;
    reg         i_rst_n;
    reg         i_btn;
    wire [7:0]  o_seg;
    wire [7:0]  o_an;

    // DUT
    week10 dut (
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
        $dumpfile("week10_tb.vcd");
        $dumpvars(0, tb_week10);
    end

endmodule