// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri Apr  3 15:57:34 2026
// Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Tukorea/Digital_System_Project/week5/week5.gen/sources_1/bd/week5/ip/week5_PWM_gen_8bit_0_0/week5_PWM_gen_8bit_0_0_stub.v
// Design      : week5_PWM_gen_8bit_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z007sclg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "PWM_gen_8bit,Vivado 2022.1" *)
module week5_PWM_gen_8bit_0_0(i_clk, i_rst, i_duty, o_pwm)
/* synthesis syn_black_box black_box_pad_pin="i_clk,i_rst,i_duty[7:0],o_pwm" */;
  input i_clk;
  input i_rst;
  input [7:0]i_duty;
  output o_pwm;
endmodule
