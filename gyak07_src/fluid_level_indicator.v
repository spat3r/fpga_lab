`timescale 1ns / 1ps
`default_nettype none

//******************************************************************************
//* folyadekszint jelz_ perif_ria.                                             *
//*                                                                            *
//*  ------------     ----                                                     *
//* |          O-|-->|    |                                                    *
//* |          O-|-->|    | folyadekszint                                      *
//* |          O-|-->|    |     (0-8)       ------------                       *
//* |~~~~~~~~~~O-|-->|    |/--------------\| MicroBlaze |                      *
//* |~~~~~~~~~~O-|-->|    |\--------------/| CPU        |                      *
//* |~~~~~~~~~~O-|-->|    |    AXI4-Lite    ------------                       *
//* |~~~~~~~~~~O-|-->|    |                                                    *
//* |~~~~~~~~~~O-|-->|    |                                                    *
//*  ------------     ----                                                     *
//*    tartaly      perif_ria                                                  *
//******************************************************************************
module fluid_level_indicator(
    //_rajel _s reset.
    input  wire        clk,         //100 MHz rendszer_rajel
    input  wire        rst,         //Akt_v magas szinkron reset
    
    //Regiszter _r_si interf_sz.
    input  wire [3:0]  wr_addr,     //_r_si c_m
    input  wire        wr_en,       //_r_s enged_lyez_ jel
    input  wire [31:0] wr_data,     //_r_si adat
    input  wire [3:0]  wr_strb,     //B_jt enged_lyez_ jelek
    
    //Regiszter olvas_si interf_sz.
    input  wire [3:0]  rd_addr,     //Olvas_si c_m
    input  wire        rd_en,       //Olvas_s enged_lyez_ jel
    output reg  [31:0] rd_data,     //Olvas_si adat      
    
    //Adat a folyad_k _rz_kel_kt_l.
    input  wire [7:0]  sensor_in,
    
    //Megszak_t_sk_r_ kimenet.
    output wire        irq
);

