--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
--Date        : Tue Jun  1 16:17:40 2021
--Host        : DESKTOP-SDVR1UU running 64-bit major release  (build 9200)
--Command     : generate_target design_4x4_wrapper.bd
--Design      : design_4x4_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_4x4_wrapper is
  port (
    clk_0 : in STD_LOGIC;
    rst_0 : in STD_LOGIC
  );
end design_4x4_wrapper;

architecture STRUCTURE of design_4x4_wrapper is
  component design_4x4 is
  port (
    clk_0 : in STD_LOGIC;
    rst_0 : in STD_LOGIC
  );
  end component design_4x4;
begin
design_4x4_i: component design_4x4
     port map (
      clk_0 => clk_0,
      rst_0 => rst_0
    );
end STRUCTURE;
