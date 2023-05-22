`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2018 09:38:16 AM
// Design Name: 
// Module Name: top_level
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


module top_level(
    input             clk,
    input             rst,
    
    output            codec_m0,
    output            codec_m1,
    output            codec_i2s,
    output            codec_mdiv1,
    output            codec_mdiv2,
    
    output            codec_rstn,
    output            codec_mclk,
    output            codec_lrclk,
    output            codec_sclk,
    output            codec_sdin,
    input             codec_sdout,
    
    input             bt3,
    input             sw0,
    output            vol_clk,
    output            vol_ud
);


assign vol_clk = bt3;
assign vol_ud  = sw0;

wire clk_pll0;
wire clk_pll_fb;
wire pll_locked;
MMCME2_BASE #(
    .BANDWIDTH("OPTIMIZED"),   // Jitter programming (OPTIMIZED, HIGH, LOW)
    .CLKFBOUT_MULT_F(10.0),     // Multiply value for all CLKOUT (2.000-64.000).
    .CLKFBOUT_PHASE(0.0),      // Phase offset in degrees of CLKFB (-360.000-360.000).
    .CLKIN1_PERIOD(10.0),       // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
    // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
    .CLKOUT1_DIVIDE(1),
    .CLKOUT2_DIVIDE(1),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT0_DIVIDE_F(5.0),    // Divide amount for CLKOUT0 (1.000-128.000).
    // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
    .CLKOUT0_DUTY_CYCLE(0.5),
    .CLKOUT1_DUTY_CYCLE(0.5),
    .CLKOUT2_DUTY_CYCLE(0.5),
    .CLKOUT3_DUTY_CYCLE(0.5),
    .CLKOUT4_DUTY_CYCLE(0.5),
    .CLKOUT5_DUTY_CYCLE(0.5),
    .CLKOUT6_DUTY_CYCLE(0.5),
    // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
    .CLKOUT0_PHASE(0.0),
    .CLKOUT1_PHASE(0.0),
    .CLKOUT2_PHASE(0.0),
    .CLKOUT3_PHASE(0.0),
    .CLKOUT4_PHASE(0.0),
    .CLKOUT5_PHASE(0.0),
    .CLKOUT6_PHASE(0.0),
    .CLKOUT4_CASCADE("FALSE"), // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
    .DIVCLK_DIVIDE(1),         // Master division value (1-106)
    .REF_JITTER1(0.0),         // Reference input jitter in UI (0.000-0.999).
    .STARTUP_WAIT("FALSE")     // Delays DONE until MMCM is locked (FALSE, TRUE)
)
MMCME2_BASE_inst (
    // Clock Outputs: 1-bit (each) output: User configurable clock outputs
    .CLKOUT0(clk_pll0),     // 1-bit output: CLKOUT0
    .CLKOUT0B(),   // 1-bit output: Inverted CLKOUT0
    .CLKOUT1(),     // 1-bit output: CLKOUT1
    .CLKOUT1B(),   // 1-bit output: Inverted CLKOUT1
    .CLKOUT2(),     // 1-bit output: CLKOUT2
    .CLKOUT2B(),   // 1-bit output: Inverted CLKOUT2
    .CLKOUT3(),     // 1-bit output: CLKOUT3
    .CLKOUT3B(),   // 1-bit output: Inverted CLKOUT3
    .CLKOUT4(),     // 1-bit output: CLKOUT4
    .CLKOUT5(),     // 1-bit output: CLKOUT5
    .CLKOUT6(),     // 1-bit output: CLKOUT6
    // Feedback Clocks: 1-bit (each) output: Clock feedback ports
    .CLKFBOUT(clk_pll_fb),   // 1-bit output: Feedback clock
    .CLKFBOUTB(), // 1-bit output: Inverted CLKFBOUT
    // Status Ports: 1-bit (each) output: MMCM status ports
    .LOCKED(pll_locked),       // 1-bit output: LOCK
    // Clock Inputs: 1-bit (each) input: Clock input
    .CLKIN1(clk),       // 1-bit input: Clock
    // Control Ports: 1-bit (each) input: MMCM control ports
    .PWRDWN(1'b0),       // 1-bit input: Power-down
    .RST(rst),             // 1-bit input: Reset
    // Feedback Clocks: 1-bit (each) input: Clock feedback ports
    .CLKFBIN(clk_pll_fb)      // 1-bit input: Feedback clock
);

wire clk_200;
BUFG BUFG_inst (
    .O(clk_200), // 1-bit output: Clock output
    .I(clk_pll0)  // 1-bit input: Clock input
);

reg [7:0] rst_shr;
always @ (posedge clk_200, negedge pll_locked)
if (~pll_locked)
    rst_shr <= 8'hFF;
else
    rst_shr <= {rst_shr[6:0], 1'b0};

wire rst_sync;
assign rst_sync = rst_shr[7];

wire [ 1:0] aud_dout_vld;
wire [23:0] aud_dout;
reg  [23:0] aud_din0;
reg  [23:0] aud_din1;
codec_if I2S_IF_I
(
   .clk           (clk_200),
   .rst           (rst_sync),
   
   .codec_m0      (codec_m0),
   .codec_m1      (codec_m1),
   .codec_i2s     (codec_i2s),
   .codec_mdiv1   (codec_mdiv1),
   .codec_mdiv2   (codec_mdiv2),
   .codec_rstn    (codec_rstn),
   .codec_mclk    (codec_mclk),
   .codec_lrclk   (codec_lrclk),
   .codec_sclk    (codec_sclk),
   .codec_sdin    (codec_sdin),
   .codec_sdout   (codec_sdout),
   
   .aud_dout_vld  (aud_dout_vld),
   .aud_dout      (aud_dout),
   
   .aud_din_vld   (2'b11),
   .aud_din_ack   (),
   .aud_din0      (aud_din0),
   .aud_din1      (aud_din1)
);

wire [23:0] fir_dout;
wire [1:0] fir_valid; 
fir_filter FIR_I(
    .clk(clk_200),
    .rst(rst_sync),
    .din_valid(aud_dout_vld),
    .din(aud_dout),
 
    .dout_valid(fir_valid),
    .dout(fir_dout)
);

always @ (posedge clk_200)
if (fir_valid[0]==1)
   aud_din0 <= fir_dout;

always @ (posedge clk_200)
if (fir_valid[1]==1)
   aud_din1 <= fir_dout;
    
endmodule
