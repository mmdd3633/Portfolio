-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Fri May  8 15:02:06 2026
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
    o_led : out STD_LOGIC_VECTOR ( 9 downto 0 );
    o_apb_prdata : out STD_LOGIC_VECTOR ( 9 downto 0 );
    i_apb_pwdata : in STD_LOGIC_VECTOR ( 9 downto 0 );
    i_clk : in STD_LOGIC;
    i_apb_penable : in STD_LOGIC;
    i_apb_pwrite : in STD_LOGIC;
    i_apb_paddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    i_apb_psel : in STD_LOGIC;
    i_rst_n : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_apb_led;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_apb_led is
  signal \led_reg[9]_i_1_n_0\ : STD_LOGIC;
  signal \o_apb_prdata[9]_i_10_n_0\ : STD_LOGIC;
  signal \o_apb_prdata[9]_i_1_n_0\ : STD_LOGIC;
  signal \o_apb_prdata[9]_i_2_n_0\ : STD_LOGIC;
  signal \o_apb_prdata[9]_i_3_n_0\ : STD_LOGIC;
  signal \o_apb_prdata[9]_i_4_n_0\ : STD_LOGIC;
  signal \o_apb_prdata[9]_i_5_n_0\ : STD_LOGIC;
  signal \o_apb_prdata[9]_i_6_n_0\ : STD_LOGIC;
  signal \o_apb_prdata[9]_i_7_n_0\ : STD_LOGIC;
  signal \o_apb_prdata[9]_i_8_n_0\ : STD_LOGIC;
  signal \o_apb_prdata[9]_i_9_n_0\ : STD_LOGIC;
  signal \^o_led\ : STD_LOGIC_VECTOR ( 9 downto 0 );
begin
  o_led(9 downto 0) <= \^o_led\(9 downto 0);
\led_reg[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0100000000000000"
    )
        port map (
      I0 => \o_apb_prdata[9]_i_3_n_0\,
      I1 => \o_apb_prdata[9]_i_4_n_0\,
      I2 => \o_apb_prdata[9]_i_5_n_0\,
      I3 => \o_apb_prdata[9]_i_6_n_0\,
      I4 => i_apb_penable,
      I5 => i_apb_pwrite,
      O => \led_reg[9]_i_1_n_0\
    );
\led_reg_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \led_reg[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => i_apb_pwdata(0),
      Q => \^o_led\(0)
    );
\led_reg_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \led_reg[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => i_apb_pwdata(1),
      Q => \^o_led\(1)
    );
\led_reg_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \led_reg[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => i_apb_pwdata(2),
      Q => \^o_led\(2)
    );
\led_reg_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \led_reg[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => i_apb_pwdata(3),
      Q => \^o_led\(3)
    );
\led_reg_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \led_reg[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => i_apb_pwdata(4),
      Q => \^o_led\(4)
    );
\led_reg_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \led_reg[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => i_apb_pwdata(5),
      Q => \^o_led\(5)
    );
\led_reg_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \led_reg[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => i_apb_pwdata(6),
      Q => \^o_led\(6)
    );
\led_reg_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \led_reg[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => i_apb_pwdata(7),
      Q => \^o_led\(7)
    );
\led_reg_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \led_reg[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => i_apb_pwdata(8),
      Q => \^o_led\(8)
    );
\led_reg_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \led_reg[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => i_apb_pwdata(9),
      Q => \^o_led\(9)
    );
\o_apb_prdata[9]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000100"
    )
        port map (
      I0 => \o_apb_prdata[9]_i_3_n_0\,
      I1 => \o_apb_prdata[9]_i_4_n_0\,
      I2 => \o_apb_prdata[9]_i_5_n_0\,
      I3 => \o_apb_prdata[9]_i_6_n_0\,
      I4 => i_apb_pwrite,
      O => \o_apb_prdata[9]_i_1_n_0\
    );
\o_apb_prdata[9]_i_10\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => i_apb_paddr(7),
      I1 => i_apb_paddr(1),
      I2 => i_apb_paddr(9),
      I3 => i_apb_paddr(4),
      O => \o_apb_prdata[9]_i_10_n_0\
    );
\o_apb_prdata[9]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => i_rst_n,
      O => \o_apb_prdata[9]_i_2_n_0\
    );
\o_apb_prdata[9]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFEFFF"
    )
        port map (
      I0 => i_apb_paddr(21),
      I1 => i_apb_paddr(2),
      I2 => i_apb_paddr(23),
      I3 => i_apb_paddr(22),
      I4 => i_apb_paddr(12),
      I5 => i_apb_paddr(20),
      O => \o_apb_prdata[9]_i_3_n_0\
    );
\o_apb_prdata[9]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFBFF"
    )
        port map (
      I0 => i_apb_paddr(19),
      I1 => i_apb_paddr(30),
      I2 => i_apb_paddr(28),
      I3 => i_apb_psel,
      I4 => \o_apb_prdata[9]_i_7_n_0\,
      O => \o_apb_prdata[9]_i_4_n_0\
    );
\o_apb_prdata[9]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFEFF"
    )
        port map (
      I0 => i_apb_paddr(10),
      I1 => i_apb_paddr(14),
      I2 => i_apb_paddr(16),
      I3 => i_apb_paddr(24),
      I4 => \o_apb_prdata[9]_i_8_n_0\,
      O => \o_apb_prdata[9]_i_5_n_0\
    );
