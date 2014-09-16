setenv LMC_TIMEUNIT -12
vlib work
vmap work work
vcom -work work ../../example_design/client/address_swap_module_8.vhd
vcom -work work ../../example_design/client/fifo/tx_client_fifo_8.vhd
vcom -work work ../../example_design/client/fifo/rx_client_fifo_8.vhd
vcom -work work ../../example_design/client/fifo/eth_fifo_8.vhd
vcom -work work ../../example_design/physical/cal_block_v1_4_1.vhd
vcom -work work ../../example_design/physical/gt11_to_gt_rxclkcorcnt_shim.vhd
vcom -work work ../../example_design/physical/gt11_dual_1000X.vhd
vcom -work work ../../example_design/physical/gt11_init_tx.vhd
vcom -work work ../../example_design/physical/gt11_init_rx.vhd
vcom -work work ../../example_design/eth2x.vhd
vcom -work work ../../example_design/eth2x_block.vhd
vcom -work work ../../example_design/eth2x_locallink.vhd
vcom -work work ../../example_design/eth2x_example_design.vhd
vcom -work work ../configuration_tb.vhd
vcom -work work ../emac0_phy_tb.vhd
vcom -work work ../emac1_phy_tb.vhd
vcom -work work ../demo_tb.vhd
vsim -t ps work.testbench
do wave_mti.do
run -all
