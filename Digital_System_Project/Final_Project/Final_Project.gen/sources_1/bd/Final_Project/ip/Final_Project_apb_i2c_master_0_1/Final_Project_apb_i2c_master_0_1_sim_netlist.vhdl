-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Fri Jun 12 15:09:28 2026
-- Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Tukorea/Digital_System_Project/Final_Project/Final_Project.gen/sources_1/bd/Final_Project/ip/Final_Project_apb_i2c_master_0_1/Final_Project_apb_i2c_master_0_1_sim_netlist.vhdl
-- Design      : Final_Project_apb_i2c_master_0_1
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z007sclg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity Final_Project_apb_i2c_master_0_1_apb_i2c_master is
  port (
    PRDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    io_i2c_scl : inout STD_LOGIC;
    io_i2c_sda : inout STD_LOGIC;
    PCLK : in STD_LOGIC;
    PRESETn : in STD_LOGIC;
    PRDATA_31_sp_1 : in STD_LOGIC;
    PADDR : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \PRDATA[31]_0\ : in STD_LOGIC;
    PSEL : in STD_LOGIC;
    PWRITE : in STD_LOGIC;
    PENABLE : in STD_LOGIC;
    PWDATA : in STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of Final_Project_apb_i2c_master_0_1_apb_i2c_master : entity is "apb_i2c_master";
end Final_Project_apb_i2c_master_0_1_apb_i2c_master;

architecture STRUCTURE of Final_Project_apb_i2c_master_0_1_apb_i2c_master is
  signal \FSM_sequential_state[3]_i_10_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[3]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[3]_i_3_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[3]_i_4_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[3]_i_5_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[3]_i_6_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[3]_i_7_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[3]_i_8_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[3]_i_9_n_0\ : STD_LOGIC;
  signal \PRDATA[0]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \PRDATA[30]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal PRDATA_31_sn_1 : STD_LOGIC;
  signal \bit_cnt[0]_i_1_n_0\ : STD_LOGIC;
  signal \bit_cnt[0]_i_2_n_0\ : STD_LOGIC;
  signal \bit_cnt[1]_i_1_n_0\ : STD_LOGIC;
  signal \bit_cnt[1]_i_2_n_0\ : STD_LOGIC;
  signal \bit_cnt[2]_i_1_n_0\ : STD_LOGIC;
  signal \bit_cnt[2]_i_2_n_0\ : STD_LOGIC;
  signal \bit_cnt[2]_i_3_n_0\ : STD_LOGIC;
  signal \bit_cnt[2]_i_4_n_0\ : STD_LOGIC;
  signal \bit_cnt_reg_n_0_[0]\ : STD_LOGIC;
  signal \bit_cnt_reg_n_0_[1]\ : STD_LOGIC;
  signal \bit_cnt_reg_n_0_[2]\ : STD_LOGIC;
  signal data0 : STD_LOGIC_VECTOR ( 15 downto 1 );
  signal in4 : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal in5 : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal is_read : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal p_0_out : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \reg_ctrl[30]_i_1_n_0\ : STD_LOGIC;
  signal \reg_ctrl[30]_i_2_n_0\ : STD_LOGIC;
  signal \reg_ctrl[30]_i_3_n_0\ : STD_LOGIC;
  signal \reg_ctrl[31]_i_1_n_0\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[0]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[17]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[18]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[19]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[1]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[20]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[21]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[22]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[23]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[24]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[25]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[26]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[27]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[28]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[29]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[2]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[30]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[3]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[4]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[5]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[6]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[7]\ : STD_LOGIC;
  signal \reg_ctrl_reg_n_0_[8]\ : STD_LOGIC;
  signal reg_rx_data : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \reg_rx_data[7]_i_2_n_0\ : STD_LOGIC;
  signal \reg_rx_data[7]_i_3_n_0\ : STD_LOGIC;
  signal \reg_rx_data[7]_i_4_n_0\ : STD_LOGIC;
  signal reg_rx_data_0 : STD_LOGIC;
  signal reg_tx_data : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal reg_tx_data_1 : STD_LOGIC;
  signal scl_out : STD_LOGIC;
  signal scl_out_i_1_n_0 : STD_LOGIC;
  signal scl_out_i_2_n_0 : STD_LOGIC;
  signal scl_out_i_3_n_0 : STD_LOGIC;
  signal sda_in : STD_LOGIC;
  signal sda_out : STD_LOGIC;
  signal sda_out_i_1_n_0 : STD_LOGIC;
  signal sda_out_i_2_n_0 : STD_LOGIC;
  signal sda_out_i_3_n_0 : STD_LOGIC;
  signal sda_out_i_4_n_0 : STD_LOGIC;
  signal shift_rx : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \shift_rx[7]_i_1_n_0\ : STD_LOGIC;
  signal \shift_rx[7]_i_2_n_0\ : STD_LOGIC;
  signal \shift_tx[0]_i_1_n_0\ : STD_LOGIC;
  signal \shift_tx[1]_i_1_n_0\ : STD_LOGIC;
  signal \shift_tx[1]_i_2_n_0\ : STD_LOGIC;
  signal \shift_tx[2]_i_1_n_0\ : STD_LOGIC;
  signal \shift_tx[2]_i_2_n_0\ : STD_LOGIC;
  signal \shift_tx[3]_i_1_n_0\ : STD_LOGIC;
  signal \shift_tx[3]_i_2_n_0\ : STD_LOGIC;
  signal \shift_tx[4]_i_1_n_0\ : STD_LOGIC;
  signal \shift_tx[4]_i_2_n_0\ : STD_LOGIC;
  signal \shift_tx[5]_i_1_n_0\ : STD_LOGIC;
  signal \shift_tx[5]_i_2_n_0\ : STD_LOGIC;
  signal \shift_tx[6]_i_1_n_0\ : STD_LOGIC;
  signal \shift_tx[6]_i_2_n_0\ : STD_LOGIC;
  signal \shift_tx[7]_i_1_n_0\ : STD_LOGIC;
  signal \shift_tx[7]_i_2_n_0\ : STD_LOGIC;
  signal \shift_tx[7]_i_3_n_0\ : STD_LOGIC;
  signal \shift_tx[7]_i_4_n_0\ : STD_LOGIC;
  signal \shift_tx[7]_i_5_n_0\ : STD_LOGIC;
  signal \shift_tx[7]_i_6_n_0\ : STD_LOGIC;
  signal \shift_tx[7]_i_7_n_0\ : STD_LOGIC;
  signal start_cmd : STD_LOGIC;
  signal \state__0\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal status_busy : STD_LOGIC;
  signal status_busy_i_1_n_0 : STD_LOGIC;
  signal status_busy_i_2_n_0 : STD_LOGIC;
  signal \step[0]_i_1_n_0\ : STD_LOGIC;
  signal \step[1]_i_1_n_0\ : STD_LOGIC;
  signal \step[1]_i_2_n_0\ : STD_LOGIC;
  signal \step_reg_n_0_[0]\ : STD_LOGIC;
  signal \step_reg_n_0_[1]\ : STD_LOGIC;
  signal tick_cnt : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal \tick_cnt0_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt0_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \tick_cnt0_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \tick_cnt0_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \tick_cnt0_carry__0_n_0\ : STD_LOGIC;
  signal \tick_cnt0_carry__0_n_1\ : STD_LOGIC;
  signal \tick_cnt0_carry__0_n_2\ : STD_LOGIC;
  signal \tick_cnt0_carry__0_n_3\ : STD_LOGIC;
  signal \tick_cnt0_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt0_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \tick_cnt0_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \tick_cnt0_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \tick_cnt0_carry__1_n_0\ : STD_LOGIC;
  signal \tick_cnt0_carry__1_n_1\ : STD_LOGIC;
  signal \tick_cnt0_carry__1_n_2\ : STD_LOGIC;
  signal \tick_cnt0_carry__1_n_3\ : STD_LOGIC;
  signal \tick_cnt0_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt0_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \tick_cnt0_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \tick_cnt0_carry__2_n_2\ : STD_LOGIC;
  signal \tick_cnt0_carry__2_n_3\ : STD_LOGIC;
  signal tick_cnt0_carry_i_1_n_0 : STD_LOGIC;
  signal tick_cnt0_carry_i_2_n_0 : STD_LOGIC;
  signal tick_cnt0_carry_i_3_n_0 : STD_LOGIC;
  signal tick_cnt0_carry_i_4_n_0 : STD_LOGIC;
  signal tick_cnt0_carry_n_0 : STD_LOGIC;
  signal tick_cnt0_carry_n_1 : STD_LOGIC;
  signal tick_cnt0_carry_n_2 : STD_LOGIC;
  signal tick_cnt0_carry_n_3 : STD_LOGIC;
  signal \tick_cnt[0]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[10]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[11]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[12]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[13]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[14]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[15]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[1]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[2]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[3]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[4]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[5]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[6]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[7]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[8]_i_1_n_0\ : STD_LOGIC;
  signal \tick_cnt[9]_i_1_n_0\ : STD_LOGIC;
  signal NLW_scl_iobuf_O_UNCONNECTED : STD_LOGIC;
  signal \NLW_tick_cnt0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_tick_cnt0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_state[0]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \FSM_sequential_state[1]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \FSM_sequential_state[2]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \FSM_sequential_state[3]_i_2\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \FSM_sequential_state[3]_i_4\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \FSM_sequential_state[3]_i_6\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \FSM_sequential_state[3]_i_7\ : label is "soft_lutpair6";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[0]\ : label is "iSTATE:0011,iSTATE0:0100,iSTATE1:1101,iSTATE2:0010,iSTATE3:1011,iSTATE4:1100,iSTATE5:1010,iSTATE6:0001,iSTATE7:0000,iSTATE8:1001,iSTATE9:0111,iSTATE10:0110,iSTATE11:1000,iSTATE12:0101";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[1]\ : label is "iSTATE:0011,iSTATE0:0100,iSTATE1:1101,iSTATE2:0010,iSTATE3:1011,iSTATE4:1100,iSTATE5:1010,iSTATE6:0001,iSTATE7:0000,iSTATE8:1001,iSTATE9:0111,iSTATE10:0110,iSTATE11:1000,iSTATE12:0101";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[2]\ : label is "iSTATE:0011,iSTATE0:0100,iSTATE1:1101,iSTATE2:0010,iSTATE3:1011,iSTATE4:1100,iSTATE5:1010,iSTATE6:0001,iSTATE7:0000,iSTATE8:1001,iSTATE9:0111,iSTATE10:0110,iSTATE11:1000,iSTATE12:0101";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[3]\ : label is "iSTATE:0011,iSTATE0:0100,iSTATE1:1101,iSTATE2:0010,iSTATE3:1011,iSTATE4:1100,iSTATE5:1010,iSTATE6:0001,iSTATE7:0000,iSTATE8:1001,iSTATE9:0111,iSTATE10:0110,iSTATE11:1000,iSTATE12:0101";
  attribute SOFT_HLUTNM of \bit_cnt[0]_i_2\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \bit_cnt[2]_i_2\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \reg_rx_data[7]_i_2\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \reg_rx_data[7]_i_4\ : label is "soft_lutpair3";
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of scl_iobuf : label is "PRIMITIVE";
  attribute BOX_TYPE of sda_iobuf : label is "PRIMITIVE";
  attribute SOFT_HLUTNM of \shift_rx[7]_i_2\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \shift_tx[7]_i_5\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \shift_tx[7]_i_7\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \step[1]_i_2\ : label is "soft_lutpair7";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of tick_cnt0_carry : label is 35;
  attribute ADDER_THRESHOLD of \tick_cnt0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \tick_cnt0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \tick_cnt0_carry__2\ : label is 35;
  attribute SOFT_HLUTNM of \tick_cnt[0]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \tick_cnt[10]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \tick_cnt[11]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \tick_cnt[12]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \tick_cnt[13]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \tick_cnt[14]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \tick_cnt[1]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \tick_cnt[2]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \tick_cnt[3]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \tick_cnt[4]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \tick_cnt[5]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \tick_cnt[6]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \tick_cnt[7]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \tick_cnt[8]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \tick_cnt[9]_i_1\ : label is "soft_lutpair12";
begin
  PRDATA_31_sn_1 <= PRDATA_31_sp_1;
\FSM_sequential_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"047F"
    )
        port map (
      I0 => \state__0\(2),
      I1 => \state__0\(3),
      I2 => \state__0\(1),
      I3 => \state__0\(0),
      O => p_0_out(0)
    );
