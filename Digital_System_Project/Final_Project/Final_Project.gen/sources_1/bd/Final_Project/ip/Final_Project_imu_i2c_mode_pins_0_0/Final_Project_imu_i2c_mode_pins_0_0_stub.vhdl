-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Fri Jun  5 14:34:41 2026
-- Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Tukorea/Digital_System_Project/Final_Project/Final_Project.gen/sources_1/bd/Final_Project/ip/Final_Project_imu_i2c_mode_pins_0_0/Final_Project_imu_i2c_mode_pins_0_0_stub.vhdl
-- Design      : Final_Project_imu_i2c_mode_pins_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z007sclg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Final_Project_imu_i2c_mode_pins_0_0 is
  Port ( 
    GYRO_CS_AG : out STD_LOGIC;
    GYRO_CS_M : out STD_LOGIC;
    GYRO_SDO_AG : out STD_LOGIC;
    GYRO_SDO_M : out STD_LOGIC;
    GYRO_DEN_AG : out STD_LOGIC
  );

end Final_Project_imu_i2c_mode_pins_0_0;

architecture stub of Final_Project_imu_i2c_mode_pins_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "GYRO_CS_AG,GYRO_CS_M,GYRO_SDO_AG,GYRO_SDO_M,GYRO_DEN_AG";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "imu_i2c_mode_pins,Vivado 2022.1";
begin
end;
