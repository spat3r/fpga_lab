-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.2.1 (win64) Build 3719031 Thu Dec  8 18:35:04 MST 2022
-- Date        : Tue May 16 00:13:01 2023
-- Host        : rtlaptop running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               e:/Egyetem/fpga_alapu_rendszerek/mb_system2/mb_system2.gen/sources_1/bd/cpu_system/ip/cpu_system_dlmb_bram_if_cntlr_0/cpu_system_dlmb_bram_if_cntlr_0_stub.vhdl
-- Design      : cpu_system_dlmb_bram_if_cntlr_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k70tfbg676-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_system_dlmb_bram_if_cntlr_0 is
  Port ( 
    LMB_Clk : in STD_LOGIC;
    LMB_Rst : in STD_LOGIC;
    LMB_ABus : in STD_LOGIC_VECTOR ( 0 to 31 );
    LMB_WriteDBus : in STD_LOGIC_VECTOR ( 0 to 31 );
    LMB_AddrStrobe : in STD_LOGIC;
    LMB_ReadStrobe : in STD_LOGIC;
    LMB_WriteStrobe : in STD_LOGIC;
    LMB_BE : in STD_LOGIC_VECTOR ( 0 to 3 );
    Sl_DBus : out STD_LOGIC_VECTOR ( 0 to 31 );
    Sl_Ready : out STD_LOGIC;
    Sl_Wait : out STD_LOGIC;
    Sl_UE : out STD_LOGIC;
    Sl_CE : out STD_LOGIC;
    BRAM_Rst_A : out STD_LOGIC;
    BRAM_Clk_A : out STD_LOGIC;
    BRAM_Addr_A : out STD_LOGIC_VECTOR ( 0 to 31 );
    BRAM_EN_A : out STD_LOGIC;
    BRAM_WEN_A : out STD_LOGIC_VECTOR ( 0 to 3 );
    BRAM_Dout_A : out STD_LOGIC_VECTOR ( 0 to 31 );
    BRAM_Din_A : in STD_LOGIC_VECTOR ( 0 to 31 )
  );

end cpu_system_dlmb_bram_if_cntlr_0;

architecture stub of cpu_system_dlmb_bram_if_cntlr_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "LMB_Clk,LMB_Rst,LMB_ABus[0:31],LMB_WriteDBus[0:31],LMB_AddrStrobe,LMB_ReadStrobe,LMB_WriteStrobe,LMB_BE[0:3],Sl_DBus[0:31],Sl_Ready,Sl_Wait,Sl_UE,Sl_CE,BRAM_Rst_A,BRAM_Clk_A,BRAM_Addr_A[0:31],BRAM_EN_A,BRAM_WEN_A[0:3],BRAM_Dout_A[0:31],BRAM_Din_A[0:31]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "lmb_bram_if_cntlr,Vivado 2022.2.1";
begin
end;
