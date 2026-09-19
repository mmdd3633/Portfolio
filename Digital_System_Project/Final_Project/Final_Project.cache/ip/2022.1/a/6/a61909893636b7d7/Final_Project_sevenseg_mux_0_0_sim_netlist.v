// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri Jun  5 14:34:07 2026
// Host        : BOOK-PI4T4K8H7V running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ Final_Project_sevenseg_mux_0_0_sim_netlist.v
// Design      : Final_Project_sevenseg_mux_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z007sclg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "Final_Project_sevenseg_mux_0_0,sevenseg_mux,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "sevenseg_mux,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clk,
    rst_n,
    value,
    seg_an,
    seg_cat);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN Final_Project_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input rst_n;
  input [15:0]value;
  output [3:0]seg_an;
  output [7:0]seg_cat;

  wire \<const1> ;
  wire clk;
  wire rst_n;
  wire [3:0]seg_an;
  wire [6:0]\^seg_cat ;
  wire [15:0]value;

  assign seg_cat[7] = \<const1> ;
  assign seg_cat[6:0] = \^seg_cat [6:0];
  VCC VCC
       (.P(\<const1> ));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_sevenseg_mux inst
       (.clk(clk),
        .rst_n(rst_n),
        .seg_an(seg_an),
        .seg_cat(\^seg_cat ),
        .value(value));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_sevenseg_mux
   (seg_an,
    seg_cat,
    clk,
    rst_n,
    value);
  output [3:0]seg_an;
  output [6:0]seg_cat;
  input clk;
  input rst_n;
  input [15:0]value;

  wire clear;
  wire clk;
  wire [3:0]hex;
  wire [1:0]p_0_in;
  wire \refresh_counter[0]_i_3_n_0 ;
  wire \refresh_counter_reg[0]_i_2_n_0 ;
  wire \refresh_counter_reg[0]_i_2_n_1 ;
  wire \refresh_counter_reg[0]_i_2_n_2 ;
  wire \refresh_counter_reg[0]_i_2_n_3 ;
  wire \refresh_counter_reg[0]_i_2_n_4 ;
  wire \refresh_counter_reg[0]_i_2_n_5 ;
  wire \refresh_counter_reg[0]_i_2_n_6 ;
  wire \refresh_counter_reg[0]_i_2_n_7 ;
  wire \refresh_counter_reg[12]_i_1_n_0 ;
  wire \refresh_counter_reg[12]_i_1_n_1 ;
  wire \refresh_counter_reg[12]_i_1_n_2 ;
  wire \refresh_counter_reg[12]_i_1_n_3 ;
  wire \refresh_counter_reg[12]_i_1_n_4 ;
  wire \refresh_counter_reg[12]_i_1_n_5 ;
  wire \refresh_counter_reg[12]_i_1_n_6 ;
  wire \refresh_counter_reg[12]_i_1_n_7 ;
  wire \refresh_counter_reg[16]_i_1_n_7 ;
  wire \refresh_counter_reg[4]_i_1_n_0 ;
  wire \refresh_counter_reg[4]_i_1_n_1 ;
  wire \refresh_counter_reg[4]_i_1_n_2 ;
  wire \refresh_counter_reg[4]_i_1_n_3 ;
  wire \refresh_counter_reg[4]_i_1_n_4 ;
  wire \refresh_counter_reg[4]_i_1_n_5 ;
  wire \refresh_counter_reg[4]_i_1_n_6 ;
  wire \refresh_counter_reg[4]_i_1_n_7 ;
  wire \refresh_counter_reg[8]_i_1_n_0 ;
  wire \refresh_counter_reg[8]_i_1_n_1 ;
  wire \refresh_counter_reg[8]_i_1_n_2 ;
  wire \refresh_counter_reg[8]_i_1_n_3 ;
  wire \refresh_counter_reg[8]_i_1_n_4 ;
  wire \refresh_counter_reg[8]_i_1_n_5 ;
  wire \refresh_counter_reg[8]_i_1_n_6 ;
  wire \refresh_counter_reg[8]_i_1_n_7 ;
  wire \refresh_counter_reg_n_0_[0] ;
  wire \refresh_counter_reg_n_0_[10] ;
  wire \refresh_counter_reg_n_0_[11] ;
  wire \refresh_counter_reg_n_0_[12] ;
  wire \refresh_counter_reg_n_0_[13] ;
  wire \refresh_counter_reg_n_0_[14] ;
  wire \refresh_counter_reg_n_0_[1] ;
  wire \refresh_counter_reg_n_0_[2] ;
  wire \refresh_counter_reg_n_0_[3] ;
  wire \refresh_counter_reg_n_0_[4] ;
  wire \refresh_counter_reg_n_0_[5] ;
  wire \refresh_counter_reg_n_0_[6] ;
  wire \refresh_counter_reg_n_0_[7] ;
  wire \refresh_counter_reg_n_0_[8] ;
  wire \refresh_counter_reg_n_0_[9] ;
  wire rst_n;
  wire [3:0]seg_an;
  wire [6:0]seg_cat;
  wire [15:0]value;
  wire [3:0]\NLW_refresh_counter_reg[16]_i_1_CO_UNCONNECTED ;
  wire [3:1]\NLW_refresh_counter_reg[16]_i_1_O_UNCONNECTED ;

  LUT1 #(
    .INIT(2'h1)) 
    \refresh_counter[0]_i_1 
       (.I0(rst_n),
        .O(clear));
  LUT1 #(
    .INIT(2'h1)) 
    \refresh_counter[0]_i_3 
       (.I0(\refresh_counter_reg_n_0_[0] ),
        .O(\refresh_counter[0]_i_3_n_0 ));
  FDRE \refresh_counter_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[0]_i_2_n_7 ),
        .Q(\refresh_counter_reg_n_0_[0] ),
        .R(clear));
  (* ADDER_THRESHOLD = "11" *) 
  CARRY4 \refresh_counter_reg[0]_i_2 
       (.CI(1'b0),
        .CO({\refresh_counter_reg[0]_i_2_n_0 ,\refresh_counter_reg[0]_i_2_n_1 ,\refresh_counter_reg[0]_i_2_n_2 ,\refresh_counter_reg[0]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\refresh_counter_reg[0]_i_2_n_4 ,\refresh_counter_reg[0]_i_2_n_5 ,\refresh_counter_reg[0]_i_2_n_6 ,\refresh_counter_reg[0]_i_2_n_7 }),
        .S({\refresh_counter_reg_n_0_[3] ,\refresh_counter_reg_n_0_[2] ,\refresh_counter_reg_n_0_[1] ,\refresh_counter[0]_i_3_n_0 }));
  FDRE \refresh_counter_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[8]_i_1_n_5 ),
        .Q(\refresh_counter_reg_n_0_[10] ),
        .R(clear));
  FDRE \refresh_counter_reg[11] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[8]_i_1_n_4 ),
        .Q(\refresh_counter_reg_n_0_[11] ),
        .R(clear));
  FDRE \refresh_counter_reg[12] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[12]_i_1_n_7 ),
        .Q(\refresh_counter_reg_n_0_[12] ),
        .R(clear));
  (* ADDER_THRESHOLD = "11" *) 
  CARRY4 \refresh_counter_reg[12]_i_1 
       (.CI(\refresh_counter_reg[8]_i_1_n_0 ),
        .CO({\refresh_counter_reg[12]_i_1_n_0 ,\refresh_counter_reg[12]_i_1_n_1 ,\refresh_counter_reg[12]_i_1_n_2 ,\refresh_counter_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\refresh_counter_reg[12]_i_1_n_4 ,\refresh_counter_reg[12]_i_1_n_5 ,\refresh_counter_reg[12]_i_1_n_6 ,\refresh_counter_reg[12]_i_1_n_7 }),
        .S({p_0_in[0],\refresh_counter_reg_n_0_[14] ,\refresh_counter_reg_n_0_[13] ,\refresh_counter_reg_n_0_[12] }));
  FDRE \refresh_counter_reg[13] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[12]_i_1_n_6 ),
        .Q(\refresh_counter_reg_n_0_[13] ),
        .R(clear));
  FDRE \refresh_counter_reg[14] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[12]_i_1_n_5 ),
        .Q(\refresh_counter_reg_n_0_[14] ),
        .R(clear));
  FDRE \refresh_counter_reg[15] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[12]_i_1_n_4 ),
        .Q(p_0_in[0]),
        .R(clear));
  FDRE \refresh_counter_reg[16] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[16]_i_1_n_7 ),
        .Q(p_0_in[1]),
        .R(clear));
  (* ADDER_THRESHOLD = "11" *) 
  CARRY4 \refresh_counter_reg[16]_i_1 
       (.CI(\refresh_counter_reg[12]_i_1_n_0 ),
        .CO(\NLW_refresh_counter_reg[16]_i_1_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_refresh_counter_reg[16]_i_1_O_UNCONNECTED [3:1],\refresh_counter_reg[16]_i_1_n_7 }),
        .S({1'b0,1'b0,1'b0,p_0_in[1]}));
  FDRE \refresh_counter_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[0]_i_2_n_6 ),
        .Q(\refresh_counter_reg_n_0_[1] ),
        .R(clear));
  FDRE \refresh_counter_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[0]_i_2_n_5 ),
        .Q(\refresh_counter_reg_n_0_[2] ),
        .R(clear));
  FDRE \refresh_counter_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[0]_i_2_n_4 ),
        .Q(\refresh_counter_reg_n_0_[3] ),
        .R(clear));
  FDRE \refresh_counter_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[4]_i_1_n_7 ),
        .Q(\refresh_counter_reg_n_0_[4] ),
        .R(clear));
  (* ADDER_THRESHOLD = "11" *) 
  CARRY4 \refresh_counter_reg[4]_i_1 
       (.CI(\refresh_counter_reg[0]_i_2_n_0 ),
        .CO({\refresh_counter_reg[4]_i_1_n_0 ,\refresh_counter_reg[4]_i_1_n_1 ,\refresh_counter_reg[4]_i_1_n_2 ,\refresh_counter_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\refresh_counter_reg[4]_i_1_n_4 ,\refresh_counter_reg[4]_i_1_n_5 ,\refresh_counter_reg[4]_i_1_n_6 ,\refresh_counter_reg[4]_i_1_n_7 }),
        .S({\refresh_counter_reg_n_0_[7] ,\refresh_counter_reg_n_0_[6] ,\refresh_counter_reg_n_0_[5] ,\refresh_counter_reg_n_0_[4] }));
  FDRE \refresh_counter_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[4]_i_1_n_6 ),
        .Q(\refresh_counter_reg_n_0_[5] ),
        .R(clear));
  FDRE \refresh_counter_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[4]_i_1_n_5 ),
        .Q(\refresh_counter_reg_n_0_[6] ),
        .R(clear));
  FDRE \refresh_counter_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[4]_i_1_n_4 ),
        .Q(\refresh_counter_reg_n_0_[7] ),
        .R(clear));
  FDRE \refresh_counter_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[8]_i_1_n_7 ),
        .Q(\refresh_counter_reg_n_0_[8] ),
        .R(clear));
  (* ADDER_THRESHOLD = "11" *) 
  CARRY4 \refresh_counter_reg[8]_i_1 
       (.CI(\refresh_counter_reg[4]_i_1_n_0 ),
        .CO({\refresh_counter_reg[8]_i_1_n_0 ,\refresh_counter_reg[8]_i_1_n_1 ,\refresh_counter_reg[8]_i_1_n_2 ,\refresh_counter_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\refresh_counter_reg[8]_i_1_n_4 ,\refresh_counter_reg[8]_i_1_n_5 ,\refresh_counter_reg[8]_i_1_n_6 ,\refresh_counter_reg[8]_i_1_n_7 }),
        .S({\refresh_counter_reg_n_0_[11] ,\refresh_counter_reg_n_0_[10] ,\refresh_counter_reg_n_0_[9] ,\refresh_counter_reg_n_0_[8] }));
  FDRE \refresh_counter_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .D(\refresh_counter_reg[8]_i_1_n_6 ),
        .Q(\refresh_counter_reg_n_0_[9] ),
        .R(clear));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \seg_an[0]_INST_0 
       (.I0(p_0_in[0]),
        .I1(p_0_in[1]),
        .O(seg_an[0]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \seg_an[1]_INST_0 
       (.I0(p_0_in[1]),
        .I1(p_0_in[0]),
        .O(seg_an[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \seg_an[2]_INST_0 
       (.I0(p_0_in[0]),
        .I1(p_0_in[1]),
        .O(seg_an[2]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \seg_an[3]_INST_0 
       (.I0(p_0_in[0]),
        .I1(p_0_in[1]),
        .O(seg_an[3]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h2094)) 
    \seg_cat[0]_INST_0 
       (.I0(hex[3]),
        .I1(hex[2]),
        .I2(hex[0]),
        .I3(hex[1]),
        .O(seg_cat[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hA4C8)) 
    \seg_cat[1]_INST_0 
       (.I0(hex[3]),
        .I1(hex[2]),
        .I2(hex[1]),
        .I3(hex[0]),
        .O(seg_cat[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hA210)) 
    \seg_cat[2]_INST_0 
       (.I0(hex[3]),
        .I1(hex[0]),
        .I2(hex[1]),
        .I3(hex[2]),
        .O(seg_cat[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hC214)) 
    \seg_cat[3]_INST_0 
       (.I0(hex[3]),
        .I1(hex[2]),
        .I2(hex[0]),
        .I3(hex[1]),
        .O(seg_cat[3]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h5710)) 
    \seg_cat[4]_INST_0 
       (.I0(hex[3]),
        .I1(hex[1]),
        .I2(hex[2]),
        .I3(hex[0]),
        .O(seg_cat[4]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h5190)) 
    \seg_cat[5]_INST_0 
       (.I0(hex[3]),
        .I1(hex[2]),
        .I2(hex[0]),
        .I3(hex[1]),
        .O(seg_cat[5]));
  LUT4 #(
    .INIT(16'h4025)) 
    \seg_cat[6]_INST_0 
       (.I0(hex[3]),
        .I1(hex[0]),
        .I2(hex[2]),
        .I3(hex[1]),
        .O(seg_cat[6]));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \seg_cat[6]_INST_0_i_1 
       (.I0(value[7]),
        .I1(value[3]),
        .I2(value[15]),
        .I3(p_0_in[0]),
        .I4(p_0_in[1]),
        .I5(value[11]),
        .O(hex[3]));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \seg_cat[6]_INST_0_i_2 
       (.I0(value[4]),
        .I1(value[0]),
        .I2(value[12]),
        .I3(p_0_in[0]),
        .I4(p_0_in[1]),
        .I5(value[8]),
        .O(hex[0]));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \seg_cat[6]_INST_0_i_3 
       (.I0(value[6]),
        .I1(value[2]),
        .I2(value[14]),
        .I3(p_0_in[0]),
        .I4(p_0_in[1]),
        .I5(value[10]),
        .O(hex[2]));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \seg_cat[6]_INST_0_i_4 
       (.I0(value[5]),
        .I1(value[1]),
        .I2(value[13]),
        .I3(p_0_in[0]),
        .I4(p_0_in[1]),
        .I5(value[9]),
        .O(hex[1]));
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
