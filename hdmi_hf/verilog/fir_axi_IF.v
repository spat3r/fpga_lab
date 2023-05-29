module fir_axi_if #(
    // AXI interface parameters
    parameter C_S_AXI_DATA_WIDTH = 32,
    parameter C_S_AXI_ADDR_WIDTH = 8
 ) (
    //AXI clock and reset signals.
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000" *)
    input  wire                              s_axi_aclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axi_aresetn RST" *)
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
    output wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_rdata,
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
    
    output reg                              fir_coef_write,
    output reg [15:0]                       fir_coef_data,
    input wire [15:0]                       hist_bin_data,
    output reg                              hist_bin_saved,
    input wire                              hist_bin_ready,

   
);
    //State variables

    input wire hdmi_vs,
    input wire hdmi_dv,
    input wire axi_write_rdy,
    input wire axi_write_ack,
    input wire axi_read_rdy,
    input wire axi_read_ack

    reg [15:0] fir_filter_coef [24:0];
    reg [15:0] hist_bin [255:0];
    reg [7:0]  addr;
    reg [1:0]  hist_bin_ready_shr;

//TODO: a top modulben az infók átadásánál metastabil szűrés és handshake kell.
    always @(posedge s_axi_aclk) begin
        if (s_axi_aresetn) begin
            addr <= 0;
        end else if (hist_bin_ready) begin
            hist_bin_saved <= 1;
            hist_bin[addr] <= hist_bin_data;
        end else begin
            hist_bin_saved <= 0;
        end
    end

//TODO: implement fsm


localparam IDLE = 0,
AXI_WRITE_ESTABLISH = 1,
WAIT_ON_WRITE_ENABLE = 2,
AXI_WRITE = 3,          //FIR adatok másolása
FIR_2_COEFF_R = 4,
HIST_READ = 5,
AXI_READ_ESTABLISH = 6,
WAIT_ON_READ_ENABLE = 7,
AXI_READ = 8;

reg state;

reg vs_delay;

always @ (posedge s_axi_aclk)
begin
      case (state)

         IDLE :
            if(axi_write_rdy)
                state <= AXI_WRITE_ESTABLISH;
            if(axi_read_rdy)
                state <= AXI_READ_ESTABLISH;

         AXI_WRITE_ESTABLISH :
            if(!hdmi_dv)
               state <= WAIT_ON_WRITE_ENABLE;

         WAIT_ON_WRITE_ENABLE :
            if(hdmi_dv)
               state <= AXI_WRITE;

         AXI_WRITE : 
            if(axi_write_ack)
                state <= FIR_2_COEFF_R;

         FIR_2_COEFF_R :  
            vs_delay <= hdmi_vs;
            if(~vs_delay & hdmi_vs)
               state <= HIST_READ;

         HIST_READ :
            if(axi_read_rdy)
                state <= AXI_READ;
            else
                state <= IDLE;

         AXI_READ_ESTABLISH :
            vs_delay <= hdmi_vs;
            if(vs_delay & ~hdmi_vs)
                state <= WAIT_ON_READ_ENABLE;

         WAIT_ON_READ_ENABLE :
            vs_delay <= hdmi_vs;
            if(~vs_delay & hdmi_vs)
                state <= HIST_READ;

         AXI_READ :
            if(axi_read_ack)
                state <= IDLE;

         default : IDLE;
         
      endcase

end



    //TODO implement fir writing, bin reading
endmodule