set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

set_property PACKAGE_PIN D23 [get_ports clk100M]
set_property IOSTANDARD LVCMOS33 [get_ports clk100M]
create_clock -period 10.000 -name clk100M -waveform {0.000 5.000} [get_ports clk100M]

set_property PACKAGE_PIN L23      [get_ports rstbt]
set_property IOSTANDARD  LVCMOS33 [get_ports rstbt]


set_property PACKAGE_PIN D20 [get_ports {led_r[23]}]
set_property PACKAGE_PIN B19 [get_ports {led_r[22]}]
set_property PACKAGE_PIN B17 [get_ports {led_r[21]}]
set_property PACKAGE_PIN B16 [get_ports {led_r[20]}]
set_property PACKAGE_PIN B15 [get_ports {led_r[19]}]
set_property PACKAGE_PIN F20 [get_ports {led_r[18]}]
set_property PACKAGE_PIN F18 [get_ports {led_r[17]}]
set_property PACKAGE_PIN F17 [get_ports {led_r[16]}]
set_property PACKAGE_PIN C19 [get_ports {led_r[15]}]
set_property PACKAGE_PIN D19 [get_ports {led_r[14]}]
set_property PACKAGE_PIN C17 [get_ports {led_r[13]}]
set_property PACKAGE_PIN D16 [get_ports {led_r[12]}]
set_property PACKAGE_PIN D14 [get_ports {led_r[11]}]
set_property PACKAGE_PIN G19 [get_ports {led_r[10]}]
set_property PACKAGE_PIN E18 [get_ports {led_r[9]}]
set_property PACKAGE_PIN G17 [get_ports {led_r[8]}]
set_property PACKAGE_PIN C18 [get_ports {led_r[7]}]
set_property PACKAGE_PIN D18 [get_ports {led_r[6]}]
set_property PACKAGE_PIN C16 [get_ports {led_r[5]}]
set_property PACKAGE_PIN D15 [get_ports {led_r[4]}]
set_property PACKAGE_PIN C14 [get_ports {led_r[3]}]
set_property PACKAGE_PIN F19 [get_ports {led_r[2]}]
set_property PACKAGE_PIN E17 [get_ports {led_r[1]}]
set_property PACKAGE_PIN E16 [get_ports {led_r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[0]}]


set_property PACKAGE_PIN E11 [get_ports {sw[0]}]
set_property PACKAGE_PIN E12 [get_ports {sw[1]}]
set_property PACKAGE_PIN E15 [get_ports {sw[2]}]
set_property PACKAGE_PIN G14 [get_ports {sw[3]}]
set_property PACKAGE_PIN B11 [get_ports {sw[4]}]
set_property PACKAGE_PIN C11 [get_ports {sw[5]}]
set_property PACKAGE_PIN C12 [get_ports {sw[6]}]
set_property PACKAGE_PIN B12 [get_ports {sw[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]


set_property PACKAGE_PIN A10      [get_ports {bt[0]}]
set_property PACKAGE_PIN A17      [get_ports {bt[1]}]
set_property PACKAGE_PIN A19      [get_ports {bt[2]}]
set_property PACKAGE_PIN A18      [get_ports {bt[3]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {bt[3]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {bt[2]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {bt[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {bt[0]}]


set_property IOSTANDARD  LVCMOS33 [get_ports {disp[11]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {disp[10]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {disp[9]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {disp[8]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {disp[7]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {disp[6]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {disp[5]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {disp[4]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {disp[3]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {disp[2]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {disp[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {disp[0]}]
set_property PACKAGE_PIN B10      [get_ports {disp[11]}]
set_property PACKAGE_PIN D10      [get_ports {disp[10]}]
set_property PACKAGE_PIN D11      [get_ports {disp[9]}]
set_property PACKAGE_PIN F10      [get_ports {disp[8]}]
set_property PACKAGE_PIN G10      [get_ports {disp[7]}]
set_property PACKAGE_PIN C9       [get_ports {disp[6]}]
set_property PACKAGE_PIN G11      [get_ports {disp[5]}]
set_property PACKAGE_PIN E13      [get_ports {disp[4]}]
set_property PACKAGE_PIN D9       [get_ports {disp[3]}]
set_property PACKAGE_PIN B9       [get_ports {disp[2]}]
set_property PACKAGE_PIN E10      [get_ports {disp[1]}]
set_property PACKAGE_PIN D8       [get_ports {disp[0]}]

set_property PACKAGE_PIN N21 [get_ports uart_rxd]
set_property PACKAGE_PIN M21 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]



set_property PACKAGE_PIN D21 [get_ports hdmi_tx_clk_p]

set_property PACKAGE_PIN G24 [get_ports hdmi_rx_clk_p]
create_clock -period 10.000 -name hdmi_rx_clk_p -waveform {0.000 5.000} [get_ports {hdmi_rx_clk_p}]

set_property PACKAGE_PIN F25 [get_ports hdmi_rx_d0_p]
set_property PACKAGE_PIN D26 [get_ports hdmi_rx_d1_p]
set_property PACKAGE_PIN E25 [get_ports hdmi_rx_d2_p]

set_property PACKAGE_PIN A23 [get_ports hdmi_tx_d0_p]
set_property PACKAGE_PIN C21 [get_ports hdmi_tx_d1_p]
set_property PACKAGE_PIN B20 [get_ports hdmi_tx_d2_p]


set_property PACKAGE_PIN E22       [get_ports hdmi_tx_cec]
set_property IOSTANDARD  LVCMOS33  [get_ports hdmi_tx_cec]

set_property PACKAGE_PIN F23       [get_ports hdmi_rx_cec]
set_property IOSTANDARD  LVCMOS33  [get_ports hdmi_rx_cec]

set_property PACKAGE_PIN E23       [get_ports hdmi_rx_sda]
set_property IOSTANDARD  LVCMOS33  [get_ports hdmi_rx_sda]

set_property PACKAGE_PIN E21       [get_ports hdmi_rx_hpd]
set_property IOSTANDARD  LVCMOS33  [get_ports hdmi_rx_hpd]

set_property PACKAGE_PIN F22       [get_ports hdmi_rx_scl]
set_property IOSTANDARD  LVCMOS33  [get_ports hdmi_rx_scl]

set_property PACKAGE_PIN D24       [get_ports hdmi_tx_scl]
set_property IOSTANDARD  LVCMOS33  [get_ports hdmi_tx_scl]

set_property PACKAGE_PIN G21       [get_ports hdmi_tx_hpdn]
set_property IOSTANDARD  LVCMOS33  [get_ports hdmi_tx_hpdn]

set_property PACKAGE_PIN C24       [get_ports hdmi_tx_sda]
set_property IOSTANDARD  LVCMOS33  [get_ports hdmi_tx_sda]