----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 09.04.2021 13:00:05
-- Design Name: NoC Router
-- Module Name: crossbar - Behavioral
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
-- Revision 0.1 - 2021-04-09 - Mrkovic
-- Additional Comments: Prva verzija crossbara
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library noc_lib;
use noc_lib.router_config.ALL;
use noc_lib.component_declarations.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity crossbar is

    Generic (
        flit_size : integer := const_flit_size
    );
    
    Port (
        select_vector_local : in std_logic_vector(4 downto 0);
        select_vector_north : in std_logic_vector(4 downto 0);
        select_vector_east : in std_logic_vector(4 downto 0);
        select_vector_south : in std_logic_vector(4 downto 0);
        select_vector_west : in std_logic_vector(4 downto 0);
    
        data_in_local : in std_logic_vector(flit_size - 1 downto 0);
        data_in_north : in std_logic_vector(flit_size - 1 downto 0);
        data_in_east  : in std_logic_vector(flit_size - 1 downto 0);
        data_in_south : in std_logic_vector(flit_size - 1 downto 0);
        data_in_west  : in std_logic_vector(flit_size - 1 downto 0);
        
        data_in_valid_local : in std_logic;
        data_in_valid_north : in std_logic;
        data_in_valid_east  : in std_logic;
        data_in_valid_south : in std_logic;
        data_in_valid_west  : in std_logic;
        
        data_out_local : out std_logic_vector(flit_size - 1 downto 0);
        data_out_north : out std_logic_vector(flit_size - 1 downto 0);
        data_out_east  : out std_logic_vector(flit_size - 1 downto 0);
        data_out_south : out std_logic_vector(flit_size - 1 downto 0);
        data_out_west  : out std_logic_vector(flit_size - 1 downto 0);
        
        data_out_valid_local : out std_logic;
        data_out_valid_north : out std_logic;
        data_out_valid_east  : out std_logic;
        data_out_valid_south : out std_logic;
        data_out_valid_west  : out std_logic
    );

end crossbar;

architecture Behavioral of crossbar is

begin

    -- crossbar_mux_module komponenta - LOCAL
    crossbar_mux_module_local : crossbar_mux_module
    
        generic map (
            flit_size => flit_size
        )
        
        port map (
            select_vector => select_vector_local,
        
            data_local => data_in_local,
            data_north => data_in_north,
            data_east => data_in_east,
            data_south => data_in_south,
            data_west => data_in_west,
            
            data_valid_local => data_in_valid_local,
            data_valid_north => data_in_valid_north,
            data_valid_east => data_in_valid_east,
            data_valid_south => data_in_valid_south,
            data_valid_west => data_in_valid_west,
            
            data_out => data_out_local,
            
            data_valid_out => data_out_valid_local
        );

    -- crossbar_mux_module komponenta - NORTH
    crossbar_mux_module_north : crossbar_mux_module
    
        generic map (
            flit_size => flit_size
        )
        
        port map (
            select_vector => select_vector_north,
        
            data_local => data_in_local,
            data_north => data_in_north,
            data_east => data_in_east,
            data_south => data_in_south,
            data_west => data_in_west,
            
            data_valid_local => data_in_valid_local,
            data_valid_north => data_in_valid_north,
            data_valid_east => data_in_valid_east,
            data_valid_south => data_in_valid_south,
            data_valid_west => data_in_valid_west,
            
            data_out => data_out_north,
            
            data_valid_out => data_out_valid_north
        );

    -- crossbar_mux_module komponenta - EAST
    crossbar_mux_module_east : crossbar_mux_module
    
        generic map (
            flit_size => flit_size
        )
        
        port map (
            select_vector => select_vector_east,
        
            data_local => data_in_local,
            data_north => data_in_north,
            data_east => data_in_east,
            data_south => data_in_south,
            data_west => data_in_west,
            
            data_valid_local => data_in_valid_local,
            data_valid_north => data_in_valid_north,
            data_valid_east => data_in_valid_east,
            data_valid_south => data_in_valid_south,
            data_valid_west => data_in_valid_west,
            
            data_out => data_out_east,
            
            data_valid_out => data_out_valid_east
        );

    -- crossbar_mux_module komponenta - SOUTH
    crossbar_mux_module_south : crossbar_mux_module
    
        generic map (
            flit_size => flit_size
        )
        
        port map (
            select_vector => select_vector_south,
        
            data_local => data_in_local,
            data_north => data_in_north,
            data_east => data_in_east,
            data_south => data_in_south,
            data_west => data_in_west,
            
            data_valid_local => data_in_valid_local,
            data_valid_north => data_in_valid_north,
            data_valid_east => data_in_valid_east,
            data_valid_south => data_in_valid_south,
            data_valid_west => data_in_valid_west,
            
            data_out => data_out_south,
            
            data_valid_out => data_out_valid_south
        );

    -- crossbar_mux_module komponenta - WEST
    crossbar_mux_module_west : crossbar_mux_module
    
        generic map (
            flit_size => flit_size
        )
        
        port map (
            select_vector => select_vector_west,
        
            data_local => data_in_local,
            data_north => data_in_north,
            data_east => data_in_east,
            data_south => data_in_south,
            data_west => data_in_west,
            
            data_valid_local => data_in_valid_local,
            data_valid_north => data_in_valid_north,
            data_valid_east => data_in_valid_east,
            data_valid_south => data_in_valid_south,
            data_valid_west => data_in_valid_west,
            
            data_out => data_out_west,
            
            data_valid_out => data_out_valid_west
        );

end Behavioral;
