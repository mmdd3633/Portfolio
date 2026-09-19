## -------------------------------------------------------------------------
## 디지털 시스템 설계: Blackboard LED 10-bit XDC (Constraints)
## -------------------------------------------------------------------------

# LED[0] (보드의 LD0)
set_property -dict { PACKAGE_PIN N20 IOSTANDARD LVCMOS33 } [get_ports { o_led[0] }]
# LED[1] (보드의 LD1)
set_property -dict { PACKAGE_PIN P20 IOSTANDARD LVCMOS33 } [get_ports { o_led[1] }]
# LED[2] (보드의 LD2)
set_property -dict { PACKAGE_PIN R19 IOSTANDARD LVCMOS33 } [get_ports { o_led[2] }]
# LED[3] (보드의 LD3)
set_property -dict { PACKAGE_PIN T20 IOSTANDARD LVCMOS33 } [get_ports { o_led[3] }]

# ※ 주의: 아래 LED[4] ~ LED[9]는 임의의 핀 번호이므로, 
# 사용 중인 Blackboard 매뉴얼의 Master XDC 핀맵을 참고하여 
# 실제 보드의 PACKAGE_PIN 번호로 알맞게 수정하여 사용한다.
set_property -dict { PACKAGE_PIN T19 IOSTANDARD LVCMOS33 } [get_ports { o_led[4] }]
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports { o_led[5] }]
set_property -dict { PACKAGE_PIN V20 IOSTANDARD LVCMOS33 } [get_ports { o_led[6] }]
set_property -dict { PACKAGE_PIN W20 IOSTANDARD LVCMOS33 } [get_ports { o_led[7] }]
set_property -dict { PACKAGE_PIN W19 IOSTANDARD LVCMOS33 } [get_ports { o_led[8] }]
set_property -dict { PACKAGE_PIN Y19 IOSTANDARD LVCMOS33 } [get_ports { o_led[9] }]

## -------------------------------------------------------------------------