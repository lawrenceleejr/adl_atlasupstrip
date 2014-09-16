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
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/mac_dst
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/mac_src
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/deser_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/deser_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/deser_we
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/deser_data
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/deser_data_len
add wave -noupdate -format Logic /readout_tb/ureadouttop/grounit__8/uunit/raw_src_rdy
add wave -noupdate -format Logic /readout_tb/ureadouttop/grounit__8/uunit/raw_sof
add wave -noupdate -format Logic /readout_tb/ureadouttop/grounit__8/uunit/raw_eof
add wave -noupdate -format Logic /readout_tb/ureadouttop/grounit__8/uunit/raw_dst_rdy
add wave -noupdate -format Literal /readout_tb/ureadouttop/grounit__8/uunit/raw_data
add wave -noupdate -format Literal /readout_tb/ureadouttop/grounit__8/uunit/raw_data_length
add wave -noupdate -format Literal /readout_tb/ureadouttop/grounit__8/uunit/ufifo/state
add wave -noupdate -format Logic /readout_tb/ureadouttop/grounit__9/uunit/raw_src_rdy
add wave -noupdate -format Logic /readout_tb/ureadouttop/grounit__9/uunit/raw_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__9/uunit/raw_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__9/uunit/raw_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__9/uunit/raw_data
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__9/uunit/raw_data_length
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__9/uunit/ufifo/state
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__10/uunit/raw_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__10/uunit/raw_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__10/uunit/raw_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__10/uunit/raw_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__10/uunit/raw_data
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__10/uunit/raw_data_length
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__10/uunit/ufifo/state
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__15/uunit/raw_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__15/uunit/raw_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__15/uunit/raw_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__15/uunit/raw_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__15/uunit/raw_data
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__15/uunit/raw_data_length
add wave -noupdate -format Logic /readout_tb/ureadouttop/grounit__15/uunit/ufifo/fifo_rd_en
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__15/uunit/ufifo/state
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/uctrl/selected_channel
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/utst/dooodooo
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/mux_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/mux_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/mux_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/mux_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/mux_data
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/mux_data_len
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/trigger
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/gendata_sel_i
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/histo_mode_i
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/capture_mode_i
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/trigger_i
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/serdata_i
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/fifo_we_o
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/fifo_eof_o
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/fifo_sof_o
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/fifo_data_o
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/data_length_o
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/en
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/clk
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/rst
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/sr_data
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/pkt_start
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/pkt_end
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/header_seen
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/trailer_seen
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/data_word
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/fifo_data
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/fifo_we
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/fifo_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/fifo_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/fifo_data_we
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/fifo_dcomhdr_we
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/fifo_zero_we
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/dcom_fragid
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/dcom_seqid
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/bit_counter
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/bit_counter_clr
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/bit_counter_slv
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/word_count
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/word_bit
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/mode_coded
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/udeser/state
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/utrigdecoder/com_i
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/utrigdecoder/l1r_i
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/utrigdecoder/trigger_o
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/utrigdecoder/rst
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/utrigdecoder/clk
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/utrigdecoder/trig_l1r
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/utrigdecoder/trig_com
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/utrigdecoder/sr_com
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/utrigdecoder/sr_l1r
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/utrigdecoder/veto
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/utrigdecoder/bcnt
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/utrigdecoder/bcnt_clr
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/utrigdecoder/len
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/utrigdecoder/state
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/uctrl/src_rdy_i
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/uctrl/eof_i
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/uctrl/dst_rdy_o
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/usyncmux/uctrl/dst_rdy_i
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/usyncmux/uctrl/freeze_o
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/uctrl/sel_o
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/usyncmux/uctrl/rst
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/usyncmux/uctrl/clk
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/uctrl/state
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/uctrl/selected_channel
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/usyncmux/uctrl/channel_inc
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/rst
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/clk
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/en
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/wren_i
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/data_i
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/sof_i
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/eof_i
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/full_o
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/data_length_i
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/data_o
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/sof_o
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/eof_o
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/dst_rdy_i
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/src_rdy_o
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/data_length_o
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/fifo_empty
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/fifo_din
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/fifo_dout
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/fifo_rd_en
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/fifo_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/fifo_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/src_rdy_out
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/eofinq
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/eofin125
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/eof_coded
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/delta_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/dec_delta_eof
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/state
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/nstate
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/len_fifo_dout
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/len_fifo_almost_full
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/len_fifo_full
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/len_fifo_empty
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/grounit__0/uunit/ufifo/insert_length
add wave -noupdate -format Logic /readout_tb/ureadouttop/usyncmux/usmx16/freeze_i
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/s_data_len_o
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/s_data_o
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/s_dst_rdy_i
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/s_eof_o
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/s_sof_o
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/s_src_rdy_o
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/s_eof_i
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/e_eof
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/d_eof
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/c_eof
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/b_eof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/eof_o
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/d_sel
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/c_sel
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/b_sel
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/a_sel
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/s_data_i(8)
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/s_data_i
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/d_data
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/c_data
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/b_data
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/data_o
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/s_sof_i
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/d_sof
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/c_sof
add wave -noupdate -format Literal -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/b_sof
add wave -noupdate -format Logic -radix hexadecimal /readout_tb/ureadouttop/usyncmux/usmx16/sof_o
add wave -noupdate -format Literal -radix hexadecimal -expand /readout_tb/utst/ll_data_pipeline
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
