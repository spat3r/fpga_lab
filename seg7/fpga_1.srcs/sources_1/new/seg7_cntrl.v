`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 03:13:50 PM
// Design Name: 
// Module Name: seg7_cntrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seg7_cntrl(
    input wire clk,
    input wire rst,
    input wire [3:0] d0,
    input wire [3:0] d1,
    input wire [3:0] d2,
    input wire [3:0] d3,
    
    output reg [3:0] digsel,
    output reg [7:0] seg
);

reg [16:0] cntr_en;
wire en;
always @ (posedge clk)
if (rst | en)
    cntr_en <= 17'b0;
else
    cntr_en <= cntr_en + 1;

assign en = cntr_en[16];

reg [3:0] shr_dig;
reg [1:0] cntr_dig;
always @ (posedge clk)
if (rst)
begin
    shr_dig  <= 4'b0001;
    cntr_dig <= 2'b0;
end
else if (en)
begin
    shr_dig  <= {shr_dig[2:0], shr_dig[3]};
    cntr_dig <= cntr_dig + 1;
end

reg [3:0] mux;
always @ ( * )
case (cntr_dig)
    2'd1: mux <= d1;
    2'd2: mux <= d2;
    2'd3: mux <= d3;
    default: mux <= d0;
endcase

// 7-segment encoding
//      0
//     ---
//  5 |   | 1
//     --- <--6
//  4 |   | 2
//     ---
//      3
reg [7:0] seg_dec;
always @( * )
case (mux)
    4'b0001 : seg_dec = 8'b11111001;   // 1
    4'b0010 : seg_dec = 8'b10100100;   // 2
    4'b0011 : seg_dec = 8'b10110000;   // 3
    4'b0100 : seg_dec = 8'b10011001;   // 4
    4'b0101 : seg_dec = 8'b10010010;   // 5
    4'b0110 : seg_dec = 8'b10000010;   // 6
    4'b0111 : seg_dec = 8'b11111000;   // 7
    4'b1000 : seg_dec = 8'b10000000;   // 8
    4'b1001 : seg_dec = 8'b10010000;   // 9
    4'b1010 : seg_dec = 8'b10001000;   // A
    4'b1011 : seg_dec = 8'b10000011;   // b
    4'b1100 : seg_dec = 8'b11000110;   // C
    4'b1101 : seg_dec = 8'b10100001;   // d
    4'b1110 : seg_dec = 8'b10000110;   // E
    4'b1111 : seg_dec = 8'b10001110;   // F
    default : seg_dec = 8'b11000000;   // 0
endcase

always @ (posedge clk)
begin
    digsel <= shr_dig;
    seg    <= ~seg_dec;
end

endmodule
