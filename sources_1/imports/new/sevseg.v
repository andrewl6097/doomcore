`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2021 10:01:00 PM
// Design Name: 
// Module Name: sevseg
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


module sevseg(
            input [31:0] din,
            input        clk,

            output [7:0] segments,
            output [3:0] digits
  );

   localparam COUNTER_WIDTH = 18;

   reg [7:0]             data1;
   reg [7:0]             data2;
   reg [7:0]             data3;
   reg [7:0]             data4;

   reg [3:0]             cur_seg = 4'b0001;

   reg [7:0]             out_data = 8'h00;

   wire [3:0]            cur_seg_n = ~cur_seg;

   reg [COUNTER_WIDTH-1:0]            counter = {COUNTER_WIDTH{1'b0}};

   assign segments = out_data;
   assign digits = cur_seg_n;
   
   always @(posedge clk) begin
      {data1, data2, data3, data4} <= din;

      if (counter == ~{COUNTER_WIDTH{1'b0}}) begin
         if (cur_seg == 4'b1000)
           cur_seg <= 4'b0001;
         else
           cur_seg <= cur_seg << 1;
      end

      counter <= counter + 1'b1;

      case (cur_seg)
        4'b1000: out_data <= data1;
        4'b0100: out_data <= data2;
        4'b0010: out_data <= data3;
        4'b0001: out_data <= data4;
        default: out_data <= 8'h55;
      endcase
   end
endmodule