\FSM_sequential_state[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0030F83C"
    )
        port map (
      I0 => is_read,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \state__0\(2),
      I4 => \state__0\(3),
      O => p_0_out(1)
    );
\FSM_sequential_state[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"33380CCC"
    )
        port map (
      I0 => is_read,
      I1 => \state__0\(2),
      I2 => \state__0\(3),
      I3 => \state__0\(1),
      I4 => \state__0\(0),
      O => p_0_out(2)
    );
\FSM_sequential_state[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAC0AA00AA00AA00"
    )
        port map (
      I0 => start_cmd,
      I1 => \step_reg_n_0_[0]\,
      I2 => \step_reg_n_0_[1]\,
      I3 => \FSM_sequential_state[3]_i_4_n_0\,
      I4 => \FSM_sequential_state[3]_i_5_n_0\,
      I5 => \FSM_sequential_state[3]_i_6_n_0\,
      O => \FSM_sequential_state[3]_i_1_n_0\
    );
\FSM_sequential_state[3]_i_10\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => tick_cnt(15),
      I1 => tick_cnt(12),
      I2 => tick_cnt(8),
      I3 => tick_cnt(9),
      O => \FSM_sequential_state[3]_i_10_n_0\
    );
\FSM_sequential_state[3]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"1F801FC0"
    )
        port map (
      I0 => \state__0\(1),
      I1 => \state__0\(0),
      I2 => \state__0\(2),
      I3 => \state__0\(3),
      I4 => is_read,
      O => p_0_out(3)
    );
\FSM_sequential_state[3]_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => PRESETn,
      O => \FSM_sequential_state[3]_i_3_n_0\
    );
\FSM_sequential_state[3]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => \state__0\(1),
      I1 => \state__0\(0),
      I2 => \state__0\(2),
      I3 => \state__0\(3),
      O => \FSM_sequential_state[3]_i_4_n_0\
    );
\FSM_sequential_state[3]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0004"
    )
        port map (
      I0 => \FSM_sequential_state[3]_i_7_n_0\,
      I1 => \FSM_sequential_state[3]_i_8_n_0\,
      I2 => \FSM_sequential_state[3]_i_9_n_0\,
      I3 => \FSM_sequential_state[3]_i_10_n_0\,
      O => \FSM_sequential_state[3]_i_5_n_0\
    );
\FSM_sequential_state[3]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"07FD7DDC"
    )
        port map (
      I0 => \reg_rx_data[7]_i_4_n_0\,
      I1 => \state__0\(0),
      I2 => \state__0\(3),
      I3 => \state__0\(1),
      I4 => \state__0\(2),
      O => \FSM_sequential_state[3]_i_6_n_0\
    );
\FSM_sequential_state[3]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => tick_cnt(0),
      I1 => tick_cnt(2),
      I2 => tick_cnt(7),
      I3 => tick_cnt(1),
      O => \FSM_sequential_state[3]_i_7_n_0\
    );
\FSM_sequential_state[3]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => tick_cnt(14),
      I1 => tick_cnt(13),
      I2 => tick_cnt(10),
      I3 => tick_cnt(3),
      O => \FSM_sequential_state[3]_i_8_n_0\
    );
\FSM_sequential_state[3]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => tick_cnt(6),
      I1 => tick_cnt(5),
      I2 => tick_cnt(11),
      I3 => tick_cnt(4),
      O => \FSM_sequential_state[3]_i_9_n_0\
    );
\FSM_sequential_state_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \FSM_sequential_state[3]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => p_0_out(0),
      Q => \state__0\(0)
    );
\FSM_sequential_state_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \FSM_sequential_state[3]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => p_0_out(1),
      Q => \state__0\(1)
    );
