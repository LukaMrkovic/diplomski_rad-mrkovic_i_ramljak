----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 08.04.2021 12:24:12
-- Design Name: NoC Router
-- Module Name: crossbar_mux_module - Behavioral
-- Project Name: NoC Router
-- Target Devices: zc706
-- Tool Versions: 2020.2
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Revision 0.1 - 2021-04-08 - Mrkovic
-- Additional Comments: Prva verzija modula
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library noc_lib;
use noc_lib.router_config.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity crossbar_mux_module is

    Generic (
        flit_size : integer := const_flit_size
    );
    
    Port (
        select_vector : in std_logic_vector(4 downto 0);
    
        data_local : in std_logic_vector(flit_size - 1 downto 0);
        data_north : in std_logic_vector(flit_size - 1 downto 0);
        data_east  : in std_logic_vector(flit_size - 1 downto 0);
        data_south : in std_logic_vector(flit_size - 1 downto 0);
        data_west  : in std_logic_vector(flit_size - 1 downto 0);
        
        data_valid_local : in std_logic;
        data_valid_north : in std_logic;
        data_valid_east  : in std_logic;
        data_valid_south : in std_logic;
        data_valid_west  : in std_logic;
        
        data_out : out std_logic_vector(flit_size - 1 downto 0);
        
        data_valid_out : out std_logic
    );

end crossbar_mux_module;

architecture Behavioral of crossbar_mux_module is

begin

    with select_vector select
        data_out <= data_local          when "00001",
                    data_north          when "00010",
                    data_east           when "00100",
                    data_south          when "01000",
                    data_west           when "10000",
                    (others => '0')     when others;
                
    with select_vector select
        data_valid_out <= data_valid_local      when "00001",
                          data_valid_north      when "00010",
                          data_valid_east       when "00100",
                          data_valid_south      when "01000",
                          data_valid_west       when "10000",
                          '0'                   when others;

end Behavioral;
