##=========================================================
##  Clock (100 MHz, pin E3)
##=========================================================
set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk -period 10.000 -waveform {0 5} [get_ports { clk }];

##=========================================================
##  Reset (CPU_RESETN 버튼, active-low, pin C12)
##=========================================================
set_property -dict { PACKAGE_PIN C12 IOSTANDARD LVCMOS33 } [get_ports { rst_n }];

##=========================================================
##  USB-UART (FTDI)
##  - C4: FPGA → PC (TX)
##  - D4: PC  → FPGA (RX)
##=========================================================
set_property -dict { PACKAGE_PIN D4  IOSTANDARD LVCMOS33 } [get_ports { uart_tx }];
set_property -dict { PACKAGE_PIN C4  IOSTANDARD LVCMOS33 } [get_ports { uart_rx }];

##=========================================================
##  7-Segment segments (CA~CG, active-low)
##  CA=T10, CB=R10, CC=K16, CD=K13, CE=P15, CF=T11, CG=L18
##=========================================================
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { seg[0] }]; # a (CA)
set_property -dict { PACKAGE_PIN R10 IOSTANDARD LVCMOS33 } [get_ports { seg[1] }]; # b (CB)
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33 } [get_ports { seg[2] }]; # c (CC)
set_property -dict { PACKAGE_PIN K13 IOSTANDARD LVCMOS33 } [get_ports { seg[3] }]; # d (CD)
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports { seg[4] }]; # e (CE)
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports { seg[5] }]; # f (CF)
set_property -dict { PACKAGE_PIN L18 IOSTANDARD LVCMOS33 } [get_ports { seg[6] }]; # g (CG)

##=========================================================
##  7-Segment anodes AN0..AN7 (active-low)
##  AN0=J17, AN1=J18, AN2=T9, AN3=J14, AN4=P14, AN5=T14, AN6=K2, AN7=U13
##=========================================================
set_property -dict { PACKAGE_PIN J17 IOSTANDARD LVCMOS33 } [get_ports { an[0] }]; # AN0 (rightmost)
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports { an[1] }]; # AN1
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { an[2] }]; # AN2
set_property -dict { PACKAGE_PIN J14 IOSTANDARD LVCMOS33 } [get_ports { an[3] }]; # AN3
set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports { an[4] }]; # AN4
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports { an[5] }]; # AN5
set_property -dict { PACKAGE_PIN K2  IOSTANDARD LVCMOS33 } [get_ports { an[6] }]; # AN6
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports { an[7] }]; # AN7

##=========================================================
##  7-Segment DP (소수점, active-low)
##  DP = H15
##=========================================================
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports { dp }];

set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1]