\FSM_sequential_state_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \FSM_sequential_state[3]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => p_0_out(2),
      Q => \state__0\(2)
    );
\FSM_sequential_state_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \FSM_sequential_state[3]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => p_0_out(3),
      Q => \state__0\(3)
    );
\PRDATA[0]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000E2E200FF"
    )
        port map (
      I0 => status_busy,
      I1 => PADDR(2),
      I2 => reg_rx_data(0),
      I3 => \PRDATA[0]_INST_0_i_1_n_0\,
      I4 => PADDR(3),
      I5 => \PRDATA[30]_INST_0_i_1_n_0\,
      O => PRDATA(0)
    );
\PRDATA[0]_INST_0_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"35"
    )
        port map (
      I0 => \reg_ctrl_reg_n_0_[0]\,
      I1 => reg_tx_data(0),
      I2 => PADDR(2),
      O => \PRDATA[0]_INST_0_i_1_n_0\
    );
\PRDATA[10]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => in4(2),
      I3 => PADDR(2),
      I4 => reg_tx_data(10),
      O => PRDATA(10)
    );
\PRDATA[11]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => in4(3),
      I3 => PADDR(2),
      I4 => reg_tx_data(11),
      O => PRDATA(11)
    );
\PRDATA[12]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => in4(4),
      I3 => PADDR(2),
      I4 => reg_tx_data(12),
      O => PRDATA(12)
    );
\PRDATA[13]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => in4(5),
      I3 => PADDR(2),
      I4 => reg_tx_data(13),
      O => PRDATA(13)
    );
\PRDATA[14]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => in4(6),
      I3 => PADDR(2),
      I4 => reg_tx_data(14),
      O => PRDATA(14)
    );
\PRDATA[15]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => in4(7),
      I3 => PADDR(2),
      I4 => reg_tx_data(15),
      O => PRDATA(15)
    );
\PRDATA[16]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => is_read,
      I3 => PADDR(2),
      I4 => reg_tx_data(16),
      O => PRDATA(16)
    );
\PRDATA[17]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[17]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(17),
      O => PRDATA(17)
    );
\PRDATA[18]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[18]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(18),
      O => PRDATA(18)
    );
\PRDATA[19]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[19]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(19),
      O => PRDATA(19)
    );
\PRDATA[1]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000CCE200E2"
    )
        port map (
      I0 => \reg_ctrl_reg_n_0_[1]\,
      I1 => PADDR(2),
      I2 => reg_tx_data(1),
      I3 => PADDR(3),
      I4 => reg_rx_data(1),
      I5 => \PRDATA[30]_INST_0_i_1_n_0\,
      O => PRDATA(1)
    );
\PRDATA[20]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[20]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(20),
      O => PRDATA(20)
    );
\PRDATA[21]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[21]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(21),
      O => PRDATA(21)
    );
\PRDATA[22]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[22]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(22),
      O => PRDATA(22)
    );
\PRDATA[23]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[23]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(23),
      O => PRDATA(23)
    );
\PRDATA[24]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[24]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(24),
      O => PRDATA(24)
    );
\PRDATA[25]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[25]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(25),
      O => PRDATA(25)
    );
\PRDATA[26]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[26]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(26),
      O => PRDATA(26)
    );
\PRDATA[27]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[27]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(27),
      O => PRDATA(27)
    );
\PRDATA[28]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[28]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(28),
      O => PRDATA(28)
    );
\PRDATA[29]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[29]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(29),
      O => PRDATA(29)
    );
\PRDATA[2]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000CCE200E2"
    )
        port map (
      I0 => \reg_ctrl_reg_n_0_[2]\,
      I1 => PADDR(2),
      I2 => reg_tx_data(2),
      I3 => PADDR(3),
      I4 => reg_rx_data(2),
      I5 => \PRDATA[30]_INST_0_i_1_n_0\,
      O => PRDATA(2)
    );
\PRDATA[30]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[30]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(30),
      O => PRDATA(30)
    );
\PRDATA[30]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => PADDR(5),
      I1 => PADDR(6),
      I2 => PADDR(4),
      I3 => PADDR(7),
      I4 => PADDR(1),
      I5 => PADDR(0),
      O => \PRDATA[30]_INST_0_i_1_n_0\
    );
\PRDATA[31]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000002320"
    )
        port map (
      I0 => reg_tx_data(31),
      I1 => PRDATA_31_sn_1,
      I2 => PADDR(2),
      I3 => start_cmd,
      I4 => PADDR(3),
      I5 => \PRDATA[31]_0\,
      O => PRDATA(31)
    );
\PRDATA[3]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000CCE200E2"
    )
        port map (
      I0 => \reg_ctrl_reg_n_0_[3]\,
      I1 => PADDR(2),
      I2 => reg_tx_data(3),
      I3 => PADDR(3),
      I4 => reg_rx_data(3),
      I5 => \PRDATA[30]_INST_0_i_1_n_0\,
      O => PRDATA(3)
    );
\PRDATA[4]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000CCE200E2"
    )
        port map (
      I0 => \reg_ctrl_reg_n_0_[4]\,
      I1 => PADDR(2),
      I2 => reg_tx_data(4),
      I3 => PADDR(3),
      I4 => reg_rx_data(4),
      I5 => \PRDATA[30]_INST_0_i_1_n_0\,
      O => PRDATA(4)
    );
\PRDATA[5]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000CCE200E2"
    )
        port map (
      I0 => \reg_ctrl_reg_n_0_[5]\,
      I1 => PADDR(2),
      I2 => reg_tx_data(5),
      I3 => PADDR(3),
      I4 => reg_rx_data(5),
      I5 => \PRDATA[30]_INST_0_i_1_n_0\,
      O => PRDATA(5)
    );
\PRDATA[6]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000CCE200E2"
    )
        port map (
      I0 => \reg_ctrl_reg_n_0_[6]\,
      I1 => PADDR(2),
      I2 => reg_tx_data(6),
      I3 => PADDR(3),
      I4 => reg_rx_data(6),
      I5 => \PRDATA[30]_INST_0_i_1_n_0\,
      O => PRDATA(6)
    );
\PRDATA[7]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000CCE200E2"
    )
        port map (
      I0 => \reg_ctrl_reg_n_0_[7]\,
      I1 => PADDR(2),
      I2 => reg_tx_data(7),
      I3 => PADDR(3),
      I4 => reg_rx_data(7),
      I5 => \PRDATA[30]_INST_0_i_1_n_0\,
      O => PRDATA(7)
    );
\PRDATA[8]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => \reg_ctrl_reg_n_0_[8]\,
      I3 => PADDR(2),
      I4 => reg_tx_data(8),
      O => PRDATA(8)
    );
\PRDATA[9]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11100010"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => in4(1),
      I3 => PADDR(2),
      I4 => reg_tx_data(9),
      O => PRDATA(9)
    );
\bit_cnt[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFEF00000030"
    )
        port map (
      I0 => \bit_cnt[0]_i_2_n_0\,
      I1 => \FSM_sequential_state[3]_i_4_n_0\,
      I2 => \FSM_sequential_state[3]_i_5_n_0\,
      I3 => \bit_cnt[2]_i_3_n_0\,
      I4 => \bit_cnt[2]_i_4_n_0\,
      I5 => \bit_cnt_reg_n_0_[0]\,
      O => \bit_cnt[0]_i_1_n_0\
    );
\bit_cnt[0]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"666A"
    )
        port map (
      I0 => \state__0\(0),
      I1 => \state__0\(1),
      I2 => \state__0\(3),
      I3 => \state__0\(2),
      O => \bit_cnt[0]_i_2_n_0\
    );
\bit_cnt[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFEF00000020"
    )
        port map (
      I0 => \bit_cnt[1]_i_2_n_0\,
      I1 => \FSM_sequential_state[3]_i_4_n_0\,
      I2 => \FSM_sequential_state[3]_i_5_n_0\,
      I3 => \bit_cnt[2]_i_3_n_0\,
      I4 => \bit_cnt[2]_i_4_n_0\,
      I5 => \bit_cnt_reg_n_0_[1]\,
      O => \bit_cnt[1]_i_1_n_0\
    );
