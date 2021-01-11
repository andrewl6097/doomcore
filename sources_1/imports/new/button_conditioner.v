`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2021 04:11:47 PM
// Design Name: 
// Module Name: button_conditioner
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

module button_conditioner (input  clk,
                           input  btn,
                           output out
                           );

   reg                            stable_button = 1'b0;
   reg                            pipe = 1'b0;
   reg                            last = 1'b0;
   reg                            button_down = 1'b0;
   reg                            up_allowed = 1'b1;

   reg                            waiting = 1'b0;
   reg [23:0]                     counter = 24'h000000;
   
   assign out = {stable_button && !last && up_allowed};

   always @(posedge clk) begin
      {stable_button, pipe} <= {pipe, btn};
      if (!stable_button && last) begin
         counter <= 0;
         up_allowed <= 1'b0;
         waiting <= 1'b1;
      end else if (waiting) begin
        counter <= counter + 1'b1;
         if (counter == 24'hFFFFFF) begin
            up_allowed <= 1'b1;
            waiting <= 1'b0;
         end
      end 
      last <= stable_button;
   end
   
endmodule
