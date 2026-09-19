// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri May  8 15:02:06 2026
// Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ week9_apb_led_0_1_stub.v
// Design      : week9_apb_led_0_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z007sclg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "apb_led,Vivado 2022.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(i_clk, i_rst_n, i_apb_paddr, i_apb_penable, 
  i_apb_psel, i_apb_pwrite, i_apb_pwdata, o_apb_prdata, o_apb_pready, o_apb_pslverr, o_led)
/* synthesis syn_black_box black_box_pad_pin="i_clk,i_rst_n,i_apb_paddr[31:0],i_apb_penable,i_apb_psel,i_apb_pwrite,i_apb_pwdata[31:0],o_apb_prdata[31:0],o_apb_pready,o_apb_pslverr,o_led[9:0]" */;
  input i_clk;
  input i_rst_n;
  input [31:0]i_apb_paddr;
  input i_apb_penable;
  input i_apb_psel;
  input i_apb_pwrite;
  input [31:0]i_apb_pwdata;
  output [31:0]o_apb_prdata;
  output o_apb_pready;
  output o_apb_pslverr;
  output [9:0]o_led;
endmodule
