`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/08 14:02:45
// Design Name: 
// Module Name: apb_led
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: APB Slave for Mono LED, Color LEDs, and Switch Status
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Expanded to support 2 Color LEDs and 12-bit Switch
// 
//////////////////////////////////////////////////////////////////////////////////

module apb_led (
    // 클럭 및 리셋
    input  wire        i_clk,
    input  wire        i_rst_n,
    
    // APB 버스 인터페이스
    input  wire [31:0] i_apb_paddr,
    input  wire        i_apb_penable,
    input  wire        i_apb_psel,
    input  wire        i_apb_pwrite,
    input  wire [31:0] i_apb_pwdata,
    output reg  [31:0] o_apb_prdata,
    output wire        o_apb_pready,
    output wire        o_apb_pslverr,
    
    // 사용자 정의 외부 인터페이스 (확장된 부분)
    output wire [9:0]  o_led,         // 단색 LED 출력
    output wire [2:0]  o_color_led_0, // 컬러 LED 0 출력 (RGB)
    output wire [2:0]  o_color_led_1, // 컬러 LED 1 출력 (RGB)
    input  wire [11:0] i_sw           // 슬라이드 스위치 입력
);

    // ==========================================
    // 주소 매핑 (CPU가 접근할 메모리 주소)
    // ==========================================
    localparam BASE_ADDR   = 32'h43C0_0000;
    localparam MONO_LED    = BASE_ADDR + 32'h0;
    localparam COLOR_LED_0 = BASE_ADDR + 32'h4;
    localparam COLOR_LED_1 = BASE_ADDR + 32'h8;
    localparam SW_STATUS   = BASE_ADDR + 32'hC;

    // ==========================================
    // 내부 레지스터 선언 (상태 저장용)
    // ==========================================
    reg [9:0] r_mono_led;
    reg [2:0] r_color_led_0;
    reg [2:0] r_color_led_1;
    // 스위치(i_sw)는 외부에서 들어오는 값을 바로 읽으므로 reg가 필요 없습니다.

    // ==========================================
    // APB 응답 신호 고정 (항상 준비됨, 에러 없음)
    // ==========================================
    assign o_apb_pready  = 1'b1;
    assign o_apb_pslverr = 1'b0;

    // ==========================================
    // 내부 레지스터 값을 실제 외부 핀(출력 포트)으로 연결
    // ==========================================
    assign o_led         = r_mono_led;
    assign o_color_led_0 = r_color_led_0;
    assign o_color_led_1 = r_color_led_1;

    // ==========================================
    // 1. APB Write 로직 (CPU가 레지스터에 값을 쓸 때)
    // ==========================================
    // 클럭에 동기화되는 순차 논리회로
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            // 리셋 시 모든 LED를 끕니다.
            r_mono_led    <= 10'd0;
            r_color_led_0 <= 3'd0;
            r_color_led_1 <= 3'd0;
        end
        else begin
            // psel과 penable이 High이고, Write 모드(1)일 때
            if (i_apb_psel && i_apb_penable && i_apb_pwrite) begin
                // 들어온 주소(i_apb_paddr)에 따라 알맞은 레지스터에 데이터를 저장
                case (i_apb_paddr)
                    MONO_LED:    r_mono_led    <= i_apb_pwdata[9:0];
                    COLOR_LED_0: r_color_led_0 <= i_apb_pwdata[2:0];
                    COLOR_LED_1: r_color_led_1 <= i_apb_pwdata[2:0];
                    // SW_STATUS (0xC)는 읽기 전용이므로 Write 로직에서는 무시합니다.
                    default: ; 
                endcase
            end
        end
    end

    // ==========================================
    // 2. APB Read 로직 (CPU가 레지스터나 스위치 값을 읽어갈 때)
    // ==========================================
    // 즉각적인 응답을 위한 조합 논리회로 (always @* 사용)
    always @(*) begin
        // 기본 데이터 버스 초기화 (LATCH 방지용)
        o_apb_prdata = 32'd0; 
        
        // psel이 High이고, Read 모드(0)일 때
        if (i_apb_psel && ~i_apb_pwrite) begin
            case (i_apb_paddr)
                MONO_LED:    o_apb_prdata = {22'h0, r_mono_led};
                COLOR_LED_0: o_apb_prdata = {29'h0, r_color_led_0};
                COLOR_LED_1: o_apb_prdata = {29'h0, r_color_led_1};
                SW_STATUS:   o_apb_prdata = {20'h0, i_sw}; // 외부 스위치 값을 읽어서 CPU로 보냄
                default:     o_apb_prdata = 32'd0;
            endcase
        end
    end

endmodule