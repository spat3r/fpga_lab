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
module dsp_25x18_presub #(
    parameter USE_PCI_REG = 0
    )(
    input  wire                clk,
    input  wire  signed [24:0] a,
    input  wire  signed [29:0] d,
    input  wire  signed [17:0] b,
    input  wire  signed [47:0] pci, 
    output wire  signed [47:0] p
    );

    wire  signed [24:0] ad_d;
    wire  signed [42:0] m_d;
    wire  signed [47:0] p_d;

    reg   signed [24:0] a_q;
    reg   signed [29:0] d_q;
    reg   signed [24:0] ad_q;
    reg   signed [17:0] b_q [1:0];
    reg   signed [47:0] pci_q;
    reg   signed [42:0] m_q;
    reg   signed [47:0] p_q;


    always @ (posedge clk) begin
        pci_q <= pci;
        a_q <= a;
        d_q <= d;
        b_q[0] <= b;
        b_q[1] <= b_q[0];
    end

    assign ad_d = a_q - d_q;
    assign m_d = ad_q * b_q[1];
    assign p_d = m_q  + (USE_PCI_REG ? pci_q : pci);


    always @ (posedge clk) begin
        ad_q <= ad_d;
        m_q <= m_d;
        p_q <= p_d;
    end

    assign p = p_q;

endmodule
