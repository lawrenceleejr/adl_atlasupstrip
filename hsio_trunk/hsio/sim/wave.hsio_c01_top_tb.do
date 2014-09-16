onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/ibe_clk200
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/clk200
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/clk40
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/clk_startup
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/clk125
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/clk40_ext_sel
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/oa_reset
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/rst125
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/rst40
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/clks_top_ready
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/clks_main_ready
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/net_usb_ready
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/clks_top_ready
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/rst_hsio
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/rst_poweron_ni
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/oa_reset
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/rst40
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/clk_startup
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/clk180_bco
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/clk270_bco
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/clk90_bco
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/clk_bco_dc
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/clk_dclk
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/clk_ro
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/clkn_bco_dc
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/clkn_dclk
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/clkn_ro
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/clk40
add wave -noupdate -format Literal /hsio_c01_top_tb/udut/umain/count_rst_netrof
add wave -noupdate -format Literal /hsio_c01_top_tb/udut/umain/count_rst_ro
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/psbusy
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/clk40
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/rst40
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/clk0_bco
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/rst_bco
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/clk_co
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/rst_co
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/rst_netrof
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/rst_co
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/rst_ro
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/rst_netrof
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/rst_ro
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/resets_all
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/umain/resets_all
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/mode_copper
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/mode_usb
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/led_linkupa
add wave -noupdate -format Literal /hsio_c01_top_tb/udut/unet_usb_top/ueth_sf_2x/emacclientsyncacqstatus
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/unet_usb_top/ueth_sf_2x/rxn_i0
add wave -noupdate -format Logic /hsio_c01_top_tb/udut/unet_usb_top/ueth_sf_2x/rxp_i0
add wave -noupdate -format Literal /hsio_c01_top_tb/sw_hex_n
add wave -noupdate -format Literal /hsio_c01_top_tb/sw_hex_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {85928369 ps} 0}
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
WaveRestoreZoom {0 ps} {29465100 ps}
