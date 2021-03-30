----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 03/25/2021 01:12:38 PM
-- Design Name: NoC_Router
-- Module Name: FIFO_buffer_module_tb - Behavioral
-- Project Name: NoC_Router
-- Target Devices: zc706
-- Tool Versions: 2020.2
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Revision 0.1 - 2021-03-25 - Mrkovic i Ramljak
-- Additional Comments: Prva verzija simulacije FIFO_buffer_modul
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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

entity FIFO_buffer_module_tb is
--  Port ( );
end FIFO_buffer_module_tb;

architecture Simulation of FIFO_buffer_module_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    signal data_in_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_sim : std_logic;
    
    signal right_shift_sim : std_logic;
    
    signal data_out_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_next_sim : std_logic_vector(const_flit_size - 1 downto 0);
    
    signal empty_sim : std_logic;
    signal almost_empty_sim : std_logic;
    
    -- Period takta
    constant clk_period : time := 200ns;
    
begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: FIFO_buffer_module
        
        generic map(
            flit_size => const_flit_size,
            buffer_size => const_buffer_size
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim, 
           
            data_in => data_in_sim,
            data_in_valid => data_in_valid_sim,
           
            right_shift => right_shift_sim,
            
            data_out => data_out_sim,
            data_next => data_next_sim,
           
            empty => empty_sim,
            almost_empty => almost_empty_sim
        );
        
    -- clk proces
    clk_process : process
    
    begin
    
        clk_sim <= '1';
        wait for clk_period / 2;
        clk_sim <= '0';
        wait for clk_period / 2;
        
    end process;
    
    -- stimulirajuci proces
    stim_process : process
    
    begin
    
        -- Inicijalne postavke ulaznih signala
        data_in_sim <= (others => '0');
        data_in_valid_sim <= '0';
        
        right_shift_sim <= '0';
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for 2us;
        
        rst_sim <= '1';
        
        wait for 1us;
        
        data_in_sim <= X"11223456677";
        data_in_valid_sim <= '1';
        
        wait for clk_period;
        
        data_in_sim <= X"77665456677";
        data_in_valid_sim <= '1';
        
        wait for clk_period;
        
        data_in_sim <= (others => '0');
        data_in_valid_sim <= '0';
        
        right_shift_sim <= '1';
        
        wait for clk_period;
        
        right_shift_sim <= '0';
        
        wait for clk_period;
        
        data_in_sim <= X"65432123456";
        data_in_valid_sim <= '1';
        
        right_shift_sim <= '1';
        
        wait for clk_period;
        
        data_in_sim <= (others => '0');
        data_in_valid_sim <= '0';
        
        right_shift_sim <= '0';
        
        wait for clk_period;
        
        data_in_sim <= X"11111111111";
        data_in_valid_sim <= '1';
        
        wait for clk_period;
        
        data_in_sim <= X"22222222222";
        data_in_valid_sim <= '1';
        
        wait for clk_period;
        
        data_in_sim <= X"33333333333";
        data_in_valid_sim <= '1';
        
        wait for clk_period;
        
        data_in_sim <= X"44444444444";
        data_in_valid_sim <= '1';
        
        wait for clk_period;
        
        data_in_sim <= X"55555555555";
        data_in_valid_sim <= '1';
        
        wait for clk_period;
        
        data_in_sim <= X"66666666666";
        data_in_valid_sim <= '1';
        
        wait for clk_period;
        
        data_in_sim <= (others => '0');
        data_in_valid_sim <= '0';
        
        wait for clk_period;
        
        -- TODO
        
        wait;
    
    end process;

end Simulation;