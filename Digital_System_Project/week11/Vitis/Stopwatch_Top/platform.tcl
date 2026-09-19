# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Tukorea\Digital_System_Project\week11\Vitis\Stopwatch_Top\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Tukorea\Digital_System_Project\week11\Vitis\Stopwatch_Top\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {Stopwatch_Top}\
-hw {C:\Tukorea\Digital_System_Project\week11\Stopwatch_Top.xsa}\
-out {C:/Tukorea/Digital_System_Project/week11/Vitis}

platform write
domain create -name {standalone_ps7_cortexa9_0} -display-name {standalone_ps7_cortexa9_0} -os {standalone} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {empty_application}
platform generate -domains 
platform active {Stopwatch_Top}
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
domain active {zynq_fsbl}
bsp reload
platform config -updatehw {C:/Tukorea/Digital_System_Project/week11/Stopwatch_Top.xsa}
platform generate
