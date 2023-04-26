`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:00:33 11/06/2014 
// Design Name: 
// Module Name:    dsp_block 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dsp_25x18
#(
   parameter A_REG = 2,
   parameter B_REG = 2
)(
   input                clk,
   input  signed [24:0] a,
   input  signed [29:0] d,
   input  signed [17:0] b,
   input  signed [47:0] pci, 
   output signed [47:0] p
);

reg signed [24:0] a_reg;
reg signed [29:0] d_reg;
reg signed [24:0] ad_reg;
reg signed [17:0] b_reg[1:0];
reg signed [42:0] m_reg;
reg signed [47:0] p_reg;


always @ (posedge clk) begin
   a_reg <= a;
   d_reg <= d;
   b_reg[0] <= b;
   b_reg[1] <= b_reg[0];
end

always @ (posedge clk)
begin
   ad_reg <= a_reg-d_reg;
   m_reg <= ad_reg*b_reg;
   p_reg <= m_reg+pci;
end

assign p = p_reg;

endmodule