\bit_cnt[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF1FE01FE0FFFF"
    )
        port map (
      I0 => \state__0\(2),
      I1 => \state__0\(3),
      I2 => \state__0\(1),
      I3 => \state__0\(0),
      I4 => \bit_cnt_reg_n_0_[1]\,
      I5 => \bit_cnt_reg_n_0_[0]\,
      O => \bit_cnt[1]_i_2_n_0\
    );
\bit_cnt[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFEF00000020"
    )
        port map (
      I0 => \bit_cnt[2]_i_2_n_0\,
      I1 => \FSM_sequential_state[3]_i_4_n_0\,
      I2 => \FSM_sequential_state[3]_i_5_n_0\,
      I3 => \bit_cnt[2]_i_3_n_0\,
      I4 => \bit_cnt[2]_i_4_n_0\,
      I5 => \bit_cnt_reg_n_0_[2]\,
      O => \bit_cnt[2]_i_1_n_0\
    );
\bit_cnt[2]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FEAB"
    )
        port map (
      I0 => \bit_cnt[0]_i_2_n_0\,
      I1 => \bit_cnt_reg_n_0_[0]\,
      I2 => \bit_cnt_reg_n_0_[1]\,
      I3 => \bit_cnt_reg_n_0_[2]\,
      O => \bit_cnt[2]_i_2_n_0\
    );
\bit_cnt[2]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF01FF01FF01FF"
    )
        port map (
      I0 => \reg_rx_data[7]_i_4_n_0\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \reg_rx_data[7]_i_3_n_0\,
      I4 => \state__0\(3),
      I5 => \state__0\(2),
      O => \bit_cnt[2]_i_3_n_0\
    );
\bit_cnt[2]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000AA85AAA5AA85"
    )
        port map (
      I0 => \state__0\(0),
      I1 => is_read,
      I2 => \state__0\(2),
      I3 => \state__0\(3),
      I4 => \state__0\(1),
      I5 => \reg_rx_data[7]_i_4_n_0\,
      O => \bit_cnt[2]_i_4_n_0\
    );
\bit_cnt_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \bit_cnt[0]_i_1_n_0\,
      Q => \bit_cnt_reg_n_0_[0]\
    );
\bit_cnt_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \bit_cnt[1]_i_1_n_0\,
      Q => \bit_cnt_reg_n_0_[1]\
    );
\bit_cnt_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \bit_cnt[2]_i_1_n_0\,
      Q => \bit_cnt_reg_n_0_[2]\
    );
\reg_ctrl[30]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000008"
    )
        port map (
      I0 => \reg_ctrl[30]_i_2_n_0\,
      I1 => \reg_ctrl[30]_i_3_n_0\,
      I2 => PADDR(2),
      I3 => PADDR(1),
      I4 => PADDR(0),
      O => \reg_ctrl[30]_i_1_n_0\
    );
\reg_ctrl[30]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => PADDR(3),
      I1 => PADDR(5),
      I2 => PADDR(6),
      I3 => PADDR(4),
      I4 => PADDR(7),
      O => \reg_ctrl[30]_i_2_n_0\
    );
\reg_ctrl[30]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => PSEL,
      I1 => PWRITE,
      I2 => PENABLE,
      O => \reg_ctrl[30]_i_3_n_0\
    );
\reg_ctrl[31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"88CF8800"
    )
        port map (
      I0 => PWDATA(31),
      I1 => \reg_ctrl[30]_i_3_n_0\,
      I2 => status_busy,
      I3 => \reg_ctrl[30]_i_1_n_0\,
      I4 => start_cmd,
      O => \reg_ctrl[31]_i_1_n_0\
    );
\reg_ctrl_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(0),
      Q => \reg_ctrl_reg_n_0_[0]\
    );
\reg_ctrl_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(10),
      Q => in4(2)
    );
\reg_ctrl_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(11),
      Q => in4(3)
    );
\reg_ctrl_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(12),
      Q => in4(4)
    );
\reg_ctrl_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(13),
      Q => in4(5)
    );
\reg_ctrl_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(14),
      Q => in4(6)
    );
\reg_ctrl_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(15),
      Q => in4(7)
    );
\reg_ctrl_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(16),
      Q => is_read
    );
\reg_ctrl_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(17),
      Q => \reg_ctrl_reg_n_0_[17]\
    );
\reg_ctrl_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(18),
      Q => \reg_ctrl_reg_n_0_[18]\
    );
\reg_ctrl_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(19),
      Q => \reg_ctrl_reg_n_0_[19]\
    );
\reg_ctrl_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(1),
      Q => \reg_ctrl_reg_n_0_[1]\
    );
\reg_ctrl_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(20),
      Q => \reg_ctrl_reg_n_0_[20]\
    );
\reg_ctrl_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(21),
      Q => \reg_ctrl_reg_n_0_[21]\
    );
\reg_ctrl_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(22),
      Q => \reg_ctrl_reg_n_0_[22]\
    );
\reg_ctrl_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(23),
      Q => \reg_ctrl_reg_n_0_[23]\
    );
\reg_ctrl_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(24),
      Q => \reg_ctrl_reg_n_0_[24]\
    );
\reg_ctrl_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(25),
      Q => \reg_ctrl_reg_n_0_[25]\
    );
\reg_ctrl_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(26),
      Q => \reg_ctrl_reg_n_0_[26]\
    );
\reg_ctrl_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(27),
      Q => \reg_ctrl_reg_n_0_[27]\
    );
\reg_ctrl_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(28),
      Q => \reg_ctrl_reg_n_0_[28]\
    );
\reg_ctrl_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(29),
      Q => \reg_ctrl_reg_n_0_[29]\
    );
\reg_ctrl_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(2),
      Q => \reg_ctrl_reg_n_0_[2]\
    );
\reg_ctrl_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(30),
      Q => \reg_ctrl_reg_n_0_[30]\
    );
\reg_ctrl_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \reg_ctrl[31]_i_1_n_0\,
      Q => start_cmd
    );
\reg_ctrl_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(3),
      Q => \reg_ctrl_reg_n_0_[3]\
    );
\reg_ctrl_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(4),
      Q => \reg_ctrl_reg_n_0_[4]\
    );
\reg_ctrl_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(5),
      Q => \reg_ctrl_reg_n_0_[5]\
    );
\reg_ctrl_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(6),
      Q => \reg_ctrl_reg_n_0_[6]\
    );
\reg_ctrl_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(7),
      Q => \reg_ctrl_reg_n_0_[7]\
    );
\reg_ctrl_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(8),
      Q => \reg_ctrl_reg_n_0_[8]\
    );
\reg_ctrl_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => \reg_ctrl[30]_i_1_n_0\,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(9),
      Q => in4(1)
    );
\reg_rx_data[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000008000000"
    )
        port map (
      I0 => \FSM_sequential_state[3]_i_5_n_0\,
      I1 => \state__0\(0),
      I2 => \state__0\(2),
      I3 => \reg_rx_data[7]_i_2_n_0\,
      I4 => \reg_rx_data[7]_i_3_n_0\,
      I5 => \reg_rx_data[7]_i_4_n_0\,
      O => reg_rx_data_0
    );
\reg_rx_data[7]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(1),
      I1 => \state__0\(3),
      O => \reg_rx_data[7]_i_2_n_0\
    );
\reg_rx_data[7]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \step_reg_n_0_[1]\,
      I1 => \step_reg_n_0_[0]\,
      O => \reg_rx_data[7]_i_3_n_0\
    );
\reg_rx_data[7]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => \bit_cnt_reg_n_0_[2]\,
      I1 => \bit_cnt_reg_n_0_[1]\,
      I2 => \bit_cnt_reg_n_0_[0]\,
      O => \reg_rx_data[7]_i_4_n_0\
    );
\reg_rx_data_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_rx_data_0,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => shift_rx(0),
      Q => reg_rx_data(0)
    );
\reg_rx_data_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_rx_data_0,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => shift_rx(1),
      Q => reg_rx_data(1)
    );
\reg_rx_data_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_rx_data_0,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => shift_rx(2),
      Q => reg_rx_data(2)
    );
