onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/clk_xtal_125_m
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/clk_xtal_125_p
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/rst_poweron_n
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/sim_conf_busy
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/ibpp_ido0_mi
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/ibpp_ido0_pi
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/clk_abc_bco
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/clk_abc_dclk
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/rst_ro
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/clk_ro
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/clk40
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
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout/clk
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout/clkn_ro
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout/rst
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout/serial_loopback_mode
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout/colstream
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout/abc_header
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout/abc_header_mask
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout/abc_trailer
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout/abc_trailer_mask
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ureadout/gendata
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout/reg_ds_capture_en
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout/reg_ds_enable
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout/reg_ds_gendata_en
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout/reg_ds_mode
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout/reg_histo_reset
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ureadout/reg_histo_ro
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {527111255 ps} 0}
configure wave -namecolwidth 185
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
WaveRestoreZoom {0 ps} {735 us}
