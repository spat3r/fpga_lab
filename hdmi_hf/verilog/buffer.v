module buffer #(
    parameter COLORDEPTH = 8,
    parameter SCREENWIDTH = 1600,
    parameter BUF_DEPTH = 5
) (
    input  wire                   clk,
    input  wire                   rst,
    input  wire  [COLORDEPTH-1:0] data_i,
    input  wire                   line_end_i,
    input  wire                   dv_i,
    input  wire                   hs_i,
    input  wire                   vs_i,
    output reg                    dv_o,
    output reg                    hs_o,
    output reg                    vs_o,
    output reg   [COLORDEPTH-1:0] buff_o_0,
    output wire   [COLORDEPTH-1:0] buff_o_1,
    output wire   [COLORDEPTH-1:0] buff_o_2,
    output wire   [COLORDEPTH-1:0] buff_o_3,
    output wire   [COLORDEPTH-1:0] buff_o_4
);

reg [10:0] addr;
reg [COLORDEPTH-1:0] buff_o [2:0];

always @(posedge clk) begin
    if (rst) begin
        addr <= 0;
    end else begin
        if (dv_i) addr <= addr + 1;
        else      addr <= 0;
    end
end

//**************************
//*                        *
//**************************
always @ (posedge clk) buff_o[0] <= data_i;

assign en = dv_i | dv_o;
assign we = dv_o;

//**************************
//*                        *
//**************************
genvar k;
generate
    for (k = 1; k < BUF_DEPTH; k = k + 1) begin
        wire  [COLORDEPTH-1:0] din_k;
        reg   [COLORDEPTH-1:0] memory_k [SCREENWIDTH-1:0];

        assign din_k = buff_o[(k-1)];

        //sync dualp memory line n-1
        always @ (posedge clk) begin
            if (en) begin
                if (we) memory_k[addr-1'b1] <= din_k;
                buff_o[k] <= memory_k[addr];
            end
        end
    end
endgenerate

assign buff_o_0 = buff_o[0];
assign buff_o_1 = buff_o[1];
assign buff_o_2 = buff_o[2];
assign buff_o_3 = buff_o[3];
assign buff_o_4 = buff_o[4];

// TODO: the last row stays in the ram and it is transfered to the forst row of the next image

    always @(posedge clk) begin
        if (rst) begin
            dv_o <= 0;
            hs_o <= 0;
            vs_o <= 0;
        end else begin
            dv_o <= dv_i;
            hs_o <= hs_i;
            vs_o <= vs_i;
        end
    end
endmodule