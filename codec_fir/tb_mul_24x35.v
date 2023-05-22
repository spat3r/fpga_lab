`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2019 09:23:02 AM
// Design Name: 
// Module Name: tb_mul_24x35
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


module tb_mul_24x35();

reg clk = 1;
always #5 clk <= ~clk;

reg signed [23:0] a;
reg signed [34:0] b;
wire signed [58:0] m;

wire signed [58:0] m_tb;

mul_24x35 UUT(
   .clk(clk),
   .a(a),
   .b(b),
   .m(m)
);

assign m_tb = a*b;
initial
begin
   a = 1;
   b = 1;
#100
   a = 24'h400000;
   b = 35'h80000000;
#100
   a = 1000;
   b = 1000;
#100
   a = 65397;
   b = 121375;
#100
   a = -65397;
   b = 121375;
#100
   a = 65397;
   b = -121375;
#100
   a = -65397;
   b = -121375;
end


endmodule
