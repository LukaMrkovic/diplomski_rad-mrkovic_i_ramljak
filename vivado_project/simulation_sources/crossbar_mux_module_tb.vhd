----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 08.04.2021 13:36:17
-- Design Name: NoC Router
-- Module Name: crossbar_mux_module_tb - Simulation
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
-- Additional Comments: Prva verzija simulacije crossbar_mux_module
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

entity crossbar_mux_module_tb is
--  Port ( );
end crossbar_mux_module_tb;

architecture Simulation of crossbar_mux_module_tb is

    -- Simulirani signali
    signal select_vector_sim : std_logic_vector(4 downto 0);
    
    signal data_local_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_north_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_east_sim  : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_south_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_west_sim  : std_logic_vector(const_flit_size - 1 downto 0);
        
    signal data_valid_local_sim : std_logic;
    signal data_valid_north_sim : std_logic;
    signal data_valid_east_sim  : std_logic;
    signal data_valid_south_sim : std_logic;
    signal data_valid_west_sim  : std_logic;
        
    signal data_out_sim : std_logic_vector(const_flit_size - 1 downto 0);
        
    signal data_valid_out_sim : std_logic;
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: crossbar_mux_module
    
        generic map (
            flit_size => const_flit_size
        )
        
        port map (
            select_vector => select_vector_sim,
        
            data_local => data_local_sim,
            data_north => data_north_sim,
            data_east => data_east_sim,
            data_south => data_south_sim,
            data_west => data_west_sim,
            
            data_valid_local => data_valid_local_sim,
            data_valid_north => data_valid_north_sim,
            data_valid_east => data_valid_east_sim,
            data_valid_south => data_valid_south_sim,
            data_valid_west => data_valid_west_sim,
            
            data_out => data_out_sim,
            
            data_valid_out => data_valid_out_sim
        );
        
    -- stimulirajuci proces
    stim_process : process
    
    begin
    
        -- Inicijalne postavke ulaznih signala
        select_vector_sim <= (others => '0');
        
        data_local_sim <= (others => '0');
        data_north_sim <= (others => '0');
        data_east_sim <= (others => '0');
        data_south_sim <= (others => '0');
        data_west_sim <= (others => '0');
        
        data_valid_local_sim <= '0';
        data_valid_north_sim <= '0';
        data_valid_east_sim <= '0';
        data_valid_south_sim <= '0';
        data_valid_west_sim <= '0';
        
        wait for (5 * clk_period);
        
        data_local_sim <= X"AAAAAAAAAAA";
        data_north_sim <= X"BBBBBBBBBBB";
        data_east_sim <= X"CCCCCCCCCCC";
        data_south_sim <= X"DDDDDDDDDDD";
        data_west_sim <= X"EEEEEEEEEEE";
        
        data_valid_local_sim <= '1';
        data_valid_east_sim <= '1';
        data_valid_west_sim <= '1';
        
        wait for (5 * clk_period);
        
        select_vector_sim <= B"10000";
        
        wait for clk_period;
        
        select_vector_sim <= B"01000";
        
        wait for clk_period;
        
        select_vector_sim <= B"00100";
        
        wait for clk_period;
        
        select_vector_sim <= B"00010";
        
        wait for clk_period;
        
        select_vector_sim <= B"00001";
        
        wait for clk_period;
        
        select_vector_sim <= (others => '0');
    
        wait;
        
    end process;

end Simulation;
