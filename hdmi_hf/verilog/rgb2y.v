
// rgb2 to gamma, double dsp w/ fixed point 
module rgb2y_3 #(
    parameter COLORDEPTH = 8,
    parameter POWEREFF = 2
    ) (
    input  wire         clk,
    input  wire         rst,
    input  wire  [7:0]  red_i,
    input  wire  [7:0]  green_i,
    input  wire  [7:0]  blue_i,
    output reg     [7:0]  gamma_o,
    input  wire         dv_i,
    input  wire         hs_i,
    input  wire         vs_i,
    output reg            dv_o,
    output reg            hs_o,
    output reg            vs_o,
    output reg            line_end_o
    );

    reg  [7:0] g_reg[1:0];
    reg  [7:0] b_reg;

    // G ES B MENTESE A KESLELTETESEK MIATT
    always @(posedge clk ) begin
        b_reg <= blue_i;
        g_reg[0] <= green_i;
        g_reg[1] <= g_reg[0];
    end

    wire [47:0] po_gb, po_rg;

    dsp_25x18_presub #(.USE_PCI_REG(1)) dsp_25x18_rg(
        .clk(clk),
        .a({1'b0,red_i,16'b0}),
        .d({1'b0,green_i,21'b0}),
        //  KR = 0,2126 *2^17 = 27866
        .b(18'd27866),
        .pci({1'b0,g_reg[1],39'b0}), 
        .p(po_rg)
    );

    dsp_25x18_presub #(.USE_PCI_REG(0)) dsp_25x18_bg(
        .clk(clk),
        .a({1'b0,b_reg,16'b0}),
        .d({1'b0,g_reg[0],21'b0}),
        //  KB = -0,0722 *2^17 = -9463
        .b(-18'd9463),
        .pci(po_rg), 
        .p(po_gb)
    );

    wire [7:0] gamma_d;
    assign gamma_d = (po_gb[47]) ? 8'b0 : po_gb[46:39];

    always @(posedge clk ) begin
        gamma_o <= gamma_d;
    end

    reg  [4:0] dv_shr;
    reg  [4:0] hs_shr;
    reg  [4:0] vs_shr;
    wire  line_end_d = dv_shr[4] & ~dv_shr[3];

    always @(posedge clk) begin
        if (rst) begin
            dv_shr <= 0; dv_o <= 0;
            hs_shr <= 0; hs_o <= 0;
            vs_shr <= 0; vs_o <= 0;
        end else begin
            dv_shr <= {dv_shr[3:0],dv_i};
            hs_shr <= {hs_shr[3:0],hs_i};
            vs_shr <= {vs_shr[3:0],vs_i};
            line_end_o <= line_end_d;
            dv_o <= dv_shr[4];
            hs_o <= hs_shr[4];
            vs_o <= vs_shr[4];
        end
    end

endmodule
