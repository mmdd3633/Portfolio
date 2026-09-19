// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri Apr 10 14:01:22 2026
// Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ week5_PWM_gen_8bit_0_0_sim_netlist.v
// Design      : week5_PWM_gen_8bit_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z007sclg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_PWM_gen_8bit
   (o_pwm_r,
    o_pwm_g,
    o_pwm_b,
    i_clk,
    i_duty,
    i_rst);
  output o_pwm_r;
  output o_pwm_g;
  output o_pwm_b;
  input i_clk;
  input [23:0]i_duty;
  input i_rst;

  wire \cnt[0]_i_1_n_0 ;
  wire \cnt[7]_i_2_n_0 ;
  wire [7:0]cnt_reg;
  wire i_clk;
  wire [23:0]i_duty;
  wire i_rst;
  wire o_pwm_b;
  wire o_pwm_b0_carry_i_1_n_0;
  wire o_pwm_b0_carry_i_2_n_0;
  wire o_pwm_b0_carry_i_3_n_0;
  wire o_pwm_b0_carry_i_4_n_0;
  wire o_pwm_b0_carry_i_5_n_0;
  wire o_pwm_b0_carry_i_6_n_0;
  wire o_pwm_b0_carry_i_7_n_0;
  wire o_pwm_b0_carry_i_8_n_0;
  wire o_pwm_b0_carry_n_0;
  wire o_pwm_b0_carry_n_1;
  wire o_pwm_b0_carry_n_2;
  wire o_pwm_b0_carry_n_3;
  wire o_pwm_g;
  wire o_pwm_g0_carry_i_1_n_0;
  wire o_pwm_g0_carry_i_2_n_0;
  wire o_pwm_g0_carry_i_3_n_0;
  wire o_pwm_g0_carry_i_4_n_0;
  wire o_pwm_g0_carry_i_5_n_0;
  wire o_pwm_g0_carry_i_6_n_0;
  wire o_pwm_g0_carry_i_7_n_0;
  wire o_pwm_g0_carry_i_8_n_0;
  wire o_pwm_g0_carry_n_0;
  wire o_pwm_g0_carry_n_1;
  wire o_pwm_g0_carry_n_2;
  wire o_pwm_g0_carry_n_3;
  wire o_pwm_r;
  wire o_pwm_r0_carry_i_1_n_0;
  wire o_pwm_r0_carry_i_2_n_0;
  wire o_pwm_r0_carry_i_3_n_0;
  wire o_pwm_r0_carry_i_4_n_0;
  wire o_pwm_r0_carry_i_5_n_0;
  wire o_pwm_r0_carry_i_6_n_0;
  wire o_pwm_r0_carry_i_7_n_0;
  wire o_pwm_r0_carry_i_8_n_0;
  wire o_pwm_r0_carry_n_1;
  wire o_pwm_r0_carry_n_2;
  wire o_pwm_r0_carry_n_3;
  wire o_pwm_r_i_1_n_0;
  wire p_0_in;
  wire [7:1]p_0_in__0;
  wire [3:0]NLW_o_pwm_b0_carry_O_UNCONNECTED;
  wire [3:0]NLW_o_pwm_g0_carry_O_UNCONNECTED;
  wire [3:0]NLW_o_pwm_r0_carry_O_UNCONNECTED;

  LUT1 #(
    .INIT(2'h1)) 
    \cnt[0]_i_1 
       (.I0(cnt_reg[0]),
        .O(\cnt[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[1]_i_1 
       (.I0(cnt_reg[0]),
        .I1(cnt_reg[1]),
        .O(p_0_in__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \cnt[2]_i_1 
       (.I0(cnt_reg[0]),
        .I1(cnt_reg[1]),
        .I2(cnt_reg[2]),
        .O(p_0_in__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \cnt[3]_i_1 
       (.I0(cnt_reg[1]),
        .I1(cnt_reg[0]),
        .I2(cnt_reg[2]),
        .I3(cnt_reg[3]),
        .O(p_0_in__0[3]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \cnt[4]_i_1 
       (.I0(cnt_reg[2]),
        .I1(cnt_reg[0]),
        .I2(cnt_reg[1]),
        .I3(cnt_reg[3]),
        .I4(cnt_reg[4]),
        .O(p_0_in__0[4]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \cnt[5]_i_1 
       (.I0(cnt_reg[3]),
        .I1(cnt_reg[1]),
        .I2(cnt_reg[0]),
        .I3(cnt_reg[2]),
        .I4(cnt_reg[4]),
        .I5(cnt_reg[5]),
        .O(p_0_in__0[5]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[6]_i_1 
       (.I0(\cnt[7]_i_2_n_0 ),
        .I1(cnt_reg[6]),
        .O(p_0_in__0[6]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \cnt[7]_i_1 
       (.I0(\cnt[7]_i_2_n_0 ),
        .I1(cnt_reg[6]),
        .I2(cnt_reg[7]),
        .O(p_0_in__0[7]));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \cnt[7]_i_2 
       (.I0(cnt_reg[5]),
        .I1(cnt_reg[3]),
        .I2(cnt_reg[1]),
        .I3(cnt_reg[0]),
        .I4(cnt_reg[2]),
        .I5(cnt_reg[4]),
        .O(\cnt[7]_i_2_n_0 ));
  FDCE \cnt_reg[0] 
       (.C(i_clk),
        .CE(1'b1),
        .CLR(o_pwm_r_i_1_n_0),
        .D(\cnt[0]_i_1_n_0 ),
        .Q(cnt_reg[0]));
  FDCE \cnt_reg[1] 
       (.C(i_clk),
        .CE(1'b1),
        .CLR(o_pwm_r_i_1_n_0),
        .D(p_0_in__0[1]),
        .Q(cnt_reg[1]));
  FDCE \cnt_reg[2] 
       (.C(i_clk),
        .CE(1'b1),
        .CLR(o_pwm_r_i_1_n_0),
        .D(p_0_in__0[2]),
        .Q(cnt_reg[2]));
  FDCE \cnt_reg[3] 
       (.C(i_clk),
        .CE(1'b1),
        .CLR(o_pwm_r_i_1_n_0),
        .D(p_0_in__0[3]),
        .Q(cnt_reg[3]));
  FDCE \cnt_reg[4] 
       (.C(i_clk),
        .CE(1'b1),
        .CLR(o_pwm_r_i_1_n_0),
        .D(p_0_in__0[4]),
        .Q(cnt_reg[4]));
  FDCE \cnt_reg[5] 
       (.C(i_clk),
        .CE(1'b1),
        .CLR(o_pwm_r_i_1_n_0),
        .D(p_0_in__0[5]),
        .Q(cnt_reg[5]));
  FDCE \cnt_reg[6] 
       (.C(i_clk),
        .CE(1'b1),
        .CLR(o_pwm_r_i_1_n_0),
        .D(p_0_in__0[6]),
        .Q(cnt_reg[6]));
  FDCE \cnt_reg[7] 
       (.C(i_clk),
        .CE(1'b1),
        .CLR(o_pwm_r_i_1_n_0),
        .D(p_0_in__0[7]),
        .Q(cnt_reg[7]));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 o_pwm_b0_carry
       (.CI(1'b0),
        .CO({o_pwm_b0_carry_n_0,o_pwm_b0_carry_n_1,o_pwm_b0_carry_n_2,o_pwm_b0_carry_n_3}),
        .CYINIT(1'b0),
        .DI({o_pwm_b0_carry_i_1_n_0,o_pwm_b0_carry_i_2_n_0,o_pwm_b0_carry_i_3_n_0,o_pwm_b0_carry_i_4_n_0}),
        .O(NLW_o_pwm_b0_carry_O_UNCONNECTED[3:0]),
        .S({o_pwm_b0_carry_i_5_n_0,o_pwm_b0_carry_i_6_n_0,o_pwm_b0_carry_i_7_n_0,o_pwm_b0_carry_i_8_n_0}));
  LUT4 #(
    .INIT(16'h2F02)) 
    o_pwm_b0_carry_i_1
       (.I0(i_duty[6]),
        .I1(cnt_reg[6]),
        .I2(cnt_reg[7]),
        .I3(i_duty[7]),
        .O(o_pwm_b0_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    o_pwm_b0_carry_i_2
       (.I0(i_duty[4]),
        .I1(cnt_reg[4]),
        .I2(cnt_reg[5]),
        .I3(i_duty[5]),
        .O(o_pwm_b0_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    o_pwm_b0_carry_i_3
       (.I0(i_duty[2]),
        .I1(cnt_reg[2]),
        .I2(cnt_reg[3]),
        .I3(i_duty[3]),
        .O(o_pwm_b0_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    o_pwm_b0_carry_i_4
       (.I0(i_duty[0]),
        .I1(cnt_reg[0]),
        .I2(cnt_reg[1]),
        .I3(i_duty[1]),
        .O(o_pwm_b0_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    o_pwm_b0_carry_i_5
       (.I0(i_duty[6]),
        .I1(cnt_reg[6]),
        .I2(i_duty[7]),
        .I3(cnt_reg[7]),
        .O(o_pwm_b0_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    o_pwm_b0_carry_i_6
       (.I0(i_duty[4]),
        .I1(cnt_reg[4]),
        .I2(i_duty[5]),
        .I3(cnt_reg[5]),
        .O(o_pwm_b0_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    o_pwm_b0_carry_i_7
       (.I0(i_duty[2]),
        .I1(cnt_reg[2]),
        .I2(i_duty[3]),
        .I3(cnt_reg[3]),
        .O(o_pwm_b0_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    o_pwm_b0_carry_i_8
       (.I0(i_duty[0]),
        .I1(cnt_reg[0]),
        .I2(i_duty[1]),
        .I3(cnt_reg[1]),
        .O(o_pwm_b0_carry_i_8_n_0));
  FDCE o_pwm_b_reg
       (.C(i_clk),
        .CE(1'b1),
        .CLR(o_pwm_r_i_1_n_0),
        .D(o_pwm_b0_carry_n_0),
        .Q(o_pwm_b));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 o_pwm_g0_carry
       (.CI(1'b0),
        .CO({o_pwm_g0_carry_n_0,o_pwm_g0_carry_n_1,o_pwm_g0_carry_n_2,o_pwm_g0_carry_n_3}),
        .CYINIT(1'b0),
        .DI({o_pwm_g0_carry_i_1_n_0,o_pwm_g0_carry_i_2_n_0,o_pwm_g0_carry_i_3_n_0,o_pwm_g0_carry_i_4_n_0}),
        .O(NLW_o_pwm_g0_carry_O_UNCONNECTED[3:0]),
        .S({o_pwm_g0_carry_i_5_n_0,o_pwm_g0_carry_i_6_n_0,o_pwm_g0_carry_i_7_n_0,o_pwm_g0_carry_i_8_n_0}));
  LUT4 #(
    .INIT(16'h2F02)) 
    o_pwm_g0_carry_i_1
       (.I0(i_duty[14]),
        .I1(cnt_reg[6]),
        .I2(cnt_reg[7]),
        .I3(i_duty[15]),
        .O(o_pwm_g0_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    o_pwm_g0_carry_i_2
       (.I0(i_duty[12]),
        .I1(cnt_reg[4]),
        .I2(cnt_reg[5]),
        .I3(i_duty[13]),
        .O(o_pwm_g0_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    o_pwm_g0_carry_i_3
       (.I0(i_duty[10]),
        .I1(cnt_reg[2]),
        .I2(cnt_reg[3]),
        .I3(i_duty[11]),
        .O(o_pwm_g0_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    o_pwm_g0_carry_i_4
       (.I0(i_duty[8]),
        .I1(cnt_reg[0]),
        .I2(cnt_reg[1]),
        .I3(i_duty[9]),
        .O(o_pwm_g0_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    o_pwm_g0_carry_i_5
       (.I0(i_duty[14]),
        .I1(cnt_reg[6]),
        .I2(i_duty[15]),
        .I3(cnt_reg[7]),
        .O(o_pwm_g0_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    o_pwm_g0_carry_i_6
       (.I0(i_duty[12]),
        .I1(cnt_reg[4]),
        .I2(i_duty[13]),
        .I3(cnt_reg[5]),
        .O(o_pwm_g0_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    o_pwm_g0_carry_i_7
       (.I0(i_duty[10]),
        .I1(cnt_reg[2]),
        .I2(i_duty[11]),
        .I3(cnt_reg[3]),
        .O(o_pwm_g0_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    o_pwm_g0_carry_i_8
       (.I0(i_duty[8]),
        .I1(cnt_reg[0]),
        .I2(i_duty[9]),
        .I3(cnt_reg[1]),
        .O(o_pwm_g0_carry_i_8_n_0));
  FDCE o_pwm_g_reg
       (.C(i_clk),
        .CE(1'b1),
        .CLR(o_pwm_r_i_1_n_0),
        .D(o_pwm_g0_carry_n_0),
        .Q(o_pwm_g));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 o_pwm_r0_carry
       (.CI(1'b0),
        .CO({p_0_in,o_pwm_r0_carry_n_1,o_pwm_r0_carry_n_2,o_pwm_r0_carry_n_3}),
        .CYINIT(1'b0),
        .DI({o_pwm_r0_carry_i_1_n_0,o_pwm_r0_carry_i_2_n_0,o_pwm_r0_carry_i_3_n_0,o_pwm_r0_carry_i_4_n_0}),
        .O(NLW_o_pwm_r0_carry_O_UNCONNECTED[3:0]),
        .S({o_pwm_r0_carry_i_5_n_0,o_pwm_r0_carry_i_6_n_0,o_pwm_r0_carry_i_7_n_0,o_pwm_r0_carry_i_8_n_0}));
  LUT4 #(
    .INIT(16'h2F02)) 
    o_pwm_r0_carry_i_1
       (.I0(i_duty[22]),
        .I1(cnt_reg[6]),
        .I2(cnt_reg[7]),
        .I3(i_duty[23]),
        .O(o_pwm_r0_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    o_pwm_r0_carry_i_2
       (.I0(i_duty[20]),
        .I1(cnt_reg[4]),
        .I2(cnt_reg[5]),
        .I3(i_duty[21]),
        .O(o_pwm_r0_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    o_pwm_r0_carry_i_3
       (.I0(i_duty[18]),
        .I1(cnt_reg[2]),
        .I2(cnt_reg[3]),
        .I3(i_duty[19]),
        .O(o_pwm_r0_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    o_pwm_r0_carry_i_4
       (.I0(i_duty[16]),
        .I1(cnt_reg[0]),
        .I2(cnt_reg[1]),
        .I3(i_duty[17]),
        .O(o_pwm_r0_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    o_pwm_r0_carry_i_5
       (.I0(i_duty[22]),
        .I1(cnt_reg[6]),
        .I2(i_duty[23]),
        .I3(cnt_reg[7]),
        .O(o_pwm_r0_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    o_pwm_r0_carry_i_6
       (.I0(i_duty[20]),
        .I1(cnt_reg[4]),
        .I2(i_duty[21]),
        .I3(cnt_reg[5]),
        .O(o_pwm_r0_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    o_pwm_r0_carry_i_7
       (.I0(i_duty[18]),
        .I1(cnt_reg[2]),
        .I2(i_duty[19]),
        .I3(cnt_reg[3]),
        .O(o_pwm_r0_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    o_pwm_r0_carry_i_8
       (.I0(i_duty[16]),
        .I1(cnt_reg[0]),
        .I2(i_duty[17]),
        .I3(cnt_reg[1]),
        .O(o_pwm_r0_carry_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    o_pwm_r_i_1
       (.I0(i_rst),
        .O(o_pwm_r_i_1_n_0));
  FDCE o_pwm_r_reg
       (.C(i_clk),
        .CE(1'b1),
        .CLR(o_pwm_r_i_1_n_0),
        .D(p_0_in),
        .Q(o_pwm_r));
endmodule

(* CHECK_LICENSE_TYPE = "week5_PWM_gen_8bit_0_0,PWM_gen_8bit,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "PWM_gen_8bit,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (i_clk,
    i_rst,
    i_duty,
    o_pwm_r,
    o_pwm_g,
    o_pwm_b);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 i_clk CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME i_clk, ASSOCIATED_RESET i_rst, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN week5_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input i_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 i_rst RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME i_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input i_rst;
  input [23:0]i_duty;
  output o_pwm_r;
  output o_pwm_g;
  output o_pwm_b;

  wire i_clk;
  wire [23:0]i_duty;
  wire i_rst;
  wire o_pwm_b;
  wire o_pwm_g;
  wire o_pwm_r;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_PWM_gen_8bit inst
       (.i_clk(i_clk),
        .i_duty(i_duty),
        .i_rst(i_rst),
        .o_pwm_b(o_pwm_b),
        .o_pwm_g(o_pwm_g),
        .o_pwm_r(o_pwm_r));
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
