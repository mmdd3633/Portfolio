-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Fri Jun  5 14:34:07 2026
-- Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Tukorea/Digital_System_Project/Final_Project/Final_Project.gen/sources_1/bd/Final_Project/ip/Final_Project_sevenseg_mux_0_0/Final_Project_sevenseg_mux_0_0_sim_netlist.vhdl
-- Design      : Final_Project_sevenseg_mux_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z007sclg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity Final_Project_sevenseg_mux_0_0_sevenseg_mux is
  port (
    seg_an : out STD_LOGIC_VECTOR ( 3 downto 0 );
    seg_cat : out STD_LOGIC_VECTOR ( 6 downto 0 );
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    value : in STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of Final_Project_sevenseg_mux_0_0_sevenseg_mux : entity is "sevenseg_mux";
end Final_Project_sevenseg_mux_0_0_sevenseg_mux;

architecture STRUCTURE of Final_Project_sevenseg_mux_0_0_sevenseg_mux is
  signal clear : STD_LOGIC;
  signal hex : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal p_0_in : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \refresh_counter[0]_i_3_n_0\ : STD_LOGIC;
  signal \refresh_counter_reg[0]_i_2_n_0\ : STD_LOGIC;
  signal \refresh_counter_reg[0]_i_2_n_1\ : STD_LOGIC;
  signal \refresh_counter_reg[0]_i_2_n_2\ : STD_LOGIC;
  signal \refresh_counter_reg[0]_i_2_n_3\ : STD_LOGIC;
  signal \refresh_counter_reg[0]_i_2_n_4\ : STD_LOGIC;
  signal \refresh_counter_reg[0]_i_2_n_5\ : STD_LOGIC;
  signal \refresh_counter_reg[0]_i_2_n_6\ : STD_LOGIC;
  signal \refresh_counter_reg[0]_i_2_n_7\ : STD_LOGIC;
  signal \refresh_counter_reg[12]_i_1_n_0\ : STD_LOGIC;
  signal \refresh_counter_reg[12]_i_1_n_1\ : STD_LOGIC;
  signal \refresh_counter_reg[12]_i_1_n_2\ : STD_LOGIC;
  signal \refresh_counter_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \refresh_counter_reg[12]_i_1_n_4\ : STD_LOGIC;
  signal \refresh_counter_reg[12]_i_1_n_5\ : STD_LOGIC;
  signal \refresh_counter_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \refresh_counter_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \refresh_counter_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \refresh_counter_reg[4]_i_1_n_0\ : STD_LOGIC;
  signal \refresh_counter_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \refresh_counter_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \refresh_counter_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \refresh_counter_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \refresh_counter_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \refresh_counter_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \refresh_counter_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \refresh_counter_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \refresh_counter_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \refresh_counter_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \refresh_counter_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \refresh_counter_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \refresh_counter_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \refresh_counter_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \refresh_counter_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[0]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[10]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[11]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[12]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[13]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[14]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[1]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[2]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[3]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[4]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[5]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[6]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[7]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[8]\ : STD_LOGIC;
  signal \refresh_counter_reg_n_0_[9]\ : STD_LOGIC;
  signal \NLW_refresh_counter_reg[16]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_refresh_counter_reg[16]_i_1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of \refresh_counter_reg[0]_i_2\ : label is 11;
  attribute ADDER_THRESHOLD of \refresh_counter_reg[12]_i_1\ : label is 11;
  attribute ADDER_THRESHOLD of \refresh_counter_reg[16]_i_1\ : label is 11;
  attribute ADDER_THRESHOLD of \refresh_counter_reg[4]_i_1\ : label is 11;
  attribute ADDER_THRESHOLD of \refresh_counter_reg[8]_i_1\ : label is 11;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \seg_an[0]_INST_0\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \seg_an[1]_INST_0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \seg_an[2]_INST_0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \seg_an[3]_INST_0\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \seg_cat[0]_INST_0\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \seg_cat[1]_INST_0\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \seg_cat[2]_INST_0\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \seg_cat[3]_INST_0\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \seg_cat[4]_INST_0\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \seg_cat[5]_INST_0\ : label is "soft_lutpair2";
begin
\refresh_counter[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => rst_n,
      O => clear
    );
\refresh_counter[0]_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \refresh_counter_reg_n_0_[0]\,
      O => \refresh_counter[0]_i_3_n_0\
    );
