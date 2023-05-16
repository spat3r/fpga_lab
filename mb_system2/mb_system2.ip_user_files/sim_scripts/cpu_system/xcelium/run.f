-makelib xcelium_lib/xpm -sv \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/microblaze_v11_0_10 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/1f7b/hdl/microblaze_v11_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/cpu_system/ip/cpu_system_microblaze_0_0/sim/cpu_system_microblaze_0_0.vhd" \
-endlib
-makelib xcelium_lib/lmb_v10_v3_0_12 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/cd1d/hdl/lmb_v10_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/cpu_system/ip/cpu_system_dlmb_v10_0/sim/cpu_system_dlmb_v10_0.vhd" \
  "../../../bd/cpu_system/ip/cpu_system_ilmb_v10_0/sim/cpu_system_ilmb_v10_0.vhd" \
-endlib
-makelib xcelium_lib/lmb_bram_if_cntlr_v4_0_21 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/a177/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/cpu_system/ip/cpu_system_dlmb_bram_if_cntlr_0/sim/cpu_system_dlmb_bram_if_cntlr_0.vhd" \
  "../../../bd/cpu_system/ip/cpu_system_ilmb_bram_if_cntlr_0/sim/cpu_system_ilmb_bram_if_cntlr_0.vhd" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_5 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/25a8/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/cpu_system/ip/cpu_system_lmb_bram_0/sim/cpu_system_lmb_bram_0.v" \
-endlib
-makelib xcelium_lib/axi_lite_ipif_v3_0_4 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_intc_v4_1_17 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/802b/hdl/axi_intc_v4_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/cpu_system/ip/cpu_system_microblaze_0_axi_intc_0/sim/cpu_system_microblaze_0_axi_intc_0.vhd" \
-endlib
-makelib xcelium_lib/xlconcat_v2_1_4 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/4b67/hdl/xlconcat_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/cpu_system/ip/cpu_system_microblaze_0_xlconcat_0/sim/cpu_system_microblaze_0_xlconcat_0.v" \
-endlib
-makelib xcelium_lib/mdm_v3_2_23 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/b8f4/hdl/mdm_v3_2_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/cpu_system/ip/cpu_system_mdm_1_0/sim/cpu_system_mdm_1_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/cpu_system/ip/cpu_system_clk_wiz_1_0/cpu_system_clk_wiz_1_0_clk_wiz.v" \
  "../../../bd/cpu_system/ip/cpu_system_clk_wiz_1_0/cpu_system_clk_wiz_1_0.v" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_13 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/cpu_system/ip/cpu_system_rst_clk_wiz_1_100M_0/sim/cpu_system_rst_clk_wiz_1_100M_0.vhd" \
-endlib
-makelib xcelium_lib/interrupt_control_v3_1_4 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_gpio_v2_0_29 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/6219/hdl/axi_gpio_v2_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/cpu_system/ip/cpu_system_axi_gpio_0_0/sim/cpu_system_axi_gpio_0_0.vhd" \
  "../../../bd/cpu_system/ip/cpu_system_axi_gpio_1_0/sim/cpu_system_axi_gpio_1_0.vhd" \
-endlib
-makelib xcelium_lib/lib_pkg_v1_0_2 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_timer_v2_0_29 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/22b2/hdl/axi_timer_v2_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/cpu_system/ip/cpu_system_axi_timer_0_0/sim/cpu_system_axi_timer_0_0.vhd" \
-endlib
-makelib xcelium_lib/lib_srl_fifo_v1_0_2 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_uartlite_v2_0_31 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/67a1/hdl/axi_uartlite_v2_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/cpu_system/ip/cpu_system_axi_uartlite_0_0/sim/cpu_system_axi_uartlite_0_0.vhd" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_27 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/f0b4/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/83df/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/83df/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/83df/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_26 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/3111/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_crossbar_v2_1_28 \
  "../../../../mb_system2.gen/sources_1/bd/cpu_system/ipshared/c40e/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/cpu_system/ip/cpu_system_xbar_0/sim/cpu_system_xbar_0.v" \
  "../../../bd/cpu_system/sim/cpu_system.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

