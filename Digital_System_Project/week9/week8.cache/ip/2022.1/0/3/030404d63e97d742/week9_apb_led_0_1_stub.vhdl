-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Fri May  8 15:02:06 2026
-- Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ week9_apb_led_0_1_stub.vhdl
-- Design      : week9_apb_led_0_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z007sclg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    i_clk : in STD_LOGIC;
    i_rst_n : in STD_LOGIC;
    i_apb_paddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    i_apb_penable : in STD_LOGIC;
    i_apb_psel : in STD_LOGIC;
    i_apb_pwrite : in STD_LOGIC;
    i_apb_pwdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    o_apb_prdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    o_apb_pready : out STD_LOGIC;
    o_apb_pslverr : out STD_LOGIC;
    o_led : out STD_LOGIC_VECTOR ( 9 downto 0 )
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "i_clk,i_rst_n,i_apb_paddr[31:0],i_apb_penable,i_apb_psel,i_apb_pwrite,i_apb_pwdata[31:0],o_apb_prdata[31:0],o_apb_pready,o_apb_pslverr,o_led[9:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "apb_led,Vivado 2022.1";
begin
end;
