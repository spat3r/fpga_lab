`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 03:53:27 PM
// Design Name: 
// Module Name: top_level
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


module top_level(
    input  wire       clk,
    input  wire       rst,
    output wire [3:0] digsel,
    output wire [7:0] seg
);
    
    
    
seg7_cntrl seg7_cntrl_i(
    .clk(clk),
    .rst(rst),
    .d0(4'd0),
    .d1(4'd1),
    .d2(4'd2),
    .d3(4'd3),

    .digsel(digsel),
    .seg(seg)
);
endmodule
