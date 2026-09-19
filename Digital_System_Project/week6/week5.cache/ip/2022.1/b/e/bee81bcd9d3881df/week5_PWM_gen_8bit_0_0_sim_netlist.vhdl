-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Fri Apr  3 15:57:34 2026
-- Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ week5_PWM_gen_8bit_0_0_sim_netlist.vhdl
-- Design      : week5_PWM_gen_8bit_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z007sclg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_PWM_gen_8bit is
  port (
    o_pwm : out STD_LOGIC;
    i_clk : in STD_LOGIC;
    i_rst : in STD_LOGIC;
    i_duty : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_PWM_gen_8bit;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_PWM_gen_8bit is
  signal \cnt[0]_i_1_n_0\ : STD_LOGIC;
  signal \cnt[7]_i_2_n_0\ : STD_LOGIC;
  signal cnt_reg : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal o_pwm0_carry_i_1_n_0 : STD_LOGIC;
  signal o_pwm0_carry_i_2_n_0 : STD_LOGIC;
  signal o_pwm0_carry_i_3_n_0 : STD_LOGIC;
  signal o_pwm0_carry_i_4_n_0 : STD_LOGIC;
  signal o_pwm0_carry_i_5_n_0 : STD_LOGIC;
  signal o_pwm0_carry_i_6_n_0 : STD_LOGIC;
  signal o_pwm0_carry_i_7_n_0 : STD_LOGIC;
  signal o_pwm0_carry_i_8_n_0 : STD_LOGIC;
  signal o_pwm0_carry_n_1 : STD_LOGIC;
  signal o_pwm0_carry_n_2 : STD_LOGIC;
  signal o_pwm0_carry_n_3 : STD_LOGIC;
  signal o_pwm_i_1_n_0 : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal \p_0_in__0\ : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal NLW_o_pwm0_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \cnt[1]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \cnt[2]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \cnt[3]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \cnt[4]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \cnt[6]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \cnt[7]_i_1\ : label is "soft_lutpair1";
  attribute COMPARATOR_THRESHOLD : integer;
  attribute COMPARATOR_THRESHOLD of o_pwm0_carry : label is 11;
begin
\cnt[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => cnt_reg(0),
      O => \cnt[0]_i_1_n_0\
    );
\cnt[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => cnt_reg(0),
      I1 => cnt_reg(1),
      O => \p_0_in__0\(1)
    );
\cnt[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => cnt_reg(0),
      I1 => cnt_reg(1),
      I2 => cnt_reg(2),
      O => \p_0_in__0\(2)
    );
\cnt[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => cnt_reg(1),
      I1 => cnt_reg(0),
      I2 => cnt_reg(2),
      I3 => cnt_reg(3),
      O => \p_0_in__0\(3)
    );
\cnt[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFF8000"
    )
        port map (
      I0 => cnt_reg(2),
      I1 => cnt_reg(0),
      I2 => cnt_reg(1),
      I3 => cnt_reg(3),
      I4 => cnt_reg(4),
      O => \p_0_in__0\(4)
    );
\cnt[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFF80000000"
    )
        port map (
      I0 => cnt_reg(3),
      I1 => cnt_reg(1),
      I2 => cnt_reg(0),
      I3 => cnt_reg(2),
      I4 => cnt_reg(4),
      I5 => cnt_reg(5),
      O => \p_0_in__0\(5)
    );
\cnt[6]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \cnt[7]_i_2_n_0\,
      I1 => cnt_reg(6),
      O => \p_0_in__0\(6)
    );
\cnt[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \cnt[7]_i_2_n_0\,
      I1 => cnt_reg(6),
      I2 => cnt_reg(7),
      O => \p_0_in__0\(7)
    );
\cnt[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => cnt_reg(5),
      I1 => cnt_reg(3),
      I2 => cnt_reg(1),
      I3 => cnt_reg(0),
      I4 => cnt_reg(2),
      I5 => cnt_reg(4),
      O => \cnt[7]_i_2_n_0\
    );
\cnt_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => '1',
      CLR => o_pwm_i_1_n_0,
      D => \cnt[0]_i_1_n_0\,
      Q => cnt_reg(0)
    );
\cnt_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => '1',
      CLR => o_pwm_i_1_n_0,
      D => \p_0_in__0\(1),
      Q => cnt_reg(1)
    );
\cnt_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => '1',
      CLR => o_pwm_i_1_n_0,
      D => \p_0_in__0\(2),
      Q => cnt_reg(2)
    );
