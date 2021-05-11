----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/10/2021 04:59:31 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: SNA_resp_buffer_controller_tb - Simulation
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
-- Revision 0.1 - 2021-05-10 - Ramljak
-- Additional Comments: Prva verzija simulacije SNA_resp_buffer_controllera
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

entity SNA_resp_buffer_controller_tb is
--  Port ( );
end SNA_resp_buffer_controller_tb;

architecture Simulation of SNA_resp_buffer_controller_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    signal flit_in_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal flit_in_valid_sim : std_logic;
    
    signal op_write_sim : std_logic;
    signal op_read_sim : std_logic;
    
    signal data_sim : std_logic_vector(31 downto 0);
    signal resp_sim : std_logic_vector(1 downto 0);
    
    signal r_addr_sim : std_logic_vector(const_address_size - 1 downto 0);
    signal r_vc_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal t_end_sim : std_logic;
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: SNA_resp_buffer_controller

        generic map (
            flit_size => const_flit_size,
            vc_num => const_vc_num,
            address_size => const_address_size
        )
                      
        port map (
            clk => clk_sim,
            rst => rst_sim,
                       
            flit_in => flit_in_sim,
            flit_in_valid => flit_in_valid_sim,
            
            op_write => op_write_sim,
            op_read => op_read_sim,
            
            data => data_sim,
            resp => resp_sim,

            r_addr => r_addr_sim,
            r_vc => r_vc_sim,
            
            t_end => t_end_sim
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
        
        op_write_sim <= '0';
        op_read_sim <= '0';
        
        data_sim  <= (others => '0');
        resp_sim <= (others => '0');
        
        r_addr_sim <= (others => '0');
        r_vc_sim <= (others => '0');
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (2.1 * clk_period);
        
        --> WRITE RESPONSE
        -- Povratna adresa routera 0 (0001 0001)
        r_addr_sim <= "00010001";
        r_vc_sim <= "01";
        
        wait for (2 * clk_period);
        
        op_write_sim <= '1';
        
        resp_sim <= "11";
        
        wait for clk_period;
        
        op_write_sim <= '0';
        --<
        
        wait for (2 * clk_period);
        
        --> READ RESPONSE
        -- Povratna adresa routera 15 (1000 1000)
        r_addr_sim <= "10001000";
        r_vc_sim <= "10";
        
        wait for (2 * clk_period);
        
        op_read_sim <= '1';
        
        data_sim  <= X"12345678";
        resp_sim <= "10";
        
        wait for clk_period;
         
        op_read_sim <= '0';
        --<
        
        wait;
    
    end process;

end Simulation;
