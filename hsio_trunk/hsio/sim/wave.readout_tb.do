onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/abc_header
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/abc_header_mask
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/abc_trailer
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/abc_trailer_mask
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/clk
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/clkn
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ll_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/mac_dst
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/mac_src
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/reg_cs_reset
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/reg_ds_enable
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/reg_ds_gendata_en
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/reg_ds_mode
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/reg_histo_reset
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/reg_histo_ro
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/rst
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/serdata
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/serdata
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/mux_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/mux_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/mux_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/mux_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/mux_data
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/mux_data_len
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ll_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ll_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ll_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ll_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ll_data
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/utx_pkt_fmt/state
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/utx_pkt_fmt/dbg_state_change
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {221731250 ps} 0}
configure wave -namecolwidth 291
configure wave -valuecolwidth 141
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
WaveRestoreZoom {51191078 ps} {102568891 ps}
