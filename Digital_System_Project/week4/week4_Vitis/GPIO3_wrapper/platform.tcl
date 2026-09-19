# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Tukorea\Digital_System_Project\week4\week4_Vitis\GPIO3_wrapper\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Tukorea\Digital_System_Project\week4\week4_Vitis\GPIO3_wrapper\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {GPIO3_wrapper}\
-hw {C:\Tukorea\Digital_System_Project\week4\GPIO3_wrapper.xsa}\
-out {C:/Tukorea/Digital_System_Project/week4/week4_Vitis}

platform write
domain create -name {standalone_ps7_cortexa9_0} -display-name {standalone_ps7_cortexa9_0} -os {standalone} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {empty_application}
platform generate -domains 
platform active {GPIO3_wrapper}
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
platform clean
platform generate
platform clean
platform generate
