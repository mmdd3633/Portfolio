// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri May  8 15:02:06 2026
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
   (o_led,
    o_apb_prdata,
    i_apb_pwdata,
    i_clk,
    i_apb_penable,
    i_apb_pwrite,
    i_apb_paddr,
    i_apb_psel,
    i_rst_n);
  output [9:0]o_led;
  output [9:0]o_apb_prdata;
  input [9:0]i_apb_pwdata;
  input i_clk;
  input i_apb_penable;
  input i_apb_pwrite;
  input [31:0]i_apb_paddr;
  input i_apb_psel;
  input i_rst_n;

  wire [31:0]i_apb_paddr;
  wire i_apb_penable;
  wire i_apb_psel;
  wire [9:0]i_apb_pwdata;
  wire i_apb_pwrite;
  wire i_clk;
  wire i_rst_n;
  wire \led_reg[9]_i_1_n_0 ;
  wire [9:0]o_apb_prdata;
  wire \o_apb_prdata[9]_i_10_n_0 ;
  wire \o_apb_prdata[9]_i_1_n_0 ;
  wire \o_apb_prdata[9]_i_2_n_0 ;
  wire \o_apb_prdata[9]_i_3_n_0 ;
  wire \o_apb_prdata[9]_i_4_n_0 ;
  wire \o_apb_prdata[9]_i_5_n_0 ;
  wire \o_apb_prdata[9]_i_6_n_0 ;
  wire \o_apb_prdata[9]_i_7_n_0 ;
  wire \o_apb_prdata[9]_i_8_n_0 ;
  wire \o_apb_prdata[9]_i_9_n_0 ;
  wire [9:0]o_led;

  LUT6 #(
    .INIT(64'h0100000000000000)) 
    \led_reg[9]_i_1 
       (.I0(\o_apb_prdata[9]_i_3_n_0 ),
        .I1(\o_apb_prdata[9]_i_4_n_0 ),
        .I2(\o_apb_prdata[9]_i_5_n_0 ),
        .I3(\o_apb_prdata[9]_i_6_n_0 ),
        .I4(i_apb_penable),
        .I5(i_apb_pwrite),
        .O(\led_reg[9]_i_1_n_0 ));
  FDCE \led_reg_reg[0] 
       (.C(i_clk),
        .CE(\led_reg[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(i_apb_pwdata[0]),
        .Q(o_led[0]));
  FDCE \led_reg_reg[1] 
       (.C(i_clk),
        .CE(\led_reg[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(i_apb_pwdata[1]),
        .Q(o_led[1]));
  FDCE \led_reg_reg[2] 
       (.C(i_clk),
        .CE(\led_reg[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(i_apb_pwdata[2]),
        .Q(o_led[2]));
  FDCE \led_reg_reg[3] 
       (.C(i_clk),
        .CE(\led_reg[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(i_apb_pwdata[3]),
        .Q(o_led[3]));
  FDCE \led_reg_reg[4] 
       (.C(i_clk),
        .CE(\led_reg[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(i_apb_pwdata[4]),
        .Q(o_led[4]));
  FDCE \led_reg_reg[5] 
       (.C(i_clk),
        .CE(\led_reg[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(i_apb_pwdata[5]),
        .Q(o_led[5]));
  FDCE \led_reg_reg[6] 
       (.C(i_clk),
        .CE(\led_reg[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(i_apb_pwdata[6]),
        .Q(o_led[6]));
  FDCE \led_reg_reg[7] 
       (.C(i_clk),
        .CE(\led_reg[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(i_apb_pwdata[7]),
        .Q(o_led[7]));
  FDCE \led_reg_reg[8] 
       (.C(i_clk),
        .CE(\led_reg[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(i_apb_pwdata[8]),
        .Q(o_led[8]));
  FDCE \led_reg_reg[9] 
       (.C(i_clk),
        .CE(\led_reg[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(i_apb_pwdata[9]),
        .Q(o_led[9]));
  LUT5 #(
    .INIT(32'h00000100)) 
    \o_apb_prdata[9]_i_1 
       (.I0(\o_apb_prdata[9]_i_3_n_0 ),
        .I1(\o_apb_prdata[9]_i_4_n_0 ),
        .I2(\o_apb_prdata[9]_i_5_n_0 ),
        .I3(\o_apb_prdata[9]_i_6_n_0 ),
        .I4(i_apb_pwrite),
        .O(\o_apb_prdata[9]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \o_apb_prdata[9]_i_10 
       (.I0(i_apb_paddr[7]),
        .I1(i_apb_paddr[1]),
        .I2(i_apb_paddr[9]),
        .I3(i_apb_paddr[4]),
        .O(\o_apb_prdata[9]_i_10_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \o_apb_prdata[9]_i_2 
       (.I0(i_rst_n),
        .O(\o_apb_prdata[9]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFEFFF)) 
    \o_apb_prdata[9]_i_3 
       (.I0(i_apb_paddr[21]),
        .I1(i_apb_paddr[2]),
        .I2(i_apb_paddr[23]),
        .I3(i_apb_paddr[22]),
        .I4(i_apb_paddr[12]),
        .I5(i_apb_paddr[20]),
        .O(\o_apb_prdata[9]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFBFF)) 
    \o_apb_prdata[9]_i_4 
       (.I0(i_apb_paddr[19]),
        .I1(i_apb_paddr[30]),
        .I2(i_apb_paddr[28]),
        .I3(i_apb_psel),
        .I4(\o_apb_prdata[9]_i_7_n_0 ),
        .O(\o_apb_prdata[9]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFEFF)) 
    \o_apb_prdata[9]_i_5 
       (.I0(i_apb_paddr[10]),
        .I1(i_apb_paddr[14]),
        .I2(i_apb_paddr[16]),
        .I3(i_apb_paddr[24]),
        .I4(\o_apb_prdata[9]_i_8_n_0 ),
        .O(\o_apb_prdata[9]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \o_apb_prdata[9]_i_6 
       (.I0(i_apb_paddr[6]),
        .I1(i_apb_paddr[31]),
        .I2(i_apb_paddr[8]),
        .I3(\o_apb_prdata[9]_i_9_n_0 ),
        .I4(\o_apb_prdata[9]_i_10_n_0 ),
        .O(\o_apb_prdata[9]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFFEF)) 
    \o_apb_prdata[9]_i_7 
       (.I0(i_apb_paddr[27]),
        .I1(i_apb_paddr[26]),
        .I2(i_apb_paddr[25]),
        .I3(i_apb_paddr[3]),
        .O(\o_apb_prdata[9]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \o_apb_prdata[9]_i_8 
       (.I0(i_apb_paddr[15]),
        .I1(i_apb_paddr[11]),
        .I2(i_apb_paddr[18]),
        .I3(i_apb_paddr[17]),
        .O(\o_apb_prdata[9]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \o_apb_prdata[9]_i_9 
       (.I0(i_apb_paddr[29]),
        .I1(i_apb_paddr[0]),
        .I2(i_apb_paddr[13]),
        .I3(i_apb_paddr[5]),
        .O(\o_apb_prdata[9]_i_9_n_0 ));
  FDCE \o_apb_prdata_reg[0] 
       (.C(i_clk),
        .CE(\o_apb_prdata[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(o_led[0]),
        .Q(o_apb_prdata[0]));
  FDCE \o_apb_prdata_reg[1] 
       (.C(i_clk),
        .CE(\o_apb_prdata[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(o_led[1]),
        .Q(o_apb_prdata[1]));
  FDCE \o_apb_prdata_reg[2] 
       (.C(i_clk),
        .CE(\o_apb_prdata[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(o_led[2]),
        .Q(o_apb_prdata[2]));
  FDCE \o_apb_prdata_reg[3] 
       (.C(i_clk),
        .CE(\o_apb_prdata[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(o_led[3]),
        .Q(o_apb_prdata[3]));
  FDCE \o_apb_prdata_reg[4] 
       (.C(i_clk),
        .CE(\o_apb_prdata[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(o_led[4]),
        .Q(o_apb_prdata[4]));
  FDCE \o_apb_prdata_reg[5] 
       (.C(i_clk),
        .CE(\o_apb_prdata[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(o_led[5]),
        .Q(o_apb_prdata[5]));
  FDCE \o_apb_prdata_reg[6] 
       (.C(i_clk),
        .CE(\o_apb_prdata[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(o_led[6]),
        .Q(o_apb_prdata[6]));
  FDCE \o_apb_prdata_reg[7] 
       (.C(i_clk),
        .CE(\o_apb_prdata[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(o_led[7]),
        .Q(o_apb_prdata[7]));
  FDCE \o_apb_prdata_reg[8] 
       (.C(i_clk),
        .CE(\o_apb_prdata[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(o_led[8]),
        .Q(o_apb_prdata[8]));
  FDCE \o_apb_prdata_reg[9] 
       (.C(i_clk),
        .CE(\o_apb_prdata[9]_i_1_n_0 ),
        .CLR(\o_apb_prdata[9]_i_2_n_0 ),
        .D(o_led[9]),
        .Q(o_apb_prdata[9]));
endmodule

(* CHECK_LICENSE_TYPE = "week9_apb_led_0_1,apb_led,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "apb_led,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (i_clk,
    i_rst_n,
    i_apb_paddr,
    i_apb_penable,
    i_apb_psel,
    i_apb_pwrite,
    i_apb_pwdata,
    o_apb_prdata,
    o_apb_pready,
    o_apb_pslverr,
    o_led);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 i_clk CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME i_clk, ASSOCIATED_RESET i_rst_n, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN week9_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input i_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 i_rst_n RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME i_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input i_rst_n;
  input [31:0]i_apb_paddr;
  input i_apb_penable;
  input i_apb_psel;
  input i_apb_pwrite;
  input [31:0]i_apb_pwdata;
  output [31:0]o_apb_prdata;
  output o_apb_pready;
  output o_apb_pslverr;
  output [9:0]o_led;

  wire \<const0> ;
  wire \<const1> ;
  wire [31:0]i_apb_paddr;
  wire i_apb_penable;
  wire i_apb_psel;
  wire [31:0]i_apb_pwdata;
  wire i_apb_pwrite;
  wire i_clk;
  wire i_rst_n;
  wire [9:0]\^o_apb_prdata ;
  wire [9:0]o_led;

  assign o_apb_prdata[31] = \<const0> ;
  assign o_apb_prdata[30] = \<const0> ;
  assign o_apb_prdata[29] = \<const0> ;
  assign o_apb_prdata[28] = \<const0> ;
  assign o_apb_prdata[27] = \<const0> ;
  assign o_apb_prdata[26] = \<const0> ;
  assign o_apb_prdata[25] = \<const0> ;
  assign o_apb_prdata[24] = \<const0> ;
  assign o_apb_prdata[23] = \<const0> ;
  assign o_apb_prdata[22] = \<const0> ;
  assign o_apb_prdata[21] = \<const0> ;
  assign o_apb_prdata[20] = \<const0> ;
  assign o_apb_prdata[19] = \<const0> ;
  assign o_apb_prdata[18] = \<const0> ;
  assign o_apb_prdata[17] = \<const0> ;
  assign o_apb_prdata[16] = \<const0> ;
  assign o_apb_prdata[15] = \<const0> ;
  assign o_apb_prdata[14] = \<const0> ;
  assign o_apb_prdata[13] = \<const0> ;
  assign o_apb_prdata[12] = \<const0> ;
  assign o_apb_prdata[11] = \<const0> ;
  assign o_apb_prdata[10] = \<const0> ;
  assign o_apb_prdata[9:0] = \^o_apb_prdata [9:0];
  assign o_apb_pready = \<const1> ;
  assign o_apb_pslverr = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_apb_led inst
       (.i_apb_paddr(i_apb_paddr),
        .i_apb_penable(i_apb_penable),
        .i_apb_psel(i_apb_psel),
        .i_apb_pwdata(i_apb_pwdata[9:0]),
        .i_apb_pwrite(i_apb_pwrite),
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .o_apb_prdata(\^o_apb_prdata ),
        .o_led(o_led));
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