\refresh_counter_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[0]_i_2_n_7\,
      Q => \refresh_counter_reg_n_0_[0]\,
      R => clear
    );
\refresh_counter_reg[0]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \refresh_counter_reg[0]_i_2_n_0\,
      CO(2) => \refresh_counter_reg[0]_i_2_n_1\,
      CO(1) => \refresh_counter_reg[0]_i_2_n_2\,
      CO(0) => \refresh_counter_reg[0]_i_2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \refresh_counter_reg[0]_i_2_n_4\,
      O(2) => \refresh_counter_reg[0]_i_2_n_5\,
      O(1) => \refresh_counter_reg[0]_i_2_n_6\,
      O(0) => \refresh_counter_reg[0]_i_2_n_7\,
      S(3) => \refresh_counter_reg_n_0_[3]\,
      S(2) => \refresh_counter_reg_n_0_[2]\,
      S(1) => \refresh_counter_reg_n_0_[1]\,
      S(0) => \refresh_counter[0]_i_3_n_0\
    );
\refresh_counter_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[8]_i_1_n_5\,
      Q => \refresh_counter_reg_n_0_[10]\,
      R => clear
    );
\refresh_counter_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[8]_i_1_n_4\,
      Q => \refresh_counter_reg_n_0_[11]\,
      R => clear
    );
\refresh_counter_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[12]_i_1_n_7\,
      Q => \refresh_counter_reg_n_0_[12]\,
      R => clear
    );
\refresh_counter_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \refresh_counter_reg[8]_i_1_n_0\,
      CO(3) => \refresh_counter_reg[12]_i_1_n_0\,
      CO(2) => \refresh_counter_reg[12]_i_1_n_1\,
      CO(1) => \refresh_counter_reg[12]_i_1_n_2\,
      CO(0) => \refresh_counter_reg[12]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \refresh_counter_reg[12]_i_1_n_4\,
      O(2) => \refresh_counter_reg[12]_i_1_n_5\,
      O(1) => \refresh_counter_reg[12]_i_1_n_6\,
      O(0) => \refresh_counter_reg[12]_i_1_n_7\,
      S(3) => p_0_in(0),
      S(2) => \refresh_counter_reg_n_0_[14]\,
      S(1) => \refresh_counter_reg_n_0_[13]\,
      S(0) => \refresh_counter_reg_n_0_[12]\
    );
\refresh_counter_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[12]_i_1_n_6\,
      Q => \refresh_counter_reg_n_0_[13]\,
      R => clear
    );
\refresh_counter_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[12]_i_1_n_5\,
      Q => \refresh_counter_reg_n_0_[14]\,
      R => clear
    );
\refresh_counter_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[12]_i_1_n_4\,
      Q => p_0_in(0),
      R => clear
    );
\refresh_counter_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[16]_i_1_n_7\,
      Q => p_0_in(1),
      R => clear
    );
\refresh_counter_reg[16]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \refresh_counter_reg[12]_i_1_n_0\,
      CO(3 downto 0) => \NLW_refresh_counter_reg[16]_i_1_CO_UNCONNECTED\(3 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 1) => \NLW_refresh_counter_reg[16]_i_1_O_UNCONNECTED\(3 downto 1),
      O(0) => \refresh_counter_reg[16]_i_1_n_7\,
      S(3 downto 1) => B"000",
      S(0) => p_0_in(1)
    );
