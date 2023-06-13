module convolution #(
    parameter COLORDEPTH = 8,
    parameter SCREENWIDTH = 1600,

    parameter M_WIDTH = 5,
    parameter M_DEPTH = 5
    ) (
    input  wire                   clk,
    input  wire                   rst,
    input  wire  [COLORDEPTH-1:0] vect_in_0,
    input  wire  [COLORDEPTH-1:0] vect_in_1,
    input  wire  [COLORDEPTH-1:0] vect_in_2,
    input  wire  [COLORDEPTH-1:0] vect_in_3,
    input  wire  [COLORDEPTH-1:0] vect_in_4,
    output wire  [COLORDEPTH-1:0] conv_o,
    input  wire            [15:0] coeff_i,
    input  wire                   dv_i,
    input  wire                   hs_i,
    input  wire                   vs_i,
    output reg                    line_end_o,
    output reg                    hs_o,
    output reg                    vs_o,
    output reg                    dv_o
        
    );

    wire [COLORDEPTH-1:0] vect_in [2:0];

    assign vect_in[0] = vect_in_0;
    assign vect_in[1] = vect_in_1;
    assign vect_in[2] = vect_in_2;
    assign vect_in[3] = vect_in_3;
    assign vect_in[4] = vect_in_4;

    localparam VECLENGTH = COLORDEPTH+1;
    reg   [15:0] coeff_reg [4:0];
    reg   [4:0] addr;
    reg   [5:0] hs_cnt;

    always @ (posedge clk) begin
        if (rst || ~vs_i) addr <= 0;
        else if (vs_i)
            if (addr == 4'd25) addr <= 4'd25;
            else               addr <= addr + 1;
    end

    always @(posedge clk) begin
        if (vs_i) coeff_reg[addr] <= coeff_i;
    end

    //**************************
    //*                        *
    //**************************
    wire  [47:0] pi [4:0];
    wire  [47:0] po [4:0];
    wire  [17:0] px_d [4:0];
    reg   [17:0] px_q [4:0];

    genvar i;
for (i = 0; i < 26; i=i+1 ) begin
    assign pi[i] = i ? {{8{po[i-1][47]}},po[i-1][47:8]} : 47'b0;
end

    genvar k;
generate
    for (k = 0; k < M_DEPTH*M_WIDTH; k = k + 1) begin
        // az elsĹ' oszlopot nem szĂĽksĂ©ges eltĂˇrolni, mivel a buffer nem hoz be
        // oszlopkĂ©sleltetĂ©st, ergo, ha engedi a kĂ©sleltetĂ©s:
        // d_in -> szorzĂˇs -> tĂˇrolĂˇs -> Ă¶sszeadĂˇsok -> tĂˇrolĂˇs -> d_out
        // d_in -> szorzĂˇs -> tĂˇrolĂˇs -> soron belĂĽl -> tĂˇrolĂˇs 
        //      -> sorok kĂ¶zĂ¶tt -> tĂˇrolĂˇs -> d_out

        assign px_d[k] = ((k % M_DEPTH) == 0) ? {10'b0,vect_in[k/M_DEPTH]} : px_q[k-1];

        always @( posedge clk ) px_q[k] <= ( hs_cnt[5:0] >= (k/M_DEPTH)) ? px_d[k] : 0;

        dsp_25x18 #(
                .A_REG(1),
                .B_REG(k+1)
            ) DSpi (
                .clk(clk),
                .a({{9{coeff_reg[15]}}, coeff_reg[k]}), // { 10*s7.8 }
                .b({px_d[k]}),// { 10*s.8 }
                .pci(pi[k]), // { 32*s7.8 }
                .p(po[k])
        );
    end
endgenerate
    
    wire [47:0] temp_trunc;
    assign temp_trunc = pi[25][47] ? ~pi[25]+1'b1 : pi[25][7:0];
    assign conv_o = temp_trunc[7:0];

    reg   [14:0] dv_shr;
    reg   [14:0] hs_shr;
    reg   [14:0] vs_shr;
    wire  line_end_d = dv_shr[12] & ~dv_shr[11];

    // dsp delay is 4 cycle, matrix size 3x3 => 9 cycle
    // total delay 13 cycle, 12 shr delay + 1 _o write delay 
    always @(posedge clk) begin
        if (rst) begin
            dv_shr <= 0; dv_o <= 0;
            hs_shr <= 0; hs_o <= 0;
            vs_shr <= 0; vs_o <= 0;
            hs_cnt <= 0;
        end else begin
            // TODO: itt meg kell hatĂˇrozni, hogy mennyi a kĂ©sleltetĂ©s
            // educated guess: M_DEPTH
            if (line_end_o & !hs_cnt[4]) hs_cnt <= hs_cnt + 1;
            else if (vs_i)               hs_cnt <= 0;
            dv_shr <= {dv_shr[13:0],dv_i};
            hs_shr <= {hs_shr[13:0],hs_i};
            if ( ~hs_o & hs_i)  vs_shr <= {vs_shr[13:0],vs_i};
            line_end_o <= line_end_d;
            dv_o <= dv_shr[12];
            hs_o <= hs_shr[12];
            // TODO: Ăˇtgondolni ez itt M_DEPTH-e
            vs_o <= vs_shr[12];
        end
    end

endmodule



