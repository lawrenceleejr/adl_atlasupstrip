#!/bin/sh
set LMC_TIMEUNIT -12
mkdir work
ncvhdl -v93 -work work ../../example_design/client/address_swap_module_8.vhd
ncvhdl -v93 -work work ../../example_design/client/fifo/tx_client_fifo_8.vhd
ncvhdl -v93 -work work ../../example_design/client/fifo/rx_client_fifo_8.vhd
ncvhdl -v93 -work work ../../example_design/client/fifo/eth_fifo_8.vhd
ncvhdl -v93 -work work ../../example_design/physical/gmii_if.vhd
ncvhdl -v93 -work work ../../example_design/eth_gmii.vhd
ncvhdl -v93 -work work ../../example_design/eth_gmii_block.vhd
ncvhdl -v93 -work work ../../example_design/eth_gmii_locallink.vhd
ncvhdl -v93 -work work ../../example_design/eth_gmii_example_design.vhd
ncvhdl -v93 -work work ../configuration_tb.vhd
ncvhdl -v93 -work work ../emac0_phy_tb.vhd
ncvhdl -v93 -work work ../demo_tb.vhd
ncelab -NOWARN CUVWSI -NOWARN CSINFI -NOWARN NTCNNC -NOWARN CUVWSP -NOWARN NCCDELW -loadpli1 swiftpli:swift_boot -access +rw work.testbench:behavioral
ncsim -gui work.testbench:behavioral -input @"simvision -input wave_ncsim.sv"