\cnt_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => '1',
      CLR => o_pwm_i_1_n_0,
      D => \p_0_in__0\(3),
      Q => cnt_reg(3)
    );
\cnt_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => '1',
      CLR => o_pwm_i_1_n_0,
      D => \p_0_in__0\(4),
      Q => cnt_reg(4)
    );
\cnt_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => '1',
      CLR => o_pwm_i_1_n_0,
      D => \p_0_in__0\(5),
      Q => cnt_reg(5)
    );
\cnt_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => '1',
      CLR => o_pwm_i_1_n_0,
      D => \p_0_in__0\(6),
      Q => cnt_reg(6)
    );
\cnt_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => '1',
      CLR => o_pwm_i_1_n_0,
      D => \p_0_in__0\(7),
      Q => cnt_reg(7)
    );
o_pwm0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => p_0_in,
      CO(2) => o_pwm0_carry_n_1,
      CO(1) => o_pwm0_carry_n_2,
      CO(0) => o_pwm0_carry_n_3,
      CYINIT => '0',
      DI(3) => o_pwm0_carry_i_1_n_0,
      DI(2) => o_pwm0_carry_i_2_n_0,
      DI(1) => o_pwm0_carry_i_3_n_0,
      DI(0) => o_pwm0_carry_i_4_n_0,
      O(3 downto 0) => NLW_o_pwm0_carry_O_UNCONNECTED(3 downto 0),
      S(3) => o_pwm0_carry_i_5_n_0,
      S(2) => o_pwm0_carry_i_6_n_0,
      S(1) => o_pwm0_carry_i_7_n_0,
      S(0) => o_pwm0_carry_i_8_n_0
    );
o_pwm0_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => i_duty(6),
      I1 => cnt_reg(6),
      I2 => cnt_reg(7),
      I3 => i_duty(7),
      O => o_pwm0_carry_i_1_n_0
    );
o_pwm0_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => i_duty(4),
      I1 => cnt_reg(4),
      I2 => cnt_reg(5),
      I3 => i_duty(5),
      O => o_pwm0_carry_i_2_n_0
    );
o_pwm0_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => i_duty(2),
      I1 => cnt_reg(2),
      I2 => cnt_reg(3),
      I3 => i_duty(3),
      O => o_pwm0_carry_i_3_n_0
    );
o_pwm0_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => i_duty(0),
      I1 => cnt_reg(0),
      I2 => cnt_reg(1),
      I3 => i_duty(1),
      O => o_pwm0_carry_i_4_n_0
    );
o_pwm0_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_duty(6),
      I1 => cnt_reg(6),
      I2 => i_duty(7),
      I3 => cnt_reg(7),
      O => o_pwm0_carry_i_5_n_0
    );
o_pwm0_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_duty(4),
      I1 => cnt_reg(4),
      I2 => i_duty(5),
      I3 => cnt_reg(5),
      O => o_pwm0_carry_i_6_n_0
    );
o_pwm0_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_duty(2),
      I1 => cnt_reg(2),
      I2 => i_duty(3),
      I3 => cnt_reg(3),
      O => o_pwm0_carry_i_7_n_0
    );
o_pwm0_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_duty(0),
      I1 => cnt_reg(0),
      I2 => i_duty(1),
      I3 => cnt_reg(1),
      O => o_pwm0_carry_i_8_n_0
    );
o_pwm_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => i_rst,
      O => o_pwm_i_1_n_0
    );
o_pwm_reg: unisim.vcomponents.FDCE
     port map (
      C => i_clk,
      CE => '1',
      CLR => o_pwm_i_1_n_0,
      D => p_0_in,
      Q => o_pwm
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
    i_clk : in STD_LOGIC;
    i_rst : in STD_LOGIC;
    i_duty : in STD_LOGIC_VECTOR ( 7 downto 0 );
    o_pwm : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "week5_PWM_gen_8bit_0_0,PWM_gen_8bit,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "PWM_gen_8bit,Vivado 2022.1";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of i_clk : signal is "xilinx.com:signal:clock:1.0 i_clk CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of i_clk : signal is "XIL_INTERFACENAME i_clk, ASSOCIATED_RESET i_rst, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN week5_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of i_rst : signal is "xilinx.com:signal:reset:1.0 i_rst RST";
  attribute X_INTERFACE_PARAMETER of i_rst : signal is "XIL_INTERFACENAME i_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0";
begin
inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_PWM_gen_8bit
     port map (
      i_clk => i_clk,
      i_duty(7 downto 0) => i_duty(7 downto 0),
      i_rst => i_rst,
      o_pwm => o_pwm
    );
end STRUCTURE;
