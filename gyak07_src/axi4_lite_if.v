`timescale 1ns / 1ps
`default_nettype none

//******************************************************************************
//* AXI4-Lite interfész.                                                       *
//******************************************************************************
module axi4_lite_if #(
    //A használt címbitek száma.
    parameter ADDR_BITS = 8
) (
    //Órajel és reset.
    input  wire                 clk,            //Rendszerórajel
    input  wire                 rst,            //Aktív magas szinkron reset
    
    //AXI4-Lite írási cím csatorna.
    input  wire [ADDR_BITS-1:0] s_axi_awaddr,
    input  wire                 s_axi_awvalid,
    output wire                 s_axi_awready,
    
    //AXI4-Lite írási adat csatorna.
    input  wire [31:0]          s_axi_wdata,
    input  wire [3:0]           s_axi_wstrb,
    input  wire                 s_axi_wvalid,
    output wire                 s_axi_wready,
    
    //AXI4-Lite írási válasz csatorna.
    output wire [1:0]           s_axi_bresp,
    output wire                 s_axi_bvalid,
    input  wire                 s_axi_bready,
    
    //AXI4-Lite olvasási cím csatorna.
    input  wire [ADDR_BITS-1:0] s_axi_araddr,
    input  wire                 s_axi_arvalid,
    output wire                 s_axi_arready,
    
    //AXI4-Lite olvasási adat csatorna.
    output reg  [31:0]          s_axi_rdata,
    output wire [1:0]           s_axi_rresp,
    output wire                 s_axi_rvalid,
    input  wire                 s_axi_rready,
    
    //Regiszter írási interfész.
    output reg  [3:0]           wr_addr,        //Írási cím
    output wire                 wr_en,          //Írás engedélyezõ jel
    output reg  [31:0]          wr_data,        //Írási adat
    output reg  [3:0]           wr_strb,        //Bájt engedélyezõ jelek
    input  wire                 wr_ack,         //Írás nyugtázó jel
    
    //Regiszter olvasási interfész.
    output reg  [3:0]           rd_addr,        //Olvasási cím
    output wire                 rd_en,          //Olvasás engedélyezõ jel
    input  wire [31:0]          rd_data,        //Olvasási adat
    input  wire                 rd_ack          //Olvasás nyugtázó jel
);

//******************************************************************************
//* Írási állapotgép.                                                          *
//******************************************************************************
localparam WR_ADDR_WAIT = 2'd0;
localparam WR_DATA_WAIT = 2'd1;
localparam WR_EXECUTE   = 2'd2;
localparam WR_RESPONSE  = 2'd3;

reg [1:0] wr_state;

always @(posedge clk)
begin
    if (rst)
        wr_state <= WR_ADDR_WAIT;
    else
        case (wr_state)
            //Váraozás az írási címre.
            WR_ADDR_WAIT: 
            
            //Várakozás az írási adatra.                
            WR_DATA_WAIT: 
            
            //Az írási mûvelet végrehajtása.
            WR_EXECUTE  : 
            
            //A nyugtázás elküldése.
            WR_RESPONSE : 
        endcase
end

//Az írási cím csatorna READY jelzésének elõállítása.
assign s_axi_awready = ;
//Az írási adat csatorna READY jelzésének elõállítása.
assign s_axi_wready  = ;
//Az írási válasz csatorna VALID jelzésének elõállítása.
assign s_axi_bvalid  = ;
//Mindog OKAY (00) nyugtát küldünk.
assign s_axi_bresp   = ;

//A regiszerek írás engedélyezõ jelének elõállítása.
assign wr_en = ;


//******************************************************************************
//* Olvasási állapotgép.                                                       *
//******************************************************************************
localparam RD_ADDR_WAIT = 2'd0;
localparam RD_EXECUTE   = 2'd1;
localparam RD_SEND_DATA = 2'd2;

reg [1:0] rd_state;

always @(posedge clk)
begin
    if (rst)
        rd_state <= RD_ADDR_WAIT;
    else
        case (rd_state)
            //Váraozás az olvasási címre.
            RD_ADDR_WAIT: 
            
            //Az olvasási mûvelet végrehajtása.
            RD_EXECUTE  : 
            
            //A beolvasott adat elküldése.
            RD_SEND_DATA: 
            
            //Érvénytelen állapotok.
            default     : rd_state <= RD_ADDR_WAIT;
        endcase
end

//Az olvasási cím csatorna READY jelzésének elõállítása.
assign s_axi_arready = ;
//Az olvasási adat csatorna VALID jelzésének elõállítása.
assign s_axi_rvalid  = ;
//Mindog OKAY (00) nyugtát küldünk.
assign s_axi_rresp   = ;

//A regiszerek olvasás engedélyezõ jelének elõállítása.
assign rd_en = ;

endmodule

`default_nettype wire
