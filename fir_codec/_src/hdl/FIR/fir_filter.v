`timescale 1ns / 1ps

module fir_filter(
      input clk,
      input rst,
      
      input [1:0] din_valid,
      input [23:0] din,
      
      output [1:0] dout_valid,
      output [23:0] dout
);

// vezérlő állapot (-> memória címek érvényesek):
//  0: nincs szűrés
//  1: aktív szűrés
// együttható címszámláló
//  255...0 között számol, konvolúció kezdetekor 255-re állítjuk
reg state;
reg [7:0] coeff_addr_reg;
always @ (posedge clk)
    if (rst)
        state <= 1'b0;
    else if (din_valid)
        state <= 1'b1;
    else if (coeff_addr_reg == 0)
        state <= 1'b0;

// feldolgozás alatt álló csatorna
// konvolúció kezdetekor elmentjük, hogy melyik bemenet volt érvényes
reg ch_act;
always @(posedge clk)
    if (din_valid)
        ch_act <= din_valid[1];

// aktív szűrés (state) késleltetése
reg [7:0] state_dl;
always @ (posedge clk)
    state_dl <= {state_dl[6:0], state};

// együttható ROM cím:
//   {aktív csatorna, együttható címszámláló}
wire [8:0] coeff_addr;
assign coeff_addr = {ch_act, coeff_addr_reg};


// minta írási címszámláló
//   din_valid[1]-re inkrementál
reg [7:0] smpl_wr_addr_reg = 0;
always @ (posedge clk)
    if (din_valid[1])
        smpl_wr_addr_reg <= smpl_wr_addr_reg + 1'b1;


// minta írási cím
//   {input valid, címszámláló}
wire [8:0] smpl_wr_addr;
assign smpl_wr_addr = {din_valid[1], smpl_wr_addr_reg};

// olvasási címszámláló
// smpl_wr_addr_reg_ről indul új minta érkezésekor, dekrementálódik
reg [7:0] smpl_rd_addr_reg;
always @ (posedge clk)
    if (din_valid)
        smpl_rd_addr_reg <= smpl_wr_addr_reg;
    else
        smpl_rd_addr_reg <= smpl_rd_addr_reg - 1'b1;


// olvasási cím: {aktív csatorna, címszámláló}
wire [8:0] smpl_rd_addr;
assign smpl_rd_addr = {ch_act, smpl_rd_addr_reg};


// Mintatár (24 bit széles)
// bementi minták: s.23
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

// Együttható ROM
// együtthatók: s.3.31
wire [34:0] coeff_rom_dout;
rom_512x35 coeff_rom(
   .clk  (clk),
   .addr (coeff_addr),
   .dout (coeff_rom_dout)
);

// részszorzat érdekes része:
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

// Accu reset: az els? érvényes bemenet alatt
// Engedélyezés: amikor érvényes a bemenete (state[1] késleltetve pipeline latency-vel)
wire accu_rst;
wire accu_en;



// Reset: az érvényes bemenetet írjuk be akkumulálás nélkül
// 256 db s.4.54 összege --> s.12.54 --> 67 bit
reg signed [66:0] accu;




// kimeneti formátum: s.23,
//  accu eredmény-ből levágjuk az alsó 31 bitet, az ezt követő 24 bit az érvényes kimenet
//  kivéve ha túlcsordulás van, ekkor szaturáció:
//    - pozitív: +0.999999 --> h7fffff
//    - negatív: -1        --> h800000

//  Kimenet érvényes: csatorna + accu_en lefutó él
reg [23:0] dout_reg;
reg  [1:0] dout_valid_reg;




assign dout = dout_reg;
assign dout_valid = dout_valid_reg;

   
endmodule
