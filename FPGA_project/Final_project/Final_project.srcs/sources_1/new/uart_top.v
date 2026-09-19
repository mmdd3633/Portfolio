`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/10 17:39:41
// Design Name: 
// Module Name: uart_top
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

module uart_top #(
    parameter integer CLK_FREQ  = 100_000_000, // 시스템 클럭 (100MHz)
    parameter integer BAUD_RATE = 115200       // 통신 속도 (115200bps)
)(
    // 시스템 클럭 및 리셋
    input  wire       clk,
    input  wire       rst_n,    // Active Low Reset (보드 버튼: 누르면 0, 평소 1)
    input  wire [1:0] sw,
    
    // UART 인터페이스 (USB-UART)
    input  wire       uart_rx,  // PC -> FPGA (수신)
    output wire       uart_tx,  // FPGA -> PC (송신)

    // 7-Segment 디스플레이 인터페이스
    output wire [6:0] seg,      // Cathode (a~g)
    output wire [7:0] an,       // Anode (AN0~AN7)
    output wire       dp        // Decimal Point
);
    // 1. 내부 신호 선언 및 리셋 처리
    wire rst = ~rst_n;

    // 모듈 간 연결을 위한 신호들
    wire       baud_tick;   // Baud Rate 생성 틱
    wire [7:0] tx_data;     // 송신할 데이터
    wire       tx_start;    // 송신 시작 트리거
    wire       tx_busy;     // 송신 중 상태 플래그
    wire [7:0] rx_data;     // 수신된 데이터
    wire       rx_valid;    // 수신 완료 펄스
    wire [7:0] last_rx;     // 마지막으로 수신된 데이터 (FSM에서 유지)

    // 2. 하위 모듈 인스턴스화 (Sub-modules)
    baud_gen #(
        .CLK_FREQ (CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) u_baud (
        .clk      (clk),
        .rst      (rst),
        .baud_tick(baud_tick)
    );

    uart_tx #(
        .CLK_FREQ (CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) u_tx (
        .clk      (clk),
        .rst      (rst),
        .baud_tick(baud_tick),
        .data_in  (tx_data),
        .start    (tx_start),
        .tx       (uart_tx),
        .busy     (tx_busy)
    );

    uart_rx #(
        .CLK_FREQ (CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) u_rx (
        .clk      (clk),
        .rst      (rst),
        .rx       (uart_rx),
        .data_out (rx_data),
        .valid    (rx_valid)
    );

    // FSM
    uart_fsm u_fsm (
        .clk      (clk),
        .rst      (rst),
        .sw       (sw),
        .rx_data  (rx_data),
        .rx_valid (rx_valid),
        .tx_busy  (tx_busy),
        .tx_data  (tx_data),
        .tx_start (tx_start),
        .last_rx  (last_rx)  // 7-Segment에 표시할 데이터
    );

    // 3. 7-Segment 디스플레이 제어 (Multiplexing)
    reg [16:0] refresh_cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) 
            refresh_cnt <= 17'd0;
        else     
            refresh_cnt <= refresh_cnt + 17'd1;
    end

    // 자리 선택 신호 (0: 하위 4비트 표시, 1: 상위 4비트 표시)
    wire digit_sel = refresh_cnt[16];

    // last_rx[7:4] (상위), last_rx[3:0] (하위)
    wire [3:0] disp_digit = (digit_sel) ? last_rx[7:4] : last_rx[3:0];

    reg [6:0] seg_r;
    always @* begin
        case (disp_digit)
            4'h0: seg_r = 7'b1000000; // 0
            4'h1: seg_r = 7'b1111001; // 1
            4'h2: seg_r = 7'b0100100; // 2
            4'h3: seg_r = 7'b0110000; // 3
            4'h4: seg_r = 7'b0011001; // 4
            4'h5: seg_r = 7'b0010010; // 5
            4'h6: seg_r = 7'b0000010; // 6
            4'h7: seg_r = 7'b1111000; // 7
            4'h8: seg_r = 7'b0000000; // 8
            4'h9: seg_r = 7'b0010000; // 9
            4'hA: seg_r = 7'b0001000; // A
            4'hB: seg_r = 7'b0000011; // b
            4'hC: seg_r = 7'b1000110; // C
            4'hD: seg_r = 7'b0100001; // d
            4'hE: seg_r = 7'b0000110; // E
            4'hF: seg_r = 7'b0001110; // F
            default: seg_r = 7'b1111111; // Off
        endcase
    end
    
    assign seg = seg_r;
    assign an = (digit_sel) ? 8'b1111_1101 : 8'b1111_1110;
    assign dp = 1'b1;
endmodule