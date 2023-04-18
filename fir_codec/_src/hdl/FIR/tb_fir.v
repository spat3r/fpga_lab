`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:43:50 11/07/2014
// Design Name:   fir_filter
// Module Name:   D:/BME/Education/logterv_2014/gyak/gyak_4/_src/tb_fir.v
// Project Name:  logterv_gyak4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fir_filter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_fir;

	// Inputs
	reg clk;
	reg rst;
	reg [1:0] din_valid;
	wire [23:0] din;

	// Outputs
	wire [1:0] dout_valid;
	wire [23:0] dout;

	// Instantiate the Unit Under Test (UUT)
	fir_filter uut (
		.clk(clk), 
		.rst(rst), 
		.din_valid(din_valid), 
		.din(din), 
		.dout_valid(dout_valid), 
		.dout(dout)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
		rst = 1;
		din_valid = 0;
	end


always #5 clk <= ~clk;

initial #102 rst = 0;

always #3000
begin
   @ (posedge clk)
   #2    din_valid = 1;
   #10   din_valid = 0;
   #3000 din_valid = 2;
   #10   din_valid = 0;
end


reg [31:0] smpl_cntr = 0;
always @ (posedge clk)
if (din_valid[1]) smpl_cntr <= smpl_cntr + 1;


assign #2 din = (smpl_cntr==3) ? 'h40_0000 : 0;

      
endmodule