\reg_rx_data_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_rx_data_0,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => shift_rx(3),
      Q => reg_rx_data(3)
    );
\reg_rx_data_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_rx_data_0,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => shift_rx(4),
      Q => reg_rx_data(4)
    );
\reg_rx_data_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_rx_data_0,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => shift_rx(5),
      Q => reg_rx_data(5)
    );
\reg_rx_data_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_rx_data_0,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => shift_rx(6),
      Q => reg_rx_data(6)
    );
\reg_rx_data_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_rx_data_0,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => shift_rx(7),
      Q => reg_rx_data(7)
    );
\reg_tx_data[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"1000000000000000"
    )
        port map (
      I0 => PADDR(3),
      I1 => \PRDATA[30]_INST_0_i_1_n_0\,
      I2 => PENABLE,
      I3 => PWRITE,
      I4 => PSEL,
      I5 => PADDR(2),
      O => reg_tx_data_1
    );
\reg_tx_data_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(0),
      Q => reg_tx_data(0)
    );
\reg_tx_data_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(10),
      Q => reg_tx_data(10)
    );
\reg_tx_data_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(11),
      Q => reg_tx_data(11)
    );
\reg_tx_data_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(12),
      Q => reg_tx_data(12)
    );
\reg_tx_data_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(13),
      Q => reg_tx_data(13)
    );
\reg_tx_data_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(14),
      Q => reg_tx_data(14)
    );
\reg_tx_data_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(15),
      Q => reg_tx_data(15)
    );
\reg_tx_data_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(16),
      Q => reg_tx_data(16)
    );
\reg_tx_data_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(17),
      Q => reg_tx_data(17)
    );
\reg_tx_data_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(18),
      Q => reg_tx_data(18)
    );
\reg_tx_data_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(19),
      Q => reg_tx_data(19)
    );
\reg_tx_data_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(1),
      Q => reg_tx_data(1)
    );
\reg_tx_data_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(20),
      Q => reg_tx_data(20)
    );
\reg_tx_data_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(21),
      Q => reg_tx_data(21)
    );
\reg_tx_data_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(22),
      Q => reg_tx_data(22)
    );
\reg_tx_data_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(23),
      Q => reg_tx_data(23)
    );
\reg_tx_data_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(24),
      Q => reg_tx_data(24)
    );
\reg_tx_data_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(25),
      Q => reg_tx_data(25)
    );
\reg_tx_data_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(26),
      Q => reg_tx_data(26)
    );
\reg_tx_data_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(27),
      Q => reg_tx_data(27)
    );
\reg_tx_data_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(28),
      Q => reg_tx_data(28)
    );
\reg_tx_data_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(29),
      Q => reg_tx_data(29)
    );
\reg_tx_data_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(2),
      Q => reg_tx_data(2)
    );
\reg_tx_data_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(30),
      Q => reg_tx_data(30)
    );
\reg_tx_data_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(31),
      Q => reg_tx_data(31)
    );
\reg_tx_data_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(3),
      Q => reg_tx_data(3)
    );
\reg_tx_data_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(4),
      Q => reg_tx_data(4)
    );
\reg_tx_data_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(5),
      Q => reg_tx_data(5)
    );
\reg_tx_data_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(6),
      Q => reg_tx_data(6)
    );
\reg_tx_data_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(7),
      Q => reg_tx_data(7)
    );
\reg_tx_data_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(8),
      Q => reg_tx_data(8)
    );
\reg_tx_data_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => reg_tx_data_1,
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => PWDATA(9),
      Q => reg_tx_data(9)
    );
scl_iobuf: unisim.vcomponents.IOBUF
    generic map(
      IOSTANDARD => "DEFAULT"
    )
        port map (
      I => '0',
      IO => io_i2c_scl,
      O => NLW_scl_iobuf_O_UNCONNECTED,
      T => scl_out
    );
scl_out_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BABB8A88"
    )
        port map (
      I0 => scl_out_i_2_n_0,
      I1 => \FSM_sequential_state[3]_i_4_n_0\,
      I2 => scl_out_i_3_n_0,
      I3 => \FSM_sequential_state[3]_i_5_n_0\,
      I4 => scl_out,
      O => scl_out_i_1_n_0
    );
scl_out_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"08013FFF3FFD0003"
    )
        port map (
      I0 => \state__0\(0),
      I1 => \state__0\(2),
      I2 => \state__0\(1),
      I3 => \state__0\(3),
      I4 => \step_reg_n_0_[1]\,
      I5 => \step_reg_n_0_[0]\,
      O => scl_out_i_2_n_0
    );
scl_out_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8980808081818181"
    )
        port map (
      I0 => \state__0\(2),
      I1 => \state__0\(3),
      I2 => \state__0\(1),
      I3 => \step_reg_n_0_[0]\,
      I4 => \step_reg_n_0_[1]\,
      I5 => \state__0\(0),
      O => scl_out_i_3_n_0
    );
scl_out_reg: unisim.vcomponents.FDPE
     port map (
      C => PCLK,
      CE => '1',
      D => scl_out_i_1_n_0,
      PRE => \FSM_sequential_state[3]_i_3_n_0\,
      Q => scl_out
    );
sda_iobuf: unisim.vcomponents.IOBUF
    generic map(
      IOSTANDARD => "DEFAULT"
    )
        port map (
      I => '0',
      IO => io_i2c_sda,
      O => sda_in,
      T => sda_out
    );
sda_out_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EFEEEFEFE0EEE0E0"
    )
        port map (
      I0 => sda_out_i_2_n_0,
      I1 => sda_out_i_3_n_0,
      I2 => \FSM_sequential_state[3]_i_4_n_0\,
      I3 => sda_out_i_4_n_0,
      I4 => \FSM_sequential_state[3]_i_5_n_0\,
      I5 => sda_out,
      O => sda_out_i_1_n_0
    );
sda_out_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F000000F1FFF100"
    )
        port map (
      I0 => \step_reg_n_0_[1]\,
      I1 => \step_reg_n_0_[0]\,
      I2 => \state__0\(3),
      I3 => \state__0\(0),
      I4 => p_0_in,
      I5 => \state__0\(2),
      O => sda_out_i_2_n_0
    );
sda_out_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"50AA55AA55AA4E55"
    )
        port map (
      I0 => \state__0\(1),
      I1 => p_0_in,
      I2 => \step_reg_n_0_[1]\,
      I3 => \state__0\(2),
      I4 => \state__0\(3),
      I5 => \state__0\(0),
      O => sda_out_i_3_n_0
    );
sda_out_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFBEDFBEDF8081"
    )
        port map (
      I0 => \state__0\(1),
      I1 => \state__0\(3),
      I2 => \state__0\(2),
      I3 => \state__0\(0),
      I4 => \step_reg_n_0_[0]\,
      I5 => \step_reg_n_0_[1]\,
      O => sda_out_i_4_n_0
    );
sda_out_reg: unisim.vcomponents.FDPE
     port map (
      C => PCLK,
      CE => '1',
      D => sda_out_i_1_n_0,
      PRE => \FSM_sequential_state[3]_i_3_n_0\,
      Q => sda_out
    );
\shift_rx[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000800000000"
    )
        port map (
      I0 => \FSM_sequential_state[3]_i_5_n_0\,
      I1 => \step_reg_n_0_[1]\,
      I2 => \step_reg_n_0_[0]\,
      I3 => \shift_rx[7]_i_2_n_0\,
      I4 => \FSM_sequential_state[3]_i_4_n_0\,
      I5 => PRESETn,
      O => \shift_rx[7]_i_1_n_0\
    );
\shift_rx[7]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F7FF"
    )
        port map (
      I0 => \state__0\(3),
      I1 => \state__0\(1),
      I2 => \state__0\(2),
      I3 => \state__0\(0),
      O => \shift_rx[7]_i_2_n_0\
    );
\shift_rx_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_rx[7]_i_1_n_0\,
      D => sda_in,
      Q => shift_rx(0),
      R => '0'
    );
\shift_rx_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_rx[7]_i_1_n_0\,
      D => shift_rx(0),
      Q => shift_rx(1),
      R => '0'
    );
