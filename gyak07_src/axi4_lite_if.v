`timescale 1ns / 1ps
`default_nettype none

//******************************************************************************
//* AXI4-Lite interf�sz.                                                       *
//******************************************************************************
module axi4_lite_if #(
    //A haszn�lt c�mbitek sz�ma.
    parameter ADDR_BITS = 8
) (
    //�rajel �s reset.
    input  wire                 clk,            //Rendszer�rajel
    input  wire                 rst,            //Akt�v magas szinkron reset
    
    //AXI4-Lite �r�si c�m csatorna.
    input  wire [ADDR_BITS-1:0] s_axi_awaddr,
    input  wire                 s_axi_awvalid,
    output wire                 s_axi_awready,
    
    //AXI4-Lite �r�si adat csatorna.
    input  wire [31:0]          s_axi_wdata,
    input  wire [3:0]           s_axi_wstrb,
    input  wire                 s_axi_wvalid,
    output wire                 s_axi_wready,
    
    //AXI4-Lite �r�si v�lasz csatorna.
    output wire [1:0]           s_axi_bresp,
    output wire                 s_axi_bvalid,
    input  wire                 s_axi_bready,
    
    //AXI4-Lite olvas�si c�m csatorna.
    input  wire [ADDR_BITS-1:0] s_axi_araddr,
    input  wire                 s_axi_arvalid,
    output wire                 s_axi_arready,
    
    //AXI4-Lite olvas�si adat csatorna.
    output reg  [31:0]          s_axi_rdata,
    output wire [1:0]           s_axi_rresp,
    output wire                 s_axi_rvalid,
    input  wire                 s_axi_rready,
    
    //Regiszter �r�si interf�sz.
    output reg  [3:0]           wr_addr,        //�r�si c�m
    output wire                 wr_en,          //�r�s enged�lyez� jel
    output reg  [31:0]          wr_data,        //�r�si adat
    output reg  [3:0]           wr_strb,        //B�jt enged�lyez� jelek
    input  wire                 wr_ack,         //�r�s nyugt�z� jel
    
    //Regiszter olvas�si interf�sz.
    output reg  [3:0]           rd_addr,        //Olvas�si c�m
    output wire                 rd_en,          //Olvas�s enged�lyez� jel
    input  wire [31:0]          rd_data,        //Olvas�si adat
    input  wire                 rd_ack          //Olvas�s nyugt�z� jel
);

//******************************************************************************
//* �r�si �llapotg�p.                                                          *
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
            //V�raoz�s az �r�si c�mre.
            WR_ADDR_WAIT: 
            
            //V�rakoz�s az �r�si adatra.                
            WR_DATA_WAIT: 
            
            //Az �r�si m�velet v�grehajt�sa.
            WR_EXECUTE  : 
            
            //A nyugt�z�s elk�ld�se.
            WR_RESPONSE : 
        endcase
end

//Az �r�si c�m csatorna READY jelz�s�nek el��ll�t�sa.
assign s_axi_awready = ;
//Az �r�si adat csatorna READY jelz�s�nek el��ll�t�sa.
assign s_axi_wready  = ;
//Az �r�si v�lasz csatorna VALID jelz�s�nek el��ll�t�sa.
assign s_axi_bvalid  = ;
//Mindog OKAY (00) nyugt�t k�ld�nk.
assign s_axi_bresp   = ;

//A regiszerek �r�s enged�lyez� jel�nek el��ll�t�sa.
assign wr_en = ;


//******************************************************************************
//* Olvas�si �llapotg�p.                                                       *
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
            //V�raoz�s az olvas�si c�mre.
            RD_ADDR_WAIT: 
            
            //Az olvas�si m�velet v�grehajt�sa.
            RD_EXECUTE  : 
            
            //A beolvasott adat elk�ld�se.
            RD_SEND_DATA: 
            
            //�rv�nytelen �llapotok.
            default     : rd_state <= RD_ADDR_WAIT;
        endcase
end

//Az olvas�si c�m csatorna READY jelz�s�nek el��ll�t�sa.
assign s_axi_arready = ;
//Az olvas�si adat csatorna VALID jelz�s�nek el��ll�t�sa.
assign s_axi_rvalid  = ;
//Mindog OKAY (00) nyugt�t k�ld�nk.
assign s_axi_rresp   = ;

//A regiszerek olvas�s enged�lyez� jel�nek el��ll�t�sa.
assign rd_en = ;

endmodule

`default_nettype wire
