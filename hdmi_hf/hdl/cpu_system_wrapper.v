//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
//Date        : Wed May 31 00:10:01 2023
//Host        : speti running 64-bit major release  (build 9200)
//Command     : generate_target cpu_system_wrapper.bd
//Design      : cpu_system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module cpu_system_wrapper
   (axi_rd_ack_i_0,
    axi_rd_strobe_o_0,
    axi_wr_ack_i_0,
    axi_wr_strobe_o_0,
    btn_tri_i,
    clk_in,
    disp,
    fir_addr_from_axi_0,
    fir_coeff_from_axi_0,
    hist_bin_data_0,
    hist_bin_ready_0,
    hist_bin_to_axi_0,
    led_tri_o,
    rstbt,
    sw,
    uart_rxd,
    uart_txd);
  input axi_rd_ack_i_0;
  output axi_rd_strobe_o_0;
  input axi_wr_ack_i_0;
  output axi_wr_strobe_o_0;
  input [3:0]btn_tri_i;
  input clk_in;
  output [11:0]disp;
  output [7:0]fir_addr_from_axi_0;
  output [31:0]fir_coeff_from_axi_0;
  input [15:0]hist_bin_data_0;
  input hist_bin_ready_0;
  input [31:0]hist_bin_to_axi_0;
  output [23:0]led_tri_o;
  input rstbt;
  input [7:0]sw;
  input uart_rxd;
  output uart_txd;

  wire axi_rd_ack_i_0;
  wire axi_rd_strobe_o_0;
  wire axi_wr_ack_i_0;
  wire axi_wr_strobe_o_0;
  wire [3:0]btn_tri_i;
  wire clk_in;
  wire [11:0]disp;
  wire [7:0]fir_addr_from_axi_0;
  wire [31:0]fir_coeff_from_axi_0;
  wire [15:0]hist_bin_data_0;
  wire hist_bin_ready_0;
  wire [31:0]hist_bin_to_axi_0;
  wire [23:0]led_tri_o;
  wire rstbt;
  wire [7:0]sw;
  wire uart_rxd;
  wire uart_txd;

  cpu_system cpu_system_i
       (.axi_rd_ack_i_0(axi_rd_ack_i_0),
        .axi_rd_strobe_o_0(axi_rd_strobe_o_0),
        .axi_wr_ack_i_0(axi_wr_ack_i_0),
        .axi_wr_strobe_o_0(axi_wr_strobe_o_0),
        .btn_tri_i(btn_tri_i),
        .clk_in(clk_in),
        .disp(disp),
        .fir_addr_from_axi_0(fir_addr_from_axi_0),
        .fir_coeff_from_axi_0(fir_coeff_from_axi_0),
        .hist_bin_data_0(hist_bin_data_0),
        .hist_bin_ready_0(hist_bin_ready_0),
        .hist_bin_to_axi_0(hist_bin_to_axi_0),
        .led_tri_o(led_tri_o),
        .rstbt(rstbt),
        .sw(sw),
        .uart_rxd(uart_rxd),
        .uart_txd(uart_txd));
endmodule
