`timescale 1ns / 1ps

module Stopwatch_Top (
    // 물리적 외부 핀
    input  wire [3:0]  btn_n_i,
    output wire [3:0]  led_o,
    output wire [7:0]  seg_o,
    output wire [3:0]  an_o,
    
    // Zynq PS 필수 핀
    inout  wire [14:0] DDR_addr,
    inout  wire [2:0]  DDR_ba,
    inout  wire        DDR_cas_n,
    inout  wire        DDR_ck_n,
    inout  wire        DDR_ck_p,
    inout  wire        DDR_cke,
    inout  wire        DDR_cs_n,
    inout  wire [3:0]  DDR_dm,
    inout  wire [31:0] DDR_dq,
    inout  wire [3:0]  DDR_dqs_n,
    inout  wire [3:0]  DDR_dqs_p,
    inout  wire        DDR_odt,
    inout  wire        DDR_ras_n,
    inout  wire        DDR_reset_n,
    inout  wire        DDR_we_n,
    inout  wire        FIXED_IO_ddr_vrn,
    inout  wire        FIXED_IO_ddr_vrp,
    inout  wire [53:0] FIXED_IO_mio,
    inout  wire        FIXED_IO_ps_clk,
    inout  wire        FIXED_IO_ps_porb,
    inout  wire        FIXED_IO_ps_srstb
);

    wire [31:0] apb_paddr;
    wire        apb_penable;
    wire [31:0] apb_prdata;
    wire        apb_pready;
    wire        apb_psel;
    wire [31:0] apb_pwdata;
    wire        apb_pwrite;
    wire        clk_100m;
    wire        rst_n;

    // [버그 수정 완료] 64KB 범위 내에서 4KB 단위로 주소 할당
    wire psel_timer  = apb_psel & (apb_paddr[15:12] == 4'h0); // Base + 0x0000
    wire psel_button = apb_psel & (apb_paddr[15:12] == 4'h1); // Base + 0x1000
    wire psel_led    = apb_psel & (apb_paddr[15:12] == 4'h2); // Base + 0x2000
    wire psel_7seg   = apb_psel & (apb_paddr[15:12] == 4'h3); // Base + 0x3000

    wire [31:0] prdata_timer, prdata_button, prdata_led, prdata_7seg;
    wire        pready_timer, pready_button, pready_led, pready_7seg;

    assign apb_prdata = psel_timer  ? prdata_timer  :
                        psel_button ? prdata_button :
                        psel_led    ? prdata_led    :
                        psel_7seg   ? prdata_7seg   : 32'h0000_0000;
                        
    assign apb_pready = psel_timer  ? pready_timer  :
                        psel_button ? pready_button :
                        psel_led    ? pready_led    :
                        psel_7seg   ? pready_7seg   : 1'b1;

    // Zynq PS Wrapper 연결
    week11_wrapper u_week11_wrapper (
        .DDR_addr(DDR_addr), .DDR_ba(DDR_ba), .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n), .DDR_ck_p(DDR_ck_p), .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n), .DDR_dm(DDR_dm), .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n), .DDR_dqs_p(DDR_dqs_p), .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n), .DDR_reset_n(DDR_reset_n), .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn), .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio), .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb), .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        
        // APB 버스
        .APB_M_paddr   (apb_paddr),
        .APB_M_penable (apb_penable),
        .APB_M_prdata  (apb_prdata),
        .APB_M_pready  (apb_pready),
        .APB_M_psel    (apb_psel),
        .APB_M_pwdata  (apb_pwdata),
        .APB_M_pwrite  (apb_pwrite),
        .APB_M_pslverr (1'b0), // 사용 안 함
        
        // 클럭 및 리셋
        .clk_100m      (clk_100m),
        .rst_n         (rst_n)
    );

    // 모듈 4개 붙이기
    APB_Timer #(.CLK_FREQ(100_000_000)) u_APB_Timer (
        .PCLK(clk_100m), .PRESETn(rst_n), .PADDR(apb_paddr), .PSEL(psel_timer),
        .PENABLE(apb_penable), .PWRITE(apb_pwrite), .PWDATA(apb_pwdata),
        .PRDATA(prdata_timer), .PREADY(pready_timer)
    );

    APB_Button #(.CLK_FREQ(100_000_000), .DEBOUNCE_CNT(2_000_000)) u_APB_Button (
        .PCLK(clk_100m), .PRESETn(rst_n), .PADDR(apb_paddr), .PSEL(psel_button),
        .PENABLE(apb_penable), .PWRITE(apb_pwrite), .PWDATA(apb_pwdata),
        .PRDATA(prdata_button), .PREADY(pready_button), .btn_n_i(btn_n_i)
    );

    APB_LED u_APB_LED (
        .PCLK(clk_100m), .PRESETn(rst_n), .PADDR(apb_paddr), .PSEL(psel_led),
        .PENABLE(apb_penable), .PWRITE(apb_pwrite), .PWDATA(apb_pwdata),
        .PRDATA(prdata_led), .PREADY(pready_led), .led_o(led_o)
    );

    APB_7Seg #(.CLK_FREQ(100_000_000)) u_APB_7Seg (
        .PCLK(clk_100m), .PRESETn(rst_n), .PADDR(apb_paddr), .PSEL(psel_7seg),
        .PENABLE(apb_penable), .PWRITE(apb_pwrite), .PWDATA(apb_pwdata),
        .PRDATA(prdata_7seg), .PREADY(pready_7seg), .seg_o(seg_o), .an_o(an_o)
    );

endmodule