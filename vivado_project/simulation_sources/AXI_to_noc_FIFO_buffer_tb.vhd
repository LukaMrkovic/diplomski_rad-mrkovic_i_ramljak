----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/03/2021 12:48:49 PM
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
-- Additional Comments: Prva verzija simulacije AXI_to_noc_FIFO_buffer modula
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

entity AXI_to_noc_FIFO_buffer_tb is
--  Port ( );
end AXI_to_noc_FIFO_buffer_tb;

architecture Simulation of AXI_to_noc_FIFO_buffer_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    signal flit_in_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal flit_in_valid_sim : std_logic;
    
    signal flit_out_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal empty_sim : std_logic;
    
    signal right_shift_sim : std_logic;
    
    signal buffer_write_ready_sim : std_logic;
    signal buffer_read_ready_sim : std_logic;

    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: AXI_to_noc_FIFO_buffer
    
        generic map(
            flit_size => const_flit_size,
            buffer_size => const_buffer_size,
            write_threshold => const_MNA_write_threshold,
            read_threshold => const_MNA_read_threshold
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim, 
           
            flit_in => flit_in_sim,
            flit_in_valid => flit_in_valid_sim,
            
            flit_out => flit_out_sim,
            empty => empty_sim,
            
            right_shift => right_shift_sim,
            
            buffer_write_ready => buffer_write_ready_sim,
            buffer_read_ready => buffer_read_ready_sim
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
        flit_in_sim <= (others => '0');
        flit_in_valid_sim <= '0';
        
        right_shift_sim <= '0';
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for 2us;
        
        rst_sim <= '1';
        
        wait for 2.1 * clk_period;
        
        flit_in_sim <= X"11223456677";
        flit_in_valid_sim <= '1';
        
        wait for clk_period;
        
        flit_in_sim <= X"77665456677";
        flit_in_valid_sim <= '1';
        
        wait for clk_period;
        
        flit_in_sim <= (others => '0');
        flit_in_valid_sim <= '0';
        
        right_shift_sim <= '1';
        
        wait for clk_period;
        
        right_shift_sim <= '0';
        
        wait for clk_period;
        
        flit_in_sim <= X"65432123456";
        flit_in_valid_sim <= '1';
        
        right_shift_sim <= '1';
        
        wait for clk_period;
        
        flit_in_sim <= (others => '0');
        flit_in_valid_sim <= '0';
        
        right_shift_sim <= '0';
        
        wait for clk_period;
        
        flit_in_sim <= X"11111111111";
        flit_in_valid_sim <= '1';
        
        wait for clk_period;
        
        flit_in_sim <= X"22222222222";
        flit_in_valid_sim <= '1';
        
        wait for clk_period;
        
        flit_in_sim <= X"33333333333";
        flit_in_valid_sim <= '1';
        
        wait for clk_period;
        
        flit_in_sim <= X"44444444444";
        flit_in_valid_sim <= '1';
        
        wait for clk_period;
        
        flit_in_sim <= X"55555555555";
        flit_in_valid_sim <= '1';
        
        wait for clk_period;
        
        flit_in_sim <= X"66666666666";
        flit_in_valid_sim <= '1';
        
        wait for clk_period;
        
        flit_in_sim <= (others => '0');
        flit_in_valid_sim <= '0';
        
        wait for clk_period;
    
        wait;
    
    end process;

end Simulation;
