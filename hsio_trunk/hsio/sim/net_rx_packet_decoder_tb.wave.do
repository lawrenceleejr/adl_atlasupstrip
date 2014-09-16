onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/clk
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/net_data
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/net_dst_rdy
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/net_eof
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/net_sof
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/net_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/rst
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/hsio_data
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/hsio_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/hsio_sof
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/hsio_eof
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/hsio_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/rx_src_mac
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/urx_pkt_fmt/state
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/rx_magicn
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/rx_seq
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/rx_len
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/rx_cbcnt
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/rx_opcode
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/rx_cbseq
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/rx_size
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/upktdec/state
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/txack_wren
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/txack_sof
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/txack_eof
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/txack_data
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/txack_len
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/tx_src_rdy
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/tx_sof
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/tx_eof
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/local_dst_rdy
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/tx_data
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/state
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/upktdec/data_store
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/urx_pkt_fmt/bcount
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/upktdec/reg_addr_str
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/upktdec/reg_addr
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/upktdec/reg_data_str
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/upktdec/reg_data
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/abc_com
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/reg_com_enable
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/reg_disp_reg
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/reg_ds_enable
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/reg_ds_mode
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/reg_histo_reset
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/reg_histo_ro
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/regstrobe
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/en
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/clk_wr
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/rst_wr
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/wren_i
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/data_i
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/sof_i
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/eof_i
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/full_o
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/overflow_o
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/underflow_o
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/data_length_i
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/data_truncd_i
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/clk_rd
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/rst_rd
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/data_o
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/sof_o
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/eof_o
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/dst_rdy_i
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/src_rdy_o
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/fifo_empty
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/fifo_din
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/fifo_dout
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/fifo_rd
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/fifo_sof
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/fifo_sof_q
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/fifo_eof
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/eof_coded
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/delta_eof
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/dec_delta_eof
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/state
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/nstate
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/len_fifo_din
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/len_fifo_rd
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/len_fifo_dout
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/len_fifo_almost_full
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/len_fifo_full
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/len_fifo_empty
add wave -noupdate -format Literal -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/len_fifo_data
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/len_fifo_data_truncd
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/insert_length
add wave -noupdate -format Logic -radix hexadecimal /net_rx_packet_decoder_tb/utxrofifo63/insert_error_opcode
add wave -noupdate -format Literal /net_rx_packet_decoder_tb/utxrofifo63/eof_coded
add wave -noupdate -format Logic /net_rx_packet_decoder_tb/utxrofifo63/eof_i
add wave -noupdate -format Logic /net_rx_packet_decoder_tb/utxrofifo63/eofin
add wave -noupdate -format Logic /net_rx_packet_decoder_tb/utxrofifo63/eofin_q
add wave -noupdate -format Logic /net_rx_packet_decoder_tb/utxrofifo63/eofin_clkrd
add wave -noupdate -format Literal /net_rx_packet_decoder_tb/utxrofifo63/eofin_rd_q
add wave -noupdate -format Logic /net_rx_packet_decoder_tb/utxrofifo63/eofin_rd_q(0)
add wave -noupdate -format Logic /net_rx_packet_decoder_tb/utxrofifo63/eofin_rd_q(1)
add wave -noupdate -format Logic /net_rx_packet_decoder_tb/utxrofifo63/eofin_rd_q(2)
add wave -noupdate -format Logic /net_rx_packet_decoder_tb/utxrofifo63/eofin_rd_q(3)
add wave -noupdate -format Logic /net_rx_packet_decoder_tb/utxrofifo63/eof_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9327788 ps} 0}
configure wave -namecolwidth 280
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {41291008 ps}
