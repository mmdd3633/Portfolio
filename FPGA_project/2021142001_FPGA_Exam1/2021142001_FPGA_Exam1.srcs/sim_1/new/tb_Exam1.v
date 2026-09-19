`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/02 22:22:20
// Design Name: 
// Module Name: tb_Exam1
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


//module tb_Exam1;

//  // DUT I/O
//  reg         i_clk   = 0;          // 100 MHz
//  reg         i_rst_n = 0;          // active-low
//  reg  [15:0] i_sw    = 16'h0000;   // SW[15:12]=SEG3 ... SW[3:0]=SEG0
//  wire [7:0]  o_ca;
//  wire [7:0]  o_an;

//  // 100 MHz clock
//  always #5 i_clk = ~i_clk;

//  // DUT
//  Exam1 dut (
//    .i_clk  (i_clk),
//    .i_rst_n(i_rst_n),
//    .i_sw   (i_sw),
//    .o_ca   (o_ca),
//    .o_an   (o_an)
//  );

//  // 클럭 N주기 대기
//  task wait_cycles;
//    input integer n;
//    integer k;
//    begin
//      for (k=0; k<n; k=k+1) @(posedge i_clk);
//    end
//  endtask

//  // 각 자리 0~F 스윕
//  task sweep_digit0; integer v; begin
//    for (v=0; v<16; v=v+1) begin i_sw[3:0]   = v[3:0];   wait_cycles(80); end
//  end endtask
//  task sweep_digit1; integer v; begin
//    for (v=0; v<16; v=v+1) begin i_sw[7:4]   = v[3:0];   wait_cycles(80); end
//  end endtask
//  task sweep_digit2; integer v; begin
//    for (v=0; v<16; v=v+1) begin i_sw[11:8]  = v[3:0];   wait_cycles(80); end
//  end endtask
//  task sweep_digit3; integer v; begin
//    for (v=0; v<16; v=v+1) begin i_sw[15:12] = v[3:0];   wait_cycles(80); end
//  end endtask

//  initial begin
//    // 리셋 후 해제
//    wait_cycles(10);
//    i_rst_n = 1'b1;

//    // 초기 패턴
//    i_sw = 16'h3210; wait_cycles(400);

//    // 자리별 0~F 스윕 (나머지 자리는 고정)
//    sweep_digit0();
//    sweep_digit1();
//    sweep_digit2();
//    sweep_digit3();

//    // 혼합 패턴
//    i_sw = 16'hDEAD; wait_cycles(400);
//    i_sw = 16'hBEEF; wait_cycles(400);

//    $finish;
//  end

//endmodule


// Vivado 2022.1 / Verilog-2001 테스트벤치
// - DUT의 tick은 r_cnt==19'd39 가정(빠른 시뮬)
// - 여러 패턴을 골고루 표시하도록 i_sw를 다양하게 구동

module tb_Exam1;

  // DUT I/O
  reg         i_clk   = 0;          // 100 MHz
  reg         i_rst_n = 0;          // active-low
  reg  [15:0] i_sw    = 16'h0000;   // SW[15:12]=SEG3 ... SW[3:0]=SEG0
  wire [7:0]  o_ca;
  wire [7:0]  o_an;

  // 100 MHz clock (10 ns)
  always #5 i_clk = ~i_clk;

  // DUT
  Exam1 dut (
    .i_clk  (i_clk),
    .i_rst_n(i_rst_n),
    .i_sw   (i_sw),
    .o_ca   (o_ca),
    .o_an   (o_an)
  );

  // -----------------------
  // 헬퍼
  // -----------------------
  task wait_cycles;
    input integer n;
    integer k;
    begin
      for (k=0; k<n; k=k+1) @(posedge i_clk);
    end
  endtask

  task apply_pattern;
    input [15:0] val;
    input integer hold;
    begin
      i_sw = val;
      wait_cycles(hold);
    end
  endtask

  // 리셋 버튼 누르기(Active-Low)
  task pulse_reset;
    input integer low_cycles; // 리셋을 Low로 유지할 클럭 수
    begin
      i_rst_n = 1'b0;               // 누름
      wait_cycles(low_cycles);
      i_rst_n = 1'b1;               // 뗌
      // 리셋 후 안정화 시간 약간 대기
      wait_cycles(20);
    end
  endtask

  // -----------------------
  // Stimulus
  // -----------------------
  integer v;
  initial begin
    // 전원 투입 직후: 리셋 유지 → 해제
    wait_cycles(10);
    i_rst_n = 1'b1;

    // (A) 자리 동일값 반복: 0000, 1111, ... , FFFF
    for (v=0; v<16; v=v+1) begin
      apply_pattern({4{v[3:0]}}, 400);
    end

    // 중간 리셋 #1 (짧게)
    pulse_reset(10);

    // (B) 연속 증가 세트: 0123, 4567, 89AB, CDEF
    apply_pattern(16'h0123, 400);
    apply_pattern(16'h4567, 400);
    apply_pattern(16'h89AB, 400);
    apply_pattern(16'hCDEF, 400);

    // (C) 체커/대칭 패턴
    apply_pattern(16'hF0F0, 400);
    apply_pattern(16'h0F0F, 400);
    apply_pattern(16'hAA55, 400);
    apply_pattern(16'h55AA, 400);

    // 중간 리셋 #2 (조금 길게)
    pulse_reset(4000);

    // (D) 헥스 워드
    apply_pattern(16'hDEAD, 400);
    apply_pattern(16'hBEEF, 400);
    apply_pattern(16'hFACE, 400);
    apply_pattern(16'hC0DE, 400);

    // (E) 랜덤 패턴 몇 개
    for (v=0; v<12; v=v+1) begin
      apply_pattern($random, 300);  // Verilog의 $random 사용(하위 16비트)
    end

    // 종료
    wait_cycles(100);
    $finish;
  end

endmodule
