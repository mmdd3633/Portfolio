-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Fri Jun 12 15:09:28 2026
-- Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Tukorea/Digital_System_Project/Final_Project/Final_Project.gen/sources_1/bd/Final_Project/ip/Final_Project_apb_i2c_master_0_1/Final_Project_apb_i2c_master_0_1_stub.vhdl
-- Design      : Final_Project_apb_i2c_master_0_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z007sclg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Final_Project_apb_i2c_master_0_1 is
  Port ( 
    PCLK : in STD_LOGIC;
    PRESETn : in STD_LOGIC;
    PSEL : in STD_LOGIC;
    PENABLE : in STD_LOGIC;
    PWRITE : in STD_LOGIC;
    PADDR : in STD_LOGIC_VECTOR ( 31 downto 0 );
    PWDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    PRDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    PREADY : out STD_LOGIC;
    PSLVERR : out STD_LOGIC;
    io_i2c_scl : inout STD_LOGIC;
    io_i2c_sda : inout STD_LOGIC
  );

end Final_Project_apb_i2c_master_0_1;

architecture stub of Final_Project_apb_i2c_master_0_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "PCLK,PRESETn,PSEL,PENABLE,PWRITE,PADDR[31:0],PWDATA[31:0],PRDATA[31:0],PREADY,PSLVERR,io_i2c_scl,io_i2c_sda";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "apb_i2c_master,Vivado 2022.1";
begin
end;
