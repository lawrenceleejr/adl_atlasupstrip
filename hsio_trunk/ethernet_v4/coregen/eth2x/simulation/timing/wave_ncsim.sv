# SimVision Command Script

#
# groups
#
if {[catch {group new -name {System Signals} -overlay 0}] != ""} {
    group using {System Signals}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :reset \
    :gtx_clk \
    :mgtclk_p \
    :mgtclk_n \
    :host_clk

if {[catch {group new -name {EMAC0 TX Client Interface} -overlay 0}] != ""} {
    group using {EMAC0 TX Client Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:clientemac0rxclientclkin \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:clientemac0txd \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:clientemac0txdvld \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac0clienttxack

if {[catch {group new -name {EMAC0 RX Client Interface} -overlay 0}] != ""} {
    group using {EMAC0 RX Client Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac0clientrxclientclkout \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac0clientrxd \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac0clientrxdvld \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac0clientrxframedrop \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac0clientrxgoodframe \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac0clientrxbadframe

if {[catch {group new -name {EMAC0 Flow Control} -overlay 0}] != ""} {
    group using {EMAC0 Flow Control}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :pause_val_0 \
    :pause_req_0


if {[catch {group new -name {EMAC0 RocketIO Interface} -overlay 0}] != ""} {
    group using {EMAC0 RocketIO Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :txp_0 \
    :txn_0 \
    :rxp_0 \
    :rxn_0

if {[catch {group new -name {EMAC0 MDIO Interface} -overlay 0}] != ""} {
    group using {EMAC0 MDIO Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :mdc_0 \
    :mdio_in_0 \
    :mdio_out_0 \
    :mdio_tri_0

if {[catch {group new -name {EMAC1 TX Client Interface} -overlay 0}] != ""} {
    group using {EMAC1 TX Client Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:clientemac1rxclientclkin \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:clientemac1txd \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:clientemac1txdvld \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac1clienttxack

if {[catch {group new -name {EMAC1 RX Client Interface} -overlay 0}] != ""} {
    group using {EMAC1 RX Client Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac1clientrxclientclkout \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac1clientrxd \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac1clientrxdvld \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac1clientrxframedrop \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac1clientrxgoodframe \
    :dut:v4_emac_ll_v4_emac_block_v4_emac_top_v4_emac:emac1clientrxbadframe

if {[catch {group new -name {EMAC1 Flow Control} -overlay 0}] != ""} {
    group using {EMAC1 Flow Control}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :pause_val_1 \
    :pause_req_1


if {[catch {group new -name {EMAC1 RocketIO Interface} -overlay 0}] != ""} {
    group using {EMAC1 RocketIO Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :txp_1 \
    :txn_1 \
    :rxp_1 \
    :rxn_1

if {[catch {group new -name {EMAC1 MDIO Interface} -overlay 0}] != ""} {
    group using {EMAC1 MDIO Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :mdc_1 \
    :mdio_in_1 \
    :mdio_out_1 \
    :mdio_tri_1

if {[catch {group new -name {Management Interface} -overlay 0}] != ""} {
    group using {Management Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :host_clk \
    :host_opcode \
    :host_addr \
    :host_wr_data \
    :host_rd_data \
    :host_miim_sel \
    :host_req \
    :host_miim_rdy \
    :host_emac1_sel

if {[catch {group new -name {Test semaphores} -overlay 0}] != ""} {
    group using {Test semaphores}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :emac0_configuration_busy \
    :emac0_monitor_finished_1g \
    :emac0_monitor_finished_100m \
    :emac0_monitor_finished_10m
group insert \
    :emac1_configuration_busy \
    :emac1_monitor_finished_1g \
    :emac1_monitor_finished_100m \
    :emac1_monitor_finished_10m 

#
# Waveform windows
#
if {[window find -match exact -name "Waveform 1"] == {}} {
    window new WaveWindow -name "Waveform 1" -geometry 906x585+25+55
} else {
    window geometry "Waveform 1" 906x585+25+55
}
window target "Waveform 1" on
waveform using {Waveform 1}
waveform sidebar visibility partial
waveform set \
    -primarycursor TimeA \
    -signalnames name \
    -signalwidth 175 \
    -units fs \
    -valuewidth 75
cursor set -using TimeA -time 50,000,000,000fs
cursor set -using TimeA -marching 1
waveform baseline set -time 0

set id [waveform add -signals [list :reset \
	:gtx_clk ]]

set groupId [waveform add -groups {{System Signals}}]


set groupId [waveform add -groups {{EMAC0 TX Client Interface}}]

set groupId [waveform add -groups {{EMAC0 RX Client Interface}}]

set groupId [waveform add -groups {{EMAC0 RocketIO Interface}}]

set groupId [waveform add -groups {{EMAC0 MDIO Interface}}]


set groupId [waveform add -groups {{EMAC1 TX Client Interface}}]

set groupId [waveform add -groups {{EMAC1 RX Client Interface}}]

set groupId [waveform add -groups {{EMAC1 RocketIO Interface}}]

set groupId [waveform add -groups {{EMAC1 MDIO Interface}}]

set groupId [waveform add -groups {{Management Interface}}]

set groupId [waveform add -groups {{Test semaphores}}]

waveform xview limits 0fs 10us

simcontrol run -time 2000us
