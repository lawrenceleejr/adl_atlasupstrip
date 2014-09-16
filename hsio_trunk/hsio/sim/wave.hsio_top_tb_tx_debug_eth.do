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
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/mux_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/mux_sof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/mux_eof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/mux_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/mux_data
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/mux_data_len
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/sf0_test/rx_is_k
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/sf0_test/rx_pdata
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/sf0_test/tx_is_k
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/sf0_test/tx_pdata
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/rst40
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/rst125
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/mux_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/mux_sof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/mux_eof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/mux_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/mux_data
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/mux_data_len
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/txll_src_rdy_net
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/txll_sof_net
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/txll_eof_net
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/txll_dst_rdy_net
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/txll_data_net
add wave -noupdate -format Logic /hsio_top_tb/udut/unet_usb_top/ueth_sf_2x/emacclientsyncacqstatus(0)
add wave -noupdate -format Logic /hsio_top_tb/udut/unet_usb_top/ueth_sf_2x/tx_ack(0)
add wave -noupdate -format Logic /hsio_top_tb/udut/unet_usb_top/ueth_sf_2x/tx_collision(0)
add wave -noupdate -format Literal -radix unsigned /hsio_top_tb/udut/unet_usb_top/ueth_sf_2x/tx_fifo_stat(0)
add wave -noupdate -format Logic /hsio_top_tb/udut/unet_usb_top/ueth_sf_2x/tx_overflow(0)
add wave -noupdate -format Logic /hsio_top_tb/udut/unet_usb_top/ueth_sf_2x/tx_retransmit(0)
add wave -noupdate -format Literal /hsio_top_tb/udut/unet_usb_top/ueth_sf_2x/tx_client_clk
add wave -noupdate -format Logic /hsio_top_tb/udut/unet_usb_top/ueth_sf_2x/tx_src_rdy_i0
add wave -noupdate -format Logic /hsio_top_tb/udut/unet_usb_top/ueth_sf_2x/tx_sof_i0
add wave -noupdate -format Logic /hsio_top_tb/udut/unet_usb_top/ueth_sf_2x/tx_eof_i0
add wave -noupdate -format Logic /hsio_top_tb/udut/unet_usb_top/ueth_sf_2x/tx_dst_rdy_o0
add wave -noupdate -format Literal -expand /hsio_top_tb/udut/unet_usb_top/ueth_sf_2x/tx_fifo_stat
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1374515000 ps} 0} {{Cursor 2} {574537253 ps} 0} {{Cursor 3} {574715000 ps} 0} {{Cursor 4} {574895000 ps} 0} {{Cursor 5} {575315388 ps} 0} {{Cursor 6} {575374972 ps} 0} {{Cursor 7} {575433705 ps} 0} {{Cursor 8} {575135451 ps} 0} {{Cursor 9} {575195369 ps} 0} {{Cursor 10} {575255000 ps} 0}
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
WaveRestoreZoom {574773172 ps} {575620970 ps}
