--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
--Date        : Mon May 31 11:28:18 2021
--Host        : LukaM-GTX980TI running 64-bit major release  (build 9200)
--Command     : generate_target demo_1_design_wrapper.bd
--Design      : demo_1_design_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity demo_1_design_wrapper is
  port (
    clk_0 : in STD_LOGIC;
    rst_0 : in STD_LOGIC
  );
end demo_1_design_wrapper;

architecture STRUCTURE of demo_1_design_wrapper is
  component demo_1_design is
  port (
    clk_0 : in STD_LOGIC;
    rst_0 : in STD_LOGIC
  );
  end component demo_1_design;
begin
demo_1_design_i: component demo_1_design
     port map (
      clk_0 => clk_0,
      rst_0 => rst_0
    );
end STRUCTURE;
