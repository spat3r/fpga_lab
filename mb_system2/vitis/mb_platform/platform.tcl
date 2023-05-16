# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct E:\Egyetem\fpga_alapu_rendszerek\mb_system2\vitis\mb_platform\platform.tcl
# 
# OR launch xsct and run below command.
# source E:\Egyetem\fpga_alapu_rendszerek\mb_system2\vitis\mb_platform\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {mb_platform}\
-hw {E:\Egyetem\fpga_alapu_rendszerek\mb_system2\cpu_system_wrapper.xsa}\
-proc {microblaze_0} -os {standalone} -out {E:/Egyetem/fpga_alapu_rendszerek/mb_system2/vitis}

platform write
platform generate -domains 
platform active {mb_platform}
bsp reload
platform generate
