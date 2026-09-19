`timescale 1ns / 1ps

module system_top (
    // Zynq PS Pass-through 포트들
    inout [14:0] DDR_addr, inout [2:0] DDR_ba, inout DDR_cas_n, inout DDR_ck_n,
    inout DDR_ck_p, inout DDR_cke, inout DDR_cs_n, inout [3:0] DDR_dm,
    inout [31:0] DDR_dq, inout [3:0] DDR_dqs_n, inout [3:0] DDR_dqs_p, inout DDR_odt,
    inout DDR_ras_n, inout DDR_reset_n, inout DDR_we_n,
    inout FIXED_IO_ddr_vrn, inout FIXED_IO_ddr_vrp, inout [53:0] FIXED_IO_mio,
    inout FIXED_IO_ps_clk, inout FIXED_IO_ps_porb, inout FIXED_IO_ps_srstb,

    // 사용자 정의 포트
    output wire [3:0]  o_seg_an,   
    output wire [7:0]  o_seg_cat,  
    input  wire [3:0]  i_btn       
);

    // 내부 Wire 선언 (이름 통일)
    wire [31:0] w_apb_paddr, w_apb_pwdata, w_apb_prdata;
    wire        w_apb_penable, w_apb_pwrite, w_apb_clk, w_apb_rst;
    wire [0:0]  w_apb_pready, w_apb_psel, w_apb_pslverr;

    // 1. Master Wrapper 인스턴스화
    week10_1_wrapper u_week10_1_wrapper (
        .APB_M_paddr     (w_apb_paddr),
        .APB_M_penable   (w_apb_penable),
        .APB_M_prdata    (w_apb_prdata),
        .APB_M_pready    (w_apb_pready),
        .APB_M_psel      (w_apb_psel),
        .APB_M_pslverr   (w_apb_pslverr),
        .APB_M_pwdata    (w_apb_pwdata),
        .APB_M_pwrite    (w_apb_pwrite),
        
        // 1단계에서 외부로 뺀 포트 이름과 일치시켜야 함
        .apb_clk         (w_apb_clk), 
        .apb_rst         (w_apb_rst),
        .btns_4bits_tri_i(i_btn), // 제공해주신 Wrapper의 실제 이름 적용

        .DDR_addr(DDR_addr), .DDR_ba(DDR_ba), .DDR_cas_n(DDR_cas_n), .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p), .DDR_cke(DDR_cke), .DDR_cs_n(DDR_cs_n), .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq), .DDR_dqs_n(DDR_dqs_n), .DDR_dqs_p(DDR_dqs_p), .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n), .DDR_reset_n(DDR_reset_n), .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn), .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio), .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb), .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb)
    );

    // 2. APB 7-Segment Slave 인스턴스화
    apb_7seg u_apb_7seg (
        .i_clk         (w_apb_clk), 
        .i_rst_n       (w_apb_rst),
        .i_apb_paddr   (w_apb_paddr), 
        .i_apb_penable (w_apb_penable), 
        .i_apb_psel    (w_apb_psel), 
        .i_apb_pwrite  (w_apb_pwrite), 
        .i_apb_pwdata  (w_apb_pwdata), 
        .o_apb_prdata  (w_apb_prdata),
        .o_apb_pready  (w_apb_pready), 
        .o_apb_pslverr (w_apb_pslverr),
        .o_seg_an      (o_seg_an), 
        .o_seg_cat     (o_seg_cat)
    );
endmodule