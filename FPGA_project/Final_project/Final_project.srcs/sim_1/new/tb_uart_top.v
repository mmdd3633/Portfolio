`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/19 13:08:13
// Design Name: 
// Module Name: tb_uart_top
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


//module tb_uart_top();

//    reg clk;
//    reg rst_n;
//    reg uart_rx;
//    wire uart_tx;
//    wire [6:0] seg;
//    wire [7:0] an;
//    wire dp;

//    // 100MHz 클럭 (주기 10ns)
//    always #5 clk = ~clk;

//    // DUT 연결
//    uart_top #(
//        .CLK_FREQ(100_000_000),
//        .BAUD_RATE(115200)
//    ) u_top (
//        .clk(clk),
//        .rst_n(rst_n),
//        .uart_rx(uart_rx),
//        .uart_tx(uart_tx),
//        .seg(seg),
//        .an(an),
//        .dp(dp)
//    );

//    initial begin
//        // 초기화
//        clk = 0;
//        rst_n = 0;
//        uart_rx = 1; // Idle
        
//        // 1. 리셋 해제 (FSM 동작 시작)
//        #100;
//        rst_n = 1;

//        // 2. 파형 관찰 구간 (약 600us)
//        // 정상이라면 이 시간 동안 Hello가 예쁘게 나와야 하지만,
//        // 수정 전 코드에서는 앞부분 100ns 동안 FSM 혼자 다 끝내버리고
//        // TX 라인은 조용하거나 이상한 값 하나만 나옵니다.
//        #600_000; 

//        $stop;
//    end

//endmodule
`timescale 1ns / 1ps

module tb_uart_top();

    // 1. 신호 선언
    reg clk;
    reg rst_n;
    reg [1:0] sw;   // [추가됨] 스위치 제어 신호
    reg uart_rx;
    
    wire uart_tx;
    wire [6:0] seg;
    wire [7:0] an;
    wire dp;

    // 1비트 시간 (115200bps -> 약 8.68us = 8680ns)
    localparam BIT_PERIOD = 8680; 

    // 2. DUT 연결 (수정된 uart_top 포트에 맞춤)
    uart_top #(
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(115200)
    ) u_dut (
        .clk(clk), 
        .rst_n(rst_n), 
        .sw(sw),         // 스위치 연결
        .uart_rx(uart_rx), 
        .uart_tx(uart_tx),
        .seg(seg), 
        .an(an), 
        .dp(dp)
    );

    // 3. 안전한 클럭 생성 (100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // 4. 문자 전송 함수 (PC -> FPGA)
    task send_byte(input [7:0] data);
        integer i;
        begin
            uart_rx = 0; // Start Bit
            #(BIT_PERIOD);
            for (i=0; i<8; i=i+1) begin
                uart_rx = data[i]; // Data Bits (LSB first)
                #(BIT_PERIOD);
            end
            uart_rx = 1; // Stop Bit
            #(BIT_PERIOD);
        end
    endtask

    // 5. 메인 시나리오
    initial begin
        $display("=== [Time: 0] Simulation Start ===");
        
        // 초기 상태 설정
        clk = 0;
        rst_n = 0;
        uart_rx = 1;
        sw = 2'b00; // 초기값

        // ---------------------------------------------------------
        // [CASE 1] TX 단독 검증 (sw = 00) -> "Hello" 출력 확인
        // ---------------------------------------------------------
        sw = 2'b00;
        rst_n = 0;
        #1000;      // 리셋 유지
        rst_n = 1;  // 리셋 해제
        $display("=== [Mode: TX Only] Reset Released. Expecting 'Hello' output... ===");

        // Hello 전송 시간 대기 (약 600~700us 소요됨)
        #(800_000); 
        $display("--- 'Hello' transmission should be done. ---");


        // ---------------------------------------------------------
        // [CASE 2] RX 단독 검증 (sw = 01) -> 7-Segment 표시 확인
        // ---------------------------------------------------------
        $display("=== [Mode Change] Switching to RX Only (sw=01) ===");
        sw = 2'b01; 
        
        // 모드 변경 적용을 위해 리셋
        rst_n = 0; #1000; rst_n = 1; 
        
        // 잠시 대기 후 문자 'A' 전송
        #10_000;
        $display("=== Sending 'A' (0x41) -> Check 7-Segment (should correspond to 0x41) ===");
        send_byte(8'h41);
        
        // 처리 시간 대기 (이때 uart_tx는 조용해야 함)
        #(200_000);


        // ---------------------------------------------------------
        // [CASE 3] Echo 검증 (sw = 10) -> 입력값 재전송 확인
        // ---------------------------------------------------------
        $display("=== [Mode Change] Switching to Echo Mode (sw=10) ===");
        sw = 2'b10;
        
        // 모드 변경 적용을 위해 리셋
        rst_n = 0; #1000; rst_n = 1;

        // 잠시 대기 후 문자 'B' 전송
        #10_000;
        $display("=== Sending 'B' (0x42) -> Expecting Echo 'B' on uart_tx ===");
        send_byte(8'h42);
        
        // Echo 돌아올 시간 대기
        #(200_000);

        $display("=== Simulation Finished Successfully ===");
        $finish;
    end

endmodule