`timescale 1ns / 1ps

module tb_codec_if();

reg clk = 1;
reg rst = 1;
wire codec_mclk;
wire codec_sclk;
wire codec_lrclk;
wire codec_sdout;
wire codec_sdin;

wire [ 1:0] aud_dout_vld;
wire [23:0] aud_dout0;
wire [23:0] aud_dout1;

reg  [ 1:0] aud_din_vld = 2'b11;
wire [ 1:0] aud_din_ack;
wire [23:0] aud_din0;
wire [23:0] aud_din1;

codec_if uut
(
   .clk           (clk),
   .rst           (rst),
   
   .codec_m0      (),
   .codec_m1      (),
   .codec_i2s     (),
   .codec_mdiv1   (),
   .codec_mdiv2   (),
   .codec_rstn    (),
   .codec_mclk    (codec_mclk),
   .codec_lrclk   (codec_lrclk),
   .codec_sclk    (codec_sclk),
   .codec_sdin    (codec_sdin),
   .codec_sdout   (codec_sdout),
   
   .aud_dout_vld  (aud_dout_vld),
   .aud_dout0     (aud_dout0),
   .aud_dout1     (aud_dout1),
   
   .aud_din_vld   (aud_din_vld),
   .aud_din_ack   (aud_din_ack),
   .aud_din0      (aud_din0),
   .aud_din1      (aud_din1)
);


always #5
   clk <= ~clk;

initial
begin
   rst <= 1;
   #102 
   rst <= 0;
end

integer i;

// Generate single period of sine with 100 samples
reg [31:0] sine_array[99:0];
real PI = 3.14159265;
initial
begin
    for (i=0; i<100; i=i+1)
    begin
        sine_array[i] = (1<<30)*($sin(2*PI*i/100));
    end
end

// Generate a sawtooth waveform
reg [31:0] saw_array[41:0];
initial
begin
    for (i=0; i<42; i=i+1)
    begin
        saw_array[i] = (i-21)*(1<<24);
    end
end

/////////////////////////////////////////////////////////////
// ADC test data generation
reg  [ 4:0] adc_bit_cntr;
reg  [31:0] adc_data_cntr = 0;

// ADC bit counter, counts from MSB to LSB in each
//  LRCLK half periof
always @ (negedge codec_lrclk)
   adc_bit_cntr <= 5'b11111;
   
always @ (posedge codec_lrclk)   
   adc_bit_cntr <= 5'b11111;

always @ (negedge codec_sclk)
   adc_bit_cntr <= adc_bit_cntr - 1;

// ADC data counter, increments once in every LRCLK period
always @ (negedge codec_lrclk)
    adc_data_cntr <= adc_data_cntr + 1;

wire [31:0] adc_data_in;
assign adc_data_in = sine_array[adc_data_cntr%100];
assign codec_sdout = adc_data_in[adc_bit_cntr];

// ADC parallel output
//   saved into a register when valid
reg [23:0] adc_data[1:0];
always @ (negedge clk)
if (aud_dout_vld[0])
    adc_data[0] <= aud_dout0;

always @ (negedge clk)
if (aud_dout_vld[1])
    adc_data[1] <= aud_dout1;
    

/////////////////////////////////////////////////////////////
// DAC test data generation
//   word counter for the 2 channels, increments for every acknowledge
reg [31:0] dac_word_cntr[1:0];
initial
begin
    dac_word_cntr[0] = 0;
    dac_word_cntr[1] = 0;
end

always @ (negedge clk)
if (aud_din_ack[0])
    dac_word_cntr[0] <= dac_word_cntr[0] + 1;

always @ (negedge clk)
if (aud_din_ack[1])
    dac_word_cntr[1] <= dac_word_cntr[1] + 1;

// DAC interface parallel input data
assign aud_din0 = saw_array[dac_word_cntr[0]%42][31:8];
assign aud_din1 = saw_array[dac_word_cntr[1]%42][31:8];

// Bit counter, serial -> parallel conversion
reg [4:0] dac_bit_cntr;
always @ (negedge codec_lrclk)
   dac_bit_cntr <= 5'b11111;
   
always @ (posedge codec_lrclk)   
   dac_bit_cntr <= 5'b11111;
   
always @ (negedge codec_sclk)
   dac_bit_cntr <= dac_bit_cntr - 1;
   
reg [31:0] dac_data_ser;
always @ (negedge codec_sclk)
begin
    dac_data_ser[dac_bit_cntr] <= codec_sdin;
end

// Save parallel data @ LRCLK edge
reg [31:0] dac_data[1:0];
always @ (negedge codec_lrclk)
   dac_data[1] <= dac_data_ser;
   
always @ (posedge codec_lrclk)   
   dac_data[0] <= dac_data_ser;

endmodule
