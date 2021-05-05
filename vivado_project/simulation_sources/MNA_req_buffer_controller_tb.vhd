----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/05/2021 01:04:00 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: MNA_req_buffer_controller_tb - Simulation
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
-- Additional Comments: Prva verzija simulacije MNA_req_buffer_controllera
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

entity MNA_req_buffer_controller_tb is
--  Port ( );
end MNA_req_buffer_controller_tb;

architecture Simulation of MNA_req_buffer_controller_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    signal flit_in_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal flit_in_valid_sim : std_logic;
    
    signal op_write_sim : std_logic;
    signal op_read_sim : std_logic;
    
    signal addr_sim : std_logic_vector(31 downto 0);
    signal data_sim : std_logic_vector(31 downto 0);
    signal prot_sim : std_logic_vector(2 downto 0);
    signal strb_sim : std_logic_vector(3 downto 0);
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: MNA_req_buffer_controller
    
        generic map(
            vc_num => const_vc_num,
            mesh_size_x => const_mesh_size_x,
            mesh_size_y => const_mesh_size_y,
            address_size => const_address_size,
            payload_size => const_payload_size,
            flit_size => const_flit_size,
            node_address_size => const_node_address_size,
            injection_vc => 1,
            local_address_x => "0100",
            local_address_y => "0010"
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim, 
           
            flit_in => flit_in_sim,
            flit_in_valid => flit_in_valid_sim,
            
            op_write => op_write_sim,
            op_read => op_read_sim,
            
            addr => addr_sim,
            data => data_sim,
            prot => prot_sim,
            strb => strb_sim
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
        
        addr_sim <= (others => '0');
        data_sim <= (others => '0');
        prot_sim <= (others => '0');
        strb_sim <= (others => '0');
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        rst_sim <= '1';
        
        wait for (2.1 * clk_period);
        
        op_write_sim <= '1';
        
        addr_sim <= X"61234578";
        data_sim <= X"11111111";
        prot_sim <= "101";
        strb_sim <= "1111";
        
        wait for clk_period;
        
        op_write_sim <= '0';
        
        wait for (6 * clk_period);
        
        op_read_sim <= '1';
        
        addr_sim <= X"D2222222";
        data_sim <= (others => '0');
        prot_sim <= "010";
        strb_sim <= (others => '0');
        
        wait for clk_period;
        
        op_read_sim <= '0';
        
        wait;
    
    end process;


end Simulation;
