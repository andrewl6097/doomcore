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
            output reg       tx,
            output reg [7:0] data_out,
            output           data_rdy,

            input [7:0]      data_in,
            input            data_in_en,
            output reg       data_in_rdy          
  );

   // 100MHz / 9600 => 10416 cycles per bit
   reg [13:0]      r_counter;
   reg [13:0]      w_counter;
   localparam WAITING = 3'b000;
   localparam WAITING_FOR_HALF = 3'b001;
   localparam WAITING_FOR_BIT = 3'b010;
   localparam STOP1 = 3'b100;
   localparam STOP2 = 3'b101;

   reg             rdy = 1'b0;
   assign data_rdy = rdy;
   reg [2:0]       r_state = WAITING;
   reg [2:0]       w_state = WAITING;

   reg [3:0]       bits_recvd;
   reg [3:0]       bits_written;

   reg [7:0]       tmp_buf;
   reg [7:0]       wrt_buf;

   localparam FULL = 14'b10000100001111;
   localparam HALF = 14'b01000010000111;

   // Writes
   always @(posedge clk) begin
      case (w_state)
        WAITING: begin
           if (data_in_en) begin
              wrt_buf <= data_in;
              w_state <= WAITING_FOR_BIT;
              w_counter <= 14'b0;
              data_in_rdy <= 1'b0;
              bits_written <= 4'b0;
              tx <= 1'b0;
           end else
             tx <= 1'b1;
        end
        WAITING_FOR_BIT: begin
           if (w_counter == FULL) begin
              w_counter <= 14'b0;
              if (bits_written == 4'b1000) begin
                 tx <= 1'b1;
                 w_state <= STOP1;
              end else begin
                 {tx, wrt_buf} <= {wrt_buf[0], 1'b0, wrt_buf[7:1]};
                 bits_written <= bits_written + 1'b1;
              end
           end else
             w_counter <= w_counter + 1'b1;
        end
        STOP1: begin
           if (w_counter == FULL) begin
              w_counter <= 14'b0;
              tx <= 1'b1;
              w_state <= WAITING;
              data_in_rdy <= 1'b1;
           end else
             w_counter <= w_counter + 1'b1;
        end
      endcase
   end

   // Reads
   always @(posedge clk) begin
      case (r_state)
        WAITING: begin
           if (!rx) begin
              r_counter <= 14'b0;
              r_state <= WAITING_FOR_HALF;
           end
        end
        WAITING_FOR_HALF: begin
           if (r_counter == HALF) begin // half cycle
              r_counter <= 14'b0;
              r_state <= WAITING_FOR_BIT;
              bits_recvd <= 4'b0;
           end else
             r_counter <= r_counter + 1'b1;
        end
        WAITING_FOR_BIT: begin
           if (r_counter == FULL) begin
              r_counter <= 14'b0;
              if (bits_recvd == 4'b1000) begin
                 rdy <= 1'b1;
                 data_out <= tmp_buf;
                 r_state <= STOP2;
              end else begin
                 tmp_buf <= {rx, tmp_buf[7:1]};
                 bits_recvd <= bits_recvd + 1'b1;
              end
           end else
             r_counter <= r_counter + 1'b1;
        end
        STOP2: begin
           if (rdy == 1'b1)
             rdy <= 1'b0;
           if (r_counter == FULL) begin
              r_counter <= 14'b0;
              r_state <= WAITING;
           end else
             r_counter <= r_counter + 1'b1;
        end
      endcase
   end
endmodule
