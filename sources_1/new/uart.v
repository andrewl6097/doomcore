`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2021 10:59:32 AM
// Design Name: 
// Module Name: uart
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


module uart(
            input            clk, // 81.25MHz
            input            rx,
            output           tx,
            output reg [7:0] data_out,
            output           data_rdy
  );

   // 100MHz / 9600 => 10416 cycles per bit
   reg [13:0]      counter;

   localparam WAITING = 3'b000;
   localparam WAITING_FOR_HALF = 3'b001;
   localparam WAITING_FOR_BIT = 3'b010;
   localparam PARITY = 3'b011;
   localparam STOP1 = 3'b100;
   localparam STOP2 = 3'b101;

   reg             rdy = 1'b0;
   assign data_rd = rdy;
   reg [2:0]       state = WAITING;
   reg [3:0]       bits_recvd;
   reg             parity;

   reg [7:0]       tmp_buf;

   localparam FULL = 14'b10000100001111;
   localparam HALF = 14'b01000010000111;

   always @(posedge clk) begin
      case (state)
        WAITING: begin
           if (!rx) begin
              counter <= 14'b0;
              state <= WAITING_FOR_HALF;
           end
        end
        WAITING_FOR_HALF: begin
           if (counter == HALF) begin // half cycle
              counter <= 14'b0;
              state <= WAITING_FOR_BIT;
              bits_recvd <= 4'b0;
           end else
             counter <= counter + 1'b1;
        end
        WAITING_FOR_BIT: begin
           if (counter == FULL) begin
              counter <= 14'b0;
              if (bits_recvd == 4'b1000) begin
                 rdy <= 1'b1;
                 data_out <= tmp_buf;
                 state <= PARITY;
              end else begin
                 tmp_buf <= {rx, tmp_buf[7:1]};
                 bits_recvd <= bits_recvd + 1'b1;
              end
           end else
             counter <= counter + 1'b1;
        end
        PARITY: begin
           if (rdy == 1'b1)
             rdy <= 1'b0;
           if (counter == FULL) begin
              counter <= 14'b0;
              parity <= rx;
              state <= STOP1;
           end else
             counter <= counter + 1'b1;
        end
        STOP1: begin
           if (counter == FULL) begin
              counter <= 14'b0;
              state <= STOP2;
           end else
             counter <= counter + 1'b1;
        end
        STOP2: begin
           if (counter == FULL) begin
              counter <= 14'b0;
              state <= WAITING;
           end else
             counter <= counter + 1'b1;
        end
      endcase
   end
endmodule
