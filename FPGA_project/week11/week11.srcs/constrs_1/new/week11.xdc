# Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { i_clk }]; 
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {i_clk}];

#CPU Reset Button
set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33 } [get_ports { i_rst_n }]; 

#Buttons
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { i_btn }]; 

#7 segment display
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { o_seg[0] }]; 
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { o_seg[1] }]; 
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { o_seg[2] }]; 
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { o_seg[3] }]; 
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { o_seg[4] }]; 
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { o_seg[5] }]; 
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { o_seg[6] }]; 
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { o_seg[7] }]; 
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { o_an[0] }]; 
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { o_an[1] }]; 
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { o_an[2] }]; 
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { o_an[3] }]; 
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { o_an[4] }]; 
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { o_an[5] }]; 
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { o_an[6] }]; 
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { o_an[7] }]; 
