`timescale 1ns / 1ps

module fir_filter(
      input clk,
      input rst,
      
      input [1:0] din_valid,
      input [23:0] din,
      
      output [1:0] dout_valid,
      output [23:0] dout
);

// vezerlo allapot (-> memoria cimek ervenyesek):
//  0: nincs szures
//  1: aktiv szures
// egyutthato cimszamlalo
//  255...0 kozott szamol, konvolucio kezdetekor 255-re allitjuk
reg state;
reg [7:0] coeff_addr_reg;
always @ (posedge clk)
    if (rst)
        state <= 1'b0;
    else if (din_valid)
        state <= 1'b1;
    else if (coeff_addr_reg == 0)
        state <= 1'b0;

// feldolgozas alatt allo csatorna
// konvolucio kezdetekor elmentjuk, hogy melyik bemenet volt ervenyes
reg ch_act;
always @(posedge clk)
    if (din_valid)
        ch_act <= din_valid[1];

// aktiv szures (state) kesleltetese
reg [7:0] state_dl;
always @ (posedge clk)
    state_dl <= {state_dl[6:0], state};

// egyutthato ROM cim:
//   {aktiv csatorna, egyutthato cimszamlalo}
wire [8:0] coeff_addr;
assign coeff_addr = {ch_act, coeff_addr_reg};


// minta irasi cimszamlalo
//   din_valid[1]-re inkremental
reg [7:0] smpl_wr_addr_reg = 0;
always @ (posedge clk)
    if (din_valid[1])
        smpl_wr_addr_reg <= smpl_wr_addr_reg + 1'b1;


// minta irasi cim
//   {input valid, cimszamlalo}
wire [8:0] smpl_wr_addr;
assign smpl_wr_addr = {din_valid[1], smpl_wr_addr_reg};

// olvasasi cimszamlalo
// smpl_wr_addr_reg_rol indul uj minta erkezesekor, dekrementalodik
reg [7:0] smpl_rd_addr_reg;
always @ (posedge clk)
    if (din_valid)
        smpl_rd_addr_reg <= smpl_wr_addr_reg;
    else
        smpl_rd_addr_reg <= smpl_rd_addr_reg - 1'b1;


// olvasasi cim: {aktiv csatorna, cimszamlalo}
wire [8:0] smpl_rd_addr;
assign smpl_rd_addr = {ch_act, smpl_rd_addr_reg};


// Mintatar (24 bit szeles)
// bementi mintak: s.23
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

// Egyutthato ROM
// egyutthatok: s.3.31
wire [34:0] coeff_rom_dout;
rom_512x35 coeff_rom(
   .clk  (clk),
   .addr (coeff_addr),
   .dout (coeff_rom_dout)
);

// reszszorzat erdekes resze:
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

// Accu reset: az elso ervenyes bemenet alatt
// Engedelyezes: amikor ervenyes a bemenete (state[1] kesleltetve pipeline latency-vel)
wire accu_rst;
assign accu_rst = ~state_dl[4] & state_dl[5];
wire accu_en;
assign accu_en = state_dl[4];



// Reset: az ervenyes bemenetet irjuk be akkumulalas nelkul
// 256 db s.4.54 osszege --> s.12.54 --> 67 bit
reg signed [66:0] accu;

always @(posedge clk ) begin
   if (accu_rst) begin
      accu <= mul_res;
   end else if (accu_en) begin
      accu <= accu + mul_res;
   end
end



// kimeneti formatum: s.23,
//  accu eredmeny-bol levagjuk az also 31 bitet, az ezt koveto 24 bit az ervenyes kimenet
//  kiveve ha tulcsordulas van, ekkor szaturacio:
//    - pozitiv: +0.999999 --> h7fffff
//    - negativ: -1        --> h800000

//  Kimenet ervenyes: csatorna + accu_en lefuto el
reg [23:0] dout_reg;
reg  [1:0] dout_valid_reg;

always @( posedge clk ) begin
   dout_valid_reg[0] <= (ch_act==0 & state_dl[5:4]==2'b1);
   dout_valid_reg[1] <= (ch_act==1 & state_dl[5:4]==2'b1);
   if (!accu[66] & (|accu[65:54])) begin  // opcio (accu[66] == 0)  & (accu[65:54] != 0)
      dout_reg <= 'h7fffff;
   end else if (accu[66] & (&accu[65:53])) begin  // opcio (accu[66] != 0)  & (accu[65:54] == 0)
      dout_reg <= 'h800000;
   end else begin
      dout_reg <= {accu[66], accu[53:30]};
   end
end



assign dout = dout_reg;
assign dout_valid = dout_valid_reg;

   
endmodule
