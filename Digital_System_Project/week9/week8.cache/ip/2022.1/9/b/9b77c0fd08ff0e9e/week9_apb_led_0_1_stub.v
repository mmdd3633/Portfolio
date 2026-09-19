// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri May  8 14:54:34 2026
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
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(PCLK, PRESETn, s_apb_paddr, s_apb_psel, 
  s_apb_penable, s_apb_pwrite, s_apb_pwdata, s_apb_prdata, s_apb_pready, s_apb_pslverr, LED)
/* synthesis syn_black_box black_box_pad_pin="PCLK,PRESETn,s_apb_paddr[31:0],s_apb_psel[0:0],s_apb_penable,s_apb_pwrite,s_apb_pwdata[31:0],s_apb_prdata[31:0],s_apb_pready[0:0],s_apb_pslverr[0:0],LED[9:0]" */;
  input PCLK;
  input PRESETn;
  input [31:0]s_apb_paddr;
  input [0:0]s_apb_psel;
  input s_apb_penable;
  input s_apb_pwrite;
  input [31:0]s_apb_pwdata;
  output [31:0]s_apb_prdata;
  output [0:0]s_apb_pready;
  output [0:0]s_apb_pslverr;
  output [9:0]LED;
endmodule
