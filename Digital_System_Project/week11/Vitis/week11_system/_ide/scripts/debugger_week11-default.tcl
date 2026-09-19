# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Tukorea\Digital_System_Project\week11\Vitis\week11_system\_ide\scripts\debugger_week11-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Tukorea\Digital_System_Project\week11\Vitis\week11_system\_ide\scripts\debugger_week11-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "RealDigital Bla 887120250118A" && level==0 && jtag_device_ctx=="jsn2-13723093-0"}
fpga -file C:/Tukorea/Digital_System_Project/week11/Vitis/week11/_ide/bitstream/Stopwatch_Top.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw C:/Tukorea/Digital_System_Project/week11/Vitis/Stopwatch_Top/export/Stopwatch_Top/hw/Stopwatch_Top.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source C:/Tukorea/Digital_System_Project/week11/Vitis/week11/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow C:/Tukorea/Digital_System_Project/week11/Vitis/week11/Debug/week11.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
