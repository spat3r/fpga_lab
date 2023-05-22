set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN DIV-1 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]

set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PACKAGE_PIN D23 [get_ports clk]
set_property PACKAGE_PIN L23 [get_ports rst]

set_property IOSTANDARD LVCMOS33 [get_ports {bt3}]
#set_property IOSTANDARD LVCMOS33 [get_ports {bt[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {bt[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {bt[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {dig[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {dig[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {dig[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {dig[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_b[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_b[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_b[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_b[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_b[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_b[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_b[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_b[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_g[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_g[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_g[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_g[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_g[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_g[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_g[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_g[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_r[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_r[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_r[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_r[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_r[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_r[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_r[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_r[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw0}]

set_property PACKAGE_PIN E11 [get_ports {sw0}]
#set_property PACKAGE_PIN C11 [get_ports {sw[5]}]
#set_property PACKAGE_PIN C12 [get_ports {sw[6]}]
#set_property PACKAGE_PIN G14 [get_ports {sw[3]}]
#set_property PACKAGE_PIN B11 [get_ports {sw[4]}]
#set_property PACKAGE_PIN B12 [get_ports {sw[7]}]
#set_property PACKAGE_PIN E12 [get_ports {sw[1]}]
#set_property PACKAGE_PIN E15 [get_ports {sw[2]}]
#set_property PACKAGE_PIN D8 [get_ports {seg[0]}]
#set_property PACKAGE_PIN D9 [get_ports {seg[3]}]
#set_property PACKAGE_PIN G11 [get_ports {seg[5]}]
#set_property PACKAGE_PIN B9 [get_ports {seg[2]}]
#set_property PACKAGE_PIN C9 [get_ports {seg[6]}]
#set_property PACKAGE_PIN G10 [get_ports {seg[7]}]
#set_property PACKAGE_PIN E13 [get_ports {seg[4]}]
#set_property PACKAGE_PIN E10 [get_ports {seg[1]}]
#set_property PACKAGE_PIN E16 [get_ports {led_r[0]}]
#set_property PACKAGE_PIN E17 [get_ports {led_r[1]}]
#set_property PACKAGE_PIN F19 [get_ports {led_r[2]}]
#set_property PACKAGE_PIN C14 [get_ports {led_r[3]}]
#set_property PACKAGE_PIN D15 [get_ports {led_r[4]}]
#set_property PACKAGE_PIN C16 [get_ports {led_r[5]}]
#set_property PACKAGE_PIN D18 [get_ports {led_r[6]}]
#set_property PACKAGE_PIN C18 [get_ports {led_r[7]}]
#set_property PACKAGE_PIN G17 [get_ports {led_g[0]}]
#set_property PACKAGE_PIN E18 [get_ports {led_g[1]}]
#set_property PACKAGE_PIN G19 [get_ports {led_g[2]}]
#set_property PACKAGE_PIN D14 [get_ports {led_g[3]}]
#set_property PACKAGE_PIN D16 [get_ports {led_g[4]}]
#set_property PACKAGE_PIN C17 [get_ports {led_g[5]}]
#set_property PACKAGE_PIN D19 [get_ports {led_g[6]}]
#set_property PACKAGE_PIN C19 [get_ports {led_g[7]}]
#set_property PACKAGE_PIN F17 [get_ports {led_b[0]}]
#set_property PACKAGE_PIN F18 [get_ports {led_b[1]}]
#set_property PACKAGE_PIN F20 [get_ports {led_b[2]}]
#set_property PACKAGE_PIN B15 [get_ports {led_b[3]}]
#set_property PACKAGE_PIN B16 [get_ports {led_b[4]}]
#set_property PACKAGE_PIN B17 [get_ports {led_b[5]}]
#set_property PACKAGE_PIN B19 [get_ports {led_b[6]}]
#set_property PACKAGE_PIN D20 [get_ports {led_b[7]}]
#set_property PACKAGE_PIN B10 [get_ports {dig[3]}]
#set_property PACKAGE_PIN D11 [get_ports {dig[1]}]
#set_property PACKAGE_PIN D10 [get_ports {dig[2]}]
#set_property PACKAGE_PIN F10 [get_ports {dig[0]}]
#set_property PACKAGE_PIN A10 [get_ports {bt[0]}]
#set_property PACKAGE_PIN A17 [get_ports {bt[1]}]
#set_property PACKAGE_PIN A19 [get_ports {bt[2]}]
set_property PACKAGE_PIN A18 [get_ports {bt3}]

set_property IOSTANDARD LVCMOS33 [get_ports codec_*]
#set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]
#set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
#set_property PULLDOWN true [get_ports codec_m0]
#set_property PULLUP true [get_ports codec_i2s]
#set_property PULLDOWN true [get_ports codec_mdiv2]
#set_property PULLDOWN true [get_ports codec_m1]
#set_property PULLDOWN true [get_ports codec_mdiv1]
#set_property PACKAGE_PIN N21 [get_ports uart_rxd]
#set_property PACKAGE_PIN M21 [get_ports uart_txd]

#SPI MISO -> M1      = 0
#SPI CLK  -> M0      = 0
#SPI CSn  -> I2S/~LJ = 1
#SPI MOSI -> MDIV1   = 0
#            MDIV2   = 0
set_property PACKAGE_PIN J23 [get_ports codec_lrclk]
set_property PACKAGE_PIN K23 [get_ports codec_sclk]
set_property PACKAGE_PIN L22 [get_ports codec_rstn]
set_property PACKAGE_PIN J25 [get_ports codec_mdiv1]
set_property PACKAGE_PIN J24 [get_ports codec_mclk]
set_property PACKAGE_PIN H24 [get_ports codec_sdin]
set_property PACKAGE_PIN H26 [get_ports codec_i2s]
set_property PACKAGE_PIN J26 [get_ports codec_mdiv2]
set_property PACKAGE_PIN G26 [get_ports codec_m0]
set_property PACKAGE_PIN G25 [get_ports codec_m1]
set_property PACKAGE_PIN K21 [get_ports codec_sdout]

set_property IOSTANDARD LVCMOS33 [get_ports vol_clk]
set_property IOSTANDARD LVCMOS33 [get_ports vol_ud]
set_property PACKAGE_PIN K22 [get_ports vol_clk]
set_property PACKAGE_PIN H22 [get_ports vol_ud]


set_property IOSTANDARD LVCMOS33 [get_ports {disp[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN B10 [get_ports {disp[3]}]
set_property PACKAGE_PIN D10 [get_ports {disp[2]}]
set_property PACKAGE_PIN D11 [get_ports {disp[1]}]
set_property PACKAGE_PIN F10 [get_ports {disp[0]}]
set_property PACKAGE_PIN G10 [get_ports {seg[7]}]
set_property PACKAGE_PIN C9 [get_ports {seg[6]}]
set_property PACKAGE_PIN G11 [get_ports {seg[5]}]
set_property PACKAGE_PIN E13 [get_ports {seg[4]}]
set_property PACKAGE_PIN D9 [get_ports {seg[3]}]
set_property PACKAGE_PIN B9 [get_ports {seg[2]}]
set_property PACKAGE_PIN E10 [get_ports {seg[1]}]
set_property PACKAGE_PIN D8 [get_ports {seg[0]}]

set_property PACKAGE_PIN M19 [get_ports sck]
set_property IOSTANDARD LVCMOS33 [get_ports sck]

set_property PACKAGE_PIN N18 [get_ports cs]
set_property IOSTANDARD LVCMOS33 [get_ports cs]

set_property PACKAGE_PIN P19 [get_ports miso]
set_property IOSTANDARD LVCMOS33 [get_ports miso]