onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/abc_evdata
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/abc_header
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/abc_header_mask
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/abc_trailer
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/abc_trailer_mask
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/clk
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/mode_word
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/rst
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/start
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/mac_dst
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/mac_src
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/ru0_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/ru0_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/ru0_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/ru0_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/ru0_data
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/ru0_data_len
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/ll_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/ll_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/ll_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/ll_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/ll_data
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/udut/udata_fifo/state
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/udut/inproc_data
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/udut/inproc_data_len
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/udut/inproc_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/udut/inproc_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/udut/inproc_we
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/udut/udata_fifo/fifo_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/udut/udata_fifo/fifo_eof
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/udut/udata_fifo/delta_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/udut/ru_src_rdy_o
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/udut/ru_sof_o
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/udut/ru_eof_o
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/udut/ru_dst_rdy_i
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/udut/ru_data
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/udut/udata_fifo/state
add wave -noupdate -format Literal -radix hexadecimal /readout_unit_tb/udut/udata_fifo/delta_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_unit_tb/udut/udata_fifo/fifo_rd_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {507587343 ps} 0}
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
WaveRestoreZoom {507324019 ps} {508729135 ps}