//******************************************************************************
//* A szenzor bemeneteket 10 Hz frekvenci_val mintav_telezz_k. Az _temez_ jel  *
//* egy 24 bites sz_ml_l_val _ll_that_ el_ (9999999 - 0 => 24 bit).            *
//******************************************************************************
reg  [23:0] clk_div;
wire        clk_div_tc = (clk_div == 24'd0);

always @(posedge clk)
    if (rst)
        clk_div <= 24'd9_999_999;
    else if (clk_div_tc)
        clk_div <= 24'd9_999_999;
    else clk_div <= clk_div - 24'd1;

reg [7:0] sensor_reg;

always @(posedge clk) begin
    if (clk_div_tc) sensor_reg <= sensor_in;
end

//******************************************************************************
//* A szenzor bemenet alapj_n a folyadekszintet egy priorit_s enk_derrel       *
//* _ll_thatjuk el_. A legnagyobb sorsz_m_ akt_v bit hat_rozza meg a           *
//* folyadekszint _rt_k_t.                                                     *
//******************************************************************************
reg [3:0] fluid_level;

always @(posedge clk)
    casex (sensor_reg)
        8'b1XXX_XXXX: fluid_level <= 4'd8;
        8'b01xx_XXXX: fluid_level <= 4'd7;
        8'b001x_xXXX: fluid_level <= 4'd6;
        8'b0001_XXXX: fluid_level <= 4'd5;
        8'b0000_1XXX: fluid_level <= 4'd4;
        8'b0000_01XX: fluid_level <= 4'd3;
        8'b0000_001X: fluid_level <= 4'd2;
        8'b0000_0001: fluid_level <= 4'd1;
        8'b0000_0000: fluid_level <= 4'd0;
    endcase

//******************************************************************************
//* A hibajelz_s el__ll_t_sa. _rv_nyes a szenzor bemeneten l_v_ adat, ha       *
//* a legnagyobb sorsz_m_ akt_v bemeneti bit alatti _sszes bit is akt_v.       *
//******************************************************************************
reg error;

always @(posedge clk)
case (sensor_reg)
    8'b1111_1111: error <= 1'b0;
    8'b0111_1111: error <= 1'b0;
    8'b0011_1111: error <= 1'b0;
    8'b0001_1111: error <= 1'b0;
    8'b0000_1111: error <= 1'b0;
    8'b0000_0111: error <= 1'b0;
    8'b0000_0011: error <= 1'b0;
    8'b0000_0001: error <= 1'b0;
    8'b0000_0000: error <= 1'b0;
    default: error <= 1'b1;
endcase

//******************************************************************************
//* A regiszterek _r_si _s olvas_si enged_lyez_ jeleinek el__ll_t_sa.          *
//*                                                                            *
//* folyadekszint regiszter     : BASEADDR+0x00, 32 bites, RD                  *
//* Megszak_t_s enged_lyez_ reg.: BASEADDR+0x04, 32 bites, R/W                 *
//* Megszak_t_s flag regiszter  : BASEADDR+0x08, 32 bites, R/W1C               *
//******************************************************************************
//A folyadekszint regiszter olvas_s enged_lyez_ jele.
wire lvl_rd = rd_en & (rd_addr[3:2]==2'd0);

//A megszak_t_s enged_lyez_ regiszter _r_s _s olvas_s enged_lyez_ jele.
wire ier_wr = wr_en & (wr_addr[3:2]==2'd1) & (wr_strb == 4'hF);
wire ier_rd = rd_en & (rd_addr[3:2]==2'd1);

//A megszak_t_s flag regiszter _r_s _s olvas_s enged_lyez_ jele.
wire ifr_wr = wr_en & (wr_addr[3:2]==2'd2) & (wr_strb == 4'hF);
wire ifr_rd = rd_en & (rd_addr[3:2]==2'd2);

//******************************************************************************
//* folyadekszint regiszter: BASEADDR+0x00, 32 bites, csak olvashat_           *
//*                                                                            *
//*    31    30          4     3     2     1     0                             *
//*  -----------------------------------------------                           *
//* |ERROR|  0   ....    0  |  folyadekszint (0-8)  |                          *
//*  -----------------------------------------------                           * 
//******************************************************************************
wire [31:0] lvl;

assign lvl[3:0]  = fluid_level;
assign lvl[30:4] = 27'b0;
assign lvl[31]   = error;

//******************************************************************************
//* Megszak_t_s enged_lyez_ reg.: BASEADDR+0x04, 32 bites, _rhat_/olvashat_    *
//*                                                                            *
//*    31          5     4     3     2     1     0                             *
//*  -----------------------------------------------                           *
//* |  x    ....   x     x    x   |ERROR|EMPTY| FULL|                          *
//*  -----------------------------------------------                           *
//******************************************************************************
reg [2:0] ier;

always @(posedge clk)
    if (rst)
        ier <= 3'b0;
    else if (ier_wr)
        ier <= wr_data[2:0];

//******************************************************************************
//* Megszak_t_s flag regiszter: BASEADDR+0x08, 32 bites, olvashat_ _s a jelz_s *
//*                             '1' be_r_s_val t_r_lhet_                       *
//*                                                                            *
//*    31          5     4     3     2     1     0                             *
//*  -----------------------------------------------                           *
//* |  x    ....   x     x    x   |ERROR|EMPTY| FULL|                          *
//*  -----------------------------------------------                           *
//******************************************************************************
//Mintav_telez_s a felfut_ _l detekt_l_s_hoz.
reg [1:0] lvl8_samples;
reg [1:0] lvl0_samples;
reg [1:0] err_samples;

always @(posedge clk)
    if (rst) begin
        lvl8_samples <= 2'b11;
        lvl0_samples <= 2'b11; 
        err_samples <= 2'b11;
    end else begin
        lvl8_samples <= {lvl8_samples [0], (fluid_level == 4'd8)};
        lvl0_samples <= {lvl8_samples [0], (fluid_level == 4'd0)};
        err_samples <= {err_samples[0], error};
    end

reg  [2:0] ifr;
wire [2:0] ifr_set;

//A tartaly _ppen megtelt (FULL): a folyadekszint 8-ra valt -> felfut_ _l detekt_l_s.
assign ifr_set[0] = (lvl8_samples == 2'b01);
//A tartaly _ppen kiurult (EMPTY): a folyadekszint 0-ra valt -> felfut_ _l detekt_l_s.
assign ifr_set[1] = (lvl0_samples == 2'b01);
//Hiba t_rt_nt (ERROR): felfut_ _l a hibajelz_sen.
assign ifr_set[2] = (err_samples == 2'b01) ;

integer i;

//A megszak_t_s flag regisztert egyetlen always blokkban _rjuk le, FOR
//ciklussal indexelve a biteket. A bitek be_ll_t_sa nagyobb priorit_s_
//az '1' be_r_s_nak hat_s_ra megt_rt_n_ t_rl_sn_l.
always @(posedge clk)
    for (i = 0; i<3; i=i+1) begin
        if (rst) ifr[i] <= 1'b0;
        else if (ifr_set[i]) ifr[i] <= 1'b1;
        else if (ifr_wr & wr_data[i]) ifr[i] <= 1'b0;
    end

//jelezzuk a megszakitasokat, ha van aktiv esemeny, amely engedelyezett is.
assign irq = |(ier&ifr) ;

//******************************************************************************
//* Az olvasasi adatbusz meghajtasa.                                         *
//******************************************************************************
always @(*)
begin
	case ({ifr_rd, ier_rd, lvl_rd})
		3'b001 : rd_data <= lvl;
		3'b010 : rd_data <= {29'd0, ier};
		3'b100 : rd_data <= {29'd0, ifr};
		default: rd_data <= 32'd0;
	endcase
end

endmodule

`default_nettype wire
