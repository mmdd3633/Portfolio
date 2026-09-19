// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri Apr 10 14:01:22 2026
// Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ week5_PWM_gen_8bit_0_0_stub.v
// Design      : week5_PWM_gen_8bit_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z007sclg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "PWM_gen_8bit,Vivado 2022.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(i_clk, i_rst, i_duty, o_pwm_r, o_pwm_g, o_pwm_b)
/* synthesis syn_black_box black_box_pad_pin="i_clk,i_rst,i_duty[23:0],o_pwm_r,o_pwm_g,o_pwm_b" */;
  input i_clk;
  input i_rst;
  input [23:0]i_duty;
  output o_pwm_r;
  output o_pwm_g;
  output o_pwm_b;
endmodule
