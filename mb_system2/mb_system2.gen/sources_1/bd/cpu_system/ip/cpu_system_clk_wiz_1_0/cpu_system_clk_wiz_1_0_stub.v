// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2.1 (win64) Build 3719031 Thu Dec  8 18:35:04 MST 2022
// Date        : Tue May 16 00:14:40 2023
// Host        : rtlaptop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/Egyetem/fpga_alapu_rendszerek/mb_system2/mb_system2.gen/sources_1/bd/cpu_system/ip/cpu_system_clk_wiz_1_0/cpu_system_clk_wiz_1_0_stub.v
// Design      : cpu_system_clk_wiz_1_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k70tfbg676-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module cpu_system_clk_wiz_1_0(clk_out1, reset, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,reset,locked,clk_in1" */;
  output clk_out1;
  input reset;
  output locked;
  input clk_in1;
endmodule
