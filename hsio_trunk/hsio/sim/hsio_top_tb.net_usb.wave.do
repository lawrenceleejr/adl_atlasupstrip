onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/usb_d_io
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/usb_rd_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/usb_rxf_i
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/usb_txe_i
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/usb_wr_o
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_data
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/rx_dst_rdy
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/rx_eof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/rx_sof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/rx_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/usb_rd_clk
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/usb_rd_data
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/usb_rd_dst_ready
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/usb_rd_eof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/usb_rd_fifo_rst
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/usb_rd_sof
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/usb_rd_src_ready
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/usb_rd_stat_word_zero
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_data_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_dst_rdy_i
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_fifo_clk_i
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_fifo_rst_i
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_sof_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_eof_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/rx_src_rdy_o
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/unet_usb_top/stat_word_o
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/abc_com
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ocwp_addr
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/ocwp_data
add wave -noupdate -format Logic -radix hexadecimal /hsio_top_tb/udut/ocwp_strobe
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_magicn
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_seq
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_len
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_cbcnt
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_opcode
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_cbseq
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/rx_size
add wave -noupdate -format Literal /hsio_top_tb/udut/uhsiopacketdecoder/state
add wave -noupdate -format Literal /hsio_top_tb/udut/uhsiopacketdecoder/wcount
add wave -noupdate -format Logic /hsio_top_tb/udut/uhsiopacketdecoder/wcount_en
add wave -noupdate -format Logic /hsio_top_tb/udut/uhsiopacketdecoder/wcount_clr
add wave -noupdate -format Literal -radix hexadecimal /hsio_top_tb/udut/uhsiopacketdecoder/data_store
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {96492986 ps} 0}
configure wave -namecolwidth 150
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
WaveRestoreZoom {146269666 ps} {413354229 ps}
