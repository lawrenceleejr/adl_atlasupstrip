view structure
view signals
view wave
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {System Signals}
add wave -noupdate -format Logic /testbench/reset
add wave -noupdate -format Logic /testbench/gtx_clk
add wave -noupdate -format Logic /testbench/host_clk
add wave -noupdate -divider {EMAC0 Tx Client Interface}
add wave -noupdate -format Logic /testbench/dut/v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac/clientemac0rxclientclkin
add wave -noupdate -format Literal -radix hexadecimal /testbench/dut/v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac/clientemac0txd
add wave -noupdate -format Logic /testbench/dut/v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac/clientemac0txdvld
add wave -noupdate -format Logic /testbench/dut/v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac/emac0clienttxack
add wave -noupdate -divider {EMAC0 Rx Client Interface}
add wave -noupdate -format Logic /testbench/dut/v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac/emac0clientrxclientclkout
add wave -noupdate -format Literal -radix hexadecimal /testbench/dut/v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac/emac0clientrxd
add wave -noupdate -format Logic /testbench/dut/v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac/emac0clientrxdvld
add wave -noupdate -format Logic /testbench/dut/v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac/emac0clientrxframedrop
add wave -noupdate -format Logic /testbench/dut/v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac/emac0clientrxgoodframe
add wave -noupdate -format Logic /testbench/dut/v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac/emac0clientrxbadframe
add wave -noupdate -divider {EMAC0 Tx GMII/MII Interface}
add wave -noupdate -format Logic /testbench/gmii_tx_clk_0
add wave -noupdate -format Literal -hex /testbench/gmii_txd_0
add wave -noupdate -format Logic /testbench/gmii_tx_en_0
add wave -noupdate -format Logic /testbench/gmii_tx_er_0
add wave -noupdate -format Logic /testbench/gmii_col_0
add wave -noupdate -format Logic /testbench/gmii_crs_0
add wave -noupdate -divider {EMAC0 Rx GMII/MII Interface}
add wave -noupdate -format Logic /testbench/gmii_rx_clk_0
add wave -noupdate -format Literal -hex /testbench/gmii_rxd_0
add wave -noupdate -format Logic /testbench/gmii_rx_dv_0
add wave -noupdate -format Logic /testbench/gmii_rx_er_0
add wave -noupdate -divider {EMAC0 MDIO Interface}
add wave -noupdate -format Logic /testbench/mdc_0
add wave -noupdate -format Logic /testbench/mdio_in_0
add wave -noupdate -format Logic /testbench/mdio_out_0
add wave -noupdate -format Logic /testbench/mdio_tri_0
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
WaveRestoreZoom {0 ps} {4310754 ps}
