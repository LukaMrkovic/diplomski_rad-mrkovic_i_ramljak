----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 11.05.2021 14:07:54
-- Design Name: AXI_Network_Adapter
-- Module Name: SNA_req_buffer_controller_tb - Simulation
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
-- Revision 0.1 - 2021-05-11 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija simulacije SNA_req_buffer_controllera
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

entity SNA_req_buffer_controller_tb is
--  Port ( );
end SNA_req_buffer_controller_tb;

architecture Simulation of SNA_req_buffer_controller_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    signal flit_out_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal has_tail_sim : std_logic;
        
    signal right_shift_sim : std_logic;
    signal vc_credits_sim : std_logic_vector(const_vc_num - 1 downto 0);
        
    signal op_write_sim : std_logic;
    signal op_read_sim : std_logic;
        
    signal addr_sim : std_logic_vector(31 downto 0);
    signal data_sim : std_logic_vector(31 downto 0);
    signal prot_sim : std_logic_vector(2 downto 0);
    signal strb_sim : std_logic_vector(3 downto 0);
        
    signal SNA_ready_sim : std_logic;
    signal t_begun_sim : std_logic;
        
    signal resp_write_sim : std_logic;
    signal resp_read_sim : std_logic;
        
    signal r_addr_sim : std_logic_vector(const_address_size - 1 downto 0);
    signal r_vc_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: SNA_req_buffer_controller
    
        generic map(
            vc_num => const_vc_num,
            flit_size => const_flit_size,
            address_size => const_address_size,
            payload_size => const_payload_size
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim, 
           
            flit_out => flit_out_sim,
            has_tail => has_tail_sim,
            
            right_shift => right_shift_sim,
            vc_credits => vc_credits_sim,
            
            op_write => op_write_sim,
            op_read => op_read_sim,
            
            addr => addr_sim,
            data => data_sim,
            prot => prot_sim,
            strb => strb_sim,
            
            SNA_ready => SNA_ready_sim,
            t_begun => t_begun_sim,
            
            resp_write => resp_write_sim,
            resp_read => resp_read_sim,
            
            r_addr => r_addr_sim,
            r_vc => r_vc_sim
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
    
        flit_out_sim <= (others => '0');
        has_tail_sim <= '0';
        
        SNA_ready_sim <= '0';
    
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (2.1 * clk_period);
        
        SNA_ready_sim <= '1';
        
        wait for (3 * clk_period);
        
        flit_out_sim <= X"914110000fa";
        has_tail_sim <= '1';
        
        wait for clk_period;
        
        flit_out_sim <= X"11487654321";
        
        wait for clk_period;
        
        flit_out_sim <= X"51412344321";
        
        wait for clk_period;
        
        flit_out_sim <= X"00000000000";
        has_tail_sim <= '0';
        
        wait for (4 * clk_period);
        
        flit_out_sim <= X"a4812000005";
        has_tail_sim <= '1';
        
        wait for clk_period;
        
        flit_out_sim <= X"648e1234567";
        
        wait for clk_period;
        
        flit_out_sim <= X"00000000000";
        has_tail_sim <= '0';
    
        wait;
    
    end process;

end Simulation;
