module fir_axi_if #(
    // AXI interface parameters
    parameter C_S_AXI_DATA_WIDTH = 32,
    parameter C_S_AXI_ADDR_WIDTH = 8
 ) (
    //AXI clock and reset signals.
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_as_axi_aclkCLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000" *)
    input  wire                              s_axi_aclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axi_aresetn s_axi_aresetn" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    input  wire                              s_axi_aresetn,
    
    //AXI4-Lite write address channel.
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *)
    (* X_INTERFACE_PARAMETER = "PROTOCOL AXI4LITE" *)
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *)
    input  wire                              s_axi_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *)
    output wire                              s_axi_awready,
    
    //AXI4-Lite write data channel.
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *)
    input  wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *)
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *)
    input  wire                              s_axi_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *)
    output wire                              s_axi_wready,
    
    //AXI4-Lite write feedback channel.
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *)
    output wire [1:0]                        s_axi_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *)
    output wire                              s_axi_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *)
    input  wire                              s_axi_bready,
    
    //AXI4-Lite read address channel.
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *)
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *)
    input  wire                              s_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *)
    output wire                              s_axi_arready,
    
    //AXI4-Lite read data channel.
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *)
    output reg  [C_S_AXI_DATA_WIDTH-1:0]     s_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *)
    output wire [1:0]                        s_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *)
    output wire                              s_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *)
    input  wire                              s_axi_rready,
        
    //Interrupt request.
    (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 irq INTR" *)
    (* X_INTERFACE_PARAMETER = "SENSITIVITY LEVEL_HIGH" *)
    output reg                              irq,
    
    (* mark_debug = "true" *) output reg [7:0] fir_addr_from_axi,
    (* mark_debug = "true" *) output reg [31:0] fir_coeff_from_axi,
    (* mark_debug = "true" *) output reg axi_wr_strobe_o,
    input wire axi_wr_ack_i,
    (* mark_debug = "true" *) output reg axi_rd_strobe_o,
    input wire axi_rd_ack_i,
    input wire [31:0] hist_bin_to_axi
);

reg rd_ack_q1, rd_ack_q2, rd_ack_q3;
reg wr_ack_q1, wr_ack_q2, wr_ack_q3;

always @(posedge s_axi_aclk) begin : fir_axi_metastable_filt
    if (~s_axi_aresetn) begin
        wr_ack_q1 <= 0; wr_ack_q2 <= 0; wr_ack_q3 <= 0;
        rd_ack_q1 <= 0; rd_ack_q2 <= 0; rd_ack_q3 <= 0;
    end else begin
        rd_ack_q1 <= axi_rd_ack_i;
        rd_ack_q2 <= rd_ack_q1;
        rd_ack_q3 <= rd_ack_q2;
        wr_ack_q1 <= axi_wr_ack_i;
        wr_ack_q2 <= wr_ack_q1;
        wr_ack_q3 <= wr_ack_q2;
    end
end


//TODO: comment states

//******************************************************************************
//* irasi allapotgep.                                                          *
//******************************************************************************
localparam WR_ADDR_WAIT = 2'd0;
localparam WR_DATA_WAIT = 2'd1;
localparam WR_EXECUTE   = 2'd2;
localparam WR_RESPONSE  = 2'd3;

(* mark_debug = "true" *) reg [1:0] wr_state;

(* mark_debug = "true" *) wire axi_write_ack, axi_wr_ack_d;
assign axi_write_ack = ~wr_ack_q3 & wr_ack_q2;
assign axi_wr_ack_d = axi_wr_ack_i ^ axi_write_ack;

always @(posedge s_axi_aclk)
begin
    if (~s_axi_aresetn) begin
        wr_state <= WR_ADDR_WAIT;
        fir_addr_from_axi <= 0;
        fir_coeff_from_axi <= 0;
        axi_wr_strobe_o <= 0;
    end else begin
        case (wr_state)
            //Varaozas az irasi cimre.
            WR_ADDR_WAIT:
            if (s_axi_awvalid) begin
                fir_addr_from_axi<= s_axi_awaddr;
                wr_state <= WR_DATA_WAIT;
            end else begin
                wr_state <= WR_ADDR_WAIT;
            end

            //Varakozas az irasi adatra.                
            WR_DATA_WAIT:
            if (s_axi_wvalid) begin
                fir_coeff_from_axi <= s_axi_wdata;
                axi_wr_strobe_o <= 1; 

                wr_state <= WR_EXECUTE;
            end else begin
                wr_state <= WR_DATA_WAIT;
            end
            //Az irasi m?velet vegrehajtasa.
            WR_EXECUTE  :
            if (axi_write_ack) begin
                axi_wr_strobe_o <= 0; 
                wr_state <= WR_RESPONSE;
            end else begin
                wr_state <= WR_EXECUTE;
            end
            //A nyugtazas elkuldese.
            WR_RESPONSE : 
            if (s_axi_bready) wr_state <= WR_ADDR_WAIT;
            else wr_state <= WR_RESPONSE;
        endcase
    end
end

//Az irasi cim csatorna READY jelzesenek eloallitasa.
assign s_axi_awready = (wr_state == WR_ADDR_WAIT);
//Az irasi adat csatorna READY jelzesenek eloallitasa.
assign s_axi_wready  = (wr_state == WR_DATA_WAIT);
//Az irasi valasz csatorna VALID jelzesenek eloallitasa.
assign s_axi_bvalid  = (wr_state == WR_RESPONSE);
//Mindog OKAY (00) nyugtat kuldunk.
assign s_axi_bresp   = 2'b00;

// we do not need this
//A regiszerek iras engedelyezo jelenek eloallitasa.
// assign wr_en = (wr_state == WR_EXECUTE);

//******************************************************************************
//* Olvasasi allapotgep.                                                       *
//******************************************************************************
localparam RD_ADDR_WAIT = 2'd0;
localparam RD_EXECUTE   = 2'd1;
localparam RD_SEND_DATA = 2'd2;

(* mark_debug = "true" *) reg [1:0] rd_state;

(* mark_debug = "true" *) wire axi_read_ack;
assign axi_read_ack = ~rd_ack_q3 & rd_ack_q2;

always @(posedge s_axi_aclk)
begin
    if (~s_axi_aresetn) begin
        rd_state <= RD_ADDR_WAIT;
        axi_rd_strobe_o <= 0;
        s_axi_rdata <= 0;
    end else begin

        case (rd_state)
            //Varaozas az olvasasi cimre.
            RD_ADDR_WAIT: if (s_axi_arvalid) begin
                axi_rd_strobe_o <= 1;
                rd_state <= RD_EXECUTE;
            end else rd_state <= RD_ADDR_WAIT;
            
            //Az olvasasi m?velet vegrehajtasa.
            RD_EXECUTE  : if (axi_read_ack) begin
                axi_rd_strobe_o <= 0;
                s_axi_rdata <= hist_bin_to_axi;
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