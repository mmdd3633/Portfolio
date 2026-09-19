# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Tukorea\Digital_System_Project\week3\Vitis_btn\week3_btn_system\_ide\scripts\debugger_week3_btn-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Tukorea\Digital_System_Project\week3\Vitis_btn\week3_btn_system\_ide\scripts\debugger_week3_btn-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "RealDigital Bla 8871202501ECA" && level==0 && jtag_device_ctx=="jsn1-13723093-0"}
fpga -file C:/Tukorea/Digital_System_Project/week3/Vitis_btn/week3_btn/_ide/bitstream/PS_Block_wrapper_btn.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw C:/Tukorea/Digital_System_Project/week3/Vitis_btn/PS_Block_wrapper_btn/export/PS_Block_wrapper_btn/hw/PS_Block_wrapper_btn.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source C:/Tukorea/Digital_System_Project/week3/Vitis_btn/week3_btn/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow C:/Tukorea/Digital_System_Project/week3/Vitis_btn/week3_btn/Debug/week3_btn.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
