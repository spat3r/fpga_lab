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

always @(posedge clk) begin
   if (rst)
      div_cntr <= 20'b0;
   else
      div_cntr <= div_cntr - 1;
end


// clock generation based on main counter
assign codec_lrclk = div_cntr[8];
assign codec_sclk  = div_cntr[2];
assign codec_mclk  = div_cntr[0];

// clock falling & rising edge signals
wire sclk_fall = (div_cntr[2:0] == 3'b111);
wire sclk_rise = (div_cntr[2:0] == 3'b011);

// "virtual" bit counter
wire [ 4:0] bit_cntr;
assign bit_cntr = div_cntr[7:3];


// reset during the first ~8 LRCLK periods
reg rst_ff;

always @(posedge clk) begin
   if (rst)
      rst_ff <= 1'b0;
   else if (div_cntr[12])
      rst_ff <= 1'b1;
end


assign codec_rstn = rst_ff;

// initializatin done after ~1045+8 LRLCK periods
reg init_done_ff;

always @(posedge clk) begin
   if (rst)
      init_done_ff <= 1'b0;
   else if (div_cntr[19:9] == (1045+8))
      init_done_ff <= 1'b1;
end


// receive shift register 
reg  [23:0] shr_rx;

always @(posedge clk) begin
   if (rst)
      shr_rx <= 24'b0;
   else
      shr_rx <= {shr_rx[22:1], codec_sdout};
end



// parallel rx data valid: aud_dout_vld
//   0 during initialization
//   1 clock cycle pulse when the channel data is valid

always @(posedge clk ) begin
   if (rst)
      aud_dout_vld <= 2'b00;
   else if (init_done_ff)
      if (sclk_rise == 1'b1  bit_cntr == 23 && codec_lrclk == 1'b0)
         aud_dout_vld[0] <= 1'b1;
      else
         aud_dout_vld[0] <= 1'b0;
   else
      if (sclk_rise == 1'b1  bit_cntr == 23 && codec_lrclk == 1'b1)
         aud_dout_vld[1] <= 1'b1;
      else
         aud_dout_vld[1] <= 1'b0;
end




// parallel output data = rx shift register
assign aud_dout0 = shr_rx;
assign aud_dout1 = shr_rx;


// transmit shift register
//    - 0 during initialization
//    - loads parallel data
//    - then shifst parallel data
reg  [23:0] shr_tx;

always @(posedge clk ) begin
   if (init_done_ff == 1'b1)
      if (sclk_fall == 1'b1)
         if (bit_cntr==31)
            if (codec_lrck == 1'b0)
               shr_tx <= aud_din1;
            else
               shr_tx <= aud_din0;
         else
            shr_tx <= {shr_tx[22:0], 1'b0};
end




// serial output -> MSB of the tx shift register
assign codec_sdin = ;


// data acnowledge: aud_din_ack
//   1 clock cycle pulse when parallel data is written into the transmit shift register



 

endmodule
