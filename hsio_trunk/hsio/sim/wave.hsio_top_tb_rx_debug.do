onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /hsio_top_tb/clk_xtal_125_m
add wave -noupdate -format Logic /hsio_top_tb/clk_xtal_125_p
add wave -noupdate -format Logic /hsio_top_tb/rst_poweron_n
add wave -noupdate -format Logic /hsio_top_tb/sim_conf_busy
add wave -noupdate -format Logic /hsio_top_tb/ibpp_ido0_mi
add wave -noupdate -format Logic /hsio_top_tb/ibpp_ido0_pi
add wave -noupdate -format Logic /hsio_top_tb/udut/clk_abc_bco
add wave -noupdate -format Logic /hsio_top_tb/udut/clk_abc_dclk
add wave -noupdate -format Logic /hsio_top_tb/udut/rst_ro
add wave -noupdate -format Logic /hsio_top_tb/udut/clk_ro
add wave -noupdate -format Logic /hsio_top_tb/udut/clk40
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/readout_mode80
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ibpp_ido0
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ibpp_ido1
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/mux_data
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/mux_data_len
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/mux_dst_rdy
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/mux_eof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/mux_sof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/mux_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/sf0_test/rx_is_k
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/sf0_test/rx_pdata
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/sf0_test/tx_is_k
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/sf0_test/tx_pdata
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/rst40
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/rst125
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/inproc_data
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/inproc_data_len
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/inproc_eof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/inproc_sof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/inproc_we
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/udata_inproc/state
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/emergency
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/ru_data
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/ru_data_len
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/ru_dst_rdy_i
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/ru_eof_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/ru_sof_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/ru_src_rdy_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/abc_evdata
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/mode_word_i
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout_unit/rst
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rxll_data_sfa
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rxll_src_rdy_sfa
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rxll_sof_sfa
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rxll_eof_sfa
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rxll_dst_rdy_sfa
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_sof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_eof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_data
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_src_rdyb
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_sofb
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_eofb
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_dst_rdyb
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_datab
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_data_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_dst_rdy_i
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_eof_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_sof_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_src_rdy_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/abc_com
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ocwp_addr
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ocwp_data
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ocwp_strobe
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_magicn
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_seq
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_size
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_opcode
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_cbcnt
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_cbseq
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_len
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/mode_copper_i
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_src_rdyb
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_sofb
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_eofb
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_dst_rdyb
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/net_datab
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_src_rdy_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_sof_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_eof_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_dst_rdy_i
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_data_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {707239137 ps} 0} {{Cursor 2} {640475400 ps} 0}
configure wave -namecolwidth 298
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {590169271 ps} {657799479 ps}
