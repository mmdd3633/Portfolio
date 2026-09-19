# 7-Segment Anodes (AN)
set_property -dict { PACKAGE_PIN K19 IOSTANDARD LVCMOS33 } [get_ports { o_seg_an[0] }]; # AN0
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports { o_seg_an[1] }]; # AN1
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports { o_seg_an[2] }]; # AN2
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [get_ports { o_seg_an[3] }]; # AN3

# 7-Segment Cathodes (CA)
set_property -dict { PACKAGE_PIN K14 IOSTANDARD LVCMOS33 } [get_ports { o_seg_cat[0] }]; # CA
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports { o_seg_cat[1] }]; # CB
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports { o_seg_cat[2] }]; # CC
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports { o_seg_cat[3] }]; # CD
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports { o_seg_cat[4] }]; # CE
set_property -dict { PACKAGE_PIN J16 IOSTANDARD LVCMOS33 } [get_ports { o_seg_cat[5] }]; # CF
set_property -dict { PACKAGE_PIN H18 IOSTANDARD LVCMOS33 } [get_ports { o_seg_cat[6] }]; # CG
set_property -dict { PACKAGE_PIN K18 IOSTANDARD LVCMOS33 } [get_ports { o_seg_cat[7] }]; # DP

# Buttons for Interrupt
set_property -dict { PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports { i_btn[0] }];
set_property -dict { PACKAGE_PIN W13 IOSTANDARD LVCMOS33 } [get_ports { i_btn[1] }];
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports { i_btn[2] }];
set_property -dict { PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports { i_btn[3] }];