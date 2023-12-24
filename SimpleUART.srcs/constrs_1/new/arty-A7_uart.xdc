## Clock signal
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

## Buttons
#set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 } [get_ports { rst }]; #IO_L6N_T0_VREF_16 Sch=btn[0]
set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { rst }]; #IO_L16P_T2_35 Sch=ck_rst

## USB-UART Interface
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVTTL} [get_ports tx_top]; # D10 pin = FT2232 input (top output)
set_property -dict {PACKAGE_PIN A9 IOSTANDARD LVTTL} [get_ports rx_top];  # A9 pin = FT2232 output (top input)