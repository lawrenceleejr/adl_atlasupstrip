onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/clk
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/mux_data
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/mux_data_len
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/mux_dst_rdy
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/mux_eof
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/mux_sof
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/mux_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/rst
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/ll_data
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/ll_dst_rdy
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/ll_eof
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/ll_sof
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/ll_src_rdy
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/data_i
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/sof_i
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/eof_i
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/dst_rdy_o
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/src_rdy_i
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/data_length_i
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/mac_dest_i
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/mac_source_i
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/ll_data_o
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/ll_sof_o
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/ll_eof_o
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/ll_dst_rdy_i
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/ll_src_rdy_o
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/clk
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/rst
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/pkt_header
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/bcount
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/bcount_en
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/bcount_clr
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/data_len
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/state
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/nstate
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/ll_sof
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/ll_eof
add wave -noupdate -format Logic -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/dst_rdy_out
add wave -noupdate -format Literal -radix hexadecimal /net_tx_packet_format_tb/utxpktfmt/net_seq_id
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7469031 ps} 0}
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
WaveRestoreZoom {2258065 ps} {9838710 ps}
