## Clock (100 MHz)
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { i_clk }]; # Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { i_clk }];

## Switches (i_sw[15:0])
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { i_sw[0]  }];
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { i_sw[1]  }];
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { i_sw[2]  }];
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { i_sw[3]  }];
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { i_sw[4]  }];
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { i_sw[5]  }];
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { i_sw[6]  }];
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { i_sw[7]  }];
set_property -dict { PACKAGE_PIN T8    IOSTANDARD LVCMOS18 } [get_ports { i_sw[8]  }];
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS18 } [get_ports { i_sw[9]  }];
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { i_sw[10] }];
set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { i_sw[11] }];
set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { i_sw[12] }];
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { i_sw[13] }];
set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { i_sw[14] }];
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { i_sw[15] }];

## 7-Segment (o_ca[7:0] = {DP, G, F, E, D, C, B, A})
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { o_ca[0] }]; # CA (a)
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { o_ca[1] }]; # CB (b)
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { o_ca[2] }]; # CC (c)
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { o_ca[3] }]; # CD (d)
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { o_ca[4] }]; # CE (e)
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { o_ca[5] }]; # CF (f)
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { o_ca[6] }]; # CG (g)
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { o_ca[7] }]; # DP (dot)

## 7-Segment AN (o_an[7:0], active-low)
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { o_an[0] }];
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { o_an[1] }];
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { o_an[2] }];
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { o_an[3] }];
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { o_an[4] }];
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { o_an[5] }];
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { o_an[6] }];
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { o_an[7] }];

## Reset (active-low)
set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33 } [get_ports { i_rst_n }];