\o_apb_prdata[9]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => i_apb_paddr(6),
      I1 => i_apb_paddr(31),
      I2 => i_apb_paddr(8),
      I3 => \o_apb_prdata[9]_i_9_n_0\,
      I4 => \o_apb_prdata[9]_i_10_n_0\,
      O => \o_apb_prdata[9]_i_6_n_0\
    );
\o_apb_prdata[9]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFEF"
    )
        port map (
      I0 => i_apb_paddr(27),
      I1 => i_apb_paddr(26),
      I2 => i_apb_paddr(25),
      I3 => i_apb_paddr(3),
      O => \o_apb_prdata[9]_i_7_n_0\
    );
\o_apb_prdata[9]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => i_apb_paddr(15),
      I1 => i_apb_paddr(11),
      I2 => i_apb_paddr(18),
      I3 => i_apb_paddr(17),
      O => \o_apb_prdata[9]_i_8_n_0\
    );
\o_apb_prdata[9]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => i_apb_paddr(29),
      I1 => i_apb_paddr(0),
      I2 => i_apb_paddr(13),
      I3 => i_apb_paddr(5),
      O => \o_apb_prdata[9]_i_9_n_0\
    );
\o_apb_prdata_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \o_apb_prdata[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => \^o_led\(0),
      Q => o_apb_prdata(0)
    );
\o_apb_prdata_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \o_apb_prdata[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => \^o_led\(1),
      Q => o_apb_prdata(1)
    );
\o_apb_prdata_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \o_apb_prdata[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => \^o_led\(2),
      Q => o_apb_prdata(2)
    );
\o_apb_prdata_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \o_apb_prdata[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => \^o_led\(3),
      Q => o_apb_prdata(3)
    );
\o_apb_prdata_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \o_apb_prdata[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => \^o_led\(4),
      Q => o_apb_prdata(4)
    );
\o_apb_prdata_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \o_apb_prdata[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => \^o_led\(5),
      Q => o_apb_prdata(5)
    );
\o_apb_prdata_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \o_apb_prdata[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => \^o_led\(6),
      Q => o_apb_prdata(6)
    );
\o_apb_prdata_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \o_apb_prdata[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => \^o_led\(7),
      Q => o_apb_prdata(7)
    );
\o_apb_prdata_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \o_apb_prdata[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => \^o_led\(8),
      Q => o_apb_prdata(8)
    );
\o_apb_prdata_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => \o_apb_prdata[9]_i_1_n_0\,
      CLR => \o_apb_prdata[9]_i_2_n_0\,
      D => \^o_led\(9),
      Q => o_apb_prdata(9)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
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
  signal \^o_apb_prdata\ : STD_LOGIC_VECTOR ( 9 downto 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of i_clk : signal is "xilinx.com:signal:clock:1.0 i_clk CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of i_clk : signal is "XIL_INTERFACENAME i_clk, ASSOCIATED_RESET i_rst_n, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN week9_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of i_rst_n : signal is "xilinx.com:signal:reset:1.0 i_rst_n RST";
  attribute X_INTERFACE_PARAMETER of i_rst_n : signal is "XIL_INTERFACENAME i_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0";
begin
  o_apb_prdata(31) <= \<const0>\;
  o_apb_prdata(30) <= \<const0>\;
  o_apb_prdata(29) <= \<const0>\;
  o_apb_prdata(28) <= \<const0>\;
  o_apb_prdata(27) <= \<const0>\;
  o_apb_prdata(26) <= \<const0>\;
  o_apb_prdata(25) <= \<const0>\;
  o_apb_prdata(24) <= \<const0>\;
  o_apb_prdata(23) <= \<const0>\;
  o_apb_prdata(22) <= \<const0>\;
  o_apb_prdata(21) <= \<const0>\;
  o_apb_prdata(20) <= \<const0>\;
  o_apb_prdata(19) <= \<const0>\;
  o_apb_prdata(18) <= \<const0>\;
  o_apb_prdata(17) <= \<const0>\;
  o_apb_prdata(16) <= \<const0>\;
  o_apb_prdata(15) <= \<const0>\;
  o_apb_prdata(14) <= \<const0>\;
  o_apb_prdata(13) <= \<const0>\;
  o_apb_prdata(12) <= \<const0>\;
  o_apb_prdata(11) <= \<const0>\;
  o_apb_prdata(10) <= \<const0>\;
  o_apb_prdata(9 downto 0) <= \^o_apb_prdata\(9 downto 0);
  o_apb_pready <= \<const1>\;
  o_apb_pslverr <= \<const0>\;
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
      i_apb_paddr(31 downto 0) => i_apb_paddr(31 downto 0),
      i_apb_penable => i_apb_penable,
      i_apb_psel => i_apb_psel,
      i_apb_pwdata(9 downto 0) => i_apb_pwdata(9 downto 0),
      i_apb_pwrite => i_apb_pwrite,
      i_clk => i_clk,
      i_rst_n => i_rst_n,
      o_apb_prdata(9 downto 0) => \^o_apb_prdata\(9 downto 0),
      o_led(9 downto 0) => o_led(9 downto 0)
    );
end STRUCTURE;
