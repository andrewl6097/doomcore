`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2021 10:05:49 PM
// Design Name: 
// Module Name: memory
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
module memory(
              input         wea,
              input         en,
              input [25:0]  addr, // 26-bit address of 4-byte range
              input [31:0]  din,
              output [31:0] dout,
              input         cmd,
              output        cmd_rdy,
              output        write_rdy,
              output        read_arrived,
              output        ui_clk,
              output        sync_rst,
              output        calibrated,

              // DDR3
              inout [15:0]  ddr3_dq,
              inout [1:0]   ddr3_dqs_n,
              inout [1:0]   ddr3_dqs_p,
              output [13:0] ddr3_addr,
              output [2:0]  ddr3_ba,
              output        ddr3_ras_n,
              output        ddr3_cas_n,
              output        ddr3_we_n,
              output        ddr3_reset_n,
              output        ddr3_ck_p,
              output        ddr3_ck_n,
              output        ddr3_cke,
              output        ddr3_cs_n,
              output [1:0]  ddr3_dm,
              output        ddr3_odt,
              input         sys_clk,
              input         clk_ref,
              input         sys_rst
    );

   wire [127:0]             mem_in_app_wdf_data;
   
   wire                     mem_in_app_wdf_end = wea;
   wire                     mem_in_app_wdf_wren = wea;
   wire [2:0]               mem_in_app_cmd = {2'b0, cmd};

   wire [23:0]              addr_128; // represents the 24-bit address
                                      // of a 16-byte range native to
                                      // the DDR

   assign addr_128 = addr[25:2];

   wire [15:0]              mem_in_app_wdf_mask;
   assign mem_in_app_wdf_mask[15:12] = {4{~(~addr[1] & ~addr[0])}};
   assign mem_in_app_wdf_mask[11:8] = {4{~(~addr[1] & addr[0])}};
   assign mem_in_app_wdf_mask[7:4] = {4{~(addr[1] & ~addr[0])}};
   assign mem_in_app_wdf_mask[3:0] = {4{~(addr[1] & addr[0])}};

   wire [27:0]              mem_in_app_addr = {1'b0, addr_128, 3'b0};

   wire [127:0]             mem_out_app_rd_data;

   assign mem_in_app_wdf_data = (addr[1:0] == 2'b00) ? {din, 96'b0} :
                                 ((addr[1:0] == 2'b01) ? {32'b0, din, 64'b0} :
                                  ((addr[1:0] == 2'b10) ? {64'b0, din, 32'b0} : {96'b0, din}));

   assign dout = (addr[1:0] == 2'b00) ? mem_out_app_rd_data[127:96] :
                  ((addr[1:0] == 2'b01) ? mem_out_app_rd_data[95:64] :
                   ((addr[1:0] == 2'b10) ? mem_out_app_rd_data[63:32] : mem_out_app_rd_data[31:0]));

   mig_wrapper_1 mig (
    .mem_in_app_wdf_data(mem_in_app_wdf_data),
    .mem_in_app_wdf_end(mem_in_app_wdf_end),
    .mem_in_app_wdf_wren(mem_in_app_wdf_wren),
    .mem_in_app_wdf_mask(mem_in_app_wdf_mask),
    .mem_in_app_cmd(mem_in_app_cmd),
    .mem_in_app_en(en),
    .mem_in_app_addr(mem_in_app_addr),
    .mem_out_app_rd_data(mem_out_app_rd_data),
    .mem_out_app_rd_data_valid(read_arrived),
    .mem_out_app_rdy(cmd_rdy),
    .mem_out_app_wdf_rdy(write_rdy),
    .calib_complete(calibrated),
    .ui_clk(ui_clk),
    .sync_rst(sync_rst),

    // DDR3
    .ddr3_dq(ddr3_dq),
    .ddr3_dqs_n(ddr3_dqs_n),
    .ddr3_dqs_p(ddr3_dqs_p),
    .ddr3_addr(ddr3_addr),
    .ddr3_ba(ddr3_ba),
    .ddr3_ras_n(ddr3_ras_n),
    .ddr3_cas_n(ddr3_cas_n),
    .ddr3_we_n(ddr3_we_n),
    .ddr3_reset_n(ddr3_reset_n),
    .ddr3_ck_p(ddr3_ck_p),
    .ddr3_ck_n(ddr3_ck_n),
    .ddr3_cke(ddr3_cke),
    .ddr3_cs_n(ddr3_cs_n),
    .ddr3_dm(ddr3_dm),
    .ddr3_odt(ddr3_odt),
    .sys_clk(sys_clk),
    .clk_ref(clk_ref),
    .sys_rst(sys_rst)
  );
endmodule
