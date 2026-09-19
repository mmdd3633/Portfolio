-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Fri May  8 14:54:34 2026
-- Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ week9_apb_led_0_1_sim_netlist.vhdl
-- Design      : week9_apb_led_0_1
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z007sclg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_apb_led is
  port (
    LED : out STD_LOGIC_VECTOR ( 9 downto 0 );
    s_apb_prdata : out STD_LOGIC_VECTOR ( 9 downto 0 );
    s_apb_pwdata : in STD_LOGIC_VECTOR ( 9 downto 0 );
    PCLK : in STD_LOGIC;
    PRESETn : in STD_LOGIC;
    s_apb_psel : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_apb_paddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_apb_pwrite : in STD_LOGIC;
    s_apb_penable : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_apb_led;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_apb_led is
  signal \^led\ : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \reg_led[9]_i_1_n_0\ : STD_LOGIC;
  signal \reg_led[9]_i_2_n_0\ : STD_LOGIC;
  signal \s_apb_prdata[9]_INST_0_i_1_n_0\ : STD_LOGIC;
begin
  LED(9 downto 0) <= \^led\(9 downto 0);
\reg_led[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0020000000000000"
    )
        port map (
      I0 => s_apb_penable,
      I1 => s_apb_paddr(7),
      I2 => \s_apb_prdata[9]_INST_0_i_1_n_0\,
      I3 => s_apb_paddr(6),
      I4 => s_apb_psel(0),
      I5 => s_apb_pwrite,
      O => \reg_led[9]_i_1_n_0\
    );
\reg_led[9]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => PRESETn,
      O => \reg_led[9]_i_2_n_0\
    );
\reg_led_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_led[9]_i_1_n_0\,
      CLR => \reg_led[9]_i_2_n_0\,
      D => s_apb_pwdata(0),
      Q => \^led\(0)
    );
\reg_led_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_led[9]_i_1_n_0\,
      CLR => \reg_led[9]_i_2_n_0\,
      D => s_apb_pwdata(1),
      Q => \^led\(1)
    );
\reg_led_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_led[9]_i_1_n_0\,
      CLR => \reg_led[9]_i_2_n_0\,
      D => s_apb_pwdata(2),
      Q => \^led\(2)
    );
\reg_led_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_led[9]_i_1_n_0\,
      CLR => \reg_led[9]_i_2_n_0\,
      D => s_apb_pwdata(3),
      Q => \^led\(3)
    );
\reg_led_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_led[9]_i_1_n_0\,
      CLR => \reg_led[9]_i_2_n_0\,
      D => s_apb_pwdata(4),
      Q => \^led\(4)
    );
\reg_led_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_led[9]_i_1_n_0\,
      CLR => \reg_led[9]_i_2_n_0\,
      D => s_apb_pwdata(5),
      Q => \^led\(5)
    );
\reg_led_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_led[9]_i_1_n_0\,
      CLR => \reg_led[9]_i_2_n_0\,
      D => s_apb_pwdata(6),
      Q => \^led\(6)
    );
\reg_led_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_led[9]_i_1_n_0\,
      CLR => \reg_led[9]_i_2_n_0\,
      D => s_apb_pwdata(7),
      Q => \^led\(7)
    );
\reg_led_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_led[9]_i_1_n_0\,
      CLR => \reg_led[9]_i_2_n_0\,
      D => s_apb_pwdata(8),
      Q => \^led\(8)
    );
\reg_led_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_led[9]_i_1_n_0\,
      CLR => \reg_led[9]_i_2_n_0\,
      D => s_apb_pwdata(9),
      Q => \^led\(9)
    );
\s_apb_prdata[0]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0010000000000000"
    )
        port map (
      I0 => s_apb_pwrite,
      I1 => s_apb_paddr(7),
      I2 => \s_apb_prdata[9]_INST_0_i_1_n_0\,
      I3 => s_apb_paddr(6),
      I4 => s_apb_psel(0),
      I5 => \^led\(0),
      O => s_apb_prdata(0)
    );
\s_apb_prdata[1]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0010000000000000"
    )
        port map (
      I0 => s_apb_pwrite,
      I1 => s_apb_paddr(7),
      I2 => \s_apb_prdata[9]_INST_0_i_1_n_0\,
      I3 => s_apb_paddr(6),
      I4 => s_apb_psel(0),
      I5 => \^led\(1),
      O => s_apb_prdata(1)
    );
\s_apb_prdata[2]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0010000000000000"
    )
        port map (
      I0 => s_apb_pwrite,
      I1 => s_apb_paddr(7),
      I2 => \s_apb_prdata[9]_INST_0_i_1_n_0\,
      I3 => s_apb_paddr(6),
      I4 => s_apb_psel(0),
      I5 => \^led\(2),
      O => s_apb_prdata(2)
    );
\s_apb_prdata[3]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0010000000000000"
    )
        port map (
      I0 => s_apb_pwrite,
      I1 => s_apb_paddr(7),
      I2 => \s_apb_prdata[9]_INST_0_i_1_n_0\,
      I3 => s_apb_paddr(6),
      I4 => s_apb_psel(0),
      I5 => \^led\(3),
      O => s_apb_prdata(3)
    );
