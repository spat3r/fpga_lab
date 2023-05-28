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
   output logic [23:0] led_r,
   input  logic [7:0] sw,
   inout  logic [3:0] bt,
   input logic [11:0] disp,
   input logic        uart_rxd,
   output logic        uart_txd,

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

   // TODO: add ports for axi registers
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
logic rx_dv, rx_hs, rx_vs;
logic tx_dv, tx_hs, tx_vs;

logic        irq;
logic        fir_coef_write;
logic [15:0] fir_coef_data;
logic [15:0] hist_bin_data;
logic        hist_bin_saved;
logic        hist_bin_ready;

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

cpu_system_wrapper cpu_inst(
   .btn_tri_i        ( bt             ),
   .clk_in           ( clk100M        ),
   .disp             ( disp           ),
   .led_tri_o        ( led_r          ),
   .rstbt            ( rstbt          ),
   .sw               ( sw             ),
   .uart_rxd         ( uart_rxd       ),
   .uart_txd         ( uart_txd       ),
   .fir_coef_write_0 ( fir_coef_write ),
   .fir_coef_data_0  ( fir_coef_data  ),
   .hist_bin_data_0  ( hist_bin_data  ),
   .hist_bin_saved_0 ( hist_bin_saved ),
   .hist_bin_ready_0 ( hist_bin_ready )
);



    // TODO: Instanciate fir_axi_if.sv


    // TODO: Instanuciate hdmi_top.sv
//FIXME: a pixel órajel miatt a microblaze másik órajeltartományban lesz.

    // TODO: reading histogram bins


    // TODO: writing fir parameters

    // TODO: szerintem az axi regiszterek itt legyenek implementálva és az almodulok csak hozzáférnek vezetékeken keresztül
                // biztosan egy vezetékezési kín lesz de nem tudom hogy lehet optimálisan megoldani

sobel_top #(
    ) sobel_top_inst (
         .clk(rx_clk),
         .rst(rst),
         .sw(sw),
         .red_i(rx_red),
         .green_i(rx_green),
         .blue_i(rx_blue),
         .red_o(tx_red),
         .green_o(tx_green),
         .blue_o(tx_blue),
         .dv_i(rx_dv),
         .hs_i(rx_hs),
         .vs_i(rx_vs),
         .dv_o(tx_dv),
         .hs_o(tx_hs),
         .vs_o(tx_vs),
         .fir_coef_write ( fir_coef_write ),
         .fir_coef_data  ( fir_coef_data  ),
         .hist_bin_data  ( hist_bin_data  ),
         .hist_bin_saved ( hist_bin_saved ),
         .hist_bin_ready ( hist_bin_ready )
         // TODO: add ports for axi registers
    );

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
