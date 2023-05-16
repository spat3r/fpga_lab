`timescale 1ns / 1ps
`default_nettype none

//******************************************************************************
//* Folyad�kszint jelz� perif�ria.                                             *
//*                                                                            *
//*  ------------     ----                                                     *
//* |          O-|-->|    |                                                    *
//* |          O-|-->|    | folyad�kszint                                      *
//* |          O-|-->|    |     (0-8)       ------------                       *
//* |~~~~~~~~~~O-|-->|    |/--------------\| MicroBlaze |                      *
//* |~~~~~~~~~~O-|-->|    |\--------------/| CPU        |                      *
//* |~~~~~~~~~~O-|-->|    |    AXI4-Lite    ------------                       *
//* |~~~~~~~~~~O-|-->|    |                                                    *
//* |~~~~~~~~~~O-|-->|    |                                                    *
//*  ------------     ----                                                     *
//*    tart�ly      perif�ria                                                  *
//******************************************************************************
module fluid_level_indicator(
    //�rajel �s reset.
    input  wire        clk,         //100 MHz rendszer�rajel
    input  wire        rst,         //Akt�v magas szinkron reset
    
    //Regiszter �r�si interf�sz.
    input  wire [3:0]  wr_addr,     //�r�si c�m
    input  wire        wr_en,       //�r�s enged�lyez� jel
    input  wire [31:0] wr_data,     //�r�si adat
    input  wire [3:0]  wr_strb,     //B�jt enged�lyez� jelek
    
    //Regiszter olvas�si interf�sz.
    input  wire [3:0]  rd_addr,     //Olvas�si c�m
    input  wire        rd_en,       //Olvas�s enged�lyez� jel
    output reg  [31:0] rd_data,     //Olvas�si adat      
    
    //Adat a folyad�k �rz�kel�kt�l.
    input  wire [7:0]  sensor_in,
    
    //Megszak�t�sk�r� kimenet.
    output wire        irq
);

//******************************************************************************
//* A szenzor bemeneteket 10 Hz frekvenci�val mintav�telezz�k. Az �temez� jel  *
//* egy 24 bites sz�ml�l�val �ll�that� el� (9999999 - 0 => 24 bit).            *
//******************************************************************************
reg  [23:0] clk_div;
wire        clk_div_tc = (clk_div == 24'd0);

always @(posedge clk)
begin
    
end

reg [7:0] sensor_reg;

always @(posedge clk)
begin
    
end

//******************************************************************************
//* A szenzor bemenet alapj�n a folyad�kszintet egy priorit�s enk�derrel       *
//* �ll�thatjuk el�. A legnagyobb sorsz�m� akt�v bit hat�rozza meg a           *
//* folyad�kszint �rt�k�t.                                                     *
//******************************************************************************
reg [3:0] fluid_level;

always @(posedge clk)
begin
	
end

//******************************************************************************
//* A hibajelz�s el��ll�t�sa. �rv�nyes a szenzor bemeneten l�v� adat, ha       *
//* a legnagyobb sorsz�m� akt�v bemeneti bit alatti �sszes bit is akt�v.       *
//******************************************************************************
reg error;

always @(posedge clk)
begin
	
end

//******************************************************************************
//* A regiszterek �r�si �s olvas�si enged�lyez� jeleinek el��ll�t�sa.          *
//*                                                                            *
//* Folyad�kszint regiszter     : BASEADDR+0x00, 32 bites, RD                  *
//* Megszak�t�s enged�lyez� reg.: BASEADDR+0x04, 32 bites, R/W                 *
//* Megszak�t�s flag regiszter  : BASEADDR+0x08, 32 bites, R/W1C               *
//******************************************************************************
//A folyad�kszint regiszter olvas�s enged�lyez� jele.
wire lvl_rd = ;

//A megszak�t�s enged�lyez� regiszter �r�s �s olvas�s enged�lyez� jele.
wire ier_wr = ;
wire ier_rd = ;

//A megszak�t�s flag regiszter �r�s �s olvas�s enged�lyez� jele.
wire ifr_wr = ;
wire ifr_rd = ;

//******************************************************************************
//* Folyad�kszint regiszter: BASEADDR+0x00, 32 bites, csak olvashat�           *
//*                                                                            *
//*    31    30          4     3     2     1     0                             *
//*  -----------------------------------------------                           *
//* |ERROR|  0   ....    0  |  folyad�kszint (0-8)  |                          *
//*  -----------------------------------------------                           * 
//******************************************************************************
wire [31:0] lvl;

assign lvl[3:0]  = ;
assign lvl[30:4] = ;
assign lvl[31]   = ;

//******************************************************************************
//* Megszak�t�s enged�lyez� reg.: BASEADDR+0x04, 32 bites, �rhat�/olvashat�    *
//*                                                                            *
//*    31          5     4     3     2     1     0                             *
//*  -----------------------------------------------                           *
//* |  x    ....   x     x    x   |ERROR|EMPTY| FULL|                          *
//*  -----------------------------------------------                           *
//******************************************************************************
reg [2:0] ier;

always @(posedge clk)
begin
	
end

//******************************************************************************
//* Megszak�t�s flag regiszter: BASEADDR+0x08, 32 bites, olvashat� �s a jelz�s *
//*                             '1' be�r�s�val t�r�lhet�                       *
//*                                                                            *
//*    31          5     4     3     2     1     0                             *
//*  -----------------------------------------------                           *
//* |  x    ....   x     x    x   |ERROR|EMPTY| FULL|                          *
//*  -----------------------------------------------                           *
//******************************************************************************
//Mintav�telez�s a felfut� �l detekt�l�s�hoz.
reg [1:0] lvl8_samples;
reg [1:0] lvl0_samples;
reg [1:0] err_samples;

always @(posedge clk)
begin
	
end

reg  [2:0] ifr;
wire [2:0] ifr_set;

//A tart�ly �ppen megtelt (FULL): a folyad�kszint 8-ra v�lt -> felfut� �l detekt�l�s.
assign ifr_set[0] = ;
//A tart�ly �ppen ki�r�lt (EMPTY): a folyad�kszint 0-ra v�lt -> felfut� �l detekt�l�s.
assign ifr_set[1] = ;
//Hiba t�rt�nt (ERROR): felfut� �l a hibajelz�sen.
assign ifr_set[2] = ;

integer i;

//A megszak�t�s flag regisztert egyetlen always blokkban �rjuk le, FOR
//ciklussal indexelve a biteket. A bitek be�ll�t�sa nagyobb priorit�s�
//az '1' be�r�s�nak hat�s�ra megt�rt�n� t�rl�sn�l.
always @(posedge clk)
begin

end

//Jelezz�k a megszak�t�sk�r�st, ha van akt�v esem�ny, amely enged�lyezett is.
assign irq = ;

//******************************************************************************
//* Az olvas�si adatbusz meghajt�sa.                                           *
//******************************************************************************
always @(*)
begin
	case ({ifr_rd, ier_rd, lvl_rd})
		3'b001 : ;
		3'b010 : ;
		3'b100 : ;
		default: rd_data <= 32'd0;
	endcase
end

endmodule

`default_nettype wire
