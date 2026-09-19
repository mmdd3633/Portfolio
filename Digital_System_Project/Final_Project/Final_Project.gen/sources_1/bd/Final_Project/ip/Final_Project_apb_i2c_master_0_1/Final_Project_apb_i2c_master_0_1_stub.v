// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri Jun 12 15:09:28 2026
// Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Tukorea/Digital_System_Project/Final_Project/Final_Project.gen/sources_1/bd/Final_Project/ip/Final_Project_apb_i2c_master_0_1/Final_Project_apb_i2c_master_0_1_stub.v
// Design      : Final_Project_apb_i2c_master_0_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z007sclg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "apb_i2c_master,Vivado 2022.1" *)
module Final_Project_apb_i2c_master_0_1(PCLK, PRESETn, PSEL, PENABLE, PWRITE, PADDR, PWDATA, 
  PRDATA, PREADY, PSLVERR, io_i2c_scl, io_i2c_sda)
/* synthesis syn_black_box black_box_pad_pin="PCLK,PRESETn,PSEL,PENABLE,PWRITE,PADDR[31:0],PWDATA[31:0],PRDATA[31:0],PREADY,PSLVERR,io_i2c_scl,io_i2c_sda" */;
  input PCLK;
  input PRESETn;
  input PSEL;
  input PENABLE;
  input PWRITE;
  input [31:0]PADDR;
  input [31:0]PWDATA;
  output [31:0]PRDATA;
  output PREADY;
  output PSLVERR;
  inout io_i2c_scl;
  inout io_i2c_sda;
endmodule
