----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljal
-- 
-- Create Date: 05/03/2021 02:06:56 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: AXI_to_noc_FIFO_buffer_tb - Simulation
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
-- Revision 0.1 - 2021-05-03 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija simulacije noc_to_AXI_FIFO_buffer modula
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library noc_lib;
use noc_lib.router_config.ALL;
use noc_lib.AXI_network_adapter_config.ALL;
use noc_lib.component_declarations.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity noc_to_AXI_FIFO_buffer_tb is
--  Port ( );
end noc_to_AXI_FIFO_buffer_tb;

architecture Simulation of noc_to_AXI_FIFO_buffer_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    signal flit_in_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal flit_in_valid_sim : std_logic;
    
    signal flit_out_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal has_tail_sim : std_logic;
    
    signal right_shift_sim : std_logic;
    
    signal full_sim : std_logic;
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: noc_to_AXI_FIFO_buffer
    
        generic map(
            flit_size => const_flit_size,
            buffer_size => const_buffer_size
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim, 
           
            flit_in => flit_in_sim,
            flit_in_valid => flit_in_valid_sim,
            
            flit_out => flit_out_sim,
            has_tail => has_tail_sim,
            
            right_shift => right_shift_sim,
            
            full => full_sim
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
    
        -- > Inicijalne postavke ulaznih signala
        flit_in_sim <= (others => '0');
        flit_in_valid_sim <= '0';
        
        right_shift_sim <= '0';
        -- < Inicijalne postavke ulaznih signala
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for 2us;
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (2.1 * clk_period);
        
        -- > Genericko testiranje
        --flit_in_sim <= X"31223456677";
        --flit_in_valid_sim <= '1';
        
        --wait for clk_period;
        
        --flit_in_sim <= X"37665456677";
        --flit_in_valid_sim <= '1';
        
        --wait for clk_period;
        
        --flit_in_sim <= (others => '0');
        --flit_in_valid_sim <= '0';
        
        --right_shift_sim <= '1';
        
        --wait for clk_period;
        
        --right_shift_sim <= '0';
        
        --wait for clk_period;
        
        --flit_in_sim <= X"75432123456";
        --flit_in_valid_sim <= '1';
        
        --right_shift_sim <= '1';
        
        --wait for clk_period;
        
        --flit_in_sim <= (others => '0');
        --flit_in_valid_sim <= '0';
        
        --right_shift_sim <= '1';
        
        --wait for clk_period;
        
        --flit_in_sim <= X"31111111111";
        --flit_in_valid_sim <= '1';
        
        --right_shift_sim <= '0';
        
        --wait for clk_period;
        
        --flit_in_sim <= X"32222222222";
        --flit_in_valid_sim <= '1';
        
        --wait for clk_period;
        
        --flit_in_sim <= X"33333333333";
        --flit_in_valid_sim <= '1';
        
        --wait for clk_period;
        
        --flit_in_sim <= X"34444444444";
        --flit_in_valid_sim <= '1';
        
        --wait for clk_period;
        
        --flit_in_sim <= X"35555555555";
        --flit_in_valid_sim <= '1';
        
        --wait for clk_period;
        
        --flit_in_sim <= X"36666666666";
        --flit_in_valid_sim <= '1';
        
        --wait for clk_period;
        
        --flit_in_sim <= X"77777777777";
        --flit_in_valid_sim <= '1';
        
        --wait for clk_period;
        
        --flit_in_sim <= X"88888888888";
        --flit_in_valid_sim <= '1';
        
        --wait for clk_period;
        
        --flit_in_sim <= (others => '0');
        --flit_in_valid_sim <= '0';
        -- < Genericko testiranje
        
        --wait for clk_period;
        
        -- > Testiranje kompatibilnosti
        flit_in_sim <= X"33333333333";
        flit_in_valid_sim <= '1';
        
        wait for clk_period;
        
        flit_in_sim <= X"77777777777";
        flit_in_valid_sim <= '1';
        
        wait for clk_period;
        
        flit_in_sim <= (others => '0');
        flit_in_valid_sim <= '0';
        
        right_shift_sim <= '1';
        
        wait for (2 * clk_period);
        
        right_shift_sim <= '0';
        -- < Testiranje kompatibilnosti
    
        wait;
    
    end process;

end Simulation;