`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/08 15:20:24
// Design Name: 
// Module Name: LED_top
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

module system_top (
    // ==========================================
    // Zynq PS 전용 필수 포트 (Pass-through)
    // ==========================================
    inout [14:0] DDR_addr,
    inout [2:0]  DDR_ba,
    inout        DDR_cas_n,
    inout        DDR_ck_n,
    inout        DDR_ck_p,
    inout        DDR_cke,
    inout        DDR_cs_n,
    inout [3:0]  DDR_dm,
    inout [31:0] DDR_dq,
    inout [3:0]  DDR_dqs_n,
    inout [3:0]  DDR_dqs_p,
    inout        DDR_odt,
    inout        DDR_ras_n,
    inout        DDR_reset_n,
    inout        DDR_we_n,
    inout        FIXED_IO_ddr_vrn,
    inout        FIXED_IO_ddr_vrp,
    inout [53:0] FIXED_IO_mio,
    inout        FIXED_IO_ps_clk,
    inout        FIXED_IO_ps_porb,
    inout        FIXED_IO_ps_srstb,

    // ==========================================
    // 사용자 정의 외부 출력 (Board LED)
    // ==========================================
    output wire [9:0] o_led
);

    // ==========================================
    // 모듈 간 연결을 위한 내부 Wire 선언
    // ==========================================
    wire [31:0] w_apb_paddr;
    wire        w_apb_penable;
    wire [31:0] w_apb_prdata;
    wire [0:0]  w_apb_pready;
    wire [0:0]  w_apb_psel;
    wire [0:0]  w_apb_pslverr;
    wire [31:0] w_apb_pwdata;
    wire        w_apb_pwrite;
    wire        w_apb_clk;
    wire [0:0]  w_apb_rst;

    // ==========================================
    // 1. Zynq PS & APB Bridge (Master) 인스턴스화
    // ==========================================
    week9_wrapper u_week9_wrapper (
        // APB Bus Connection
        .APB_M_paddr   (w_apb_paddr),
        .APB_M_penable (w_apb_penable),
        .APB_M_prdata  (w_apb_prdata),
        .APB_M_pready  (w_apb_pready),
        .APB_M_psel    (w_apb_psel),
        .APB_M_pslverr (w_apb_pslverr),
        .APB_M_pwdata  (w_apb_pwdata),
        .APB_M_pwrite  (w_apb_pwrite),
        .apb_clk       (w_apb_clk),
        .apb_rst       (w_apb_rst),

        // DDR & FIXED_IO Connection
        .DDR_addr(DDR_addr), .DDR_ba(DDR_ba), .DDR_cas_n(DDR_cas_n), .DDR_ck_n(DDR_ck_n), 
        .DDR_ck_p(DDR_ck_p), .DDR_cke(DDR_cke), .DDR_cs_n(DDR_cs_n), .DDR_dm(DDR_dm), 
        .DDR_dq(DDR_dq), .DDR_dqs_n(DDR_dqs_n), .DDR_dqs_p(DDR_dqs_p), .DDR_odt(DDR_odt), 
        .DDR_ras_n(DDR_ras_n), .DDR_reset_n(DDR_reset_n), .DDR_we_n(DDR_we_n), 
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn), .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp), 
        .FIXED_IO_mio(FIXED_IO_mio), .FIXED_IO_ps_clk(FIXED_IO_ps_clk), 
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb), .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb)
    );

    // ==========================================
    // 2. Custom APB Slave (LED Controller) 인스턴스화
    // ==========================================
    apb_led u_apb_led (
        .i_clk         (w_apb_clk),
        .i_rst_n       (w_apb_rst[0]),    // 배열[0]과 단일 비트 매핑
        .i_apb_paddr   (w_apb_paddr),
        .i_apb_penable (w_apb_penable),
        .i_apb_psel    (w_apb_psel[0]),   // 배열[0]과 단일 비트 매핑
        .i_apb_pwrite  (w_apb_pwrite),
        .i_apb_pwdata  (w_apb_pwdata),
        .o_apb_prdata  (w_apb_prdata),
        .o_apb_pready  (w_apb_pready[0]), // 단일 비트 출력을 배열[0]으로 인가
        .o_apb_pslverr (w_apb_pslverr[0]),// 단일 비트 출력을 배열[0]으로 인가
        
        .o_led         (o_led)            // 외부 LED 포트로 출력
    );

endmodule