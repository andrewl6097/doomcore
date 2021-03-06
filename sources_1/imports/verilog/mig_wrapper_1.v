/*
 This file was generated automatically by Alchitry Labs version 1.2.5.
 Do not edit this file directly. Instead edit the original Lucid source.
 This is a temporary file and any changes made to it will be destroyed.
 */

module mig_wrapper_1 (input [127:0]  mem_in_app_wdf_data,
                      input          mem_in_app_wdf_end,
                      input          mem_in_app_wdf_wren,
                      input [15:0]   mem_in_app_wdf_mask,
                      input [2:0]    mem_in_app_cmd,
                      input          mem_in_app_en,
                      input [27:0]   mem_in_app_addr,

                      input          sys_rst,

                      output [127:0] mem_out_app_rd_data,
                      output         mem_out_app_rd_data_valid,
                      output         mem_out_app_rdy,
                      output         mem_out_app_wdf_rdy,
                      output         ui_clk,
                      output         sync_rst,
                      output         calib_complete,

                      inout [15:0]   ddr3_dq,
                      inout [1:0]    ddr3_dqs_n,
                      inout [1:0]    ddr3_dqs_p,
                      output [13:0]  ddr3_addr,
                      output [2:0]   ddr3_ba,
                      output         ddr3_ras_n,
                      output         ddr3_cas_n,
                      output         ddr3_we_n,
                      output         ddr3_reset_n,
                      output         ddr3_ck_p,
                      output         ddr3_ck_n,
                      output         ddr3_cke,
                      output         ddr3_cs_n,
                      output [1:0]   ddr3_dm,
                      output         ddr3_odt,
                      input          sys_clk,
                      input          clk_ref
                      );
   
   wire                             M_mig_app_sr_active;
   wire                             M_mig_app_rd_data_end;
   wire                             M_mig_app_ref_ack;
   wire                             M_mig_app_zq_ack;
   wire [11:0]                      M_mig_device_temp;

   wire                             sr_req = 1'b0;
   wire                             ref_req = 1'b0;
   wire                             zq_req = 1'b0;

   mig_7series_0 mig (
                      .ddr3_dq(ddr3_dq),
                      .ddr3_dqs_n(ddr3_dqs_n),
                      .ddr3_dqs_p(ddr3_dqs_p),
                      .sys_clk_i(sys_clk),
                      .clk_ref_i(clk_ref),
                      .app_addr(mem_in_app_addr),
                      .app_cmd(mem_in_app_cmd),
                      .app_en(mem_in_app_en),
                      .app_wdf_data(mem_in_app_wdf_data),
                      .app_wdf_end(mem_in_app_wdf_end),
                      .app_wdf_mask(mem_in_app_wdf_mask),
                      .app_wdf_wren(mem_in_app_wdf_wren),
                      .app_sr_req(sr_req),
                      .app_ref_req(ref_req),
                      .app_zq_req(zq_req),
                      .sys_rst(sys_rst),
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
                      .app_rd_data(mem_out_app_rd_data),
                      .app_rd_data_end(M_mig_app_rd_data_end),
                      .app_rd_data_valid(mem_out_app_rd_data_valid),
                      .app_rdy(mem_out_app_rdy),
                      .app_wdf_rdy(mem_out_app_wdf_rdy),
                      .app_sr_active(M_mig_app_sr_active),
                      .app_ref_ack(M_mig_app_ref_ack),
                      .app_zq_ack(M_mig_app_zq_ack),
                      .ui_clk(ui_clk),
                      .ui_clk_sync_rst(sync_rst),
                      .init_calib_complete(calib_complete),
                      .device_temp(M_mig_device_temp)
                      );
endmodule
