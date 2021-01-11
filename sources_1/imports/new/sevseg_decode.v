`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2021 10:24:28 AM
// Design Name: 
// Module Name: sevseg_decode
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


module sevseg_decode(
                     input [3:0] in,
                     output reg [7:0] out
  );

   always @(*) begin
      case (in)
        4'h0: out = ~8'b00111111;
        4'h1: out = ~8'b00000110;
        4'h2: out = ~8'b01011011;
        4'h3: out = ~8'b01001111;
        4'h4: out = ~8'b01100110;
        4'h5: out = ~8'b01101101;
        4'h6: out = ~8'b01111101;
        4'h7: out = ~8'b00000111;
        4'h8: out = ~8'b01111111;
        4'h9: out = ~8'b01100111;
        4'ha: out = ~8'b01110111;
        4'hb: out = ~8'b01111100;
        4'hc: out = ~8'b01011000;
        4'hd: out = ~8'b01011110;
        4'he: out = ~8'b01111001;
        4'hf: out = ~8'b01110001;
      endcase
   end
endmodule
