# ===================================================================
# Black Board XDC for APB Stopwatch System
# ===================================================================

# -------------------------------------------------------------------
# Push Buttons (btn_n_i)
# -------------------------------------------------------------------
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { btn_n_i[0] }]; # Schematic=BTN0
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { btn_n_i[1] }]; # Schematic=BTN1
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { btn_n_i[2] }]; # Schematic=BTN2
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { btn_n_i[3] }]; # Schematic=BTN3

# -------------------------------------------------------------------
# Individual LEDs (led_o)
# -------------------------------------------------------------------
set_property -dict { PACKAGE_PIN N20   IOSTANDARD LVCMOS33 } [get_ports { led_o[0] }]; # Schematic=LD0
set_property -dict { PACKAGE_PIN P20   IOSTANDARD LVCMOS33 } [get_ports { led_o[1] }]; # Schematic=LD1
set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports { led_o[2] }]; # Schematic=LD2
set_property -dict { PACKAGE_PIN T20   IOSTANDARD LVCMOS33 } [get_ports { led_o[3] }]; # Schematic=LD3

# -------------------------------------------------------------------
# Seven Segment Display Anodes (an_o)
# -------------------------------------------------------------------
set_property -dict { PACKAGE_PIN K19   IOSTANDARD LVCMOS33 } [get_ports { an_o[0] }]; # Schematic=SSEG_AN0
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { an_o[1] }]; # Schematic=SSEG_AN1
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { an_o[2] }]; # Schematic=SSEG_AN2
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { an_o[3] }]; # Schematic=SSEG_AN3

# -------------------------------------------------------------------
# Seven Segment Display Cathodes (seg_o) 
# 배열 순서: [7]=DP, [6]=G, [5]=F, [4]=E, [3]=D, [2]=C, [1]=B, [0]=A
# -------------------------------------------------------------------
set_property -dict { PACKAGE_PIN K14   IOSTANDARD LVCMOS33 } [get_ports { seg_o[0] }]; # Schematic=SSEG_CA
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { seg_o[1] }]; # Schematic=SSEG_CB
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { seg_o[2] }]; # Schematic=SSEG_CC
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { seg_o[3] }]; # Schematic=SSEG_CD
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { seg_o[4] }]; # Schematic=SSEG_CE
set_property -dict { PACKAGE_PIN J16   IOSTANDARD LVCMOS33 } [get_ports { seg_o[5] }]; # Schematic=SSEG_CF
set_property -dict { PACKAGE_PIN H18   IOSTANDARD LVCMOS33 } [get_ports { seg_o[6] }]; # Schematic=SSEG_CG
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { seg_o[7] }]; # Schematic=SSEG_DP# ===================================================================
# Black Board XDC for APB Stopwatch System
# ===================================================================

# -------------------------------------------------------------------
# Push Buttons (btn_n_i)
# -------------------------------------------------------------------
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { btn_n_i[0] }]; # Schematic=BTN0
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { btn_n_i[1] }]; # Schematic=BTN1
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { btn_n_i[2] }]; # Schematic=BTN2
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { btn_n_i[3] }]; # Schematic=BTN3

# -------------------------------------------------------------------
# Individual LEDs (led_o)
# -------------------------------------------------------------------
set_property -dict { PACKAGE_PIN N20   IOSTANDARD LVCMOS33 } [get_ports { led_o[0] }]; # Schematic=LD0
set_property -dict { PACKAGE_PIN P20   IOSTANDARD LVCMOS33 } [get_ports { led_o[1] }]; # Schematic=LD1
set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports { led_o[2] }]; # Schematic=LD2
set_property -dict { PACKAGE_PIN T20   IOSTANDARD LVCMOS33 } [get_ports { led_o[3] }]; # Schematic=LD3

# -------------------------------------------------------------------
# Seven Segment Display Anodes (an_o)
# -------------------------------------------------------------------
set_property -dict { PACKAGE_PIN K19   IOSTANDARD LVCMOS33 } [get_ports { an_o[0] }]; # Schematic=SSEG_AN0
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { an_o[1] }]; # Schematic=SSEG_AN1
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { an_o[2] }]; # Schematic=SSEG_AN2
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { an_o[3] }]; # Schematic=SSEG_AN3

# -------------------------------------------------------------------
# Seven Segment Display Cathodes (seg_o) 
# 배열 순서: [7]=DP, [6]=G, [5]=F, [4]=E, [3]=D, [2]=C, [1]=B, [0]=A
# -------------------------------------------------------------------
set_property -dict { PACKAGE_PIN K14   IOSTANDARD LVCMOS33 } [get_ports { seg_o[0] }]; # Schematic=SSEG_CA
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { seg_o[1] }]; # Schematic=SSEG_CB
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { seg_o[2] }]; # Schematic=SSEG_CC
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { seg_o[3] }]; # Schematic=SSEG_CD
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { seg_o[4] }]; # Schematic=SSEG_CE
set_property -dict { PACKAGE_PIN J16   IOSTANDARD LVCMOS33 } [get_ports { seg_o[5] }]; # Schematic=SSEG_CF
set_property -dict { PACKAGE_PIN H18   IOSTANDARD LVCMOS33 } [get_ports { seg_o[6] }]; # Schematic=SSEG_CG
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { seg_o[7] }]; # Schematic=SSEG_DP