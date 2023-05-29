module sobel_top #(
    parameter COLORDEPTH = 8,
    parameter SCREENWIDTH = 1600,
    parameter POL_VS = 1,
    parameter POL_HS = 1
    )(
    input  wire         clk,
    input  wire         rst,
    input  wire   [7:0] sw,
    input  wire   [7:0] red_i,
    input  wire   [7:0] green_i,
    input  wire   [7:0] blue_i,
    input  wire         dv_i,
    input  wire         hs_i,
    input  wire         vs_i,
    output reg    [7:0] red_o,
    output reg    [7:0] green_o,
    output reg    [7:0] blue_o,
    output reg          dv_o,
    output reg          hs_o,
    output reg          vs_o,

    input  wire         fir_coef_write,
    input  wire  [15:0] fir_coef_data,
    
    output reg   [15:0] hist_bin_data,
    input  wire         hist_bin_saved,
    output reg          hist_bin_ready

    // TODO: update port for axi
);


wire hs_in, vs_in;
assign hs_in = POL_HS ? hs_i : ~hs_i;
assign vs_in = POL_VS ? vs_i : ~vs_i;


wire dv_y, hs_y, vs_y;
wire dv_gb, hs_gb, vs_gb;
wire dv_blur, hs_blur, vs_blur;
wire dv_bb, hs_bb, vs_bb;
wire dv_sob, hs_sob, vs_sob;
wire line_end_gb, line_end_bb;
wire [7:0] gamma_o, blur_o, sob_o;
wire [7:0] gb_line_o [2:0];
wire [7:0] bb_line_o [2:0];
wire [15:0] fir_filter_coef [24:0];
wire [15:0] hist_bin [255:0];
//TODO: add fsm for filling axi rd wr

rgb2y_3 #(
    .COLORDEPTH(8)
    ) rgb2y_inst (
    .clk            (clk),
    .rst            (rst),
    .red_i          (red_i),
    .green_i        (green_i),
    .blue_i         (blue_i),
    .gamma_o        (gamma_o),
    .dv_i           (dv_i),
    .hs_i           (hs_in),
    .vs_i           (vs_in),
    .dv_o           (dv_y),
    .hs_o           (hs_y),
    .vs_o           (vs_y),
    .line_end_o     (line_end_gb)
);


buffer #(
    .COLORDEPTH(COLORDEPTH),
    .SCREENWIDTH(SCREENWIDTH),
    .BUF_DEPTH(3)
   ) gray_buff_inst (
    .clk            (clk),
    .rst            (rst),
    .data_i         (gamma_o),
    .dv_i           (dv_y),
    .hs_i           (hs_y),
    .vs_i           (vs_y),
    .dv_o           (dv_gb),
    .hs_o           (hs_gb),
    .vs_o           (vs_gb),
    .line_end_i     (line_end_gb),
    .buff_o_0       (gb_line_o[0]),
    .buff_o_1       (gb_line_o[1]),
    .buff_o_2       (gb_line_o[2])
);

// TODO: bekotni a coef reget.
// gauss_blr_conv #(
convolution #(
    .COLORDEPTH(COLORDEPTH),
    .M_WIDTH(3),
    .M_DEPTH(3)
    ) blur_inst (
    .clk            (clk),
    .rst            (rst),
    .vect_in_0      (gb_line_o[0]),
    .vect_in_1      (gb_line_o[1]),
    .vect_in_2      (gb_line_o[2]),
    .conv_o         (blur_o),
    .coeff_i        (8'h1),
    .dv_i           (dv_gb),
    .hs_i           (hs_gb),
    .vs_i           (vs_gb),
    .dv_o           (dv_blur),
    .hs_o           (hs_blur),
    .vs_o           (vs_blur),
    .line_end_o     (line_end_bb)
);

buffer #(
    .COLORDEPTH(COLORDEPTH),
    .SCREENWIDTH(SCREENWIDTH),
    .BUF_DEPTH(3)
    ) blr_buff_inst (
    .clk            (clk),
    .rst            (rst),
    .data_i         (blur_o),
    .dv_i           (dv_blur),
    .hs_i           (hs_blur),
    .vs_i           (vs_blur),
    .dv_o           (dv_bb),
    .hs_o           (hs_bb),
    .vs_o           (vs_bb),
    .line_end_i     (line_end_bb),
    .buff_o_0       (bb_line_o[0]),
    .buff_o_1       (bb_line_o[1]),
    .buff_o_2       (bb_line_o[2])
);

// sobel_conv #(
convolution #(
    .COLORDEPTH(COLORDEPTH),
    .M_WIDTH(3),
    .M_DEPTH(3)
    ) sob_inst (
    .clk            (clk),
    .rst            (rst),
    .vect_in_0      (bb_line_o[0]),
    .vect_in_1      (bb_line_o[1]),
    .vect_in_2      (bb_line_o[2]),
    .conv_o         (sob_o),
    .coeff_i        (8'h1),
    .dv_i           (dv_bb),
    .hs_i           (hs_bb),
    .vs_i           (vs_bb),
    .dv_o           (dv_sob),
    .hs_o           (hs_sob),
    .vs_o           (vs_sob),
    .line_end_o     ()
);

always @ ( posedge clk ) begin : output_multiplexer
    case (sw)
        5'd0: begin : input_passtrough
            dv_o <= dv_i;                           red_o   <= red_i;         
            hs_o <= POL_HS ? hs_i : ~hs_i;          green_o <= green_i;
            vs_o <= POL_VS ? vs_i : ~vs_i;          blue_o  <= blue_i;
            
    end
        5'd1: begin : gamma_out
            dv_o <= dv_y;                           red_o   <= gamma_o;       
            hs_o <= POL_HS ? hs_y : ~hs_y;          green_o <= gamma_o;
            vs_o <= POL_VS ? vs_y : ~vs_y;          blue_o  <= gamma_o;
            
    end
        5'd2: begin : blurred_out
            dv_o <= dv_blur;                        red_o   <= blur_o;        
            hs_o <= POL_HS ? hs_blur : ~hs_blur;    green_o <= blur_o;
            vs_o <= POL_VS ? vs_blur : ~vs_blur;    blue_o  <= blur_o;
            
    end
        5'd4: begin :sobel_out
            dv_o <= dv_sob;                         red_o   <= sob_o;         
            hs_o <= POL_HS ? hs_sob : ~hs_sob;      green_o <= sob_o;
            vs_o <= POL_VS ? vs_sob : ~vs_sob;      blue_o  <= sob_o;
            
    end
        default: begin : def__input_out
            dv_o <= dv_i;                           red_o   <= red_i;         
            hs_o <= POL_HS ? hs_i : ~hs_i;          green_o <= green_i;
            vs_o <= POL_VS ? vs_i : ~vs_i;          blue_o  <= blue_i;
            
    end
    endcase
end

endmodule
