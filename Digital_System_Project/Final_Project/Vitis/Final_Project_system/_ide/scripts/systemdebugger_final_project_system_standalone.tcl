# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Tukorea\Digital_System_Project\Final_Project\Vitis\Final_Project_system\_ide\scripts\systemdebugger_final_project_system_standalone.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Tukorea\Digital_System_Project\Final_Project\Vitis\Final_Project_system\_ide\scripts\systemdebugger_final_project_system_standalone.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "RealDigital Bla 8871202501E2A" && level==0 && jtag_device_ctx=="jsn1-13723093-0"}
fpga -file C:/Tukorea/Digital_System_Project/Final_Project/Vitis/Final_Project/_ide/bitstream/Final_Project_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw C:/Tukorea/Digital_System_Project/Final_Project/Vitis/Final_Project_wrapper/export/Final_Project_wrapper/hw/Final_Project_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source C:/Tukorea/Digital_System_Project/Final_Project/Vitis/Final_Project/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow C:/Tukorea/Digital_System_Project/Final_Project/Vitis/Final_Project/Debug/Final_Project.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
