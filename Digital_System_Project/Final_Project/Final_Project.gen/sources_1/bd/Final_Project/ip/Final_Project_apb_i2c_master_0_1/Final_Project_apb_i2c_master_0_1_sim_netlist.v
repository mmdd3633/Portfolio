// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri Jun 12 15:09:28 2026
// Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Tukorea/Digital_System_Project/Final_Project/Final_Project.gen/sources_1/bd/Final_Project/ip/Final_Project_apb_i2c_master_0_1/Final_Project_apb_i2c_master_0_1_sim_netlist.v
// Design      : Final_Project_apb_i2c_master_0_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z007sclg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "Final_Project_apb_i2c_master_0_1,apb_i2c_master,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "apb_i2c_master,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module Final_Project_apb_i2c_master_0_1
   (PCLK,
    PRESETn,
    PSEL,
    PENABLE,
    PWRITE,
    PADDR,
    PWDATA,
    PRDATA,
    PREADY,
    PSLVERR,
    io_i2c_scl,
    io_i2c_sda);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 PCLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME PCLK, ASSOCIATED_RESET PRESETn, ASSOCIATED_BUSIF APB_S, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN Final_Project_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input PCLK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 PRESETn RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME PRESETn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input PRESETn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PSEL" *) input PSEL;
  (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PENABLE" *) input PENABLE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PWRITE" *) input PWRITE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PADDR" *) input [31:0]PADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PWDATA" *) input [31:0]PWDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PRDATA" *) output [31:0]PRDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PREADY" *) output PREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PSLVERR" *) output PSLVERR;
  inout io_i2c_scl;
  inout io_i2c_sda;

  wire \<const0> ;
  wire \<const1> ;
  wire [31:0]PADDR;
  wire PCLK;
  wire PENABLE;
  wire [31:0]PRDATA;
  wire \PRDATA[31]_INST_0_i_1_n_0 ;
  wire \PRDATA[31]_INST_0_i_2_n_0 ;
  wire PRESETn;
  wire PSEL;
  wire [31:0]PWDATA;
  wire PWRITE;
  (* DRIVE = "12" *) (* IBUF_LOW_PWR *) (* SLEW = "SLOW" *) wire io_i2c_scl;
  (* DRIVE = "12" *) (* IBUF_LOW_PWR *) (* SLEW = "SLOW" *) wire io_i2c_sda;

  assign PREADY = \<const1> ;
  assign PSLVERR = \<const0> ;
  GND GND
       (.G(\<const0> ));
  LUT2 #(
    .INIT(4'hE)) 
    \PRDATA[31]_INST_0_i_1 
       (.I0(PADDR[0]),
        .I1(PADDR[1]),
        .O(\PRDATA[31]_INST_0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \PRDATA[31]_INST_0_i_2 
       (.I0(PADDR[7]),
        .I1(PADDR[4]),
        .I2(PADDR[6]),
        .I3(PADDR[5]),
        .O(\PRDATA[31]_INST_0_i_2_n_0 ));
  VCC VCC
       (.P(\<const1> ));
  Final_Project_apb_i2c_master_0_1_apb_i2c_master inst
       (.PADDR(PADDR[7:0]),
        .PCLK(PCLK),
        .PENABLE(PENABLE),
        .PRDATA(PRDATA),
        .\PRDATA[31]_0 (\PRDATA[31]_INST_0_i_2_n_0 ),
        .PRDATA_31_sp_1(\PRDATA[31]_INST_0_i_1_n_0 ),
        .PRESETn(PRESETn),
        .PSEL(PSEL),
        .PWDATA(PWDATA),
        .PWRITE(PWRITE),
        .io_i2c_scl(io_i2c_scl),
        .io_i2c_sda(io_i2c_sda));
endmodule

(* ORIG_REF_NAME = "apb_i2c_master" *) 
module Final_Project_apb_i2c_master_0_1_apb_i2c_master
   (PRDATA,
    io_i2c_scl,
    io_i2c_sda,
    PCLK,
    PRESETn,
    PRDATA_31_sp_1,
    PADDR,
    \PRDATA[31]_0 ,
    PSEL,
    PWRITE,
    PENABLE,
    PWDATA);
  output [31:0]PRDATA;
  inout io_i2c_scl;
  inout io_i2c_sda;
  input PCLK;
  input PRESETn;
  input PRDATA_31_sp_1;
  input [7:0]PADDR;
  input \PRDATA[31]_0 ;
  input PSEL;
  input PWRITE;
  input PENABLE;
  input [31:0]PWDATA;

  wire \FSM_sequential_state[3]_i_10_n_0 ;
  wire \FSM_sequential_state[3]_i_1_n_0 ;
  wire \FSM_sequential_state[3]_i_3_n_0 ;
  wire \FSM_sequential_state[3]_i_4_n_0 ;
  wire \FSM_sequential_state[3]_i_5_n_0 ;
  wire \FSM_sequential_state[3]_i_6_n_0 ;
  wire \FSM_sequential_state[3]_i_7_n_0 ;
  wire \FSM_sequential_state[3]_i_8_n_0 ;
  wire \FSM_sequential_state[3]_i_9_n_0 ;
  wire [7:0]PADDR;
  wire PCLK;
  wire PENABLE;
  wire [31:0]PRDATA;
  wire \PRDATA[0]_INST_0_i_1_n_0 ;
  wire \PRDATA[30]_INST_0_i_1_n_0 ;
  wire \PRDATA[31]_0 ;
  wire PRDATA_31_sn_1;
  wire PRESETn;
  wire PSEL;
  wire [31:0]PWDATA;
  wire PWRITE;
  wire \bit_cnt[0]_i_1_n_0 ;
  wire \bit_cnt[0]_i_2_n_0 ;
  wire \bit_cnt[1]_i_1_n_0 ;
  wire \bit_cnt[1]_i_2_n_0 ;
  wire \bit_cnt[2]_i_1_n_0 ;
  wire \bit_cnt[2]_i_2_n_0 ;
  wire \bit_cnt[2]_i_3_n_0 ;
  wire \bit_cnt[2]_i_4_n_0 ;
  wire \bit_cnt_reg_n_0_[0] ;
  wire \bit_cnt_reg_n_0_[1] ;
  wire \bit_cnt_reg_n_0_[2] ;
  wire [15:1]data0;
  wire [7:1]in4;
  wire [7:1]in5;
  wire io_i2c_scl;
  wire io_i2c_sda;
  wire is_read;
  wire p_0_in;
  wire [3:0]p_0_out;
  wire \reg_ctrl[30]_i_1_n_0 ;
  wire \reg_ctrl[30]_i_2_n_0 ;
  wire \reg_ctrl[30]_i_3_n_0 ;
  wire \reg_ctrl[31]_i_1_n_0 ;
  wire \reg_ctrl_reg_n_0_[0] ;
  wire \reg_ctrl_reg_n_0_[17] ;
  wire \reg_ctrl_reg_n_0_[18] ;
  wire \reg_ctrl_reg_n_0_[19] ;
  wire \reg_ctrl_reg_n_0_[1] ;
  wire \reg_ctrl_reg_n_0_[20] ;
  wire \reg_ctrl_reg_n_0_[21] ;
  wire \reg_ctrl_reg_n_0_[22] ;
  wire \reg_ctrl_reg_n_0_[23] ;
  wire \reg_ctrl_reg_n_0_[24] ;
  wire \reg_ctrl_reg_n_0_[25] ;
  wire \reg_ctrl_reg_n_0_[26] ;
  wire \reg_ctrl_reg_n_0_[27] ;
  wire \reg_ctrl_reg_n_0_[28] ;
  wire \reg_ctrl_reg_n_0_[29] ;
  wire \reg_ctrl_reg_n_0_[2] ;
  wire \reg_ctrl_reg_n_0_[30] ;
  wire \reg_ctrl_reg_n_0_[3] ;
  wire \reg_ctrl_reg_n_0_[4] ;
  wire \reg_ctrl_reg_n_0_[5] ;
  wire \reg_ctrl_reg_n_0_[6] ;
  wire \reg_ctrl_reg_n_0_[7] ;
  wire \reg_ctrl_reg_n_0_[8] ;
  wire [7:0]reg_rx_data;
  wire \reg_rx_data[7]_i_2_n_0 ;
  wire \reg_rx_data[7]_i_3_n_0 ;
  wire \reg_rx_data[7]_i_4_n_0 ;
  wire reg_rx_data_0;
  wire [31:0]reg_tx_data;
  wire reg_tx_data_1;
  wire scl_out;
  wire scl_out_i_1_n_0;
  wire scl_out_i_2_n_0;
  wire scl_out_i_3_n_0;
  wire sda_in;
  wire sda_out;
  wire sda_out_i_1_n_0;
  wire sda_out_i_2_n_0;
  wire sda_out_i_3_n_0;
  wire sda_out_i_4_n_0;
  wire [7:0]shift_rx;
  wire \shift_rx[7]_i_1_n_0 ;
  wire \shift_rx[7]_i_2_n_0 ;
  wire \shift_tx[0]_i_1_n_0 ;
  wire \shift_tx[1]_i_1_n_0 ;
  wire \shift_tx[1]_i_2_n_0 ;
  wire \shift_tx[2]_i_1_n_0 ;
  wire \shift_tx[2]_i_2_n_0 ;
  wire \shift_tx[3]_i_1_n_0 ;
  wire \shift_tx[3]_i_2_n_0 ;
  wire \shift_tx[4]_i_1_n_0 ;
  wire \shift_tx[4]_i_2_n_0 ;
  wire \shift_tx[5]_i_1_n_0 ;
  wire \shift_tx[5]_i_2_n_0 ;
  wire \shift_tx[6]_i_1_n_0 ;
  wire \shift_tx[6]_i_2_n_0 ;
  wire \shift_tx[7]_i_1_n_0 ;
  wire \shift_tx[7]_i_2_n_0 ;
  wire \shift_tx[7]_i_3_n_0 ;
  wire \shift_tx[7]_i_4_n_0 ;
  wire \shift_tx[7]_i_5_n_0 ;
  wire \shift_tx[7]_i_6_n_0 ;
  wire \shift_tx[7]_i_7_n_0 ;
  wire start_cmd;
  wire [3:0]state__0;
  wire status_busy;
  wire status_busy_i_1_n_0;
  wire status_busy_i_2_n_0;
  wire \step[0]_i_1_n_0 ;
  wire \step[1]_i_1_n_0 ;
  wire \step[1]_i_2_n_0 ;
  wire \step_reg_n_0_[0] ;
  wire \step_reg_n_0_[1] ;
  wire [15:0]tick_cnt;
  wire tick_cnt0_carry__0_i_1_n_0;
  wire tick_cnt0_carry__0_i_2_n_0;
  wire tick_cnt0_carry__0_i_3_n_0;
  wire tick_cnt0_carry__0_i_4_n_0;
  wire tick_cnt0_carry__0_n_0;
  wire tick_cnt0_carry__0_n_1;
  wire tick_cnt0_carry__0_n_2;
  wire tick_cnt0_carry__0_n_3;
  wire tick_cnt0_carry__1_i_1_n_0;
  wire tick_cnt0_carry__1_i_2_n_0;
  wire tick_cnt0_carry__1_i_3_n_0;
  wire tick_cnt0_carry__1_i_4_n_0;
  wire tick_cnt0_carry__1_n_0;
  wire tick_cnt0_carry__1_n_1;
  wire tick_cnt0_carry__1_n_2;
  wire tick_cnt0_carry__1_n_3;
  wire tick_cnt0_carry__2_i_1_n_0;
  wire tick_cnt0_carry__2_i_2_n_0;
  wire tick_cnt0_carry__2_i_3_n_0;
  wire tick_cnt0_carry__2_n_2;
  wire tick_cnt0_carry__2_n_3;
  wire tick_cnt0_carry_i_1_n_0;
  wire tick_cnt0_carry_i_2_n_0;
  wire tick_cnt0_carry_i_3_n_0;
  wire tick_cnt0_carry_i_4_n_0;
  wire tick_cnt0_carry_n_0;
  wire tick_cnt0_carry_n_1;
  wire tick_cnt0_carry_n_2;
  wire tick_cnt0_carry_n_3;
  wire \tick_cnt[0]_i_1_n_0 ;
  wire \tick_cnt[10]_i_1_n_0 ;
  wire \tick_cnt[11]_i_1_n_0 ;
  wire \tick_cnt[12]_i_1_n_0 ;
  wire \tick_cnt[13]_i_1_n_0 ;
  wire \tick_cnt[14]_i_1_n_0 ;
  wire \tick_cnt[15]_i_1_n_0 ;
  wire \tick_cnt[1]_i_1_n_0 ;
  wire \tick_cnt[2]_i_1_n_0 ;
  wire \tick_cnt[3]_i_1_n_0 ;
  wire \tick_cnt[4]_i_1_n_0 ;
  wire \tick_cnt[5]_i_1_n_0 ;
  wire \tick_cnt[6]_i_1_n_0 ;
  wire \tick_cnt[7]_i_1_n_0 ;
  wire \tick_cnt[8]_i_1_n_0 ;
  wire \tick_cnt[9]_i_1_n_0 ;
  wire NLW_scl_iobuf_O_UNCONNECTED;
  wire [3:2]NLW_tick_cnt0_carry__2_CO_UNCONNECTED;
  wire [3:3]NLW_tick_cnt0_carry__2_O_UNCONNECTED;

  assign PRDATA_31_sn_1 = PRDATA_31_sp_1;
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h047F)) 
    \FSM_sequential_state[0]_i_1 
       (.I0(state__0[2]),
        .I1(state__0[3]),
        .I2(state__0[1]),
        .I3(state__0[0]),
        .O(p_0_out[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h0030F83C)) 
    \FSM_sequential_state[1]_i_1 
       (.I0(is_read),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(state__0[2]),
        .I4(state__0[3]),
        .O(p_0_out[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h33380CCC)) 
    \FSM_sequential_state[2]_i_1 
       (.I0(is_read),
        .I1(state__0[2]),
        .I2(state__0[3]),
        .I3(state__0[1]),
        .I4(state__0[0]),
        .O(p_0_out[2]));
  LUT6 #(
    .INIT(64'hAAC0AA00AA00AA00)) 
    \FSM_sequential_state[3]_i_1 
       (.I0(start_cmd),
        .I1(\step_reg_n_0_[0] ),
        .I2(\step_reg_n_0_[1] ),
        .I3(\FSM_sequential_state[3]_i_4_n_0 ),
        .I4(\FSM_sequential_state[3]_i_5_n_0 ),
        .I5(\FSM_sequential_state[3]_i_6_n_0 ),
        .O(\FSM_sequential_state[3]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_sequential_state[3]_i_10 
       (.I0(tick_cnt[15]),
        .I1(tick_cnt[12]),
        .I2(tick_cnt[8]),
        .I3(tick_cnt[9]),
        .O(\FSM_sequential_state[3]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h1F801FC0)) 
    \FSM_sequential_state[3]_i_2 
       (.I0(state__0[1]),
        .I1(state__0[0]),
        .I2(state__0[2]),
        .I3(state__0[3]),
        .I4(is_read),
        .O(p_0_out[3]));
  LUT1 #(
    .INIT(2'h1)) 
    \FSM_sequential_state[3]_i_3 
       (.I0(PRESETn),
        .O(\FSM_sequential_state[3]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    \FSM_sequential_state[3]_i_4 
       (.I0(state__0[1]),
        .I1(state__0[0]),
        .I2(state__0[2]),
        .I3(state__0[3]),
        .O(\FSM_sequential_state[3]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h0004)) 
    \FSM_sequential_state[3]_i_5 
       (.I0(\FSM_sequential_state[3]_i_7_n_0 ),
        .I1(\FSM_sequential_state[3]_i_8_n_0 ),
        .I2(\FSM_sequential_state[3]_i_9_n_0 ),
        .I3(\FSM_sequential_state[3]_i_10_n_0 ),
        .O(\FSM_sequential_state[3]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h07FD7DDC)) 
    \FSM_sequential_state[3]_i_6 
       (.I0(\reg_rx_data[7]_i_4_n_0 ),
        .I1(state__0[0]),
        .I2(state__0[3]),
        .I3(state__0[1]),
        .I4(state__0[2]),
        .O(\FSM_sequential_state[3]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_sequential_state[3]_i_7 
       (.I0(tick_cnt[0]),
        .I1(tick_cnt[2]),
        .I2(tick_cnt[7]),
        .I3(tick_cnt[1]),
        .O(\FSM_sequential_state[3]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h0001)) 
    \FSM_sequential_state[3]_i_8 
       (.I0(tick_cnt[14]),
        .I1(tick_cnt[13]),
        .I2(tick_cnt[10]),
        .I3(tick_cnt[3]),
        .O(\FSM_sequential_state[3]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_sequential_state[3]_i_9 
       (.I0(tick_cnt[6]),
        .I1(tick_cnt[5]),
        .I2(tick_cnt[11]),
        .I3(tick_cnt[4]),
        .O(\FSM_sequential_state[3]_i_9_n_0 ));
  (* FSM_ENCODED_STATES = "iSTATE:0011,iSTATE0:0100,iSTATE1:1101,iSTATE2:0010,iSTATE3:1011,iSTATE4:1100,iSTATE5:1010,iSTATE6:0001,iSTATE7:0000,iSTATE8:1001,iSTATE9:0111,iSTATE10:0110,iSTATE11:1000,iSTATE12:0101" *) 
  FDCE \FSM_sequential_state_reg[0] 
       (.C(PCLK),
        .CE(\FSM_sequential_state[3]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(p_0_out[0]),
        .Q(state__0[0]));
  (* FSM_ENCODED_STATES = "iSTATE:0011,iSTATE0:0100,iSTATE1:1101,iSTATE2:0010,iSTATE3:1011,iSTATE4:1100,iSTATE5:1010,iSTATE6:0001,iSTATE7:0000,iSTATE8:1001,iSTATE9:0111,iSTATE10:0110,iSTATE11:1000,iSTATE12:0101" *) 
  FDCE \FSM_sequential_state_reg[1] 
       (.C(PCLK),
        .CE(\FSM_sequential_state[3]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(p_0_out[1]),
        .Q(state__0[1]));
  (* FSM_ENCODED_STATES = "iSTATE:0011,iSTATE0:0100,iSTATE1:1101,iSTATE2:0010,iSTATE3:1011,iSTATE4:1100,iSTATE5:1010,iSTATE6:0001,iSTATE7:0000,iSTATE8:1001,iSTATE9:0111,iSTATE10:0110,iSTATE11:1000,iSTATE12:0101" *) 
  FDCE \FSM_sequential_state_reg[2] 
       (.C(PCLK),
        .CE(\FSM_sequential_state[3]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(p_0_out[2]),
        .Q(state__0[2]));
  (* FSM_ENCODED_STATES = "iSTATE:0011,iSTATE0:0100,iSTATE1:1101,iSTATE2:0010,iSTATE3:1011,iSTATE4:1100,iSTATE5:1010,iSTATE6:0001,iSTATE7:0000,iSTATE8:1001,iSTATE9:0111,iSTATE10:0110,iSTATE11:1000,iSTATE12:0101" *) 
  FDCE \FSM_sequential_state_reg[3] 
       (.C(PCLK),
        .CE(\FSM_sequential_state[3]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(p_0_out[3]),
        .Q(state__0[3]));
  LUT6 #(
    .INIT(64'h00000000E2E200FF)) 
    \PRDATA[0]_INST_0 
       (.I0(status_busy),
        .I1(PADDR[2]),
        .I2(reg_rx_data[0]),
        .I3(\PRDATA[0]_INST_0_i_1_n_0 ),
        .I4(PADDR[3]),
        .I5(\PRDATA[30]_INST_0_i_1_n_0 ),
        .O(PRDATA[0]));
  LUT3 #(
    .INIT(8'h35)) 
    \PRDATA[0]_INST_0_i_1 
       (.I0(\reg_ctrl_reg_n_0_[0] ),
        .I1(reg_tx_data[0]),
        .I2(PADDR[2]),
        .O(\PRDATA[0]_INST_0_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[10]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(in4[2]),
        .I3(PADDR[2]),
        .I4(reg_tx_data[10]),
        .O(PRDATA[10]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[11]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(in4[3]),
        .I3(PADDR[2]),
        .I4(reg_tx_data[11]),
        .O(PRDATA[11]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[12]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(in4[4]),
        .I3(PADDR[2]),
        .I4(reg_tx_data[12]),
        .O(PRDATA[12]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[13]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(in4[5]),
        .I3(PADDR[2]),
        .I4(reg_tx_data[13]),
        .O(PRDATA[13]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[14]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(in4[6]),
        .I3(PADDR[2]),
        .I4(reg_tx_data[14]),
        .O(PRDATA[14]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[15]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(in4[7]),
        .I3(PADDR[2]),
        .I4(reg_tx_data[15]),
        .O(PRDATA[15]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[16]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(is_read),
        .I3(PADDR[2]),
        .I4(reg_tx_data[16]),
        .O(PRDATA[16]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[17]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[17] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[17]),
        .O(PRDATA[17]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[18]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[18] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[18]),
        .O(PRDATA[18]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[19]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[19] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[19]),
        .O(PRDATA[19]));
  LUT6 #(
    .INIT(64'h00000000CCE200E2)) 
    \PRDATA[1]_INST_0 
       (.I0(\reg_ctrl_reg_n_0_[1] ),
        .I1(PADDR[2]),
        .I2(reg_tx_data[1]),
        .I3(PADDR[3]),
        .I4(reg_rx_data[1]),
        .I5(\PRDATA[30]_INST_0_i_1_n_0 ),
        .O(PRDATA[1]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[20]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[20] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[20]),
        .O(PRDATA[20]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[21]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[21] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[21]),
        .O(PRDATA[21]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[22]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[22] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[22]),
        .O(PRDATA[22]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[23]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[23] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[23]),
        .O(PRDATA[23]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[24]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[24] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[24]),
        .O(PRDATA[24]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[25]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[25] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[25]),
        .O(PRDATA[25]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[26]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[26] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[26]),
        .O(PRDATA[26]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[27]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[27] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[27]),
        .O(PRDATA[27]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[28]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[28] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[28]),
        .O(PRDATA[28]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[29]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[29] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[29]),
        .O(PRDATA[29]));
  LUT6 #(
    .INIT(64'h00000000CCE200E2)) 
    \PRDATA[2]_INST_0 
       (.I0(\reg_ctrl_reg_n_0_[2] ),
        .I1(PADDR[2]),
        .I2(reg_tx_data[2]),
        .I3(PADDR[3]),
        .I4(reg_rx_data[2]),
        .I5(\PRDATA[30]_INST_0_i_1_n_0 ),
        .O(PRDATA[2]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[30]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[30] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[30]),
        .O(PRDATA[30]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \PRDATA[30]_INST_0_i_1 
       (.I0(PADDR[5]),
        .I1(PADDR[6]),
        .I2(PADDR[4]),
        .I3(PADDR[7]),
        .I4(PADDR[1]),
        .I5(PADDR[0]),
        .O(\PRDATA[30]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000002320)) 
    \PRDATA[31]_INST_0 
       (.I0(reg_tx_data[31]),
        .I1(PRDATA_31_sn_1),
        .I2(PADDR[2]),
        .I3(start_cmd),
        .I4(PADDR[3]),
        .I5(\PRDATA[31]_0 ),
        .O(PRDATA[31]));
  LUT6 #(
    .INIT(64'h00000000CCE200E2)) 
    \PRDATA[3]_INST_0 
       (.I0(\reg_ctrl_reg_n_0_[3] ),
        .I1(PADDR[2]),
        .I2(reg_tx_data[3]),
        .I3(PADDR[3]),
        .I4(reg_rx_data[3]),
        .I5(\PRDATA[30]_INST_0_i_1_n_0 ),
        .O(PRDATA[3]));
  LUT6 #(
    .INIT(64'h00000000CCE200E2)) 
    \PRDATA[4]_INST_0 
       (.I0(\reg_ctrl_reg_n_0_[4] ),
        .I1(PADDR[2]),
        .I2(reg_tx_data[4]),
        .I3(PADDR[3]),
        .I4(reg_rx_data[4]),
        .I5(\PRDATA[30]_INST_0_i_1_n_0 ),
        .O(PRDATA[4]));
  LUT6 #(
    .INIT(64'h00000000CCE200E2)) 
    \PRDATA[5]_INST_0 
       (.I0(\reg_ctrl_reg_n_0_[5] ),
        .I1(PADDR[2]),
        .I2(reg_tx_data[5]),
        .I3(PADDR[3]),
        .I4(reg_rx_data[5]),
        .I5(\PRDATA[30]_INST_0_i_1_n_0 ),
        .O(PRDATA[5]));
  LUT6 #(
    .INIT(64'h00000000CCE200E2)) 
    \PRDATA[6]_INST_0 
       (.I0(\reg_ctrl_reg_n_0_[6] ),
        .I1(PADDR[2]),
        .I2(reg_tx_data[6]),
        .I3(PADDR[3]),
        .I4(reg_rx_data[6]),
        .I5(\PRDATA[30]_INST_0_i_1_n_0 ),
        .O(PRDATA[6]));
  LUT6 #(
    .INIT(64'h00000000CCE200E2)) 
    \PRDATA[7]_INST_0 
       (.I0(\reg_ctrl_reg_n_0_[7] ),
        .I1(PADDR[2]),
        .I2(reg_tx_data[7]),
        .I3(PADDR[3]),
        .I4(reg_rx_data[7]),
        .I5(\PRDATA[30]_INST_0_i_1_n_0 ),
        .O(PRDATA[7]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[8]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(\reg_ctrl_reg_n_0_[8] ),
        .I3(PADDR[2]),
        .I4(reg_tx_data[8]),
        .O(PRDATA[8]));
  LUT5 #(
    .INIT(32'h11100010)) 
    \PRDATA[9]_INST_0 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(in4[1]),
        .I3(PADDR[2]),
        .I4(reg_tx_data[9]),
        .O(PRDATA[9]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000030)) 
    \bit_cnt[0]_i_1 
       (.I0(\bit_cnt[0]_i_2_n_0 ),
        .I1(\FSM_sequential_state[3]_i_4_n_0 ),
        .I2(\FSM_sequential_state[3]_i_5_n_0 ),
        .I3(\bit_cnt[2]_i_3_n_0 ),
        .I4(\bit_cnt[2]_i_4_n_0 ),
        .I5(\bit_cnt_reg_n_0_[0] ),
        .O(\bit_cnt[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h666A)) 
    \bit_cnt[0]_i_2 
       (.I0(state__0[0]),
        .I1(state__0[1]),
        .I2(state__0[3]),
        .I3(state__0[2]),
        .O(\bit_cnt[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \bit_cnt[1]_i_1 
       (.I0(\bit_cnt[1]_i_2_n_0 ),
        .I1(\FSM_sequential_state[3]_i_4_n_0 ),
        .I2(\FSM_sequential_state[3]_i_5_n_0 ),
        .I3(\bit_cnt[2]_i_3_n_0 ),
        .I4(\bit_cnt[2]_i_4_n_0 ),
        .I5(\bit_cnt_reg_n_0_[1] ),
        .O(\bit_cnt[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF1FE01FE0FFFF)) 
    \bit_cnt[1]_i_2 
       (.I0(state__0[2]),
        .I1(state__0[3]),
        .I2(state__0[1]),
        .I3(state__0[0]),
        .I4(\bit_cnt_reg_n_0_[1] ),
        .I5(\bit_cnt_reg_n_0_[0] ),
        .O(\bit_cnt[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \bit_cnt[2]_i_1 
       (.I0(\bit_cnt[2]_i_2_n_0 ),
        .I1(\FSM_sequential_state[3]_i_4_n_0 ),
        .I2(\FSM_sequential_state[3]_i_5_n_0 ),
        .I3(\bit_cnt[2]_i_3_n_0 ),
        .I4(\bit_cnt[2]_i_4_n_0 ),
        .I5(\bit_cnt_reg_n_0_[2] ),
        .O(\bit_cnt[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hFEAB)) 
    \bit_cnt[2]_i_2 
       (.I0(\bit_cnt[0]_i_2_n_0 ),
        .I1(\bit_cnt_reg_n_0_[0] ),
        .I2(\bit_cnt_reg_n_0_[1] ),
        .I3(\bit_cnt_reg_n_0_[2] ),
        .O(\bit_cnt[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF01FF01FF01FF)) 
    \bit_cnt[2]_i_3 
       (.I0(\reg_rx_data[7]_i_4_n_0 ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\reg_rx_data[7]_i_3_n_0 ),
        .I4(state__0[3]),
        .I5(state__0[2]),
        .O(\bit_cnt[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000AA85AAA5AA85)) 
    \bit_cnt[2]_i_4 
       (.I0(state__0[0]),
        .I1(is_read),
        .I2(state__0[2]),
        .I3(state__0[3]),
        .I4(state__0[1]),
        .I5(\reg_rx_data[7]_i_4_n_0 ),
        .O(\bit_cnt[2]_i_4_n_0 ));
  FDCE \bit_cnt_reg[0] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\bit_cnt[0]_i_1_n_0 ),
        .Q(\bit_cnt_reg_n_0_[0] ));
  FDCE \bit_cnt_reg[1] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\bit_cnt[1]_i_1_n_0 ),
        .Q(\bit_cnt_reg_n_0_[1] ));
  FDCE \bit_cnt_reg[2] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\bit_cnt[2]_i_1_n_0 ),
        .Q(\bit_cnt_reg_n_0_[2] ));
  LUT5 #(
    .INIT(32'h00000008)) 
    \reg_ctrl[30]_i_1 
       (.I0(\reg_ctrl[30]_i_2_n_0 ),
        .I1(\reg_ctrl[30]_i_3_n_0 ),
        .I2(PADDR[2]),
        .I3(PADDR[1]),
        .I4(PADDR[0]),
        .O(\reg_ctrl[30]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \reg_ctrl[30]_i_2 
       (.I0(PADDR[3]),
        .I1(PADDR[5]),
        .I2(PADDR[6]),
        .I3(PADDR[4]),
        .I4(PADDR[7]),
        .O(\reg_ctrl[30]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h80)) 
    \reg_ctrl[30]_i_3 
       (.I0(PSEL),
        .I1(PWRITE),
        .I2(PENABLE),
        .O(\reg_ctrl[30]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h88CF8800)) 
    \reg_ctrl[31]_i_1 
       (.I0(PWDATA[31]),
        .I1(\reg_ctrl[30]_i_3_n_0 ),
        .I2(status_busy),
        .I3(\reg_ctrl[30]_i_1_n_0 ),
        .I4(start_cmd),
        .O(\reg_ctrl[31]_i_1_n_0 ));
  FDCE \reg_ctrl_reg[0] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[0]),
        .Q(\reg_ctrl_reg_n_0_[0] ));
  FDCE \reg_ctrl_reg[10] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[10]),
        .Q(in4[2]));
  FDCE \reg_ctrl_reg[11] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[11]),
        .Q(in4[3]));
  FDCE \reg_ctrl_reg[12] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[12]),
        .Q(in4[4]));
  FDCE \reg_ctrl_reg[13] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[13]),
        .Q(in4[5]));
  FDCE \reg_ctrl_reg[14] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[14]),
        .Q(in4[6]));
  FDCE \reg_ctrl_reg[15] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[15]),
        .Q(in4[7]));
  FDCE \reg_ctrl_reg[16] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[16]),
        .Q(is_read));
  FDCE \reg_ctrl_reg[17] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[17]),
        .Q(\reg_ctrl_reg_n_0_[17] ));
  FDCE \reg_ctrl_reg[18] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[18]),
        .Q(\reg_ctrl_reg_n_0_[18] ));
  FDCE \reg_ctrl_reg[19] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[19]),
        .Q(\reg_ctrl_reg_n_0_[19] ));
  FDCE \reg_ctrl_reg[1] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[1]),
        .Q(\reg_ctrl_reg_n_0_[1] ));
  FDCE \reg_ctrl_reg[20] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[20]),
        .Q(\reg_ctrl_reg_n_0_[20] ));
  FDCE \reg_ctrl_reg[21] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[21]),
        .Q(\reg_ctrl_reg_n_0_[21] ));
  FDCE \reg_ctrl_reg[22] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[22]),
        .Q(\reg_ctrl_reg_n_0_[22] ));
  FDCE \reg_ctrl_reg[23] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[23]),
        .Q(\reg_ctrl_reg_n_0_[23] ));
  FDCE \reg_ctrl_reg[24] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[24]),
        .Q(\reg_ctrl_reg_n_0_[24] ));
  FDCE \reg_ctrl_reg[25] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[25]),
        .Q(\reg_ctrl_reg_n_0_[25] ));
  FDCE \reg_ctrl_reg[26] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[26]),
        .Q(\reg_ctrl_reg_n_0_[26] ));
  FDCE \reg_ctrl_reg[27] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[27]),
        .Q(\reg_ctrl_reg_n_0_[27] ));
  FDCE \reg_ctrl_reg[28] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[28]),
        .Q(\reg_ctrl_reg_n_0_[28] ));
  FDCE \reg_ctrl_reg[29] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[29]),
        .Q(\reg_ctrl_reg_n_0_[29] ));
  FDCE \reg_ctrl_reg[2] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[2]),
        .Q(\reg_ctrl_reg_n_0_[2] ));
  FDCE \reg_ctrl_reg[30] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[30]),
        .Q(\reg_ctrl_reg_n_0_[30] ));
  FDCE \reg_ctrl_reg[31] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\reg_ctrl[31]_i_1_n_0 ),
        .Q(start_cmd));
  FDCE \reg_ctrl_reg[3] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[3]),
        .Q(\reg_ctrl_reg_n_0_[3] ));
  FDCE \reg_ctrl_reg[4] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[4]),
        .Q(\reg_ctrl_reg_n_0_[4] ));
  FDCE \reg_ctrl_reg[5] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[5]),
        .Q(\reg_ctrl_reg_n_0_[5] ));
  FDCE \reg_ctrl_reg[6] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[6]),
        .Q(\reg_ctrl_reg_n_0_[6] ));
  FDCE \reg_ctrl_reg[7] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[7]),
        .Q(\reg_ctrl_reg_n_0_[7] ));
  FDCE \reg_ctrl_reg[8] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[8]),
        .Q(\reg_ctrl_reg_n_0_[8] ));
  FDCE \reg_ctrl_reg[9] 
       (.C(PCLK),
        .CE(\reg_ctrl[30]_i_1_n_0 ),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[9]),
        .Q(in4[1]));
  LUT6 #(
    .INIT(64'h0000000008000000)) 
    \reg_rx_data[7]_i_1 
       (.I0(\FSM_sequential_state[3]_i_5_n_0 ),
        .I1(state__0[0]),
        .I2(state__0[2]),
        .I3(\reg_rx_data[7]_i_2_n_0 ),
        .I4(\reg_rx_data[7]_i_3_n_0 ),
        .I5(\reg_rx_data[7]_i_4_n_0 ),
        .O(reg_rx_data_0));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \reg_rx_data[7]_i_2 
       (.I0(state__0[1]),
        .I1(state__0[3]),
        .O(\reg_rx_data[7]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \reg_rx_data[7]_i_3 
       (.I0(\step_reg_n_0_[1] ),
        .I1(\step_reg_n_0_[0] ),
        .O(\reg_rx_data[7]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \reg_rx_data[7]_i_4 
       (.I0(\bit_cnt_reg_n_0_[2] ),
        .I1(\bit_cnt_reg_n_0_[1] ),
        .I2(\bit_cnt_reg_n_0_[0] ),
        .O(\reg_rx_data[7]_i_4_n_0 ));
  FDCE \reg_rx_data_reg[0] 
       (.C(PCLK),
        .CE(reg_rx_data_0),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(shift_rx[0]),
        .Q(reg_rx_data[0]));
  FDCE \reg_rx_data_reg[1] 
       (.C(PCLK),
        .CE(reg_rx_data_0),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(shift_rx[1]),
        .Q(reg_rx_data[1]));
  FDCE \reg_rx_data_reg[2] 
       (.C(PCLK),
        .CE(reg_rx_data_0),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(shift_rx[2]),
        .Q(reg_rx_data[2]));
  FDCE \reg_rx_data_reg[3] 
       (.C(PCLK),
        .CE(reg_rx_data_0),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(shift_rx[3]),
        .Q(reg_rx_data[3]));
  FDCE \reg_rx_data_reg[4] 
       (.C(PCLK),
        .CE(reg_rx_data_0),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(shift_rx[4]),
        .Q(reg_rx_data[4]));
  FDCE \reg_rx_data_reg[5] 
       (.C(PCLK),
        .CE(reg_rx_data_0),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(shift_rx[5]),
        .Q(reg_rx_data[5]));
  FDCE \reg_rx_data_reg[6] 
       (.C(PCLK),
        .CE(reg_rx_data_0),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(shift_rx[6]),
        .Q(reg_rx_data[6]));
  FDCE \reg_rx_data_reg[7] 
       (.C(PCLK),
        .CE(reg_rx_data_0),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(shift_rx[7]),
        .Q(reg_rx_data[7]));
  LUT6 #(
    .INIT(64'h1000000000000000)) 
    \reg_tx_data[31]_i_1 
       (.I0(PADDR[3]),
        .I1(\PRDATA[30]_INST_0_i_1_n_0 ),
        .I2(PENABLE),
        .I3(PWRITE),
        .I4(PSEL),
        .I5(PADDR[2]),
        .O(reg_tx_data_1));
  FDCE \reg_tx_data_reg[0] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[0]),
        .Q(reg_tx_data[0]));
  FDCE \reg_tx_data_reg[10] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[10]),
        .Q(reg_tx_data[10]));
  FDCE \reg_tx_data_reg[11] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[11]),
        .Q(reg_tx_data[11]));
  FDCE \reg_tx_data_reg[12] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[12]),
        .Q(reg_tx_data[12]));
  FDCE \reg_tx_data_reg[13] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[13]),
        .Q(reg_tx_data[13]));
  FDCE \reg_tx_data_reg[14] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[14]),
        .Q(reg_tx_data[14]));
  FDCE \reg_tx_data_reg[15] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[15]),
        .Q(reg_tx_data[15]));
  FDCE \reg_tx_data_reg[16] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[16]),
        .Q(reg_tx_data[16]));
  FDCE \reg_tx_data_reg[17] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[17]),
        .Q(reg_tx_data[17]));
  FDCE \reg_tx_data_reg[18] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[18]),
        .Q(reg_tx_data[18]));
  FDCE \reg_tx_data_reg[19] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[19]),
        .Q(reg_tx_data[19]));
  FDCE \reg_tx_data_reg[1] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[1]),
        .Q(reg_tx_data[1]));
  FDCE \reg_tx_data_reg[20] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[20]),
        .Q(reg_tx_data[20]));
  FDCE \reg_tx_data_reg[21] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[21]),
        .Q(reg_tx_data[21]));
  FDCE \reg_tx_data_reg[22] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[22]),
        .Q(reg_tx_data[22]));
  FDCE \reg_tx_data_reg[23] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[23]),
        .Q(reg_tx_data[23]));
  FDCE \reg_tx_data_reg[24] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[24]),
        .Q(reg_tx_data[24]));
  FDCE \reg_tx_data_reg[25] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[25]),
        .Q(reg_tx_data[25]));
  FDCE \reg_tx_data_reg[26] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[26]),
        .Q(reg_tx_data[26]));
  FDCE \reg_tx_data_reg[27] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[27]),
        .Q(reg_tx_data[27]));
  FDCE \reg_tx_data_reg[28] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[28]),
        .Q(reg_tx_data[28]));
  FDCE \reg_tx_data_reg[29] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[29]),
        .Q(reg_tx_data[29]));
  FDCE \reg_tx_data_reg[2] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[2]),
        .Q(reg_tx_data[2]));
  FDCE \reg_tx_data_reg[30] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[30]),
        .Q(reg_tx_data[30]));
  FDCE \reg_tx_data_reg[31] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[31]),
        .Q(reg_tx_data[31]));
  FDCE \reg_tx_data_reg[3] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[3]),
        .Q(reg_tx_data[3]));
  FDCE \reg_tx_data_reg[4] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[4]),
        .Q(reg_tx_data[4]));
  FDCE \reg_tx_data_reg[5] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[5]),
        .Q(reg_tx_data[5]));
  FDCE \reg_tx_data_reg[6] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[6]),
        .Q(reg_tx_data[6]));
  FDCE \reg_tx_data_reg[7] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[7]),
        .Q(reg_tx_data[7]));
  FDCE \reg_tx_data_reg[8] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[8]),
        .Q(reg_tx_data[8]));
  FDCE \reg_tx_data_reg[9] 
       (.C(PCLK),
        .CE(reg_tx_data_1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(PWDATA[9]),
        .Q(reg_tx_data[9]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  IOBUF #(
    .IOSTANDARD("DEFAULT")) 
    scl_iobuf
       (.I(1'b0),
        .IO(io_i2c_scl),
        .O(NLW_scl_iobuf_O_UNCONNECTED),
        .T(scl_out));
  LUT5 #(
    .INIT(32'hBABB8A88)) 
    scl_out_i_1
       (.I0(scl_out_i_2_n_0),
        .I1(\FSM_sequential_state[3]_i_4_n_0 ),
        .I2(scl_out_i_3_n_0),
        .I3(\FSM_sequential_state[3]_i_5_n_0 ),
        .I4(scl_out),
        .O(scl_out_i_1_n_0));
  LUT6 #(
    .INIT(64'h08013FFF3FFD0003)) 
    scl_out_i_2
       (.I0(state__0[0]),
        .I1(state__0[2]),
        .I2(state__0[1]),
        .I3(state__0[3]),
        .I4(\step_reg_n_0_[1] ),
        .I5(\step_reg_n_0_[0] ),
        .O(scl_out_i_2_n_0));
  LUT6 #(
    .INIT(64'h8980808081818181)) 
    scl_out_i_3
       (.I0(state__0[2]),
        .I1(state__0[3]),
        .I2(state__0[1]),
        .I3(\step_reg_n_0_[0] ),
        .I4(\step_reg_n_0_[1] ),
        .I5(state__0[0]),
        .O(scl_out_i_3_n_0));
  FDPE scl_out_reg
       (.C(PCLK),
        .CE(1'b1),
        .D(scl_out_i_1_n_0),
        .PRE(\FSM_sequential_state[3]_i_3_n_0 ),
        .Q(scl_out));
  (* BOX_TYPE = "PRIMITIVE" *) 
  IOBUF #(
    .IOSTANDARD("DEFAULT")) 
    sda_iobuf
       (.I(1'b0),
        .IO(io_i2c_sda),
        .O(sda_in),
        .T(sda_out));
  LUT6 #(
    .INIT(64'hEFEEEFEFE0EEE0E0)) 
    sda_out_i_1
       (.I0(sda_out_i_2_n_0),
        .I1(sda_out_i_3_n_0),
        .I2(\FSM_sequential_state[3]_i_4_n_0 ),
        .I3(sda_out_i_4_n_0),
        .I4(\FSM_sequential_state[3]_i_5_n_0 ),
        .I5(sda_out),
        .O(sda_out_i_1_n_0));
  LUT6 #(
    .INIT(64'h0F000000F1FFF100)) 
    sda_out_i_2
       (.I0(\step_reg_n_0_[1] ),
        .I1(\step_reg_n_0_[0] ),
        .I2(state__0[3]),
        .I3(state__0[0]),
        .I4(p_0_in),
        .I5(state__0[2]),
        .O(sda_out_i_2_n_0));
  LUT6 #(
    .INIT(64'h50AA55AA55AA4E55)) 
    sda_out_i_3
       (.I0(state__0[1]),
        .I1(p_0_in),
        .I2(\step_reg_n_0_[1] ),
        .I3(state__0[2]),
        .I4(state__0[3]),
        .I5(state__0[0]),
        .O(sda_out_i_3_n_0));
  LUT6 #(
    .INIT(64'hFFFFBEDFBEDF8081)) 
    sda_out_i_4
       (.I0(state__0[1]),
        .I1(state__0[3]),
        .I2(state__0[2]),
        .I3(state__0[0]),
        .I4(\step_reg_n_0_[0] ),
        .I5(\step_reg_n_0_[1] ),
        .O(sda_out_i_4_n_0));
  FDPE sda_out_reg
       (.C(PCLK),
        .CE(1'b1),
        .D(sda_out_i_1_n_0),
        .PRE(\FSM_sequential_state[3]_i_3_n_0 ),
        .Q(sda_out));
  LUT6 #(
    .INIT(64'h0000000800000000)) 
    \shift_rx[7]_i_1 
       (.I0(\FSM_sequential_state[3]_i_5_n_0 ),
        .I1(\step_reg_n_0_[1] ),
        .I2(\step_reg_n_0_[0] ),
        .I3(\shift_rx[7]_i_2_n_0 ),
        .I4(\FSM_sequential_state[3]_i_4_n_0 ),
        .I5(PRESETn),
        .O(\shift_rx[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hF7FF)) 
    \shift_rx[7]_i_2 
       (.I0(state__0[3]),
        .I1(state__0[1]),
        .I2(state__0[2]),
        .I3(state__0[0]),
        .O(\shift_rx[7]_i_2_n_0 ));
  FDRE \shift_rx_reg[0] 
       (.C(PCLK),
        .CE(\shift_rx[7]_i_1_n_0 ),
        .D(sda_in),
        .Q(shift_rx[0]),
        .R(1'b0));
  FDRE \shift_rx_reg[1] 
       (.C(PCLK),
        .CE(\shift_rx[7]_i_1_n_0 ),
        .D(shift_rx[0]),
        .Q(shift_rx[1]),
        .R(1'b0));
  FDRE \shift_rx_reg[2] 
       (.C(PCLK),
        .CE(\shift_rx[7]_i_1_n_0 ),
        .D(shift_rx[1]),
        .Q(shift_rx[2]),
        .R(1'b0));
  FDRE \shift_rx_reg[3] 
       (.C(PCLK),
        .CE(\shift_rx[7]_i_1_n_0 ),
        .D(shift_rx[2]),
        .Q(shift_rx[3]),
        .R(1'b0));
  FDRE \shift_rx_reg[4] 
       (.C(PCLK),
        .CE(\shift_rx[7]_i_1_n_0 ),
        .D(shift_rx[3]),
        .Q(shift_rx[4]),
        .R(1'b0));
  FDRE \shift_rx_reg[5] 
       (.C(PCLK),
        .CE(\shift_rx[7]_i_1_n_0 ),
        .D(shift_rx[4]),
        .Q(shift_rx[5]),
        .R(1'b0));
  FDRE \shift_rx_reg[6] 
       (.C(PCLK),
        .CE(\shift_rx[7]_i_1_n_0 ),
        .D(shift_rx[5]),
        .Q(shift_rx[6]),
        .R(1'b0));
  FDRE \shift_rx_reg[7] 
       (.C(PCLK),
        .CE(\shift_rx[7]_i_1_n_0 ),
        .D(shift_rx[6]),
        .Q(shift_rx[7]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hAAA83C80AAA83080)) 
    \shift_tx[0]_i_1 
       (.I0(reg_tx_data[0]),
        .I1(state__0[0]),
        .I2(state__0[2]),
        .I3(state__0[1]),
        .I4(state__0[3]),
        .I5(\reg_ctrl_reg_n_0_[0] ),
        .O(\shift_tx[0]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFCBB3088)) 
    \shift_tx[1]_i_1 
       (.I0(reg_tx_data[1]),
        .I1(\shift_tx[7]_i_5_n_0 ),
        .I2(\shift_tx[1]_i_2_n_0 ),
        .I3(\shift_tx[7]_i_7_n_0 ),
        .I4(in4[1]),
        .O(\shift_tx[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAABBBAAAAA888AAA)) 
    \shift_tx[1]_i_2 
       (.I0(in5[1]),
        .I1(state__0[3]),
        .I2(state__0[1]),
        .I3(state__0[2]),
        .I4(state__0[0]),
        .I5(\reg_ctrl_reg_n_0_[1] ),
        .O(\shift_tx[1]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFCBB3088)) 
    \shift_tx[2]_i_1 
       (.I0(reg_tx_data[2]),
        .I1(\shift_tx[7]_i_5_n_0 ),
        .I2(\shift_tx[2]_i_2_n_0 ),
        .I3(\shift_tx[7]_i_7_n_0 ),
        .I4(in4[2]),
        .O(\shift_tx[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAABBBAAAAA888AAA)) 
    \shift_tx[2]_i_2 
       (.I0(in5[2]),
        .I1(state__0[3]),
        .I2(state__0[1]),
        .I3(state__0[2]),
        .I4(state__0[0]),
        .I5(\reg_ctrl_reg_n_0_[2] ),
        .O(\shift_tx[2]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFCBB3088)) 
    \shift_tx[3]_i_1 
       (.I0(reg_tx_data[3]),
        .I1(\shift_tx[7]_i_5_n_0 ),
        .I2(\shift_tx[3]_i_2_n_0 ),
        .I3(\shift_tx[7]_i_7_n_0 ),
        .I4(in4[3]),
        .O(\shift_tx[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAABBBAAAAA888AAA)) 
    \shift_tx[3]_i_2 
       (.I0(in5[3]),
        .I1(state__0[3]),
        .I2(state__0[1]),
        .I3(state__0[2]),
        .I4(state__0[0]),
        .I5(\reg_ctrl_reg_n_0_[3] ),
        .O(\shift_tx[3]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFCBB3088)) 
    \shift_tx[4]_i_1 
       (.I0(reg_tx_data[4]),
        .I1(\shift_tx[7]_i_5_n_0 ),
        .I2(\shift_tx[4]_i_2_n_0 ),
        .I3(\shift_tx[7]_i_7_n_0 ),
        .I4(in4[4]),
        .O(\shift_tx[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAABBBAAAAA888AAA)) 
    \shift_tx[4]_i_2 
       (.I0(in5[4]),
        .I1(state__0[3]),
        .I2(state__0[1]),
        .I3(state__0[2]),
        .I4(state__0[0]),
        .I5(\reg_ctrl_reg_n_0_[4] ),
        .O(\shift_tx[4]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFCBB3088)) 
    \shift_tx[5]_i_1 
       (.I0(reg_tx_data[5]),
        .I1(\shift_tx[7]_i_5_n_0 ),
        .I2(\shift_tx[5]_i_2_n_0 ),
        .I3(\shift_tx[7]_i_7_n_0 ),
        .I4(in4[5]),
        .O(\shift_tx[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAABBBAAAAA888AAA)) 
    \shift_tx[5]_i_2 
       (.I0(in5[5]),
        .I1(state__0[3]),
        .I2(state__0[1]),
        .I3(state__0[2]),
        .I4(state__0[0]),
        .I5(\reg_ctrl_reg_n_0_[5] ),
        .O(\shift_tx[5]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFCBB3088)) 
    \shift_tx[6]_i_1 
       (.I0(reg_tx_data[6]),
        .I1(\shift_tx[7]_i_5_n_0 ),
        .I2(\shift_tx[6]_i_2_n_0 ),
        .I3(\shift_tx[7]_i_7_n_0 ),
        .I4(in4[6]),
        .O(\shift_tx[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAABBBAAAAA888AAA)) 
    \shift_tx[6]_i_2 
       (.I0(in5[6]),
        .I1(state__0[3]),
        .I2(state__0[1]),
        .I3(state__0[2]),
        .I4(state__0[0]),
        .I5(\reg_ctrl_reg_n_0_[6] ),
        .O(\shift_tx[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000808808)) 
    \shift_tx[7]_i_1 
       (.I0(\FSM_sequential_state[3]_i_5_n_0 ),
        .I1(PRESETn),
        .I2(\shift_tx[7]_i_3_n_0 ),
        .I3(state__0[2]),
        .I4(state__0[3]),
        .I5(\shift_tx[7]_i_4_n_0 ),
        .O(\shift_tx[7]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFCBB3088)) 
    \shift_tx[7]_i_2 
       (.I0(reg_tx_data[7]),
        .I1(\shift_tx[7]_i_5_n_0 ),
        .I2(\shift_tx[7]_i_6_n_0 ),
        .I3(\shift_tx[7]_i_7_n_0 ),
        .I4(in4[7]),
        .O(\shift_tx[7]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h1)) 
    \shift_tx[7]_i_3 
       (.I0(state__0[0]),
        .I1(state__0[1]),
        .O(\shift_tx[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h4000FFFFFFFFFFFF)) 
    \shift_tx[7]_i_4 
       (.I0(state__0[1]),
        .I1(is_read),
        .I2(state__0[0]),
        .I3(state__0[2]),
        .I4(\step_reg_n_0_[0] ),
        .I5(\step_reg_n_0_[1] ),
        .O(\shift_tx[7]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'hAEE8)) 
    \shift_tx[7]_i_5 
       (.I0(state__0[3]),
        .I1(state__0[2]),
        .I2(state__0[0]),
        .I3(state__0[1]),
        .O(\shift_tx[7]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAABBBAAAAA888AAA)) 
    \shift_tx[7]_i_6 
       (.I0(in5[7]),
        .I1(state__0[3]),
        .I2(state__0[1]),
        .I3(state__0[2]),
        .I4(state__0[0]),
        .I5(\reg_ctrl_reg_n_0_[7] ),
        .O(\shift_tx[7]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'h0D1D)) 
    \shift_tx[7]_i_7 
       (.I0(state__0[0]),
        .I1(state__0[1]),
        .I2(state__0[3]),
        .I3(state__0[2]),
        .O(\shift_tx[7]_i_7_n_0 ));
  FDRE \shift_tx_reg[0] 
       (.C(PCLK),
        .CE(\shift_tx[7]_i_1_n_0 ),
        .D(\shift_tx[0]_i_1_n_0 ),
        .Q(in5[1]),
        .R(1'b0));
  FDRE \shift_tx_reg[1] 
       (.C(PCLK),
        .CE(\shift_tx[7]_i_1_n_0 ),
        .D(\shift_tx[1]_i_1_n_0 ),
        .Q(in5[2]),
        .R(1'b0));
  FDRE \shift_tx_reg[2] 
       (.C(PCLK),
        .CE(\shift_tx[7]_i_1_n_0 ),
        .D(\shift_tx[2]_i_1_n_0 ),
        .Q(in5[3]),
        .R(1'b0));
  FDRE \shift_tx_reg[3] 
       (.C(PCLK),
        .CE(\shift_tx[7]_i_1_n_0 ),
        .D(\shift_tx[3]_i_1_n_0 ),
        .Q(in5[4]),
        .R(1'b0));
  FDRE \shift_tx_reg[4] 
       (.C(PCLK),
        .CE(\shift_tx[7]_i_1_n_0 ),
        .D(\shift_tx[4]_i_1_n_0 ),
        .Q(in5[5]),
        .R(1'b0));
  FDRE \shift_tx_reg[5] 
       (.C(PCLK),
        .CE(\shift_tx[7]_i_1_n_0 ),
        .D(\shift_tx[5]_i_1_n_0 ),
        .Q(in5[6]),
        .R(1'b0));
  FDRE \shift_tx_reg[6] 
       (.C(PCLK),
        .CE(\shift_tx[7]_i_1_n_0 ),
        .D(\shift_tx[6]_i_1_n_0 ),
        .Q(in5[7]),
        .R(1'b0));
  FDRE \shift_tx_reg[7] 
       (.C(PCLK),
        .CE(\shift_tx[7]_i_1_n_0 ),
        .D(\shift_tx[7]_i_2_n_0 ),
        .Q(p_0_in),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h7F507F7F40504040)) 
    status_busy_i_1
       (.I0(state__0[3]),
        .I1(\FSM_sequential_state[3]_i_4_n_0 ),
        .I2(start_cmd),
        .I3(status_busy_i_2_n_0),
        .I4(\FSM_sequential_state[3]_i_5_n_0 ),
        .I5(status_busy),
        .O(status_busy_i_1_n_0));
  LUT6 #(
    .INIT(64'hF7FFFFFFFFFFFFFF)) 
    status_busy_i_2
       (.I0(state__0[2]),
        .I1(state__0[3]),
        .I2(state__0[1]),
        .I3(state__0[0]),
        .I4(\step_reg_n_0_[1] ),
        .I5(\step_reg_n_0_[0] ),
        .O(status_busy_i_2_n_0));
  FDCE status_busy_reg
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(status_busy_i_1_n_0),
        .Q(status_busy));
  LUT5 #(
    .INIT(32'h70770F08)) 
    \step[0]_i_1 
       (.I0(\FSM_sequential_state[3]_i_4_n_0 ),
        .I1(start_cmd),
        .I2(\step[1]_i_2_n_0 ),
        .I3(\FSM_sequential_state[3]_i_5_n_0 ),
        .I4(\step_reg_n_0_[0] ),
        .O(\step[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h3F553F7F00AA0080)) 
    \step[1]_i_1 
       (.I0(\step_reg_n_0_[0] ),
        .I1(\FSM_sequential_state[3]_i_4_n_0 ),
        .I2(start_cmd),
        .I3(\step[1]_i_2_n_0 ),
        .I4(\FSM_sequential_state[3]_i_5_n_0 ),
        .I5(\step_reg_n_0_[1] ),
        .O(\step[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h8081)) 
    \step[1]_i_2 
       (.I0(state__0[1]),
        .I1(state__0[3]),
        .I2(state__0[2]),
        .I3(state__0[0]),
        .O(\step[1]_i_2_n_0 ));
  FDCE \step_reg[0] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\step[0]_i_1_n_0 ),
        .Q(\step_reg_n_0_[0] ));
  FDCE \step_reg[1] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\step[1]_i_1_n_0 ),
        .Q(\step_reg_n_0_[1] ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 tick_cnt0_carry
       (.CI(1'b0),
        .CO({tick_cnt0_carry_n_0,tick_cnt0_carry_n_1,tick_cnt0_carry_n_2,tick_cnt0_carry_n_3}),
        .CYINIT(tick_cnt[0]),
        .DI(tick_cnt[4:1]),
        .O(data0[4:1]),
        .S({tick_cnt0_carry_i_1_n_0,tick_cnt0_carry_i_2_n_0,tick_cnt0_carry_i_3_n_0,tick_cnt0_carry_i_4_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 tick_cnt0_carry__0
       (.CI(tick_cnt0_carry_n_0),
        .CO({tick_cnt0_carry__0_n_0,tick_cnt0_carry__0_n_1,tick_cnt0_carry__0_n_2,tick_cnt0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI(tick_cnt[8:5]),
        .O(data0[8:5]),
        .S({tick_cnt0_carry__0_i_1_n_0,tick_cnt0_carry__0_i_2_n_0,tick_cnt0_carry__0_i_3_n_0,tick_cnt0_carry__0_i_4_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry__0_i_1
       (.I0(tick_cnt[8]),
        .O(tick_cnt0_carry__0_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry__0_i_2
       (.I0(tick_cnt[7]),
        .O(tick_cnt0_carry__0_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry__0_i_3
       (.I0(tick_cnt[6]),
        .O(tick_cnt0_carry__0_i_3_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry__0_i_4
       (.I0(tick_cnt[5]),
        .O(tick_cnt0_carry__0_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 tick_cnt0_carry__1
       (.CI(tick_cnt0_carry__0_n_0),
        .CO({tick_cnt0_carry__1_n_0,tick_cnt0_carry__1_n_1,tick_cnt0_carry__1_n_2,tick_cnt0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI(tick_cnt[12:9]),
        .O(data0[12:9]),
        .S({tick_cnt0_carry__1_i_1_n_0,tick_cnt0_carry__1_i_2_n_0,tick_cnt0_carry__1_i_3_n_0,tick_cnt0_carry__1_i_4_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry__1_i_1
       (.I0(tick_cnt[12]),
        .O(tick_cnt0_carry__1_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry__1_i_2
       (.I0(tick_cnt[11]),
        .O(tick_cnt0_carry__1_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry__1_i_3
       (.I0(tick_cnt[10]),
        .O(tick_cnt0_carry__1_i_3_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry__1_i_4
       (.I0(tick_cnt[9]),
        .O(tick_cnt0_carry__1_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 tick_cnt0_carry__2
       (.CI(tick_cnt0_carry__1_n_0),
        .CO({NLW_tick_cnt0_carry__2_CO_UNCONNECTED[3:2],tick_cnt0_carry__2_n_2,tick_cnt0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,tick_cnt[14:13]}),
        .O({NLW_tick_cnt0_carry__2_O_UNCONNECTED[3],data0[15:13]}),
        .S({1'b0,tick_cnt0_carry__2_i_1_n_0,tick_cnt0_carry__2_i_2_n_0,tick_cnt0_carry__2_i_3_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry__2_i_1
       (.I0(tick_cnt[15]),
        .O(tick_cnt0_carry__2_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry__2_i_2
       (.I0(tick_cnt[14]),
        .O(tick_cnt0_carry__2_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry__2_i_3
       (.I0(tick_cnt[13]),
        .O(tick_cnt0_carry__2_i_3_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry_i_1
       (.I0(tick_cnt[4]),
        .O(tick_cnt0_carry_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry_i_2
       (.I0(tick_cnt[3]),
        .O(tick_cnt0_carry_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry_i_3
       (.I0(tick_cnt[2]),
        .O(tick_cnt0_carry_i_3_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    tick_cnt0_carry_i_4
       (.I0(tick_cnt[1]),
        .O(tick_cnt0_carry_i_4_n_0));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \tick_cnt[0]_i_1 
       (.I0(status_busy),
        .I1(tick_cnt[0]),
        .O(\tick_cnt[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \tick_cnt[10]_i_1 
       (.I0(data0[10]),
        .I1(status_busy),
        .I2(\FSM_sequential_state[3]_i_5_n_0 ),
        .O(\tick_cnt[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \tick_cnt[11]_i_1 
       (.I0(data0[11]),
        .I1(status_busy),
        .I2(\FSM_sequential_state[3]_i_5_n_0 ),
        .O(\tick_cnt[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \tick_cnt[12]_i_1 
       (.I0(data0[12]),
        .I1(status_busy),
        .I2(\FSM_sequential_state[3]_i_5_n_0 ),
        .O(\tick_cnt[12]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \tick_cnt[13]_i_1 
       (.I0(data0[13]),
        .I1(status_busy),
        .I2(\FSM_sequential_state[3]_i_5_n_0 ),
        .O(\tick_cnt[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \tick_cnt[14]_i_1 
       (.I0(data0[14]),
        .I1(status_busy),
        .I2(\FSM_sequential_state[3]_i_5_n_0 ),
        .O(\tick_cnt[14]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h08)) 
    \tick_cnt[15]_i_1 
       (.I0(data0[15]),
        .I1(status_busy),
        .I2(\FSM_sequential_state[3]_i_5_n_0 ),
        .O(\tick_cnt[15]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \tick_cnt[1]_i_1 
       (.I0(data0[1]),
        .I1(status_busy),
        .I2(\FSM_sequential_state[3]_i_5_n_0 ),
        .O(\tick_cnt[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \tick_cnt[2]_i_1 
       (.I0(data0[2]),
        .I1(status_busy),
        .I2(\FSM_sequential_state[3]_i_5_n_0 ),
        .O(\tick_cnt[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hA8)) 
    \tick_cnt[3]_i_1 
       (.I0(status_busy),
        .I1(\FSM_sequential_state[3]_i_5_n_0 ),
        .I2(data0[3]),
        .O(\tick_cnt[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hA8)) 
    \tick_cnt[4]_i_1 
       (.I0(status_busy),
        .I1(\FSM_sequential_state[3]_i_5_n_0 ),
        .I2(data0[4]),
        .O(\tick_cnt[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hA8)) 
    \tick_cnt[5]_i_1 
       (.I0(status_busy),
        .I1(\FSM_sequential_state[3]_i_5_n_0 ),
        .I2(data0[5]),
        .O(\tick_cnt[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hA8)) 
    \tick_cnt[6]_i_1 
       (.I0(status_busy),
        .I1(\FSM_sequential_state[3]_i_5_n_0 ),
        .I2(data0[6]),
        .O(\tick_cnt[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hA8)) 
    \tick_cnt[7]_i_1 
       (.I0(status_busy),
        .I1(\FSM_sequential_state[3]_i_5_n_0 ),
        .I2(data0[7]),
        .O(\tick_cnt[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \tick_cnt[8]_i_1 
       (.I0(data0[8]),
        .I1(status_busy),
        .I2(\FSM_sequential_state[3]_i_5_n_0 ),
        .O(\tick_cnt[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \tick_cnt[9]_i_1 
       (.I0(data0[9]),
        .I1(status_busy),
        .I2(\FSM_sequential_state[3]_i_5_n_0 ),
        .O(\tick_cnt[9]_i_1_n_0 ));
  FDCE \tick_cnt_reg[0] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[0]_i_1_n_0 ),
        .Q(tick_cnt[0]));
  FDCE \tick_cnt_reg[10] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[10]_i_1_n_0 ),
        .Q(tick_cnt[10]));
  FDCE \tick_cnt_reg[11] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[11]_i_1_n_0 ),
        .Q(tick_cnt[11]));
  FDCE \tick_cnt_reg[12] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[12]_i_1_n_0 ),
        .Q(tick_cnt[12]));
  FDCE \tick_cnt_reg[13] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[13]_i_1_n_0 ),
        .Q(tick_cnt[13]));
  FDCE \tick_cnt_reg[14] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[14]_i_1_n_0 ),
        .Q(tick_cnt[14]));
  FDCE \tick_cnt_reg[15] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[15]_i_1_n_0 ),
        .Q(tick_cnt[15]));
  FDCE \tick_cnt_reg[1] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[1]_i_1_n_0 ),
        .Q(tick_cnt[1]));
  FDCE \tick_cnt_reg[2] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[2]_i_1_n_0 ),
        .Q(tick_cnt[2]));
  FDCE \tick_cnt_reg[3] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[3]_i_1_n_0 ),
        .Q(tick_cnt[3]));
  FDCE \tick_cnt_reg[4] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[4]_i_1_n_0 ),
        .Q(tick_cnt[4]));
  FDCE \tick_cnt_reg[5] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[5]_i_1_n_0 ),
        .Q(tick_cnt[5]));
  FDCE \tick_cnt_reg[6] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[6]_i_1_n_0 ),
        .Q(tick_cnt[6]));
  FDCE \tick_cnt_reg[7] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[7]_i_1_n_0 ),
        .Q(tick_cnt[7]));
  FDCE \tick_cnt_reg[8] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[8]_i_1_n_0 ),
        .Q(tick_cnt[8]));
  FDCE \tick_cnt_reg[9] 
       (.C(PCLK),
        .CE(1'b1),
        .CLR(\FSM_sequential_state[3]_i_3_n_0 ),
        .D(\tick_cnt[9]_i_1_n_0 ),
        .Q(tick_cnt[9]));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
