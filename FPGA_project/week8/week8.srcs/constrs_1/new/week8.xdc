## Clock signal
#set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { i_clk }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {i_clk}];

##CPU Reset Button
#set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33 } [get_ports { i_rst_n }]; #IO_L3P_T0_DQS_AD1P_15 Sch=cpu_resetn

#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { i_sw[0] }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
#set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { i_sw[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1]

#set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { o_led }]; #IO_L18P_T2_A24_15 Sch=led[0]


# Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { i_clk }]; 
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {i_clk}];
#CPU Reset Button
set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33 } [get_ports { i_rst_n }]; 

set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { i_sw }]; 
# LEDs
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { o_led[0] }]; 
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { o_led[1] }]; 
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { o_led[2] }]; 
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { o_led[3] }]; 
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { o_led[4] }]; 
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { o_led[5] }]; 
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { o_led[6] }]; 
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { o_led[7] }]; 
