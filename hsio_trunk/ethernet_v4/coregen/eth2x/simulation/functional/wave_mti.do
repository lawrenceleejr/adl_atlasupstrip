view structure
view signals
view wave
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {System Signals}
add wave -noupdate -format Logic /testbench/reset
add wave -noupdate -format Logic /testbench/gtx_clk
add wave -noupdate -format Logic /testbench/host_clk
add wave -noupdate -format Logic /testbench/mgtclk_p
add wave -noupdate -format Logic /testbench/mgtclk_n
add wave -noupdate -divider {EMAC0 Tx Client Interface}
add wave -noupdate -format Logic /testbench/dut/tx_clk_0_i
add wave -noupdate -format Literal /testbench/dut/tx_ll_data_0_i
add wave -noupdate -format Logic /testbench/dut/tx_ll_src_rdy_n_0_i
add wave -noupdate -format Logic /testbench/dut/tx_ll_dst_rdy_n_0_i
add wave -noupdate -format Logic /testbench/dut/tx_ll_sof_n_0_i
add wave -noupdate -format Logic /testbench/dut/tx_ll_eof_n_0_i
add wave -noupdate -divider {EMAC0 Rx Client Interface}
add wave -noupdate -format Logic /testbench/dut/rx_clk_0_i
add wave -noupdate -format Literal /testbench/dut/rx_ll_data_0_i
add wave -noupdate -format Logic /testbench/dut/rx_ll_src_rdy_n_0_i
add wave -noupdate -format Logic /testbench/dut/rx_ll_dst_rdy_n_0_i
add wave -noupdate -format Logic /testbench/dut/rx_ll_sof_n_0_i
add wave -noupdate -format Logic /testbench/dut/rx_ll_eof_n_0_i
add wave -noupdate -format Logic /testbench/dut/v4_emac_ll/rx_bad_frame_0_i
add wave -noupdate -format Logic /testbench/dut/v4_emac_ll/rx_good_frame_0_i
add wave -noupdate -divider {EMAC0 RocketIO Interface}
add wave -noupdate -format Logic /testbench/txp_0
add wave -noupdate -format Logic /testbench/txn_0
add wave -noupdate -format Logic /testbench/rxp_0
add wave -noupdate -format Logic /testbench/rxn_0
add wave -noupdate -divider {EMAC0 MDIO Interface}
add wave -noupdate -format Logic /testbench/mdc_0
add wave -noupdate -format Logic /testbench/mdio_in_0
add wave -noupdate -format Logic /testbench/mdio_out_0
add wave -noupdate -format Logic /testbench/mdio_tri_0
add wave -noupdate -divider {EMAC1 Tx Client Interface}
add wave -noupdate -format Logic /testbench/dut/tx_clk_1_i
add wave -noupdate -format Literal /testbench/dut/tx_ll_data_1_i
add wave -noupdate -format Logic /testbench/dut/tx_ll_dst_rdy_n_1_i
add wave -noupdate -format Logic /testbench/dut/tx_ll_eof_n_1_i
add wave -noupdate -format Logic /testbench/dut/tx_ll_sof_n_1_i
add wave -noupdate -format Logic /testbench/dut/tx_ll_src_rdy_n_1_i
add wave -noupdate -divider {EMAC1 Rx Client Interface}
add wave -noupdate -format Logic /testbench/dut/rx_clk_1_i
add wave -noupdate -format Literal /testbench/dut/rx_ll_data_1_i
add wave -noupdate -format Logic /testbench/dut/rx_ll_dst_rdy_n_1_i
add wave -noupdate -format Logic /testbench/dut/rx_ll_eof_n_1_i
add wave -noupdate -format Logic /testbench/dut/rx_ll_sof_n_1_i
add wave -noupdate -format Logic /testbench/dut/rx_ll_src_rdy_n_1_i
add wave -noupdate -format Logic /testbench/dut/v4_emac_ll/rx_bad_frame_1_i
add wave -noupdate -format Logic /testbench/dut/v4_emac_ll/rx_good_frame_1_i
add wave -noupdate -divider {EMAC1 RocketIO Interface}
add wave -noupdate -format Logic /testbench/txp_1
add wave -noupdate -format Logic /testbench/txn_1
add wave -noupdate -format Logic /testbench/rxp_1
add wave -noupdate -format Logic /testbench/rxn_1
add wave -noupdate -divider {EMAC1 MDIO Interface}
add wave -noupdate -format Logic /testbench/mdc_1
add wave -noupdate -format Logic /testbench/mdio_in_1
add wave -noupdate -format Logic /testbench/mdio_out_1
add wave -noupdate -format Logic /testbench/mdio_tri_1
add wave -noupdate -divider {Management Interface}
add wave -noupdate -format Logic /testbench/host_clk
add wave -noupdate -format Literal -binary /testbench/host_opcode
add wave -noupdate -format Literal -hex /testbench/host_addr
add wave -noupdate -format Literal -hex /testbench/host_wr_data
add wave -noupdate -format Literal -hex /testbench/host_rd_data
add wave -noupdate -format Logic /testbench/host_miim_sel
add wave -noupdate -format Logic /testbench/host_req
add wave -noupdate -format Logic /testbench/host_miim_rdy
add wave -noupdate -format Logic /testbench/host_emac1_sel
add wave -noupdate -divider {Test semaphores}
add wave -noupdate -format Logic /testbench/emac0_configuration_busy
add wave -noupdate -format Logic /testbench/emac0_monitor_finished_1g
add wave -noupdate -format Logic /testbench/emac0_monitor_finished_100m
add wave -noupdate -format Logic /testbench/emac0_monitor_finished_10m
add wave -noupdate -format Logic /testbench/emac1_configuration_busy
add wave -noupdate -format Logic /testbench/emac1_monitor_finished_1g
add wave -noupdate -format Logic /testbench/emac1_monitor_finished_100m
add wave -noupdate -format Logic /testbench/emac1_monitor_finished_10m
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
WaveRestoreZoom {0 ps} {4310754 ps}