\refresh_counter_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[0]_i_2_n_6\,
      Q => \refresh_counter_reg_n_0_[1]\,
      R => clear
    );
\refresh_counter_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[0]_i_2_n_5\,
      Q => \refresh_counter_reg_n_0_[2]\,
      R => clear
    );
\refresh_counter_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[0]_i_2_n_4\,
      Q => \refresh_counter_reg_n_0_[3]\,
      R => clear
    );
\refresh_counter_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[4]_i_1_n_7\,
      Q => \refresh_counter_reg_n_0_[4]\,
      R => clear
    );
\refresh_counter_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \refresh_counter_reg[0]_i_2_n_0\,
      CO(3) => \refresh_counter_reg[4]_i_1_n_0\,
      CO(2) => \refresh_counter_reg[4]_i_1_n_1\,
      CO(1) => \refresh_counter_reg[4]_i_1_n_2\,
      CO(0) => \refresh_counter_reg[4]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \refresh_counter_reg[4]_i_1_n_4\,
      O(2) => \refresh_counter_reg[4]_i_1_n_5\,
      O(1) => \refresh_counter_reg[4]_i_1_n_6\,
      O(0) => \refresh_counter_reg[4]_i_1_n_7\,
      S(3) => \refresh_counter_reg_n_0_[7]\,
      S(2) => \refresh_counter_reg_n_0_[6]\,
      S(1) => \refresh_counter_reg_n_0_[5]\,
      S(0) => \refresh_counter_reg_n_0_[4]\
    );
\refresh_counter_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[4]_i_1_n_6\,
      Q => \refresh_counter_reg_n_0_[5]\,
      R => clear
    );
\refresh_counter_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[4]_i_1_n_5\,
      Q => \refresh_counter_reg_n_0_[6]\,
      R => clear
    );
\refresh_counter_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[4]_i_1_n_4\,
      Q => \refresh_counter_reg_n_0_[7]\,
      R => clear
    );
\refresh_counter_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[8]_i_1_n_7\,
      Q => \refresh_counter_reg_n_0_[8]\,
      R => clear
    );
\refresh_counter_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \refresh_counter_reg[4]_i_1_n_0\,
      CO(3) => \refresh_counter_reg[8]_i_1_n_0\,
      CO(2) => \refresh_counter_reg[8]_i_1_n_1\,
      CO(1) => \refresh_counter_reg[8]_i_1_n_2\,
      CO(0) => \refresh_counter_reg[8]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \refresh_counter_reg[8]_i_1_n_4\,
      O(2) => \refresh_counter_reg[8]_i_1_n_5\,
      O(1) => \refresh_counter_reg[8]_i_1_n_6\,
      O(0) => \refresh_counter_reg[8]_i_1_n_7\,
      S(3) => \refresh_counter_reg_n_0_[11]\,
      S(2) => \refresh_counter_reg_n_0_[10]\,
      S(1) => \refresh_counter_reg_n_0_[9]\,
      S(0) => \refresh_counter_reg_n_0_[8]\
    );
\refresh_counter_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => \refresh_counter_reg[8]_i_1_n_6\,
      Q => \refresh_counter_reg_n_0_[9]\,
      R => clear
    );
\seg_an[0]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in(0),
      I1 => p_0_in(1),
      O => seg_an(0)
    );
\seg_an[1]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => p_0_in(1),
      I1 => p_0_in(0),
      O => seg_an(1)
    );
\seg_an[2]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => p_0_in(0),
      I1 => p_0_in(1),
      O => seg_an(2)
    );
\seg_an[3]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => p_0_in(0),
      I1 => p_0_in(1),
      O => seg_an(3)
    );
\seg_cat[0]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2094"
    )
        port map (
      I0 => hex(3),
      I1 => hex(2),
      I2 => hex(0),
      I3 => hex(1),
      O => seg_cat(0)
    );
\seg_cat[1]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A4C8"
    )
        port map (
      I0 => hex(3),
      I1 => hex(2),
      I2 => hex(1),
      I3 => hex(0),
      O => seg_cat(1)
    );
