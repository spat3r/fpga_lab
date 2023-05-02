`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2019 04:56:58 PM
// Design Name: 
// Module Name: hdmi_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hdmi_top(
   input  logic       clk100M,
   input  logic       rstbt,
   output logic [7:0] led_r,
   input  logic [7:0] sw,
   inout  logic [3:0] bt,
   
   input  logic       hdmi_rx_d0_p,
   input  logic       hdmi_rx_d0_n,
   input  logic       hdmi_rx_d1_p,
   input  logic       hdmi_rx_d1_n,
   input  logic       hdmi_rx_d2_p,
   input  logic       hdmi_rx_d2_n,
   input  logic       hdmi_rx_clk_p,
   input  logic       hdmi_rx_clk_n,
   input  logic       hdmi_rx_cec,
   output logic       hdmi_rx_hpd,
   input  logic       hdmi_rx_scl,
   inout  logic       hdmi_rx_sda,
   
   output logic       hdmi_tx_d0_p,
   output logic       hdmi_tx_d0_n,
   output logic       hdmi_tx_d1_p,
   output logic       hdmi_tx_d1_n,
   output logic       hdmi_tx_d2_p,
   output logic       hdmi_tx_d2_n,
   output logic       hdmi_tx_clk_p,
   output logic       hdmi_tx_clk_n,
   input  logic       hdmi_tx_cec,
   input  logic       hdmi_tx_hpdn,
   input  logic       hdmi_tx_scl,
   input  logic       hdmi_tx_sda
);

//******************************************************************************
//* Generating the 200 MHz reference clock for the IDELAYCTRL.                 *
//******************************************************************************
logic clk200M;
logic pll_clkfb;
logic pll_locked;

PLLE2_BASE #(
   .BANDWIDTH("OPTIMIZED"),         // OPTIMIZED, HIGH, LOW
   .CLKFBOUT_MULT(10),              // Multiply value for all CLKOUT, (2-64)
   .CLKFBOUT_PHASE(0.0),            // Phase offset in degrees of CLKFB, (-360.000-360.000).
   .CLKIN1_PERIOD(1000.0 / 100.0),  // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
   .CLKOUT0_DIVIDE(5),              // CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for each CLKOUT (1-128)
   .CLKOUT1_DIVIDE(1),
   .CLKOUT2_DIVIDE(1),
   .CLKOUT3_DIVIDE(1),
   .CLKOUT4_DIVIDE(1),
   .CLKOUT5_DIVIDE(1),
   .CLKOUT0_DUTY_CYCLE(0.5),        // CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for each CLKOUT (0.001-0.999).
   .CLKOUT1_DUTY_CYCLE(0.5),
   .CLKOUT2_DUTY_CYCLE(0.5),
   .CLKOUT3_DUTY_CYCLE(0.5),
   .CLKOUT4_DUTY_CYCLE(0.5),
   .CLKOUT5_DUTY_CYCLE(0.5),
   .CLKOUT0_PHASE(0.0),             // CLKOUT0_PHASE - CLKOUT5_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
   .CLKOUT1_PHASE(0.0),
   .CLKOUT2_PHASE(0.0),
   .CLKOUT3_PHASE(0.0),
   .CLKOUT4_PHASE(0.0),
   .CLKOUT5_PHASE(0.0),
   .DIVCLK_DIVIDE(1),               // Master division value, (1-56)
   .REF_JITTER1(0.0),               // Reference input jitter in UI, (0.000-0.999).
   .STARTUP_WAIT("FALSE")           // Delay DONE until PLL Locks, ("TRUE"/"FALSE")
   ) clk_generator1 (
   .CLKOUT0(clk200M),               // 1-bit output: CLKOUT0
   .CLKOUT1(),                      // 1-bit output: CLKOUT1
   .CLKOUT2(),                      // 1-bit output: CLKOUT2
   .CLKOUT3(),                      // 1-bit output: CLKOUT3
   .CLKOUT4(),                      // 1-bit output: CLKOUT4
   .CLKOUT5(),                      // 1-bit output: CLKOUT5
   .CLKFBOUT(pll_clkfb),            // 1-bit output: Feedback clock
   .LOCKED(pll_locked),             // 1-bit output: LOCK
   .CLKIN1(clk100M),                // 1-bit input: Input clock
   .PWRDWN(1'b0),                   // 1-bit input: Power-down
   .RST(rstbt),                     // 1-bit input: Reset
   .CLKFBIN(pll_clkfb)              // 1-bit input: Feedback clock
);

logic rst;
assign rst = ~pll_locked;

logic clk_200M;
BUFG BUFG_200M (
   .O(clk_200M),
   .I(clk200M)
);



logic rx_clk, rx_clk_5x;
logic [5:0] rx_status;
logic [7:0] rx_red, rx_green, rx_blue;
logic [7:0] tx_red, tx_green, tx_blue;
logic [7:0] red_o, green_o, blue_o;
logic rx_dv, rx_hs, rx_vs;
logic tx_dv, tx_hs, tx_vs;
logic dv_y, hs_y, vs_y;
logic dv_gb, hs_gb, vs_gb;
logic dv_bb, hs_bb, vs_bb;
logic dv_cnv, hs_cnv, vs_cnv;
logic dv_blur, hs_blur, vs_blur;
logic line_end_gb, line_end_blur;
logic [23:0] rgb_i;
logic [7:0] gamma_o;

assign rgb_i = { rx_red, rx_green, rx_blue};

hdmi_rx hdmi_rx_0(
   .clk_200M(clk_200M),
   .rst(rst),
   .hdmi_rx_cec(hdmi_rx_cec),
   .hdmi_rx_hpd(hdmi_rx_hpd),
   .hdmi_rx_scl(hdmi_rx_scl),
   .hdmi_rx_sda(hdmi_rx_sda),
   .hdmi_rx_clk_p(hdmi_rx_clk_p),
   .hdmi_rx_clk_n(hdmi_rx_clk_n),
   .hdmi_rx_d0_p(hdmi_rx_d0_p),
   .hdmi_rx_d0_n(hdmi_rx_d0_n),
   .hdmi_rx_d1_p(hdmi_rx_d1_p),
   .hdmi_rx_d1_n(hdmi_rx_d1_n),
   .hdmi_rx_d2_p(hdmi_rx_d2_p),
   .hdmi_rx_d2_n(hdmi_rx_d2_n),
   .rx_clk(rx_clk),
   .rx_clk_5x(rx_clk_5x),
   .rx_red(rx_red),
   .rx_green(rx_green),
   .rx_blue(rx_blue),
   .rx_dv(rx_dv),
   .rx_hs(rx_hs),
   .rx_vs(rx_vs),
   .rx_status(rx_status)
);

// loopback

always_comb begin
   tx_dv    <= dv_gb;
   tx_hs    <= hs_gb;
   tx_vs    <= vs_gb;
   tx_red   <= gamma_o;
   tx_green <= gamma_o;
   tx_blue  <= gamma_o;
end



// logic dv_rgb_o;
// logic line_end_gb;
// logic line_end_blur;
// logic [7:0] gb_line_o [2:0];

rgb2y_3 #(
    .COLORDEPTH(8)
    ) rgb2y_inst (
    .clk            (clk),
    .rst            (rst),
    .rgb_i          (rgb_i),
    .gamma_o        (gamma_o),
    .dv_i           (rx_dv),
    .hs_i           (rx_hs),
    .vs_i           (rx_vs),
    .dv_o           (dv_y),
    .hs_o           (hs_y),
    .vs_o           (vs_y),
    .line_end_o     (line_end_gb)
);

// buffer #(
//     .COLORDEPTH(8)
//    ) gray_buff_inst (
//     .clk            (clk),
//     .rst            (rst),
//     .data_i         (data_i),
//     .dv_i           (dv_y),
//     .hs_i           (hs_y),
//     .vs_i           (vs_y),
//     .dv_o           (dv_gb),
//     .hs_o           (hs_gb),
//     .vs_o           (vs_gb),
//     .line_end_i     (line_end_gb),
//     .buff_o         (gb_line_o)
// );

// convolution #(
//     .COLORDEPTH(8)
// ) blur_inst (
//     .clk            (clk),
//     .rst            (rst),
//     .vect_in        (gb_line_o),
//     .conv_o         (conv_o),
//     .dv_i           (dv_gb),
//     .hs_i           (hs_gb),
//     .vs_i           (vs_gb),
//     .dv_o           (dv_blur),
//     .hs_o           (hs_blur),
//     .vs_o           (vs_blur),
//     .line_end_o     (line_end_blur)
// );


hdmi_tx hdmi_tx_0(
   .tx_clk(rx_clk),
   .tx_clk_5x(rx_clk_5x),
   .rst(rst),
   .tx_red(tx_red),
   .tx_green(tx_green),
   .tx_blue(tx_blue),
   .tx_dv(tx_dv),
   .tx_hs(tx_hs),
   .tx_vs(tx_vs),
   .hdmi_tx_clk_p(hdmi_tx_clk_p),
   .hdmi_tx_clk_n(hdmi_tx_clk_n),
   .hdmi_tx_d0_p(hdmi_tx_d0_p),
   .hdmi_tx_d0_n(hdmi_tx_d0_n),
   .hdmi_tx_d1_p(hdmi_tx_d1_p),
   .hdmi_tx_d1_n(hdmi_tx_d1_n),
   .hdmi_tx_d2_p(hdmi_tx_d2_p),
   .hdmi_tx_d2_n(hdmi_tx_d2_n)
);

assign led_r = {pll_locked, 1'b0, rx_status};

endmodule
