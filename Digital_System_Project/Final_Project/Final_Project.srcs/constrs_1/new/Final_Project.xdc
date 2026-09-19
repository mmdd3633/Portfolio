## =====================================================================
## Master .xdc for the Blackboard (Customized for APB I2C & AXI GPIO)
## =====================================================================

## LSM9DS1 I2C Ports (Open-Drain Configuration with Internal Pull-up)
set_property -dict { PACKAGE_PIN H20    IOSTANDARD LVCMOS33 PULLUP true } [get_ports { iic_rtl_scl_io }]
set_property -dict { PACKAGE_PIN J19    IOSTANDARD LVCMOS33 PULLUP true } [get_ports { iic_rtl_sda_io }]

## LSM9DS1 Mode / Address Pins Control
set_property -dict { PACKAGE_PIN K17    IOSTANDARD LVCMOS33 } [get_ports { GYRO_CS_AG_0 }]
set_property -dict { PACKAGE_PIN K16    IOSTANDARD LVCMOS33 } [get_ports { GYRO_CS_M_0 }]
set_property -dict { PACKAGE_PIN J20    IOSTANDARD LVCMOS33 } [get_ports { GYRO_SDO_AG_0 }]
set_property -dict { PACKAGE_PIN L17    IOSTANDARD LVCMOS33 } [get_ports { GYRO_SDO_M_0 }]
set_property -dict { PACKAGE_PIN J14    IOSTANDARD LVCMOS33 } [get_ports { GYRO_DEN_AG_0 }]

## LEDs (AXI GPIO 16-bit Output - Fixed Pin Duplication with RGB LEDs)
# Individual LEDs (0 to 9)
set_property -dict { PACKAGE_PIN N20    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[0] }]; # Schematic=LD0
set_property -dict { PACKAGE_PIN P20    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[1] }]; # Schematic=LD1
set_property -dict { PACKAGE_PIN R19    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[2] }]; # Schematic=LD2
set_property -dict { PACKAGE_PIN T20    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[3] }]; # Schematic=LD3
set_property -dict { PACKAGE_PIN T19    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[4] }]; # Schematic=LD4
set_property -dict { PACKAGE_PIN U13    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[5] }]; # Schematic=LD5
set_property -dict { PACKAGE_PIN V20    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[6] }]; # Schematic=LD6
set_property -dict { PACKAGE_PIN W20    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[7] }]; # Schematic=LD7
set_property -dict { PACKAGE_PIN W19    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[8] }]; # Schematic=LD8
set_property -dict { PACKAGE_PIN Y19    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[9] }]; # Schematic=LD9

# RGB LED A Mapped to GPIO bits 10, 11, 12
set_property -dict { PACKAGE_PIN W18    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[10] }]; # Schematic=LD10_R
set_property -dict { PACKAGE_PIN W16    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[11] }]; # Schematic=LD10_G
set_property -dict { PACKAGE_PIN Y18    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[12] }]; # Schematic=LD10_B

# RGB LED B Mapped to GPIO bits 13, 14, 15
set_property -dict { PACKAGE_PIN Y14    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[13] }]; # Schematic=LD11_R
set_property -dict { PACKAGE_PIN Y16    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[14] }]; # Schematic=LD11_G
set_property -dict { PACKAGE_PIN Y17    IOSTANDARD LVCMOS33 } [get_ports { leds_16bits_tri_io[15] }]; # Schematic=LD11_B

## Push Buttons (AXI GPIO 4-bit Input)
set_property -dict { PACKAGE_PIN W14    IOSTANDARD LVCMOS33 } [get_ports { btns_4bits_0_tri_i[0] }]; # Schematic=BTN0
set_property -dict { PACKAGE_PIN W13    IOSTANDARD LVCMOS33 } [get_ports { btns_4bits_0_tri_i[1] }]; # Schematic=BTN1
set_property -dict { PACKAGE_PIN P15    IOSTANDARD LVCMOS33 } [get_ports { btns_4bits_0_tri_i[2] }]; # Schematic=BTN2
set_property -dict { PACKAGE_PIN M14    IOSTANDARD LVCMOS33 } [get_ports { btns_4bits_0_tri_i[3] }]; # Schematic=BTN3

## Seven-Segment Display Anodes (Active-Low)
set_property -dict { PACKAGE_PIN K19    IOSTANDARD LVCMOS33 } [get_ports { seg_an[0] }]; # Schematic=SSEG_AN0
set_property -dict { PACKAGE_PIN H17    IOSTANDARD LVCMOS33 } [get_ports { seg_an[1] }]; # Schematic=SSEG_AN1
set_property -dict { PACKAGE_PIN M18    IOSTANDARD LVCMOS33 } [get_ports { seg_an[2] }]; # Schematic=SSEG_AN2
set_property -dict { PACKAGE_PIN L16    IOSTANDARD LVCMOS33 } [get_ports { seg_an[3] }]; # Schematic=SSEG_AN3

## Seven-Segment Display Cathodes (A B C D E F G DP)
set_property -dict { PACKAGE_PIN K14    IOSTANDARD LVCMOS33 } [get_ports { seg_cat[0] }]; # Schematic=SSEG_CA
set_property -dict { PACKAGE_PIN H15    IOSTANDARD LVCMOS33 } [get_ports { seg_cat[1] }]; # Schematic=SSEG_CB
set_property -dict { PACKAGE_PIN J18    IOSTANDARD LVCMOS33 } [get_ports { seg_cat[2] }]; # Schematic=SSEG_CC
set_property -dict { PACKAGE_PIN J15    IOSTANDARD LVCMOS33 } [get_ports { seg_cat[3] }]; # Schematic=SSEG_CD
set_property -dict { PACKAGE_PIN M17    IOSTANDARD LVCMOS33 } [get_ports { seg_cat[4] }]; # Schematic=SSEG_CE
set_property -dict { PACKAGE_PIN J16    IOSTANDARD LVCMOS33 } [get_ports { seg_cat[5] }]; # Schematic=SSEG_CF
set_property -dict { PACKAGE_PIN H18    IOSTANDARD LVCMOS33 } [get_ports { seg_cat[6] }]; # Schematic=SSEG_CG
set_property -dict { PACKAGE_PIN K18    IOSTANDARD LVCMOS33 } [get_ports { seg_cat[7] }]; # Schematic=SSEG_DP