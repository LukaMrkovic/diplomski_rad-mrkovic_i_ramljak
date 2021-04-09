----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 09.04.2021 13:36:50
-- Design Name: NoC Router
-- Module Name: crossbar_tb - Simulation
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
-- Additional Comments: Prva verzija simulacije integriranog crossbara
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

entity crossbar_tb is
--  Port ( );
end crossbar_tb;

architecture Simulation of crossbar_tb is

    -- Simulirani signali
    signal select_vector_local_sim : std_logic_vector(4 downto 0);
    signal select_vector_north_sim : std_logic_vector(4 downto 0);
    signal select_vector_east_sim : std_logic_vector(4 downto 0);
    signal select_vector_south_sim : std_logic_vector(4 downto 0);
    signal select_vector_west_sim : std_logic_vector(4 downto 0);
    
    signal data_in_local_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_north_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_east_sim  : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_south_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_west_sim  : std_logic_vector(const_flit_size - 1 downto 0);
        
    signal data_in_valid_local_sim : std_logic;
    signal data_in_valid_north_sim : std_logic;
    signal data_in_valid_east_sim  : std_logic;
    signal data_in_valid_south_sim : std_logic;
    signal data_in_valid_west_sim  : std_logic;
        
    signal data_out_local_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_north_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_east_sim  : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_south_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_west_sim  : std_logic_vector(const_flit_size - 1 downto 0);
        
    signal data_out_valid_local_sim : std_logic;
    signal data_out_valid_north_sim : std_logic;
    signal data_out_valid_east_sim  : std_logic;
    signal data_out_valid_south_sim : std_logic;
    signal data_out_valid_west_sim  : std_logic;
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: crossbar
    
        generic map (
            flit_size => const_flit_size
        )
        
        port map (
            select_vector_local => select_vector_local_sim,
            select_vector_north => select_vector_north_sim,
            select_vector_east => select_vector_east_sim,
            select_vector_south => select_vector_south_sim,
            select_vector_west => select_vector_west_sim,
        
            data_in_local => data_in_local_sim,
            data_in_north => data_in_north_sim,
            data_in_east => data_in_east_sim,
            data_in_south => data_in_south_sim,
            data_in_west => data_in_west_sim,
            
            data_in_valid_local => data_in_valid_local_sim,
            data_in_valid_north => data_in_valid_north_sim,
            data_in_valid_east => data_in_valid_east_sim,
            data_in_valid_south => data_in_valid_south_sim,
            data_in_valid_west => data_in_valid_west_sim,
            
            data_out_local => data_out_local_sim,
            data_out_north => data_out_north_sim,
            data_out_east => data_out_east_sim,
            data_out_south => data_out_south_sim,
            data_out_west => data_out_west_sim,
            
            data_out_valid_local => data_out_valid_local_sim,
            data_out_valid_north => data_out_valid_north_sim,
            data_out_valid_east => data_out_valid_east_sim,
            data_out_valid_south => data_out_valid_south_sim,
            data_out_valid_west => data_out_valid_west_sim
        );

    -- stimulirajuci proces
    stim_process : process
    
    begin
    
        -- Inicijalne postavke ulaznih signala
        select_vector_local_sim <= (others => '0');
        select_vector_north_sim <= (others => '0');
        select_vector_east_sim <= (others => '0');
        select_vector_south_sim <= (others => '0');
        select_vector_west_sim <= (others => '0');
        
        data_in_local_sim <= (others => '0');
        data_in_north_sim <= (others => '0');
        data_in_east_sim <= (others => '0');
        data_in_south_sim <= (others => '0');
        data_in_west_sim <= (others => '0');
        
        data_in_valid_local_sim <= '0';
        data_in_valid_north_sim <= '0';
        data_in_valid_east_sim <= '0';
        data_in_valid_south_sim <= '0';
        data_in_valid_west_sim <= '0';
        
        wait for (10 * clk_period);
        
        data_in_local_sim <= X"AAAAAAAAAAA";
        data_in_north_sim <= X"BBBBBBBBBBB";
        data_in_east_sim <= X"CCCCCCCCCCC";
        data_in_south_sim <= X"DDDDDDDDDDD";
        data_in_west_sim <= X"EEEEEEEEEEE";
        
        data_in_valid_local_sim <= '1';
        data_in_valid_east_sim <= '1';
        data_in_valid_west_sim <= '1';
        
        select_vector_local_sim <= B"10000";
        select_vector_north_sim <= B"01000";
        select_vector_east_sim <= B"00100";
        select_vector_south_sim <= B"00010";
        select_vector_west_sim <= B"00001";
        
        wait for clk_period;
        
        select_vector_local_sim <= B"01000";
        select_vector_north_sim <= B"00100";
        select_vector_east_sim <= B"00010";
        select_vector_south_sim <= B"00001";
        select_vector_west_sim <= B"10000";
        
        wait for clk_period;
        
        select_vector_local_sim <= B"00100";
        select_vector_north_sim <= B"00010";
        select_vector_east_sim <= B"00001";
        select_vector_south_sim <= B"10000";
        select_vector_west_sim <= B"01000";
        
        wait for clk_period;
        
        select_vector_local_sim <= B"00010";
        select_vector_north_sim <= B"00001";
        select_vector_east_sim <= B"10000";
        select_vector_south_sim <= B"01000";
        select_vector_west_sim <= B"00100";
        
        wait for clk_period;
        
        select_vector_local_sim <= B"00001";
        select_vector_north_sim <= B"10000";
        select_vector_east_sim <= B"01000";
        select_vector_south_sim <= B"00100";
        select_vector_west_sim <= B"00010";
        
        wait for clk_period;
        
        select_vector_local_sim <= (others => '0');
        select_vector_north_sim <= (others => '0');
        select_vector_east_sim <= (others => '0');
        select_vector_south_sim <= (others => '0');
        select_vector_west_sim <= (others => '0');
        
        data_in_local_sim <= (others => '0');
        data_in_north_sim <= (others => '0');
        data_in_east_sim <= (others => '0');
        data_in_south_sim <= (others => '0');
        data_in_west_sim <= (others => '0');
        
        data_in_valid_local_sim <= '0';
        data_in_valid_east_sim <= '0';
        data_in_valid_west_sim <= '0';
    
        wait;
        
    end process;

end Simulation;