\shift_rx_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_rx[7]_i_1_n_0\,
      D => shift_rx(1),
      Q => shift_rx(2),
      R => '0'
    );
\shift_rx_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_rx[7]_i_1_n_0\,
      D => shift_rx(2),
      Q => shift_rx(3),
      R => '0'
    );
\shift_rx_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_rx[7]_i_1_n_0\,
      D => shift_rx(3),
      Q => shift_rx(4),
      R => '0'
    );
\shift_rx_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_rx[7]_i_1_n_0\,
      D => shift_rx(4),
      Q => shift_rx(5),
      R => '0'
    );
\shift_rx_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_rx[7]_i_1_n_0\,
      D => shift_rx(5),
      Q => shift_rx(6),
      R => '0'
    );
\shift_rx_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_rx[7]_i_1_n_0\,
      D => shift_rx(6),
      Q => shift_rx(7),
      R => '0'
    );
\shift_tx[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAA83C80AAA83080"
    )
        port map (
      I0 => reg_tx_data(0),
      I1 => \state__0\(0),
      I2 => \state__0\(2),
      I3 => \state__0\(1),
      I4 => \state__0\(3),
      I5 => \reg_ctrl_reg_n_0_[0]\,
      O => \shift_tx[0]_i_1_n_0\
    );
\shift_tx[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FCBB3088"
    )
        port map (
      I0 => reg_tx_data(1),
      I1 => \shift_tx[7]_i_5_n_0\,
      I2 => \shift_tx[1]_i_2_n_0\,
      I3 => \shift_tx[7]_i_7_n_0\,
      I4 => in4(1),
      O => \shift_tx[1]_i_1_n_0\
    );
\shift_tx[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AABBBAAAAA888AAA"
    )
        port map (
      I0 => in5(1),
      I1 => \state__0\(3),
      I2 => \state__0\(1),
      I3 => \state__0\(2),
      I4 => \state__0\(0),
      I5 => \reg_ctrl_reg_n_0_[1]\,
      O => \shift_tx[1]_i_2_n_0\
    );
\shift_tx[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FCBB3088"
    )
        port map (
      I0 => reg_tx_data(2),
      I1 => \shift_tx[7]_i_5_n_0\,
      I2 => \shift_tx[2]_i_2_n_0\,
      I3 => \shift_tx[7]_i_7_n_0\,
      I4 => in4(2),
      O => \shift_tx[2]_i_1_n_0\
    );
\shift_tx[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AABBBAAAAA888AAA"
    )
        port map (
      I0 => in5(2),
      I1 => \state__0\(3),
      I2 => \state__0\(1),
      I3 => \state__0\(2),
      I4 => \state__0\(0),
      I5 => \reg_ctrl_reg_n_0_[2]\,
      O => \shift_tx[2]_i_2_n_0\
    );
\shift_tx[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FCBB3088"
    )
        port map (
      I0 => reg_tx_data(3),
      I1 => \shift_tx[7]_i_5_n_0\,
      I2 => \shift_tx[3]_i_2_n_0\,
      I3 => \shift_tx[7]_i_7_n_0\,
      I4 => in4(3),
      O => \shift_tx[3]_i_1_n_0\
    );
\shift_tx[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AABBBAAAAA888AAA"
    )
        port map (
      I0 => in5(3),
      I1 => \state__0\(3),
      I2 => \state__0\(1),
      I3 => \state__0\(2),
      I4 => \state__0\(0),
      I5 => \reg_ctrl_reg_n_0_[3]\,
      O => \shift_tx[3]_i_2_n_0\
    );
\shift_tx[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FCBB3088"
    )
        port map (
      I0 => reg_tx_data(4),
      I1 => \shift_tx[7]_i_5_n_0\,
      I2 => \shift_tx[4]_i_2_n_0\,
      I3 => \shift_tx[7]_i_7_n_0\,
      I4 => in4(4),
      O => \shift_tx[4]_i_1_n_0\
    );
\shift_tx[4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AABBBAAAAA888AAA"
    )
        port map (
      I0 => in5(4),
      I1 => \state__0\(3),
      I2 => \state__0\(1),
      I3 => \state__0\(2),
      I4 => \state__0\(0),
      I5 => \reg_ctrl_reg_n_0_[4]\,
      O => \shift_tx[4]_i_2_n_0\
    );
\shift_tx[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FCBB3088"
    )
        port map (
      I0 => reg_tx_data(5),
      I1 => \shift_tx[7]_i_5_n_0\,
      I2 => \shift_tx[5]_i_2_n_0\,
      I3 => \shift_tx[7]_i_7_n_0\,
      I4 => in4(5),
      O => \shift_tx[5]_i_1_n_0\
    );
\shift_tx[5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AABBBAAAAA888AAA"
    )
        port map (
      I0 => in5(5),
      I1 => \state__0\(3),
      I2 => \state__0\(1),
      I3 => \state__0\(2),
      I4 => \state__0\(0),
      I5 => \reg_ctrl_reg_n_0_[5]\,
      O => \shift_tx[5]_i_2_n_0\
    );
\shift_tx[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FCBB3088"
    )
        port map (
      I0 => reg_tx_data(6),
      I1 => \shift_tx[7]_i_5_n_0\,
      I2 => \shift_tx[6]_i_2_n_0\,
      I3 => \shift_tx[7]_i_7_n_0\,
      I4 => in4(6),
      O => \shift_tx[6]_i_1_n_0\
    );
\shift_tx[6]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AABBBAAAAA888AAA"
    )
        port map (
      I0 => in5(6),
      I1 => \state__0\(3),
      I2 => \state__0\(1),
      I3 => \state__0\(2),
      I4 => \state__0\(0),
      I5 => \reg_ctrl_reg_n_0_[6]\,
      O => \shift_tx[6]_i_2_n_0\
    );
\shift_tx[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000808808"
    )
        port map (
      I0 => \FSM_sequential_state[3]_i_5_n_0\,
      I1 => PRESETn,
      I2 => \shift_tx[7]_i_3_n_0\,
      I3 => \state__0\(2),
      I4 => \state__0\(3),
      I5 => \shift_tx[7]_i_4_n_0\,
      O => \shift_tx[7]_i_1_n_0\
    );
\shift_tx[7]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FCBB3088"
    )
        port map (
      I0 => reg_tx_data(7),
      I1 => \shift_tx[7]_i_5_n_0\,
      I2 => \shift_tx[7]_i_6_n_0\,
      I3 => \shift_tx[7]_i_7_n_0\,
      I4 => in4(7),
      O => \shift_tx[7]_i_2_n_0\
    );
\shift_tx[7]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \state__0\(0),
      I1 => \state__0\(1),
      O => \shift_tx[7]_i_3_n_0\
    );
\shift_tx[7]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4000FFFFFFFFFFFF"
    )
        port map (
      I0 => \state__0\(1),
      I1 => is_read,
      I2 => \state__0\(0),
      I3 => \state__0\(2),
      I4 => \step_reg_n_0_[0]\,
      I5 => \step_reg_n_0_[1]\,
      O => \shift_tx[7]_i_4_n_0\
    );
\shift_tx[7]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AEE8"
    )
        port map (
      I0 => \state__0\(3),
      I1 => \state__0\(2),
      I2 => \state__0\(0),
      I3 => \state__0\(1),
      O => \shift_tx[7]_i_5_n_0\
    );
\shift_tx[7]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AABBBAAAAA888AAA"
    )
        port map (
      I0 => in5(7),
      I1 => \state__0\(3),
      I2 => \state__0\(1),
      I3 => \state__0\(2),
      I4 => \state__0\(0),
      I5 => \reg_ctrl_reg_n_0_[7]\,
      O => \shift_tx[7]_i_6_n_0\
    );
\shift_tx[7]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0D1D"
    )
        port map (
      I0 => \state__0\(0),
      I1 => \state__0\(1),
      I2 => \state__0\(3),
      I3 => \state__0\(2),
      O => \shift_tx[7]_i_7_n_0\
    );
\shift_tx_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_tx[7]_i_1_n_0\,
      D => \shift_tx[0]_i_1_n_0\,
      Q => in5(1),
      R => '0'
    );
