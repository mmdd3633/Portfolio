// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri Jun  5 14:34:40 2026
// Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ Final_Project_imu_i2c_mode_pins_0_0_stub.v
// Design      : Final_Project_imu_i2c_mode_pins_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z007sclg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "imu_i2c_mode_pins,Vivado 2022.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(GYRO_CS_AG, GYRO_CS_M, GYRO_SDO_AG, GYRO_SDO_M, 
  GYRO_DEN_AG)
/* synthesis syn_black_box black_box_pad_pin="GYRO_CS_AG,GYRO_CS_M,GYRO_SDO_AG,GYRO_SDO_M,GYRO_DEN_AG" */;
  output GYRO_CS_AG;
  output GYRO_CS_M;
  output GYRO_SDO_AG;
  output GYRO_SDO_M;
  output GYRO_DEN_AG;
endmodule
