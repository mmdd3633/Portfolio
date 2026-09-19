-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Fri Jun  5 14:34:40 2026
-- Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ Final_Project_imu_i2c_mode_pins_0_0_stub.vhdl
-- Design      : Final_Project_imu_i2c_mode_pins_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z007sclg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    GYRO_CS_AG : out STD_LOGIC;
    GYRO_CS_M : out STD_LOGIC;
    GYRO_SDO_AG : out STD_LOGIC;
    GYRO_SDO_M : out STD_LOGIC;
    GYRO_DEN_AG : out STD_LOGIC
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "GYRO_CS_AG,GYRO_CS_M,GYRO_SDO_AG,GYRO_SDO_M,GYRO_DEN_AG";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "imu_i2c_mode_pins,Vivado 2022.1";
begin
end;