\shift_tx_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_tx[7]_i_1_n_0\,
      D => \shift_tx[1]_i_1_n_0\,
      Q => in5(2),
      R => '0'
    );
\shift_tx_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_tx[7]_i_1_n_0\,
      D => \shift_tx[2]_i_1_n_0\,
      Q => in5(3),
      R => '0'
    );
\shift_tx_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_tx[7]_i_1_n_0\,
      D => \shift_tx[3]_i_1_n_0\,
      Q => in5(4),
      R => '0'
    );
\shift_tx_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_tx[7]_i_1_n_0\,
      D => \shift_tx[4]_i_1_n_0\,
      Q => in5(5),
      R => '0'
    );
\shift_tx_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_tx[7]_i_1_n_0\,
      D => \shift_tx[5]_i_1_n_0\,
      Q => in5(6),
      R => '0'
    );
\shift_tx_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_tx[7]_i_1_n_0\,
      D => \shift_tx[6]_i_1_n_0\,
      Q => in5(7),
      R => '0'
    );
\shift_tx_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => PCLK,
      CE => \shift_tx[7]_i_1_n_0\,
      D => \shift_tx[7]_i_2_n_0\,
      Q => p_0_in,
      R => '0'
    );
status_busy_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7F507F7F40504040"
    )
        port map (
      I0 => \state__0\(3),
      I1 => \FSM_sequential_state[3]_i_4_n_0\,
      I2 => start_cmd,
      I3 => status_busy_i_2_n_0,
      I4 => \FSM_sequential_state[3]_i_5_n_0\,
      I5 => status_busy,
      O => status_busy_i_1_n_0
    );
status_busy_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F7FFFFFFFFFFFFFF"
    )
        port map (
      I0 => \state__0\(2),
      I1 => \state__0\(3),
      I2 => \state__0\(1),
      I3 => \state__0\(0),
      I4 => \step_reg_n_0_[1]\,
      I5 => \step_reg_n_0_[0]\,
      O => status_busy_i_2_n_0
    );
status_busy_reg: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => status_busy_i_1_n_0,
      Q => status_busy
    );
\step[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"70770F08"
    )
        port map (
      I0 => \FSM_sequential_state[3]_i_4_n_0\,
      I1 => start_cmd,
      I2 => \step[1]_i_2_n_0\,
      I3 => \FSM_sequential_state[3]_i_5_n_0\,
      I4 => \step_reg_n_0_[0]\,
      O => \step[0]_i_1_n_0\
    );
\step[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3F553F7F00AA0080"
    )
        port map (
      I0 => \step_reg_n_0_[0]\,
      I1 => \FSM_sequential_state[3]_i_4_n_0\,
      I2 => start_cmd,
      I3 => \step[1]_i_2_n_0\,
      I4 => \FSM_sequential_state[3]_i_5_n_0\,
      I5 => \step_reg_n_0_[1]\,
      O => \step[1]_i_1_n_0\
    );
\step[1]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8081"
    )
        port map (
      I0 => \state__0\(1),
      I1 => \state__0\(3),
      I2 => \state__0\(2),
      I3 => \state__0\(0),
      O => \step[1]_i_2_n_0\
    );
\step_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \step[0]_i_1_n_0\,
      Q => \step_reg_n_0_[0]\
    );
\step_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \step[1]_i_1_n_0\,
      Q => \step_reg_n_0_[1]\
    );
tick_cnt0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => tick_cnt0_carry_n_0,
      CO(2) => tick_cnt0_carry_n_1,
      CO(1) => tick_cnt0_carry_n_2,
      CO(0) => tick_cnt0_carry_n_3,
      CYINIT => tick_cnt(0),
      DI(3 downto 0) => tick_cnt(4 downto 1),
      O(3 downto 0) => data0(4 downto 1),
      S(3) => tick_cnt0_carry_i_1_n_0,
      S(2) => tick_cnt0_carry_i_2_n_0,
      S(1) => tick_cnt0_carry_i_3_n_0,
      S(0) => tick_cnt0_carry_i_4_n_0
    );
\tick_cnt0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => tick_cnt0_carry_n_0,
      CO(3) => \tick_cnt0_carry__0_n_0\,
      CO(2) => \tick_cnt0_carry__0_n_1\,
      CO(1) => \tick_cnt0_carry__0_n_2\,
      CO(0) => \tick_cnt0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => tick_cnt(8 downto 5),
      O(3 downto 0) => data0(8 downto 5),
      S(3) => \tick_cnt0_carry__0_i_1_n_0\,
      S(2) => \tick_cnt0_carry__0_i_2_n_0\,
      S(1) => \tick_cnt0_carry__0_i_3_n_0\,
      S(0) => \tick_cnt0_carry__0_i_4_n_0\
    );
\tick_cnt0_carry__0_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(8),
      O => \tick_cnt0_carry__0_i_1_n_0\
    );
\tick_cnt0_carry__0_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(7),
      O => \tick_cnt0_carry__0_i_2_n_0\
    );
\tick_cnt0_carry__0_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(6),
      O => \tick_cnt0_carry__0_i_3_n_0\
    );
\tick_cnt0_carry__0_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(5),
      O => \tick_cnt0_carry__0_i_4_n_0\
    );
\tick_cnt0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \tick_cnt0_carry__0_n_0\,
      CO(3) => \tick_cnt0_carry__1_n_0\,
      CO(2) => \tick_cnt0_carry__1_n_1\,
      CO(1) => \tick_cnt0_carry__1_n_2\,
      CO(0) => \tick_cnt0_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => tick_cnt(12 downto 9),
      O(3 downto 0) => data0(12 downto 9),
      S(3) => \tick_cnt0_carry__1_i_1_n_0\,
      S(2) => \tick_cnt0_carry__1_i_2_n_0\,
      S(1) => \tick_cnt0_carry__1_i_3_n_0\,
      S(0) => \tick_cnt0_carry__1_i_4_n_0\
    );
\tick_cnt0_carry__1_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(12),
      O => \tick_cnt0_carry__1_i_1_n_0\
    );
\tick_cnt0_carry__1_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(11),
      O => \tick_cnt0_carry__1_i_2_n_0\
    );
\tick_cnt0_carry__1_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(10),
      O => \tick_cnt0_carry__1_i_3_n_0\
    );
\tick_cnt0_carry__1_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(9),
      O => \tick_cnt0_carry__1_i_4_n_0\
    );
\tick_cnt0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \tick_cnt0_carry__1_n_0\,
      CO(3 downto 2) => \NLW_tick_cnt0_carry__2_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \tick_cnt0_carry__2_n_2\,
      CO(0) => \tick_cnt0_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1 downto 0) => tick_cnt(14 downto 13),
      O(3) => \NLW_tick_cnt0_carry__2_O_UNCONNECTED\(3),
      O(2 downto 0) => data0(15 downto 13),
      S(3) => '0',
      S(2) => \tick_cnt0_carry__2_i_1_n_0\,
      S(1) => \tick_cnt0_carry__2_i_2_n_0\,
      S(0) => \tick_cnt0_carry__2_i_3_n_0\
    );
\tick_cnt0_carry__2_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(15),
      O => \tick_cnt0_carry__2_i_1_n_0\
    );
\tick_cnt0_carry__2_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(14),
      O => \tick_cnt0_carry__2_i_2_n_0\
    );
\tick_cnt0_carry__2_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(13),
      O => \tick_cnt0_carry__2_i_3_n_0\
    );
tick_cnt0_carry_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(4),
      O => tick_cnt0_carry_i_1_n_0
    );
tick_cnt0_carry_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(3),
      O => tick_cnt0_carry_i_2_n_0
    );
tick_cnt0_carry_i_3: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(2),
      O => tick_cnt0_carry_i_3_n_0
    );
tick_cnt0_carry_i_4: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => tick_cnt(1),
      O => tick_cnt0_carry_i_4_n_0
    );
\tick_cnt[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => status_busy,
      I1 => tick_cnt(0),
      O => \tick_cnt[0]_i_1_n_0\
    );
\tick_cnt[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data0(10),
      I1 => status_busy,
      I2 => \FSM_sequential_state[3]_i_5_n_0\,
      O => \tick_cnt[10]_i_1_n_0\
    );
