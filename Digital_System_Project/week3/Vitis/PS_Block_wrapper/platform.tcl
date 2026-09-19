# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Tukorea\Digital_System_Project\week3\Vitis\PS_Block_wrapper\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Tukorea\Digital_System_Project\week3\Vitis\PS_Block_wrapper\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {PS_Block_wrapper}\
-hw {C:\Tukorea\Digital_System_Project\week3\PS_Block_wrapper.xsa}\
-out {C:/Tukorea/Digital_System_Project/week3/Vitis}

platform write
domain create -name {standalone_ps7_cortexa9_0} -display-name {standalone_ps7_cortexa9_0} -os {standalone} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {empty_application}
platform generate -domains 
platform active {PS_Block_wrapper}
domain active {zynq_fsbl}
domain active {standalone_ps7_cortexa9_0}
platform generate -quick
bsp reload
bsp config stdin "ps7_uart_1"
bsp config stdout "ps7_uart_1"
bsp write
bsp reload
catch {bsp regenerate}
platform generate
