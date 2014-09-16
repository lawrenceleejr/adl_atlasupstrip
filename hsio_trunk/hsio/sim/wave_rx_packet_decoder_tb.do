onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/clk
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/strobe40
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/net_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/net_sof
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/net_eof
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/net_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/net_data
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/rst
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/hsio_src_rdy0
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/hsio_sof0
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/hsio_eof0
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/hsio_dst_rdy0
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/hsio_data0
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/urx_pkt_fmt/state
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/urx_pkt_fmt/rx_src_mac_o
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/hsio_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/hsio_sof
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/hsio_eof
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/hsio_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/hsio_data
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/upktdec/state
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/oc_data
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/rx_magicn
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/rx_seq
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/rx_len
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/rx_cbcnt
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/rx_opcode
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/rx_ocseq
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/rx_size
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/rx_word0
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/ullpktfifo/eof_i
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/ullpktfifo/eofin
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/ullpktfifo/src_rdy_i
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/ullpktfifo/state
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/oc_data
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/oc_valid
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/local_dst_rdy
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/local_dst_rdy
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/oc_dtack(1)
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/oc_dtack(0)
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/oc_dtack
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/upktdec/oc_dtack_all
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/tx_data
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/tx_eof
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/tx_sof
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/tx_src_rdy
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/a_data
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/a_dst_rdy
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/a_eof
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/a_sof
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/a_src_rdy
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/ocb_data
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/ocb_dst_rdy
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/ocb_eof
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/ocb_sof
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/ocb_src_rdy
add wave -noupdate -format Literal -radix hexadecimal /rx_packet_decoder_tb/ll_data
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/ll_dst_rdy
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/ll_eof
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/ll_sof
add wave -noupdate -format Logic -radix hexadecimal /rx_packet_decoder_tb/ll_src_rdy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7205664 ps} 0} {{Cursor 2} {54062410 ps} 0}
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
WaveRestoreZoom {6951464 ps} {7763491 ps}
