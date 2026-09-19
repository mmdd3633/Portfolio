# ==========================================
# 1. Slide Switches (12 bits) : i_sw[11:0]
# 마스터 XDC의 sw[0] ~ sw[11] 핀 번호 적용
# ==========================================
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { i_sw[0] }];  # SW0
set_property -dict { PACKAGE_PIN U20   IOSTANDARD LVCMOS33 } [get_ports { i_sw[1] }];  # SW1
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { i_sw[2] }];  # SW2
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { i_sw[3] }];  # SW3
set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { i_sw[4] }];  # SW4
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { i_sw[5] }];  # SW5
set_property -dict { PACKAGE_PIN L15   IOSTANDARD LVCMOS33 } [get_ports { i_sw[6] }];  # SW6
set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { i_sw[7] }];  # SW7
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { i_sw[8] }];  # SW8
set_property -dict { PACKAGE_PIN T12   IOSTANDARD LVCMOS33 } [get_ports { i_sw[9] }];  # SW9
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { i_sw[10] }]; # SW10
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { i_sw[11] }]; # SW11

# ==========================================
# 2. Mono LEDs (10 bits) : o_led[9:0]
# 마스터 XDC의 led[0] ~ led[9] 핀 번호 적용
# ==========================================
set_property -dict { PACKAGE_PIN N20   IOSTANDARD LVCMOS33 } [get_ports { o_led[0] }]; # LD0
set_property -dict { PACKAGE_PIN P20   IOSTANDARD LVCMOS33 } [get_ports { o_led[1] }]; # LD1
set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports { o_led[2] }]; # LD2
set_property -dict { PACKAGE_PIN T20   IOSTANDARD LVCMOS33 } [get_ports { o_led[3] }]; # LD3
set_property -dict { PACKAGE_PIN T19   IOSTANDARD LVCMOS33 } [get_ports { o_led[4] }]; # LD4
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { o_led[5] }]; # LD5
set_property -dict { PACKAGE_PIN V20   IOSTANDARD LVCMOS33 } [get_ports { o_led[6] }]; # LD6
set_property -dict { PACKAGE_PIN W20   IOSTANDARD LVCMOS33 } [get_ports { o_led[7] }]; # LD7
set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports { o_led[8] }]; # LD8
set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { o_led[9] }]; # LD9

# ==========================================
# 3. RGB Color LED 0 (3 bits) : o_color_led_0[2:0]
# 마스터 XDC의 RGB_led_A[2:0] 핀 번호 적용 
# [0]: Red, [1]: Green, [2]: Blue
# ==========================================
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports { o_color_led_0[0] }]; # LD10_R
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { o_color_led_0[1] }]; # LD10_G
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { o_color_led_0[2] }]; # LD10_B

# ==========================================
# 4. RGB Color LED 1 (3 bits) : o_color_led_1[2:0]
# 마스터 XDC의 RGB_led_B[2:0] 핀 번호 적용 
# [0]: Red, [1]: Green, [2]: Blue
# ==========================================
set_property -dict { PACKAGE_PIN Y14   IOSTANDARD LVCMOS33 } [get_ports { o_color_led_1[0] }]; # LD11_R
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { o_color_led_1[1] }]; # LD11_G
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { o_color_led_1[2] }]; # LD11_B