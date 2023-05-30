`timescale 1ns / 1ps
`default_nettype none

//******************************************************************************
//* Folyadekszint jelzo periferia top-level modulja.                           *
//******************************************************************************
module lvl_indicator #(
    //AXI interfesz parameterek.
    parameter C_S_AXI_DATA_WIDTH = 32,
    parameter C_S_AXI_ADDR_WIDTH = 4
) (
    //AXI orajel es reset jel.
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000" *)
    input  wire                              s_axi_aclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axi_aresetn RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    input  wire                              s_axi_aresetn,
    
    //AXI4-Lite irasi cim csatorna.
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *)
    (* X_INTERFACE_PARAMETER = "PROTOCOL AXI4LITE" *)
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *)
    input  wire                              s_axi_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *)
    output wire                              s_axi_awready,
    
    //AXI4-Lite irasi adat csatorna.
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *)
    input  wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *)
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *)
    input  wire                              s_axi_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *)
    output wire                              s_axi_wready,
    
    //AXI4-Lite irasi valasz csatorna.
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *)
    output wire [1:0]                        s_axi_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *)
    output wire                              s_axi_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *)
    input  wire                              s_axi_bready,
    
    //AXI4-Lite olvasasi cim csatorna.
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *)
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *)
    input  wire                              s_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *)
    output wire                              s_axi_arready,
    
    //AXI4-Lite olvasasi adat csatorna.
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *)
    output wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *)
    output wire [1:0]                        s_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *)
    output wire                              s_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *)
    input  wire                              s_axi_rready,
    
    //Adat a folyadek erzekeloktol.
    input  wire [7:0]                        sensor_in,
        
    //Megszakitaskero kimenet.
    (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 irq INTR" *)
    (* X_INTERFACE_PARAMETER = "SENSITIVITY LEVEL_HIGH" *)
    output wire                              irq
);

//******************************************************************************
//* AXI4-Lite interfesz.                                                       *
//******************************************************************************
wire [3:0]  wr_addr;
wire        wr_en;
wire [31:0] wr_data;
wire [3:0]  wr_strb;

wire [3:0]  rd_addr;
wire        rd_en;
wire [31:0] rd_data;

axi4_lite_if #(
    //A hasznalt cimbitek szama.
    .ADDR_BITS(C_S_AXI_ADDR_WIDTH)
) axi4_lite_if_i (
    //orajel es reset.
    .clk(s_axi_aclk),                   //Rendszerorajel
    .rst(~s_axi_aresetn),               //Aktiv magas szinkron reset
    
    //AXI4-Lite irasi cim csatorna.
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    
    //AXI4-Lite irasi adat csatorna.
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    
    //AXI4-Lite irasi valasz csatorna.
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    
    //AXI4-Lite olvasasi cim csatorna.
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    
    //AXI4-Lite olvasasi adat csatorna.
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    
    //Regiszter irasi interfesz.
    .wr_addr(wr_addr),                  //irasi cim
    .wr_en(wr_en),                      //iras engedelyezo jel
    .wr_data(wr_data),                  //irasi adat
    .wr_strb(wr_strb),                  //Bajt engedelyezo jelek
    .wr_ack(1'b1),                      //iras nyugtazo jel
    
    //Regiszter olvasasi interfesz.
    .rd_addr(rd_addr),                  //Olvasasi cim
    .rd_en(rd_en),                      //Olvasas engedelyezo jel
    .rd_data(rd_data),                  //Olvasasi adat
    .rd_ack(1'b1)                       //Olvasas nyugtazo jel
);

//******************************************************************************
//* A periferia funkciojat megvalosito modul.                                  *
//******************************************************************************
fluid_level_indicator fluid_level_indicator_i(
    //orajel es reset.
    .clk(s_axi_aclk),         //100 MHz rendszerorajel
    .rst(~s_axi_aresetn),         //Aktiv magas szinkron reset
    
    //Regiszter irasi interfesz.
    .wr_addr(wr_addr),     //irasi cim
    .wr_en(wr_en),       //iras engedelyezo jel
    .wr_data(wr_data),     //irasi adat
    .wr_strb(wr_strb),     //Bajt engedelyezo jelek
    
    //Regiszter olvasasi interfesz.
    .rd_addr(rd_addr),     //Olvasasi cim
    .rd_en(rd_en),       //Olvasas engedelyezo jel
    .rd_data(rd_data),     //Olvasasi adat      
    
    //Adat a folyadek erzekeloktol.
    .sensor_in(sensor_in),
    
    //Megszakitaskero kimenet.
    .irq(irq)
);

endmodule

`default_nettype wire
