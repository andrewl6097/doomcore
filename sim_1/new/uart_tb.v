`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2021 06:29:43 PM
// Design Name: 
// Module Name: uart_tb
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


module uart_tb(
  );

   reg clk = 1'b0;
   reg rx = 1'b1;

   wire [7:0] data_out;
   wire       data_rdy;

   uart uut(.clk(clk), .rx(rx), .data_out(data_out), .data_rdy(data_rdy));

   localparam WIDTH=24'd104166;

   always #6.153 clk=~clk;

   initial begin
      #2000
        rx=1'b0;                // start
      #WIDTH
        rx = 1'b1;
      #WIDTH
        rx = 1'b0;
      #WIDTH
        rx = 1'b1;
      #WIDTH
        rx = 1'b1;
      #WIDTH
        rx = 1'b1;
      #WIDTH
        rx = 1'b0;
      #WIDTH
        rx = 1'b0;
      #WIDTH
        rx = 1'b1;
      #WIDTH
        rx = 1'b0;              // stop
      #WIDTH
        rx = 1'b1;              // hack to high
   end

   // 10110101
endmodule
