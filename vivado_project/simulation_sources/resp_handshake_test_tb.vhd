----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/13/2021 01:35:01 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: resp_handshake_test_tb - Simulation
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
-- Revision 0.1 - 2021-05-13 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija simulacije resp_handshakea
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

entity resp_handshake_test_tb is
--  Port ( );
end resp_handshake_test_tb;

architecture Simulation of resp_handshake_test_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    signal BREADY_sim : std_logic;
    signal BRESP_sim : std_logic_vector(1 downto 0);
    signal BVALID_sim : std_logic;
            
    signal RREADY_sim : std_logic;
    signal RDATA_sim : std_logic_vector(31 downto 0);
    signal RRESP_sim : std_logic_vector(1 downto 0);
    signal RVALID_sim : std_logic;
            
    signal op_write_SNA_sim : std_logic;
    signal op_read_SNA_sim : std_logic;
            
    signal data_SNA_sim : std_logic_vector(31 downto 0);
    signal resp_SNA_sim : std_logic_vector(1 downto 0);
    
    signal op_write_MNA_sim : std_logic;
    signal op_read_MNA_sim : std_logic;
            
    signal data_MNA_sim : std_logic_vector(31 downto 0);
    signal resp_MNA_sim : std_logic_vector(1 downto 0);
    
    signal resp_write_sim : std_logic;
    signal resp_read_sim : std_logic;
    
    signal buffer_read_ready_sim : std_logic;
    signal buffer_write_ready_sim : std_logic;
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    MNA_resp_handshake: MNA_resp_AXI_handshake_controller
    
        port map(
            clk => clk_sim,
            rst => rst_sim, 
              
            BREADY => BREADY_sim,
            BRESP => BRESP_sim,
            BVALID => BVALID_sim,
            
            RREADY => RREADY_sim,
            RDATA => RDATA_sim,
            RRESP => RRESP_sim,
            RVALID => RVALID_sim,
            
            op_write => op_write_MNA_sim,
            op_read => op_read_MNA_sim,
            
            data => data_MNA_sim,
            resp => resp_MNA_sim
        );
        
    -- Komponenta koja se testira (Unit Under Test)
    SNA_resp_handshake: SNA_resp_AXI_handshake_controller
    
        port map(
            clk => clk_sim,
            rst => rst_sim,
            
            BREADY => BREADY_sim,
            BRESP => BRESP_sim,
            BVALID => BVALID_sim,
            
            RREADY => RREADY_sim,
            RDATA => RDATA_sim,
            RRESP => RRESP_sim,
            RVALID => RVALID_sim,
            
            resp_write => resp_write_sim,
            resp_read => resp_read_sim,
            
            op_write => op_write_SNA_sim,
            op_read => op_read_SNA_sim,
            
            buffer_read_ready => buffer_read_ready_sim,
            buffer_write_ready => buffer_write_ready_sim,
            
            data => data_SNA_sim,
            resp => resp_SNA_sim
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
    
        op_write_MNA_sim <= '0';
        op_read_MNA_sim <= '0';
        
        data_MNA_sim <= (others => '0');
        resp_MNA_sim <= (others => '0');
        
        resp_write_sim <= '0';
        resp_read_sim <= '0';
        
        buffer_read_ready_sim <= '0';
        buffer_write_ready_sim <= '0';
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (4.1 * clk_period);
        
        buffer_read_ready_sim <= '1';
        buffer_write_ready_sim <= '1';
        
        wait for (4 * clk_period);
        
        op_write_MNA_sim <= '1';
        
        data_MNA_sim <= (others => '0');
        resp_MNA_sim <= "01";
        
        wait for clk_period;
        
        op_write_MNA_sim <= '0';    
            
        resp_write_sim <= '1';
        
        wait for clk_period;
        
        resp_write_sim <= '0';
        
        wait for (4 * clk_period);
        
        op_read_MNA_sim <= '1';
        
        data_MNA_sim <= X"12345678";
        resp_MNA_sim <= "10";
        
        wait for clk_period;
        
        op_read_MNA_sim <= '0';
        
        resp_read_sim <= '1';
        
        wait for clk_period;
        
        resp_read_sim <= '0';
    
        wait;
    
    end process;


end Simulation;