\s_apb_prdata[4]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0010000000000000"
    )
        port map (
      I0 => s_apb_pwrite,
      I1 => s_apb_paddr(7),
      I2 => \s_apb_prdata[9]_INST_0_i_1_n_0\,
      I3 => s_apb_paddr(6),
      I4 => s_apb_psel(0),
      I5 => \^led\(4),
      O => s_apb_prdata(4)
    );
\s_apb_prdata[5]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0010000000000000"
    )
        port map (
      I0 => s_apb_pwrite,
      I1 => s_apb_paddr(7),
      I2 => \s_apb_prdata[9]_INST_0_i_1_n_0\,
      I3 => s_apb_paddr(6),
      I4 => s_apb_psel(0),
      I5 => \^led\(5),
      O => s_apb_prdata(5)
    );
\s_apb_prdata[6]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0010000000000000"
    )
        port map (
      I0 => s_apb_pwrite,
      I1 => s_apb_paddr(7),
      I2 => \s_apb_prdata[9]_INST_0_i_1_n_0\,
      I3 => s_apb_paddr(6),
      I4 => s_apb_psel(0),
      I5 => \^led\(6),
      O => s_apb_prdata(6)
    );
\s_apb_prdata[7]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0010000000000000"
    )
        port map (
      I0 => s_apb_pwrite,
      I1 => s_apb_paddr(7),
      I2 => \s_apb_prdata[9]_INST_0_i_1_n_0\,
      I3 => s_apb_paddr(6),
      I4 => s_apb_psel(0),
      I5 => \^led\(7),
      O => s_apb_prdata(7)
    );
\s_apb_prdata[8]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000002000"
    )
        port map (
      I0 => s_apb_psel(0),
      I1 => s_apb_paddr(6),
      I2 => \s_apb_prdata[9]_INST_0_i_1_n_0\,
      I3 => \^led\(8),
      I4 => s_apb_paddr(7),
      I5 => s_apb_pwrite,
      O => s_apb_prdata(8)
    );
\s_apb_prdata[9]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000002000"
    )
        port map (
      I0 => s_apb_psel(0),
      I1 => s_apb_paddr(6),
      I2 => \s_apb_prdata[9]_INST_0_i_1_n_0\,
      I3 => \^led\(9),
      I4 => s_apb_paddr(7),
      I5 => s_apb_pwrite,
      O => s_apb_prdata(9)
    );
\s_apb_prdata[9]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => s_apb_paddr(3),
      I1 => s_apb_paddr(1),
      I2 => s_apb_paddr(0),
      I3 => s_apb_paddr(2),
      I4 => s_apb_paddr(5),
      I5 => s_apb_paddr(4),
      O => \s_apb_prdata[9]_INST_0_i_1_n_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
    PCLK : in STD_LOGIC;
    PRESETn : in STD_LOGIC;
    s_apb_paddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_apb_psel : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_apb_penable : in STD_LOGIC;
    s_apb_pwrite : in STD_LOGIC;
    s_apb_pwdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_apb_prdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_apb_pready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_apb_pslverr : out STD_LOGIC_VECTOR ( 0 to 0 );
    LED : out STD_LOGIC_VECTOR ( 9 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "week9_apb_led_0_1,apb_led,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "apb_led,Vivado 2022.1";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
  signal \^s_apb_prdata\ : STD_LOGIC_VECTOR ( 9 downto 0 );
begin
  s_apb_prdata(31) <= \<const0>\;
  s_apb_prdata(30) <= \<const0>\;
  s_apb_prdata(29) <= \<const0>\;
  s_apb_prdata(28) <= \<const0>\;
  s_apb_prdata(27) <= \<const0>\;
  s_apb_prdata(26) <= \<const0>\;
  s_apb_prdata(25) <= \<const0>\;
  s_apb_prdata(24) <= \<const0>\;
  s_apb_prdata(23) <= \<const0>\;
  s_apb_prdata(22) <= \<const0>\;
  s_apb_prdata(21) <= \<const0>\;
  s_apb_prdata(20) <= \<const0>\;
  s_apb_prdata(19) <= \<const0>\;
  s_apb_prdata(18) <= \<const0>\;
  s_apb_prdata(17) <= \<const0>\;
  s_apb_prdata(16) <= \<const0>\;
  s_apb_prdata(15) <= \<const0>\;
  s_apb_prdata(14) <= \<const0>\;
  s_apb_prdata(13) <= \<const0>\;
  s_apb_prdata(12) <= \<const0>\;
  s_apb_prdata(11) <= \<const0>\;
  s_apb_prdata(10) <= \<const0>\;
  s_apb_prdata(9 downto 0) <= \^s_apb_prdata\(9 downto 0);
  s_apb_pready(0) <= \<const1>\;
  s_apb_pslverr(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_apb_led
     port map (
      LED(9 downto 0) => LED(9 downto 0),
      PCLK => PCLK,
      PRESETn => PRESETn,
      s_apb_paddr(7 downto 0) => s_apb_paddr(7 downto 0),
      s_apb_penable => s_apb_penable,
      s_apb_prdata(9 downto 0) => \^s_apb_prdata\(9 downto 0),
      s_apb_psel(0) => s_apb_psel(0),
      s_apb_pwdata(9 downto 0) => s_apb_pwdata(9 downto 0),
      s_apb_pwrite => s_apb_pwrite
    );
end STRUCTURE;
