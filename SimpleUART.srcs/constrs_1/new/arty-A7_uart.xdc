## Clock signal
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

## Buttons
#set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 } [get_ports { rst }]; #IO_L6N_T0_VREF_16 Sch=btn[0]
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports rst]

## USB-UART Interface
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVTTL} [get_ports tx_top]
set_property -dict {PACKAGE_PIN A9 IOSTANDARD LVTTL} [get_ports rx_top]

# ## ILA debug
# create_debug_core u_ila_0 ila
# set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
# set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
# set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
# set_property C_DATA_DEPTH 131072 [get_debug_cores u_ila_0]
# set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
# set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
# set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
# set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
# set_property port_width 1 [get_debug_ports u_ila_0/clk]
# connect_debug_port u_ila_0/clk [get_nets [list clk_IBUF_BUFG]]
# set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
# set_property port_width 8 [get_debug_ports u_ila_0/probe0]
# connect_debug_port u_ila_0/probe0 [get_nets [list {recieved_data[0]} {recieved_data[1]} {recieved_data[2]} {recieved_data[3]} {recieved_data[4]} {recieved_data[5]} {recieved_data[6]} {recieved_data[7]}]]
# create_debug_port u_ila_0 probe
# set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
# set_property port_width 1 [get_debug_ports u_ila_0/probe1]
# connect_debug_port u_ila_0/probe1 [get_nets [list rx_top_IBUF]]
# create_debug_port u_ila_0 probe
# set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
# set_property port_width 1 [get_debug_ports u_ila_0/probe2]
# connect_debug_port u_ila_0/probe2 [get_nets [list tx_busy]]
# create_debug_port u_ila_0 probe
# set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
# set_property port_width 1 [get_debug_ports u_ila_0/probe3]
# connect_debug_port u_ila_0/probe3 [get_nets [list tx_top_OBUF]]
# set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
# set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
# set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
# connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]
