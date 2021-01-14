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

            output [7:0]     debug_leds,

            input [7:0]      data_in,
            input            data_in_en,
            output reg       data_in_rdy
  );

   reg [12:0]      r_counter_in;
   reg [12:0]      r_counter_out;
   reg [12:0]      w_counter_in;
   reg [12:0]      w_counter_out;

   localparam WAITING = 3'b000;
   localparam WAITING_FOR_HALF = 3'b001;
   localparam WAITING_FOR_BIT = 3'b011;
   localparam STOP = 3'b111;
   localparam FULL = 13'b1000010000110;
   localparam HALF = 12'b100001000011;

   reg             rdy_out = 1'b0;
   reg             rdy_in = 1'b0;
   assign data_rdy = rdy_out;
   
   reg             rx_in = 1'b1;
   reg             rx_out = 1'b1;
   reg [2:0]       r_state_in = WAITING;
   reg [2:0]       r_state_out = WAITING;
   
   reg [2:0]       w_state_in = WAITING;
   reg [2:0]       w_state_out = WAITING;

   reg [3:0]       bits_recvd_in;
   reg [3:0]       bits_recvd_out = 4'b0;

   reg [3:0]       bits_written_in;
   reg [3:0]       bits_written_out = 4'b0;

   reg [7:0]       tmp_buf_in;
   reg [7:0]       tmp_buf_out;

   reg [7:0]       wrt_buf_in;
   reg [7:0]       wrt_buf_out;

   reg [7:0]       led_buf = 8'b0;
   assign debug_leds = led_buf;

   // Reads
   always @(posedge clk) begin
      rx_in <= rx;

      rx_out <= rx_in;
      r_state_out <= r_state_in;
      r_counter_out <= r_counter_in;
      bits_recvd_out <= bits_recvd_in;
      tmp_buf_out <= tmp_buf_in;
      rdy_out <= rdy_in;

      case (r_state_out)
        WAITING: begin
           if (!rx_out) begin
              r_counter_in <= 14'b0;
              r_state_in <= WAITING_FOR_HALF;
           end
        end
        WAITING_FOR_HALF: begin
           if (r_counter_out == HALF) begin // half cycle
              r_counter_in <= 14'b0;
              r_state_in <= WAITING_FOR_BIT;
              bits_recvd_in <= 4'b0;
           end else
             r_counter_in <= r_counter_out + 1'b1;
        end
        WAITING_FOR_BIT: begin
           if (r_counter_out == FULL) begin
              r_counter_in <= 14'b0;
              if (bits_recvd_out == 4'b1000) begin
                 rdy_in <= 1'b1;
                 data_out <= tmp_buf_out;
                 r_state_in <= STOP;
              end else begin
                 case (bits_recvd_out)
                   4'b0000: led_buf[0] <= rx_out;
                   4'b0001: led_buf[1] <= rx_out;
                   4'b0010: led_buf[2] <= rx_out;
                   4'b0011: led_buf[3] <= rx_out;
                   4'b0100: led_buf[4] <= rx_out;
                   4'b0101: led_buf[5] <= rx_out;
                   4'b0110: led_buf[6] <= rx_out;
                   4'b0111: led_buf[7] <= rx_out;
                 endcase
                 tmp_buf_in <= {rx_out, tmp_buf_out[7:1]};
                 bits_recvd_in <= bits_recvd_out + 1'b1;
              end
           end else
             r_counter_in <= r_counter_out + 1'b1;
        end
        STOP: begin
           rdy_in <= 1'b0;
           if (rx_out == 1'b1)
              r_state_in <= WAITING;
        end
      endcase
   end

   // Writes
   always @(posedge clk) begin
      w_state_out <= w_state_in;
      w_counter_out <= w_counter_in;
      wrt_buf_out <= wrt_buf_in;
      bits_written_out <= bits_written_in;

      case (w_state_out)
        WAITING: begin
           if (data_in_en) begin
              wrt_buf_in <= data_in;
              w_state_in <= WAITING_FOR_BIT;
              w_counter_in <= 14'b0;
              data_in_rdy <= 1'b0;
              bits_written_in <= 4'b0;
              tx <= 1'b0;
           end else begin
              tx <= 1'b1;
              data_in_rdy <= 1'b1;
           end
        end
        WAITING_FOR_BIT: begin
           if (w_counter_out == FULL) begin
              w_counter_in <= 14'b0;
              if (bits_written_out == 4'b1000) begin
                 tx <= 1'b1;
                 w_state_in <= STOP;
              end else begin
                 {tx, wrt_buf_in} <= {wrt_buf_out[0], 1'b0, wrt_buf_out[7:1]};
                 bits_written_in <= bits_written_out + 1'b1;
              end
           end else
             w_counter_in <= w_counter_out + 1'b1;
        end
        STOP: begin
           if (w_counter_out == FULL) begin
              w_counter_in <= 14'b0;
              tx <= 1'b1;
              w_state_in <= WAITING;
              data_in_rdy <= 1'b1;
           end else
             w_counter_in <= w_counter_out + 1'b1;
        end
      endcase
   end
endmodule
