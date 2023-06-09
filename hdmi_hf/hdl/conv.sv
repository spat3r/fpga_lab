module convolution #(
    parameter COLORDEPTH = 8,
    parameter SCREENWIDTH = 1600,

    parameter M_WIDTH = 3,
    parameter M_DEPTH = 3
    ) (
    input  logic                  clk,
    input  logic                  rst,
    input  logic [COLORDEPTH-1:0] vect_in [M_DEPTH-1:0],
    output logic [COLORDEPTH-1:0] conv_o,
    input  logic            [8:0] coeff_i,
    input  logic                  dv_i,
    input  logic                  hs_i,
    input  logic                  vs_i,
    output logic                  line_end_o,
    output logic                  hs_o,
    output logic                  vs_o,
    output logic                  dv_o
        
    );

// TODO: Ellenőrízni kell hogy a conv module alkalmas-e a paraméterek fogadására.
    localparam VECLENGTH = COLORDEPTH+1;
    logic [VECLENGTH-1:0] coeff_reg [8:0] = '{{9'd0},  {9'd0},  {9'd0}, {-9'd0},  {9'd1},  {9'd0}, {9'd0}, { 9'd0},  {9'd0}};
    logic [$rtoi($ceil($clog2(VECLENGTH))):0] addr;
    logic [5:0] hs_cnt;

    always_ff @ (posedge clk) begin
        if (rst || ~vs_i) addr <= 0;
        else if (vs_i)
            if (addr == 5'd10) addr <= 5'd10;
            else               addr <= addr + 1;
    end

// FIXME: A conv modul elvileg úgy fogadná az új paramétereket, hogy a VSYNC jelváltásnál 25 órajelciklus alatt végigprget egy [33:0] [24:0] regisztertömböt és feltölti az együtthatókkal
    always_ff @(posedge clk) begin
        if (vs_i) coeff_reg[addr] <= coeff_i;
    end

    //**************************
    //*                        *
    //**************************
    logic [47:0] pi [8:0];
    logic [47:0] po [8:0];
    logic [VECLENGTH-1:0] px_d [8:0];
    logic [VECLENGTH-1:0] px_q [8:0];

    genvar i;
for (i = 0; i < 9; i=i+1 ) begin
    assign pi[i] = i ? po[i-1] : 9'b0;
end

    genvar k;
generate
    for (k = 0; k < M_DEPTH*M_WIDTH; k = k + 1) begin
        // az első oszlopot nem szükséges eltárolni, mivel a buffer nem hoz be
        // oszlopkésleltetést, ergo, ha engedi a késleltetés:
        // d_in -> szorzás -> tárolás -> összeadások -> tárolás -> d_out
        // d_in -> szorzás -> tárolás -> soron belül -> tárolás 
        //      -> sorok között -> tárolás -> d_out

        assign px_d[k] = ((k % M_DEPTH) == 0) ? {1'b0,vect_in[k/M_DEPTH]} : px_q[k-1];

        always_ff @( posedge clk ) px_q[k] <= ( hs_cnt[5:0] >= (k/M_DEPTH)) ? px_d[k] : 0;

// TODO: Le kell ellenőrízni, hogy a conv blokk jól számol-e.
        dsp_25x18 #(
                .A_REG(1),
                .B_REG(k+1)
            ) DSpi (
                .clk(clk),
                .a({{15{coeff_reg[8]}}, coeff_reg[k]}),
                .b({0,px_d[k]}),
                .pci(pi[k]), 
                .p(po[k])
        );
    end
endgenerate

    assign conv_o = po[8][9] ? (~po[8]+1'b1) : po[8];

    logic [14:0] dv_shr;
    logic [14:0] hs_shr;
    logic [14:0] vs_shr;
    logic line_end_d = dv_shr[12] & ~dv_shr[11];

    // dsp delay is 4 cycle, matrix size 3x3 => 9 cycle
    // total delay 13 cycle, 12 shr delay + 1 _o write delay 
    always_ff @(posedge clk) begin
        if (rst) begin
            dv_shr <= 0; dv_o <= 0;
            hs_shr <= 0; hs_o <= 0;
            vs_shr <= 0; vs_o <= 0;
            hs_cnt <= 0;
        end else begin
            // TODO: itt meg kell határozni, hogy mennyi a késleltetés
            // educated guess: M_DEPTH
            if (line_end_o & !hs_cnt[1]) hs_cnt <= hs_cnt + 1;
            else if (vs_i)               hs_cnt <= 0;
            dv_shr <= {dv_shr[13:0],dv_i};
            hs_shr <= {hs_shr[13:0],hs_i};
            if ( ~hs_o & hs_i)  vs_shr <= {vs_shr[13:0],vs_i};
            line_end_o <= line_end_d;
            dv_o <= dv_shr[12];
            hs_o <= hs_shr[12];
            // TODO: átgondolni ez itt M_DEPTH-e
            vs_o <= vs_shr[12];
        end
    end

endmodule



