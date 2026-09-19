// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri May  8 14:54:34 2026
// Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ week9_apb_led_0_1_sim_netlist.v
// Design      : week9_apb_led_0_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z007sclg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_apb_led
   (LED,
    s_apb_prdata,
    s_apb_pwdata,
    PCLK,
    PRESETn,
    s_apb_psel,
    s_apb_paddr,
    s_apb_pwrite,
    s_apb_penable);
  output [9:0]LED;
  output [9:0]s_apb_prdata;
  input [9:0]s_apb_pwdata;
  input PCLK;
  input PRESETn;
  input [0:0]s_apb_psel;
  input [7:0]s_apb_paddr;
  input s_apb_pwrite;
  input s_apb_penable;

  wire [9:0]LED;
  wire PCLK;
  wire PRESETn;
  wire \reg_led[9]_i_1_n_0 ;
  wire \reg_led[9]_i_2_n_0 ;
  wire [7:0]s_apb_paddr;
  wire s_apb_penable;
  wire [9:0]s_apb_prdata;
  wire \s_apb_prdata[9]_INST_0_i_1_n_0 ;
  wire [0:0]s_apb_psel;
  wire [9:0]s_apb_pwdata;
  wire s_apb_pwrite;

  LUT6 #(
    .INIT(64'h0020000000000000)) 
    \reg_led[9]_i_1 
       (.I0(s_apb_penable),
        .I1(s_apb_paddr[7]),
        .I2(\s_apb_prdata[9]_INST_0_i_1_n_0 ),
        .I3(s_apb_paddr[6]),
        .I4(s_apb_psel),
        .I5(s_apb_pwrite),
        .O(\reg_led[9]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \reg_led[9]_i_2 
       (.I0(PRESETn),
        .O(\reg_led[9]_i_2_n_0 ));
  FDCE \reg_led_reg[0] 
       (.C(PCLK),
        .CE(\reg_led[9]_i_1_n_0 ),
        .CLR(\reg_led[9]_i_2_n_0 ),
        .D(s_apb_pwdata[0]),
        .Q(LED[0]));
  FDCE \reg_led_reg[1] 
       (.C(PCLK),
        .CE(\reg_led[9]_i_1_n_0 ),
        .CLR(\reg_led[9]_i_2_n_0 ),
        .D(s_apb_pwdata[1]),
        .Q(LED[1]));
  FDCE \reg_led_reg[2] 
       (.C(PCLK),
        .CE(\reg_led[9]_i_1_n_0 ),
        .CLR(\reg_led[9]_i_2_n_0 ),
        .D(s_apb_pwdata[2]),
        .Q(LED[2]));
  FDCE \reg_led_reg[3] 
       (.C(PCLK),
        .CE(\reg_led[9]_i_1_n_0 ),
        .CLR(\reg_led[9]_i_2_n_0 ),
        .D(s_apb_pwdata[3]),
        .Q(LED[3]));
  FDCE \reg_led_reg[4] 
       (.C(PCLK),
        .CE(\reg_led[9]_i_1_n_0 ),
        .CLR(\reg_led[9]_i_2_n_0 ),
        .D(s_apb_pwdata[4]),
        .Q(LED[4]));
  FDCE \reg_led_reg[5] 
       (.C(PCLK),
        .CE(\reg_led[9]_i_1_n_0 ),
        .CLR(\reg_led[9]_i_2_n_0 ),
        .D(s_apb_pwdata[5]),
        .Q(LED[5]));
  FDCE \reg_led_reg[6] 
       (.C(PCLK),
        .CE(\reg_led[9]_i_1_n_0 ),
        .CLR(\reg_led[9]_i_2_n_0 ),
        .D(s_apb_pwdata[6]),
        .Q(LED[6]));
  FDCE \reg_led_reg[7] 
       (.C(PCLK),
        .CE(\reg_led[9]_i_1_n_0 ),
        .CLR(\reg_led[9]_i_2_n_0 ),
        .D(s_apb_pwdata[7]),
        .Q(LED[7]));
  FDCE \reg_led_reg[8] 
       (.C(PCLK),
        .CE(\reg_led[9]_i_1_n_0 ),
        .CLR(\reg_led[9]_i_2_n_0 ),
        .D(s_apb_pwdata[8]),
        .Q(LED[8]));
  FDCE \reg_led_reg[9] 
       (.C(PCLK),
        .CE(\reg_led[9]_i_1_n_0 ),
        .CLR(\reg_led[9]_i_2_n_0 ),
        .D(s_apb_pwdata[9]),
        .Q(LED[9]));
  LUT6 #(
    .INIT(64'h0010000000000000)) 
    \s_apb_prdata[0]_INST_0 
       (.I0(s_apb_pwrite),
        .I1(s_apb_paddr[7]),
        .I2(\s_apb_prdata[9]_INST_0_i_1_n_0 ),
        .I3(s_apb_paddr[6]),
        .I4(s_apb_psel),
        .I5(LED[0]),
        .O(s_apb_prdata[0]));
  LUT6 #(
    .INIT(64'h0010000000000000)) 
    \s_apb_prdata[1]_INST_0 
       (.I0(s_apb_pwrite),
        .I1(s_apb_paddr[7]),
        .I2(\s_apb_prdata[9]_INST_0_i_1_n_0 ),
        .I3(s_apb_paddr[6]),
        .I4(s_apb_psel),
        .I5(LED[1]),
        .O(s_apb_prdata[1]));
  LUT6 #(
    .INIT(64'h0010000000000000)) 
    \s_apb_prdata[2]_INST_0 
       (.I0(s_apb_pwrite),
        .I1(s_apb_paddr[7]),
        .I2(\s_apb_prdata[9]_INST_0_i_1_n_0 ),
        .I3(s_apb_paddr[6]),
        .I4(s_apb_psel),
        .I5(LED[2]),
        .O(s_apb_prdata[2]));
  LUT6 #(
    .INIT(64'h0010000000000000)) 
    \s_apb_prdata[3]_INST_0 
       (.I0(s_apb_pwrite),
        .I1(s_apb_paddr[7]),
        .I2(\s_apb_prdata[9]_INST_0_i_1_n_0 ),
        .I3(s_apb_paddr[6]),
        .I4(s_apb_psel),
        .I5(LED[3]),
        .O(s_apb_prdata[3]));
  LUT6 #(
    .INIT(64'h0010000000000000)) 
    \s_apb_prdata[4]_INST_0 
       (.I0(s_apb_pwrite),
        .I1(s_apb_paddr[7]),
        .I2(\s_apb_prdata[9]_INST_0_i_1_n_0 ),
        .I3(s_apb_paddr[6]),
        .I4(s_apb_psel),
        .I5(LED[4]),
        .O(s_apb_prdata[4]));
  LUT6 #(
    .INIT(64'h0010000000000000)) 
    \s_apb_prdata[5]_INST_0 
       (.I0(s_apb_pwrite),
        .I1(s_apb_paddr[7]),
        .I2(\s_apb_prdata[9]_INST_0_i_1_n_0 ),
        .I3(s_apb_paddr[6]),
        .I4(s_apb_psel),
        .I5(LED[5]),
        .O(s_apb_prdata[5]));
  LUT6 #(
    .INIT(64'h0010000000000000)) 
    \s_apb_prdata[6]_INST_0 
       (.I0(s_apb_pwrite),
        .I1(s_apb_paddr[7]),
        .I2(\s_apb_prdata[9]_INST_0_i_1_n_0 ),
        .I3(s_apb_paddr[6]),
        .I4(s_apb_psel),
        .I5(LED[6]),
        .O(s_apb_prdata[6]));
  LUT6 #(
    .INIT(64'h0010000000000000)) 
    \s_apb_prdata[7]_INST_0 
       (.I0(s_apb_pwrite),
        .I1(s_apb_paddr[7]),
        .I2(\s_apb_prdata[9]_INST_0_i_1_n_0 ),
        .I3(s_apb_paddr[6]),
        .I4(s_apb_psel),
        .I5(LED[7]),
        .O(s_apb_prdata[7]));
  LUT6 #(
    .INIT(64'h0000000000002000)) 
    \s_apb_prdata[8]_INST_0 
       (.I0(s_apb_psel),
        .I1(s_apb_paddr[6]),
        .I2(\s_apb_prdata[9]_INST_0_i_1_n_0 ),
        .I3(LED[8]),
        .I4(s_apb_paddr[7]),
        .I5(s_apb_pwrite),
        .O(s_apb_prdata[8]));
  LUT6 #(
    .INIT(64'h0000000000002000)) 
    \s_apb_prdata[9]_INST_0 
       (.I0(s_apb_psel),
        .I1(s_apb_paddr[6]),
        .I2(\s_apb_prdata[9]_INST_0_i_1_n_0 ),
        .I3(LED[9]),
        .I4(s_apb_paddr[7]),
        .I5(s_apb_pwrite),
        .O(s_apb_prdata[9]));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \s_apb_prdata[9]_INST_0_i_1 
       (.I0(s_apb_paddr[3]),
        .I1(s_apb_paddr[1]),
        .I2(s_apb_paddr[0]),
        .I3(s_apb_paddr[2]),
        .I4(s_apb_paddr[5]),
        .I5(s_apb_paddr[4]),
        .O(\s_apb_prdata[9]_INST_0_i_1_n_0 ));
endmodule

(* CHECK_LICENSE_TYPE = "week9_apb_led_0_1,apb_led,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "apb_led,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (PCLK,
    PRESETn,
    s_apb_paddr,
    s_apb_psel,
    s_apb_penable,
    s_apb_pwrite,
    s_apb_pwdata,
    s_apb_prdata,
    s_apb_pready,
    s_apb_pslverr,
    LED);
  input PCLK;
  input PRESETn;
  input [31:0]s_apb_paddr;
  input [0:0]s_apb_psel;
  input s_apb_penable;
  input s_apb_pwrite;
  input [31:0]s_apb_pwdata;
  output [31:0]s_apb_prdata;
  output [0:0]s_apb_pready;
  output [0:0]s_apb_pslverr;
  output [9:0]LED;

  wire \<const0> ;
  wire \<const1> ;
  wire [9:0]LED;
  wire PCLK;
  wire PRESETn;
  wire [31:0]s_apb_paddr;
  wire s_apb_penable;
  wire [9:0]\^s_apb_prdata ;
  wire [0:0]s_apb_psel;
  wire [31:0]s_apb_pwdata;
  wire s_apb_pwrite;

  assign s_apb_prdata[31] = \<const0> ;
  assign s_apb_prdata[30] = \<const0> ;
  assign s_apb_prdata[29] = \<const0> ;
  assign s_apb_prdata[28] = \<const0> ;
  assign s_apb_prdata[27] = \<const0> ;
  assign s_apb_prdata[26] = \<const0> ;
  assign s_apb_prdata[25] = \<const0> ;
  assign s_apb_prdata[24] = \<const0> ;
  assign s_apb_prdata[23] = \<const0> ;
  assign s_apb_prdata[22] = \<const0> ;
  assign s_apb_prdata[21] = \<const0> ;
  assign s_apb_prdata[20] = \<const0> ;
  assign s_apb_prdata[19] = \<const0> ;
  assign s_apb_prdata[18] = \<const0> ;
  assign s_apb_prdata[17] = \<const0> ;
  assign s_apb_prdata[16] = \<const0> ;
  assign s_apb_prdata[15] = \<const0> ;
  assign s_apb_prdata[14] = \<const0> ;
  assign s_apb_prdata[13] = \<const0> ;
  assign s_apb_prdata[12] = \<const0> ;
  assign s_apb_prdata[11] = \<const0> ;
  assign s_apb_prdata[10] = \<const0> ;
  assign s_apb_prdata[9:0] = \^s_apb_prdata [9:0];
  assign s_apb_pready[0] = \<const1> ;
  assign s_apb_pslverr[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_apb_led inst
       (.LED(LED),
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .s_apb_paddr(s_apb_paddr[7:0]),
        .s_apb_penable(s_apb_penable),
        .s_apb_prdata(\^s_apb_prdata ),
        .s_apb_psel(s_apb_psel),
        .s_apb_pwdata(s_apb_pwdata[9:0]),
        .s_apb_pwrite(s_apb_pwrite));
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
