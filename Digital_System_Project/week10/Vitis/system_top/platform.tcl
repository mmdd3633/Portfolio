# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Tukorea\Digital_System_Project\week10\Vitis\system_top\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Tukorea\Digital_System_Project\week10\Vitis\system_top\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {system_top}\
-hw {C:\Tukorea\Digital_System_Project\week10\system_top.xsa}\
-out {C:/Tukorea/Digital_System_Project/week10/Vitis}

platform write
domain create -name {standalone_ps7_cortexa9_0} -display-name {standalone_ps7_cortexa9_0} -os {standalone} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {empty_application}
platform generate -domains 
platform active {system_top}
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
platform config -updatehw {C:/Tukorea/Digital_System_Project/week10/system_top.xsa}
platform generate -domains 
platform config -updatehw {C:/Tukorea/Digital_System_Project/week10/system_top.xsa}
platform config -updatehw {C:/Tukorea/Digital_System_Project/week10/system_top.xsa}
bsp reload
bsp reload
platform config -updatehw {C:/Tukorea/Digital_System_Project/week10/system_top.xsa}
platform generate -domains 
platform clean
platform generate
platform clean
platform generate
