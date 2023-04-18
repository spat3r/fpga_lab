`timescale 1ns / 1ps

module fir_filter(
      input clk,
      input rst,
      
      input [1:0] din_valid,
      input [23:0] din,
      
      output [1:0] dout_valid,
      output [23:0] dout
);

// vez�rl� �llapot (-> mem�ria c�mek �rv�nyesek):
//  0: nincs sz�r�s
//  1: akt�v sz�r�s
reg state;
// egy�tthat� c�msz�ml�l�
//  255...0 k�z�tt sz�mol, konvol�ci� kezdetekor 255-re �ll�tjuk
reg [7:0] coeff_addr_reg;



// feldolgoz�s alatt �ll� csatorna
// konvol�ci� kezdetekor elmentj�k, hogy melyik bemenet volt �rv�nyes
reg ch_act;



// akt�v sz�r�s (state) k�sleltet�se
reg [7:0] state_dl;


// egy�tthat� ROM c�m:
//   {akt�v csatorna, egy�tthat� c�msz�ml�l�}
wire [8:0] coeff_addr;


// minta �r�si c�msz�ml�l�
//   din_valid[1]-re inkrement�l
reg [7:0] smpl_wr_addr_reg;



// minta �r�si c�m
//   {input valid, c�msz�ml�l�}
wire [8:0] smpl_wr_addr;


// olvas�si c�msz�ml�l�
// smpl_wr_addr_reg_r�l indul �j minta �rkez�sekor, dekrement�l�dik
reg [7:0] smpl_rd_addr_reg;



// olvas�si c�m: {akt�v csatorna, c�msz�ml�l�}
wire [8:0] smpl_rd_addr;



// Mintat�r (24 bit sz�les)
// bementi mint�k: s.23
wire [23:0] smpl_ram_dout;
ram #(
   .DATA_W(24),
   .ADDR_W(9)
)
smpl_ram(
   .clk_a  (clk),
   .we_a   ((din_valid!=0)),
   .addr_a (smpl_wr_addr),
   .din_a  (din),
   .dout_a (),
   .clk_b  (clk),
   .we_b   (1'b0),
   .addr_b (smpl_rd_addr),
   .din_b  (36'b0),
   .dout_b (smpl_ram_dout)
);

// Egy�tthat� ROM
// egy�tthat�k: s.3.31
wire [34:0] coeff_rom_dout;
rom_512x35 coeff_rom(
   .clk  (clk),
   .addr (coeff_addr),
   .dout (coeff_rom_dout)
);

// r�szszorzat �rdekes r�sze:
// minta: 24 bit
// coeff: 35 bit
//    azaz:  59 bit
//  s.23*s.3.31 = s.4.54
wire signed [58:0] mul_res;
mul_24x35 mul_fir(
      .clk  (clk),
      .a    (smpl_ram_dout),
      .b    (coeff_rom_dout),
      .m    (mul_res)
);

// Accu reset: az els? �rv�nyes bemenet alatt
// Enged�lyez�s: amikor �rv�nyes a bemenete (state[1] k�sleltetve pipeline latency-vel)
wire accu_rst;
wire accu_en;



// Reset: az �rv�nyes bemenetet �rjuk be akkumul�l�s n�lk�l
// 256 db s.4.54 �sszege --> s.12.54 --> 67 bit
reg signed [66:0] accu;




// kimeneti form�tum: s.23,
//  accu eredm�ny-b�l lev�gjuk az als� 31 bitet, az ezt k�vet� 24 bit az �rv�nyes kimenet
//  kiv�ve ha t�lcsordul�s van, ekkor szatur�ci�:
//    - pozit�v: +0.999999 --> h7fffff
//    - negat�v: -1        --> h800000

//  Kimenet �rv�nyes: csatorna + accu_en lefut� �l
reg [23:0] dout_reg;
reg  [1:0] dout_valid_reg;




assign dout = dout_reg;
assign dout_valid = dout_valid_reg;

   
endmodule