\tick_cnt[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data0(11),
      I1 => status_busy,
      I2 => \FSM_sequential_state[3]_i_5_n_0\,
      O => \tick_cnt[11]_i_1_n_0\
    );
\tick_cnt[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data0(12),
      I1 => status_busy,
      I2 => \FSM_sequential_state[3]_i_5_n_0\,
      O => \tick_cnt[12]_i_1_n_0\
    );
\tick_cnt[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data0(13),
      I1 => status_busy,
      I2 => \FSM_sequential_state[3]_i_5_n_0\,
      O => \tick_cnt[13]_i_1_n_0\
    );
\tick_cnt[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data0(14),
      I1 => status_busy,
      I2 => \FSM_sequential_state[3]_i_5_n_0\,
      O => \tick_cnt[14]_i_1_n_0\
    );
\tick_cnt[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data0(15),
      I1 => status_busy,
      I2 => \FSM_sequential_state[3]_i_5_n_0\,
      O => \tick_cnt[15]_i_1_n_0\
    );
\tick_cnt[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data0(1),
      I1 => status_busy,
      I2 => \FSM_sequential_state[3]_i_5_n_0\,
      O => \tick_cnt[1]_i_1_n_0\
    );
\tick_cnt[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data0(2),
      I1 => status_busy,
      I2 => \FSM_sequential_state[3]_i_5_n_0\,
      O => \tick_cnt[2]_i_1_n_0\
    );
\tick_cnt[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => status_busy,
      I1 => \FSM_sequential_state[3]_i_5_n_0\,
      I2 => data0(3),
      O => \tick_cnt[3]_i_1_n_0\
    );
\tick_cnt[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => status_busy,
      I1 => \FSM_sequential_state[3]_i_5_n_0\,
      I2 => data0(4),
      O => \tick_cnt[4]_i_1_n_0\
    );
\tick_cnt[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => status_busy,
      I1 => \FSM_sequential_state[3]_i_5_n_0\,
      I2 => data0(5),
      O => \tick_cnt[5]_i_1_n_0\
    );
\tick_cnt[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => status_busy,
      I1 => \FSM_sequential_state[3]_i_5_n_0\,
      I2 => data0(6),
      O => \tick_cnt[6]_i_1_n_0\
    );
\tick_cnt[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => status_busy,
      I1 => \FSM_sequential_state[3]_i_5_n_0\,
      I2 => data0(7),
      O => \tick_cnt[7]_i_1_n_0\
    );
\tick_cnt[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data0(8),
      I1 => status_busy,
      I2 => \FSM_sequential_state[3]_i_5_n_0\,
      O => \tick_cnt[8]_i_1_n_0\
    );
\tick_cnt[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data0(9),
      I1 => status_busy,
      I2 => \FSM_sequential_state[3]_i_5_n_0\,
      O => \tick_cnt[9]_i_1_n_0\
    );
\tick_cnt_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[0]_i_1_n_0\,
      Q => tick_cnt(0)
    );
\tick_cnt_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[10]_i_1_n_0\,
      Q => tick_cnt(10)
    );
\tick_cnt_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[11]_i_1_n_0\,
      Q => tick_cnt(11)
    );
\tick_cnt_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[12]_i_1_n_0\,
      Q => tick_cnt(12)
    );
\tick_cnt_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[13]_i_1_n_0\,
      Q => tick_cnt(13)
    );
\tick_cnt_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[14]_i_1_n_0\,
      Q => tick_cnt(14)
    );
\tick_cnt_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[15]_i_1_n_0\,
      Q => tick_cnt(15)
    );
\tick_cnt_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[1]_i_1_n_0\,
      Q => tick_cnt(1)
    );
\tick_cnt_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[2]_i_1_n_0\,
      Q => tick_cnt(2)
    );
\tick_cnt_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[3]_i_1_n_0\,
      Q => tick_cnt(3)
    );
\tick_cnt_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[4]_i_1_n_0\,
      Q => tick_cnt(4)
    );
\tick_cnt_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[5]_i_1_n_0\,
      Q => tick_cnt(5)
    );
\tick_cnt_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[6]_i_1_n_0\,
      Q => tick_cnt(6)
    );
\tick_cnt_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[7]_i_1_n_0\,
      Q => tick_cnt(7)
    );
\tick_cnt_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[8]_i_1_n_0\,
      Q => tick_cnt(8)
    );
\tick_cnt_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => PCLK,
      CE => '1',
      CLR => \FSM_sequential_state[3]_i_3_n_0\,
      D => \tick_cnt[9]_i_1_n_0\,
      Q => tick_cnt(9)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity Final_Project_apb_i2c_master_0_1 is
  port (
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
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of Final_Project_apb_i2c_master_0_1 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of Final_Project_apb_i2c_master_0_1 : entity is "Final_Project_apb_i2c_master_0_1,apb_i2c_master,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of Final_Project_apb_i2c_master_0_1 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of Final_Project_apb_i2c_master_0_1 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of Final_Project_apb_i2c_master_0_1 : entity is "apb_i2c_master,Vivado 2022.1";
end Final_Project_apb_i2c_master_0_1;

architecture STRUCTURE of Final_Project_apb_i2c_master_0_1 is
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
  signal \PRDATA[31]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \PRDATA[31]_INST_0_i_2_n_0\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of PCLK : signal is "xilinx.com:signal:clock:1.0 PCLK CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of PCLK : signal is "XIL_INTERFACENAME PCLK, ASSOCIATED_RESET PRESETn, ASSOCIATED_BUSIF APB_S, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN Final_Project_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of PENABLE : signal is "xilinx.com:interface:apb:1.0 APB_S PENABLE";
  attribute X_INTERFACE_INFO of PREADY : signal is "xilinx.com:interface:apb:1.0 APB_S PREADY";
  attribute X_INTERFACE_INFO of PRESETn : signal is "xilinx.com:signal:reset:1.0 PRESETn RST";
  attribute X_INTERFACE_PARAMETER of PRESETn : signal is "XIL_INTERFACENAME PRESETn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of PSEL : signal is "xilinx.com:interface:apb:1.0 APB_S PSEL";
  attribute X_INTERFACE_INFO of PSLVERR : signal is "xilinx.com:interface:apb:1.0 APB_S PSLVERR";
  attribute X_INTERFACE_INFO of PWRITE : signal is "xilinx.com:interface:apb:1.0 APB_S PWRITE";
  attribute X_INTERFACE_INFO of PADDR : signal is "xilinx.com:interface:apb:1.0 APB_S PADDR";
  attribute X_INTERFACE_INFO of PRDATA : signal is "xilinx.com:interface:apb:1.0 APB_S PRDATA";
  attribute X_INTERFACE_INFO of PWDATA : signal is "xilinx.com:interface:apb:1.0 APB_S PWDATA";
begin
  PREADY <= \<const1>\;
  PSLVERR <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
\PRDATA[31]_INST_0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => PADDR(0),
      I1 => PADDR(1),
      O => \PRDATA[31]_INST_0_i_1_n_0\
    );
\PRDATA[31]_INST_0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => PADDR(7),
      I1 => PADDR(4),
      I2 => PADDR(6),
      I3 => PADDR(5),
      O => \PRDATA[31]_INST_0_i_2_n_0\
    );
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
inst: entity work.Final_Project_apb_i2c_master_0_1_apb_i2c_master
     port map (
      PADDR(7 downto 0) => PADDR(7 downto 0),
      PCLK => PCLK,
      PENABLE => PENABLE,
      PRDATA(31 downto 0) => PRDATA(31 downto 0),
      \PRDATA[31]_0\ => \PRDATA[31]_INST_0_i_2_n_0\,
      PRDATA_31_sp_1 => \PRDATA[31]_INST_0_i_1_n_0\,
      PRESETn => PRESETn,
      PSEL => PSEL,
      PWDATA(31 downto 0) => PWDATA(31 downto 0),
      PWRITE => PWRITE,
      io_i2c_scl => io_i2c_scl,
      io_i2c_sda => io_i2c_sda
    );
end STRUCTURE;
