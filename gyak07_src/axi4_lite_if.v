`timescale 1ns / 1ps
`default_nettype none

//******************************************************************************
//* AXI4-Lite interfesz.                                                       *
//******************************************************************************
module axi4_lite_if #(
    //A hasznalt cimbitek szama.
    parameter ADDR_BITS = 8
) (
    //orajel es reset.
    input  wire                 clk,            //Rendszerorajel
    input  wire                 rst,            //Aktiv magas szinkron reset
    
    //AXI4-Lite irasi cim csatorna.
    input  wire [ADDR_BITS-1:0] s_axi_awaddr,
    input  wire                 s_axi_awvalid,
    output wire                 s_axi_awready,
    
    //AXI4-Lite irasi adat csatorna.
    input  wire [31:0]          s_axi_wdata,
    input  wire [3:0]           s_axi_wstrb,
    input  wire                 s_axi_wvalid,
    output wire                 s_axi_wready,
    
    //AXI4-Lite irasi valasz csatorna.
    output wire [1:0]           s_axi_bresp,
    output wire                 s_axi_bvalid,
    input  wire                 s_axi_bready,
    
    //AXI4-Lite olvasasi cim csatorna.
    input  wire [ADDR_BITS-1:0] s_axi_araddr,
    input  wire                 s_axi_arvalid,
    output wire                 s_axi_arready,
    
    //AXI4-Lite olvasasi adat csatorna.
    output reg  [31:0]          s_axi_rdata,
    output wire [1:0]           s_axi_rresp,
    output wire                 s_axi_rvalid,
    input  wire                 s_axi_rready,
    
    //Regiszter irasi interfesz.
    output reg  [3:0]           wr_addr,        //irasi cim
    output wire                 wr_en,          //iras engedelyezo jel
    output reg  [31:0]          wr_data,        //irasi adat
    output reg  [3:0]           wr_strb,        //Bajt engedelyezo jelek
    input  wire                 wr_ack,         //iras nyugtazo jel
    
    //Regiszter olvasasi interfesz.
    output reg  [3:0]           rd_addr,        //Olvasasi cim
    output wire                 rd_en,          //Olvasas engedelyezo jel
    input  wire [31:0]          rd_data,        //Olvasasi adat
    input  wire                 rd_ack          //Olvasas nyugtazo jel
);

//******************************************************************************
//* irasi allapotgep.                                                          *
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
            //Varaozas az irasi cimre.
            WR_ADDR_WAIT:
            if (s_axi_awvalid) begin
                wr_addr <= s_axi_awaddr[3:0];
                wr_state <= WR_DATA_WAIT;
            end else begin
                wr_state <= WR_ADDR_WAIT;
            end

            //Varakozas az irasi adatra.                
            WR_DATA_WAIT:
            if (s_axi_wvalid) begin
                wr_data <= s_axi_wdata;
                wr_strb <= s_axi_wstrb;
                wr_state <= WR_EXECUTE;
            end else begin
                wr_state <= WR_DATA_WAIT;
            end
            //Az irasi mûvelet vegrehajtasa.
            WR_EXECUTE  :
            if (wr_ack)
                wr_state <= WR_RESPONSE;
            else begin
                wr_state <= WR_EXECUTE;
            end
            //A nyugtazas elkuldese.
            WR_RESPONSE : 
            if ( s_axi_bready) wr_state <= WR_ADDR_WAIT;
            else wr_state <= WR_RESPONSE;

            default: wr_state <= WR_ADDR_WAIT;
        endcase
end

//Az irasi cim csatorna READY jelzesenek eloallitasa.
assign s_axi_awready = (wr_state == WR_ADDR_WAIT);
//Az irasi adat csatorna READY jelzesenek eloallitasa.
assign s_axi_wready  = (wr_state == WR_DATA_WAIT);
//Az irasi valasz csatorna VALID jelzesenek eloallitasa.
assign s_axi_bvalid  = (wr_state == WR_RESPONSE);
//Mindog OKAY (00) nyugtat kuldunk.
assign s_axi_bresp   = 2'b00;

//A regiszerek iras engedelyezo jelenek eloallitasa.
assign wr_en = (wr_state == WR_EXECUTE);


//******************************************************************************
//* Olvasasi allapotgep.                                                       *
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
            //Varaozas az olvasasi cimre.
            RD_ADDR_WAIT: if (s_axi_arvalid) begin
                rd_addr <= s_axi_araddr[3:0];
                rd_state <= RD_EXECUTE;
            end else rd_state <= RD_ADDR_WAIT;
            
            //Az olvasasi mûvelet vegrehajtasa.
            RD_EXECUTE  : if (rd_ack) begin
                s_axi_rdata <= rd_data;
                rd_state <= RD_SEND_DATA;
            end else rd_state <= RD_EXECUTE;
            
            //A beolvasott adat elkuldese.
            RD_SEND_DATA: if (s_axi_rready) begin
                s_axi_rdata <= 0;
                rd_state <= RD_ADDR_WAIT;
            end else rd_state <= RD_SEND_DATA;
            
            //ervenytelen allapotok.
            default     : rd_state <= RD_ADDR_WAIT;
        endcase
end

//Az olvasasi cim csatorna READY jelzesenek eloallitasa.
assign s_axi_arready = (rd_state == RD_ADDR_WAIT);
//Az olvasasi adat csatorna VALID jelzesenek eloallitasa.
assign s_axi_rvalid  = (rd_state == RD_SEND_DATA);
//Mindog OKAY (00) nyugtat kuldunk.
assign s_axi_rresp   = 2'b00;

//A regiszerek olvasas engedelyezo jelenek eloallitasa.
assign rd_en = (rd_state==RD_EXECUTE);

endmodule

`default_nettype wire
