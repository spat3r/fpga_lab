`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:31:45 11/28/2012 
// Design Name: 
// Module Name:    rom_512x36 
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
module rom_512x35(
   input         clk,
   input   [8:0] addr,
   output [34:0] dout
);

(* ram_style = "block" *) reg signed [34:0] const_array[511:0];
initial $readmemh("coeffs_1k.txt", const_array);
//initial $readmemh("coeffs_2k_m2.txt", const_array);
//initial $readmemh("coeffs_allpass.txt", const_array);
//initial $readmemh("coeffs_avg.txt", const_array);
//initial $readmemh("coeffs_avg_m4.txt", const_array);
//initial $readmemh("coeffs_avg32_m2.txt", const_array);

reg [34:0] dout_reg;
always @ (posedge clk)
   dout_reg <= const_array[addr];
   
assign dout = dout_reg;


integer i;
reg signed [23:0] dbg_array[511:0];
initial
for (i=0; i<512; i=i+1)
   dbg_array[i] = const_array[i]>>9;

endmodule
