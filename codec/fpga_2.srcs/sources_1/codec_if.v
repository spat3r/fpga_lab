`timescale 1ns / 1ps

module codec_if
(
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
   
   output reg [ 1:0] aud_dout_vld,
   output     [23:0] aud_dout0,
   output     [23:0] aud_dout1,
   
   input      [ 1:0] aud_din_vld,
   output reg [ 1:0] aud_din_ack,
   input      [23:0] aud_din0,
   input      [23:0] aud_din1
);

// CODEC configuration
assign codec_m0      = 1'b1;
assign codec_m1      = 1'b1;
assign codec_i2s     = 1'b0;
assign codec_mdiv1   = 1'b1;
assign codec_mdiv2   = 1'b1;


// free running main counter
reg [19:0] div_cntr;




// clock generation based on main counter
assign codec_lrclk =
assign codec_sclk  =
assign codec_mclk  =

// clock falling & rising edge signals
wire sclk_fall;
wire sclk_rise;

// "virtual" bit counter
wire [ 4:0] bit_cntr;
assign bit_cntr     =


// reset during the first ~8 LRCLK periods
reg rst_ff;


      
assign codec_rstn = rst_ff;

// initializatin done after ~1045+8 LRLCK periods
reg init_done_ff;



// receive shift register 
reg  [23:0] shr_rx;




// parallel rx data valid: aud_dout_vld
//   0 during initialization
//   1 clock cycle pulse when the channel data is valid





// parallel output data = rx shift register
assign aud_dout0 = shr_rx;
assign aud_dout1 = shr_rx;


// transmit shift register
//    - 0 during initialization
//    - loads parallel data
//    - then shifst parallel data
reg  [23:0] shr_tx;





// serial output -> MSB of the tx shift register
assign codec_sdin = ;


// data acnowledge: aud_din_ack
//   1 clock cycle pulse when parallel data is written into the transmit shift register



 

endmodule
