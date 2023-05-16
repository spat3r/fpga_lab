`timescale 1ns / 1ps
`default_nettype none

//******************************************************************************
//* Folyadékszint jelzõ periféria.                                             *
//*                                                                            *
//*  ------------     ----                                                     *
//* |          O-|-->|    |                                                    *
//* |          O-|-->|    | folyadékszint                                      *
//* |          O-|-->|    |     (0-8)       ------------                       *
//* |~~~~~~~~~~O-|-->|    |/--------------\| MicroBlaze |                      *
//* |~~~~~~~~~~O-|-->|    |\--------------/| CPU        |                      *
//* |~~~~~~~~~~O-|-->|    |    AXI4-Lite    ------------                       *
//* |~~~~~~~~~~O-|-->|    |                                                    *
//* |~~~~~~~~~~O-|-->|    |                                                    *
//*  ------------     ----                                                     *
//*    tartály      periféria                                                  *
//******************************************************************************
module fluid_level_indicator(
    //Órajel és reset.
    input  wire        clk,         //100 MHz rendszerórajel
    input  wire        rst,         //Aktív magas szinkron reset
    
    //Regiszter írási interfész.
    input  wire [3:0]  wr_addr,     //Írási cím
    input  wire        wr_en,       //Írás engedélyezõ jel
    input  wire [31:0] wr_data,     //Írási adat
    input  wire [3:0]  wr_strb,     //Bájt engedélyezõ jelek
    
    //Regiszter olvasási interfész.
    input  wire [3:0]  rd_addr,     //Olvasási cím
    input  wire        rd_en,       //Olvasás engedélyezõ jel
    output reg  [31:0] rd_data,     //Olvasási adat      
    
    //Adat a folyadék érzékelõktõl.
    input  wire [7:0]  sensor_in,
    
    //Megszakításkérõ kimenet.
    output wire        irq
);

//******************************************************************************
//* A szenzor bemeneteket 10 Hz frekvenciával mintavételezzük. Az ütemezõ jel  *
//* egy 24 bites számlálóval állítható elõ (9999999 - 0 => 24 bit).            *
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
//* A szenzor bemenet alapján a folyadékszintet egy prioritás enkóderrel       *
//* állíthatjuk elõ. A legnagyobb sorszámú aktív bit határozza meg a           *
//* folyadékszint értékét.                                                     *
//******************************************************************************
reg [3:0] fluid_level;

always @(posedge clk)
begin
	
end

//******************************************************************************
//* A hibajelzés elõállítása. Érvényes a szenzor bemeneten lévõ adat, ha       *
//* a legnagyobb sorszámú aktív bemeneti bit alatti összes bit is aktív.       *
//******************************************************************************
reg error;

always @(posedge clk)
begin
	
end

//******************************************************************************
//* A regiszterek írási és olvasási engedélyezõ jeleinek elõállítása.          *
//*                                                                            *
//* Folyadékszint regiszter     : BASEADDR+0x00, 32 bites, RD                  *
//* Megszakítás engedélyezõ reg.: BASEADDR+0x04, 32 bites, R/W                 *
//* Megszakítás flag regiszter  : BASEADDR+0x08, 32 bites, R/W1C               *
//******************************************************************************
//A folyadékszint regiszter olvasás engedélyezõ jele.
wire lvl_rd = ;

//A megszakítás engedélyezõ regiszter írás és olvasás engedélyezõ jele.
wire ier_wr = ;
wire ier_rd = ;

//A megszakítás flag regiszter írás és olvasás engedélyezõ jele.
wire ifr_wr = ;
wire ifr_rd = ;

//******************************************************************************
//* Folyadékszint regiszter: BASEADDR+0x00, 32 bites, csak olvasható           *
//*                                                                            *
//*    31    30          4     3     2     1     0                             *
//*  -----------------------------------------------                           *
//* |ERROR|  0   ....    0  |  folyadékszint (0-8)  |                          *
//*  -----------------------------------------------                           * 
//******************************************************************************
wire [31:0] lvl;

assign lvl[3:0]  = ;
assign lvl[30:4] = ;
assign lvl[31]   = ;

//******************************************************************************
//* Megszakítás engedélyezõ reg.: BASEADDR+0x04, 32 bites, írható/olvasható    *
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
//* Megszakítás flag regiszter: BASEADDR+0x08, 32 bites, olvasható és a jelzés *
//*                             '1' beírásával törölhetõ                       *
//*                                                                            *
//*    31          5     4     3     2     1     0                             *
//*  -----------------------------------------------                           *
//* |  x    ....   x     x    x   |ERROR|EMPTY| FULL|                          *
//*  -----------------------------------------------                           *
//******************************************************************************
//Mintavételezés a felfutó él detektálásához.
reg [1:0] lvl8_samples;
reg [1:0] lvl0_samples;
reg [1:0] err_samples;

always @(posedge clk)
begin
	
end

reg  [2:0] ifr;
wire [2:0] ifr_set;

//A tartály éppen megtelt (FULL): a folyadékszint 8-ra vált -> felfutó él detektálás.
assign ifr_set[0] = ;
//A tartály éppen kiürült (EMPTY): a folyadékszint 0-ra vált -> felfutó él detektálás.
assign ifr_set[1] = ;
//Hiba történt (ERROR): felfutó él a hibajelzésen.
assign ifr_set[2] = ;

integer i;

//A megszakítás flag regisztert egyetlen always blokkban írjuk le, FOR
//ciklussal indexelve a biteket. A bitek beállítása nagyobb prioritású
//az '1' beírásának hatására megtörténõ törlésnél.
always @(posedge clk)
begin

end

//Jelezzük a megszakításkérést, ha van aktív esemény, amely engedélyezett is.
assign irq = ;

//******************************************************************************
//* Az olvasási adatbusz meghajtása.                                           *
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
