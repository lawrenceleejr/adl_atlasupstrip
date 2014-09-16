onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /bcc_top_tb/udut/ucontrol/bcc_data_o
add wave -noupdate -format Literal /bcc_top_tb/udut/ucontrol/config_reg_i
add wave -noupdate -format Logic /bcc_top_tb/udut/ucontrol/abc_dclk_o
add wave -noupdate -format Logic /bcc_top_tb/udut/ucontrol/abc_bco_o
add wave -noupdate -format Logic /bcc_top_tb/udut/ucontrol/abc_mode80_o
add wave -noupdate -format Logic /bcc_top_tb/udut/ucontrol/rst
add wave -noupdate -format Logic /bcc_top_tb/udut/ucontrol/bco
add wave -noupdate -format Logic /bcc_top_tb/udut/ucontrol/dclk_inv
add wave -noupdate -format Logic /bcc_top_tb/udut/ucontrol/bco_inv
add wave -noupdate -format Literal /bcc_top_tb/udut/ucontrol/linkmode
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/bcc_com_i
add wave -noupdate -format Logic /bcc_top_tb/udut/ucontrol/abc_com_o
add wave -noupdate -format Literal /bcc_top_tb/udut/udecoder/hybrid_addr_i
add wave -noupdate -format Literal /bcc_top_tb/udut/udecoder/config_reg_o
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/rst
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/bco
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/machine_reset
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/bit_cnt_start
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/bit_cnt_en
add wave -noupdate -format Literal /bcc_top_tb/udut/udecoder/bit_cnt
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/address_ok_set
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/address_ok
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/shift_bypass_set
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/shift_bypass
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/bcc_com_i
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/local_com_o
add wave -noupdate -format Literal /bcc_top_tb/udut/udecoder/hybrid_addr_i
add wave -noupdate -format Literal /bcc_top_tb/udut/udecoder/config_reg_o
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/rst
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/bco
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/machine_reset
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/bit_cnt_start
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/bit_cnt_stop
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/bit_cnt_en
add wave -noupdate -format Literal /bcc_top_tb/udut/udecoder/bit_cnt
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/address_ok_set
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/address_ok
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/shift_bypass_set
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/shift_bypass
add wave -noupdate -format Literal -radix unsigned /bcc_top_tb/udut/udecoder/sr_counter
add wave -noupdate -format Literal /bcc_top_tb/udut/udecoder/command_reg
add wave -noupdate -format Literal /bcc_top_tb/udut/udecoder/command_reg_integer
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/forward_bcc_com
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/generated_com
add wave -noupdate -format Literal /bcc_top_tb/udut/udecoder/com_lut
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/load_config_reg
add wave -noupdate -format Logic /bcc_top_tb/udut/udecoder/load_command_reg
add wave -noupdate -format Literal /bcc_top_tb/utester/debug_msg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8125208 ps} 0}
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
WaveRestoreZoom {0 ps} {2044403 ps}
