`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:27:27 11/28/2012 
// Design Name: 
// Module Name:    ram_512x36 
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
module ram #(
   parameter DATA_W = 24,
   parameter ADDR_W = 9
)(
   input               clk_a,
   input               we_a,
   input  [ADDR_W-1:0] addr_a,
   input  [DATA_W-1:0] din_a,
   output [DATA_W-1:0] dout_a,
   
   input               clk_b,
   input               we_b,
   input  [ADDR_W-1:0] addr_b,
   input  [DATA_W-1:0] din_b,
   output [DATA_W-1:0] dout_b
);

(* ram_style = "block" *) reg [DATA_W-1:0] ram_array[(2**ADDR_W)-1:0];
integer i;
initial
   for (i=0; i<(2**ADDR_W); i=i+1) ram_array[i] = 0;

reg [DATA_W-1:0] dout_reg_a;
always @ (posedge clk_a)
begin
   if (we_a) ram_array[addr_a] <= din_a;
   dout_reg_a <= ram_array[addr_a];
end
assign dout_a = dout_reg_a;


reg [DATA_W-1:0] dout_reg_b;
always @ (posedge clk_b)
begin
   if (we_b) ram_array[addr_b] <= din_b;
   dout_reg_b <= ram_array[addr_b];
end
assign dout_b = dout_reg_b;

endmodule
