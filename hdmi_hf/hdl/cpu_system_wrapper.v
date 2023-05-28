//Copyright 1986-2023 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2.2 (win64) Build 3788238 Tue Feb 21 20:00:34 MST 2023
//Date        : Mon May 29 00:00:02 2023
//Host        : LECSA running 64-bit major release  (build 9200)
//Command     : generate_target cpu_system_wrapper.bd
//Design      : cpu_system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module cpu_system_wrapper
   (btn_tri_i,
    clk_in,
    disp,
    fir_coef_data_0,
    fir_coef_write_0,
    hist_bin_data_0,
    hist_bin_ready_0,
    hist_bin_saved_0,
    led_tri_o,
    rstbt,
    sw,
    uart_rxd,
    uart_txd);
  input [3:0]btn_tri_i;
  input clk_in;
  output [11:0]disp;
  output [15:0]fir_coef_data_0;
  output fir_coef_write_0;
  input [15:0]hist_bin_data_0;
  input hist_bin_ready_0;
  output hist_bin_saved_0;
  output [23:0]led_tri_o;
  input rstbt;
  input [7:0]sw;
  input uart_rxd;
  output uart_txd;

  wire [3:0]btn_tri_i;
  wire clk_in;
  wire [11:0]disp;
  wire [15:0]fir_coef_data_0;
  wire fir_coef_write_0;
  wire [15:0]hist_bin_data_0;
  wire hist_bin_ready_0;
  wire hist_bin_saved_0;
  wire [23:0]led_tri_o;
  wire rstbt;
  wire [7:0]sw;
  wire uart_rxd;
  wire uart_txd;

  cpu_system cpu_system_i
       (.btn_tri_i(btn_tri_i),
        .clk_in(clk_in),
        .disp(disp),
        .fir_coef_data_0(fir_coef_data_0),
        .fir_coef_write_0(fir_coef_write_0),
        .hist_bin_data_0(hist_bin_data_0),
        .hist_bin_ready_0(hist_bin_ready_0),
        .hist_bin_saved_0(hist_bin_saved_0),
        .led_tri_o(led_tri_o),
        .rstbt(rstbt),
        .sw(sw),
        .uart_rxd(uart_rxd),
        .uart_txd(uart_txd));
endmodule
