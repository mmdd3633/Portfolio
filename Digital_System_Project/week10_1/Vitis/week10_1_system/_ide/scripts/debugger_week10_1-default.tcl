# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Tukorea\Digital_System_Project\week10_1\Vitis\week10_1_system\_ide\scripts\debugger_week10_1-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Tukorea\Digital_System_Project\week10_1\Vitis\week10_1_system\_ide\scripts\debugger_week10_1-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "RealDigital Bla 887120250180A" && level==0 && jtag_device_ctx=="jsn1-13723093-0"}
fpga -file C:/Tukorea/Digital_System_Project/week10_1/Vitis/week10_1/_ide/bitstream/system_top.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw C:/Tukorea/Digital_System_Project/week10_1/Vitis/system_top/export/system_top/hw/system_top.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source C:/Tukorea/Digital_System_Project/week10_1/Vitis/week10_1/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow C:/Tukorea/Digital_System_Project/week10_1/Vitis/week10_1/Debug/week10_1.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
