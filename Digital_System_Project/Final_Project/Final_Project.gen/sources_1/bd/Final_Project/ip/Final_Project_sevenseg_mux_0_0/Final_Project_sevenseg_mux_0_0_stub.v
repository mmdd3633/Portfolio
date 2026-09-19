// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri Jun  5 14:34:07 2026
// Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Tukorea/Digital_System_Project/Final_Project/Final_Project.gen/sources_1/bd/Final_Project/ip/Final_Project_sevenseg_mux_0_0/Final_Project_sevenseg_mux_0_0_stub.v
// Design      : Final_Project_sevenseg_mux_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z007sclg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "sevenseg_mux,Vivado 2022.1" *)
module Final_Project_sevenseg_mux_0_0(clk, rst_n, value, seg_an, seg_cat)
/* synthesis syn_black_box black_box_pad_pin="clk,rst_n,value[15:0],seg_an[3:0],seg_cat[7:0]" */;
  input clk;
  input rst_n;
  input [15:0]value;
  output [3:0]seg_an;
  output [7:0]seg_cat;
endmodule
