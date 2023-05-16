//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2.1 (win64) Build 3719031 Thu Dec  8 18:35:04 MST 2022
//Date        : Tue May 16 00:07:19 2023
//Host        : rtlaptop running 64-bit major release  (build 9200)
//Command     : generate_target cpu_system_wrapper.bd
//Design      : cpu_system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module cpu_system_wrapper
   (btn_tri_i,
    clk_in,
    disp_tri_o,
    led_tri_o,
    rstbt,
    sw,
    uart_rxd,
    uart_txd);
  input [3:0]btn_tri_i;
  input clk_in;
  output [11:0]disp_tri_o;
  output [23:0]led_tri_o;
  input rstbt;
  input [7:0]sw;
  input uart_rxd;
  output uart_txd;

  wire [3:0]btn_tri_i;
  wire clk_in;
  wire [11:0]disp_tri_o;
  wire [23:0]led_tri_o;
  wire rstbt;
  wire [7:0]sw;
  wire uart_rxd;
  wire uart_txd;

  cpu_system cpu_system_i
       (.btn_tri_i(btn_tri_i),
        .clk_in(clk_in),
        .disp_tri_o(disp_tri_o),
        .led_tri_o(led_tri_o),
        .rstbt(rstbt),
        .sw(sw),
        .uart_rxd(uart_rxd),
        .uart_txd(uart_txd));
endmodule