\seg_cat[2]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A210"
    )
        port map (
      I0 => hex(3),
      I1 => hex(0),
      I2 => hex(1),
      I3 => hex(2),
      O => seg_cat(2)
    );
\seg_cat[3]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"C214"
    )
        port map (
      I0 => hex(3),
      I1 => hex(2),
      I2 => hex(0),
      I3 => hex(1),
      O => seg_cat(3)
    );
\seg_cat[4]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5710"
    )
        port map (
      I0 => hex(3),
      I1 => hex(1),
      I2 => hex(2),
      I3 => hex(0),
      O => seg_cat(4)
    );
\seg_cat[5]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5190"
    )
        port map (
      I0 => hex(3),
      I1 => hex(2),
      I2 => hex(0),
      I3 => hex(1),
      O => seg_cat(5)
    );
\seg_cat[6]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4025"
    )
        port map (
      I0 => hex(3),
      I1 => hex(0),
      I2 => hex(2),
      I3 => hex(1),
      O => seg_cat(6)
    );
\seg_cat[6]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0FFAACCF000AACC"
    )
        port map (
      I0 => value(7),
      I1 => value(3),
      I2 => value(15),
      I3 => p_0_in(0),
      I4 => p_0_in(1),
      I5 => value(11),
      O => hex(3)
    );
\seg_cat[6]_INST_0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0FFAACCF000AACC"
    )
        port map (
      I0 => value(4),
      I1 => value(0),
      I2 => value(12),
      I3 => p_0_in(0),
      I4 => p_0_in(1),
      I5 => value(8),
      O => hex(0)
    );
\seg_cat[6]_INST_0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0FFAACCF000AACC"
    )
        port map (
      I0 => value(6),
      I1 => value(2),
      I2 => value(14),
      I3 => p_0_in(0),
      I4 => p_0_in(1),
      I5 => value(10),
      O => hex(2)
    );
\seg_cat[6]_INST_0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0FFAACCF000AACC"
    )
        port map (
      I0 => value(5),
      I1 => value(1),
      I2 => value(13),
      I3 => p_0_in(0),
      I4 => p_0_in(1),
      I5 => value(9),
      O => hex(1)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity Final_Project_sevenseg_mux_0_0 is
  port (
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    value : in STD_LOGIC_VECTOR ( 15 downto 0 );
    seg_an : out STD_LOGIC_VECTOR ( 3 downto 0 );
    seg_cat : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of Final_Project_sevenseg_mux_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of Final_Project_sevenseg_mux_0_0 : entity is "Final_Project_sevenseg_mux_0_0,sevenseg_mux,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of Final_Project_sevenseg_mux_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of Final_Project_sevenseg_mux_0_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of Final_Project_sevenseg_mux_0_0 : entity is "sevenseg_mux,Vivado 2022.1";
end Final_Project_sevenseg_mux_0_0;

architecture STRUCTURE of Final_Project_sevenseg_mux_0_0 is
  signal \<const1>\ : STD_LOGIC;
  signal \^seg_cat\ : STD_LOGIC_VECTOR ( 6 downto 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN Final_Project_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of rst_n : signal is "xilinx.com:signal:reset:1.0 rst_n RST";
  attribute X_INTERFACE_PARAMETER of rst_n : signal is "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0";
begin
  seg_cat(7) <= \<const1>\;
  seg_cat(6 downto 0) <= \^seg_cat\(6 downto 0);
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
inst: entity work.Final_Project_sevenseg_mux_0_0_sevenseg_mux
     port map (
      clk => clk,
      rst_n => rst_n,
      seg_an(3 downto 0) => seg_an(3 downto 0),
      seg_cat(6 downto 0) => \^seg_cat\(6 downto 0),
      value(15 downto 0) => value(15 downto 0)
    );
end STRUCTURE;
