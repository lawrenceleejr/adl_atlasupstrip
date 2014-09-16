onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/clk
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/hi
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/ll_data
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/ll_dst_rdy
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/ll_eof
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/ll_sof
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/ll_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/lo
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/mac_dst
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/mac_src
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/mux_data
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/mux_data_len
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/mux_dst_rdy
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/mux_sof
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/mux_eof
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/mux_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/rst
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/s_src_rdy
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/s_sof
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/s_eof
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/s_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/s_data
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/s_data_len
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/s_src_rdy(0)
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/s_sof(0)
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/s_eof(0)
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/data_i
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/sof_i
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/eof_i
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/dst_rdy_o
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/src_rdy_i
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/data_length_i
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/mac_dest_i
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/mac_source_i
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/ll_data_o
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/ll_sof_o
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/ll_eof_o
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/ll_dst_rdy_i
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/ll_src_rdy_o
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/clk
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/rst
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/pkt_header
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/bcount
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/bcount_en
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/bcount_clr
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/data_len
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/state
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/ll_sof
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/ll_eof
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/dst_rdy_out
add wave -noupdate -format Literal -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/net_seq_id
add wave -noupdate -format Logic -radix hexadecimal /ll_syncmux_top_tb/utxpktfmt/dbg_state_change
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 4} {147187550 ps} 0} {{Cursor 5} {103449883 ps} 0}
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
WaveRestoreZoom {122134784 ps} {161899598 ps}
