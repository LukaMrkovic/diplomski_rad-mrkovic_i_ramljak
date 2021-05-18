----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/05/2021 02:55:45 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: MNA_resp_buffer_controller_tb - Simulation
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
-- Revision 0.1 - 2021-05-05 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija simulacije MNA_resp_buffer_controllera
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

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

entity MNA_resp_buffer_controller_tb is
--  Port ( );
end MNA_resp_buffer_controller_tb;

architecture Simulation of MNA_resp_buffer_controller_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    signal op_write_sim : std_logic;
    signal op_read_sim : std_logic;
    
    signal data_sim : std_logic_vector(31 downto 0);
    signal resp_sim : std_logic_vector(1 downto 0);
    
    signal flit_out_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal has_tail_sim : std_logic;
    
    signal right_shift_sim : std_logic;
    
    signal vc_credits_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: MNA_resp_buffer_controller
    
        generic map(
            flit_size => const_flit_size,
            vc_num => const_vc_num
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
            
            -- MNA_resp_AXI_handshake_controller
            op_write => op_write_sim,
            op_read => op_read_sim,
            
            data => data_sim,
            resp => resp_sim,
            
            -- noc_to_AXI_FIFO_buffer
            flit_out => flit_out_sim,
            has_tail => has_tail_sim,
            
            right_shift => right_shift_sim,
            
            -- noc_receiver
            vc_credits => vc_credits_sim
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
        flit_out_sim <= (others => '0');
        has_tail_sim <= '0';
        -- < Inicijalne postavke ulaznih signala
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (2.1 * clk_period);
        
        flit_out_sim <= X"D1234567896";
        has_tail_sim <= '1';
        
        wait for clk_period;
        
        flit_out_sim <= X"00000000000";
        has_tail_sim <= '0';
        
        wait for (4 * clk_period);
        
        flit_out_sim <= X"A1234567893";
        has_tail_sim <= '1';
        
        wait for clk_period;
        
        flit_out_sim <= X"60012345678";
        
        wait for clk_period;
        
        flit_out_sim <= X"00000000000";
        has_tail_sim <= '0';
        
        wait;
    
    end process;

end Simulation;