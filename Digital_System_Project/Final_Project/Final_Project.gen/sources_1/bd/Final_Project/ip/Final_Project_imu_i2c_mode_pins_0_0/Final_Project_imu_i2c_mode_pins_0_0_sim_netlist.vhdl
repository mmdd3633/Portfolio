-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Fri Jun  5 14:34:41 2026
-- Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Tukorea/Digital_System_Project/Final_Project/Final_Project.gen/sources_1/bd/Final_Project/ip/Final_Project_imu_i2c_mode_pins_0_0/Final_Project_imu_i2c_mode_pins_0_0_sim_netlist.vhdl
-- Design      : Final_Project_imu_i2c_mode_pins_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z007sclg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity Final_Project_imu_i2c_mode_pins_0_0 is
  port (
    GYRO_CS_AG : out STD_LOGIC;
    GYRO_CS_M : out STD_LOGIC;
    GYRO_SDO_AG : out STD_LOGIC;
    GYRO_SDO_M : out STD_LOGIC;
    GYRO_DEN_AG : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of Final_Project_imu_i2c_mode_pins_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of Final_Project_imu_i2c_mode_pins_0_0 : entity is "Final_Project_imu_i2c_mode_pins_0_0,imu_i2c_mode_pins,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of Final_Project_imu_i2c_mode_pins_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of Final_Project_imu_i2c_mode_pins_0_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of Final_Project_imu_i2c_mode_pins_0_0 : entity is "imu_i2c_mode_pins,Vivado 2022.1";
end Final_Project_imu_i2c_mode_pins_0_0;

architecture STRUCTURE of Final_Project_imu_i2c_mode_pins_0_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
begin
  GYRO_CS_AG <= \<const1>\;
  GYRO_CS_M <= \<const1>\;
  GYRO_DEN_AG <= \<const0>\;
  GYRO_SDO_AG <= \<const0>\;
  GYRO_SDO_M <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
end STRUCTURE;
