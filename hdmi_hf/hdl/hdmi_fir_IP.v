module hdmi_fir_IP #(
    // AXI interface parameters
    parameter C_S_AXI_DATA_WIDTH = 16,
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
    output wire                              irq,

    // HDMI inputs and outputs.
    input  wire       hdmi_rx_d0_p,
    input  wire       hdmi_rx_d0_n,
    input  wire       hdmi_rx_d1_p,
    input  wire       hdmi_rx_d1_n,
    input  wire       hdmi_rx_d2_p,
    input  wire       hdmi_rx_d2_n,
    input  wire       hdmi_rx_clk_p,
    input  wire       hdmi_rx_clk_n,
    input  wire       hdmi_rx_cec,
    output reg        hdmi_rx_hpd,
    input  wire       hdmi_rx_scl,
    inout  wire       hdmi_rx_sda,

    output reg        hdmi_tx_d0_p,
    output reg        hdmi_tx_d0_n,
    output reg        hdmi_tx_d1_p,
    output reg        hdmi_tx_d1_n,
    output reg        hdmi_tx_d2_p,
    output reg        hdmi_tx_d2_n,
    output reg        hdmi_tx_clk_p,
    output reg        hdmi_tx_clk_n,
    input  wire       hdmi_tx_cec,
    input  wire       hdmi_tx_hpdn,
    input  wire       hdmi_tx_scl,
    input  wire       hdmi_tx_sda
);
    reg [15:0] fir_filter_coef [24:0];
    reg [15:0] hist_bin [255:0];
    reg [7:0]  addr;
    reg [1:0] hist_bin_ready_shr;
    reg fir_coef_write, hist_bin_saved;
    wire hist_bin_ready;
    reg [15:0] fir_coef_data, hist_bin_data;

//TODO: a top modulben az infók átadásánál metastabil szűrés és handshake kell.
    always @(posedge clk) begin
        if (rst) begin
            addr <= 0;
        end else if (hist_bin_ready) begin
            hist_bin_saved <= 1;
            hist_bin[addr] <= hist_bin_data;
        end else begin
            hist_bin_saved <= 0;
        end
    end

    // TODO: Instanciate fir_axi_if.sv


    // TODO: Instanuciate hdmi_top.sv
//FIXME: a pixel órajel miatt a microblaze másik órajeltartományban lesz.
hdmi_top hdmi_top_inst(
   .clk100M        ( s_axi_aclk    ),
   .rstbt          ( ~s_axi_aresetn),
   .led_r          ( led_r         ),
   .sw             ( 4'h3          ),
   .bt             ( 4'h3          ),   
   .hdmi_rx_d0_p   ( hdmi_rx_d0_p  ),
   .hdmi_rx_d0_n   ( hdmi_rx_d0_n  ),
   .hdmi_rx_d1_p   ( hdmi_rx_d1_p  ),
   .hdmi_rx_d1_n   ( hdmi_rx_d1_n  ),
   .hdmi_rx_d2_p   ( hdmi_rx_d2_p  ),
   .hdmi_rx_d2_n   ( hdmi_rx_d2_n  ),
   .hdmi_rx_clk_p  ( hdmi_rx_clk_p ),
   .hdmi_rx_clk_n  ( hdmi_rx_clk_n ),
   .hdmi_rx_cec    ( hdmi_rx_cec   ),
   .hdmi_rx_hpd    ( hdmi_rx_hpd   ),
   .hdmi_rx_scl    ( hdmi_rx_scl   ),
   .hdmi_rx_sda    ( hdmi_rx_sda   ),   
   .hdmi_tx_d0_p   ( hdmi_tx_d0_p  ),
   .hdmi_tx_d0_n   ( hdmi_tx_d0_n  ),
   .hdmi_tx_d1_p   ( hdmi_tx_d1_p  ),
   .hdmi_tx_d1_n   ( hdmi_tx_d1_n  ),
   .hdmi_tx_d2_p   ( hdmi_tx_d2_p  ),
   .hdmi_tx_d2_n   ( hdmi_tx_d2_n  ),
   .hdmi_tx_clk_p  ( hdmi_tx_clk_p ),
   .hdmi_tx_clk_n  ( hdmi_tx_clk_n ),
   .hdmi_tx_cec    ( hdmi_tx_cec   ),
   .hdmi_tx_hpdn   ( hdmi_tx_hpdn  ),
   .hdmi_tx_scl    ( hdmi_tx_scl   ),
   .hdmi_tx_sda    ( hdmi_tx_sda   ),
   .fir_coef_write(fir_coef_write   ),
   .fir_coef_data(fir_coef_data     ),
   .hist_bin_data(hist_bin_data     ),
   .hist_bin_saved(hist_bin_saved   ),
   .hist_bin_ready(hist_bin_ready   )
);

    // TODO: reading histogram bins


    // TODO: writing fir parameters

    // TODO: szerintem az axi regiszterek itt legyenek implementálva és az almodulok csak hozzáférnek vezetékeken keresztül
                // biztosan egy vezetékezési kín lesz de nem tudom hogy lehet optimálisan megoldani
endmodule