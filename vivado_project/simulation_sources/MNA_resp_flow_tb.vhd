----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/06/2021 01:59:24 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: MNA_resp_flow_tb - Simulation
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
-- Revision 0.1 - 2021-05-06 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija simulacije MNA_resp_flowa
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

entity MNA_resp_flow_tb is
--  Port ( );
end MNA_resp_flow_tb;

architecture Simulation of MNA_resp_flow_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
        
    -- AXI WRITE RESPONSE CHANNEL   
    signal BREADY_sim : std_logic;
    signal BRESP_sim : std_logic_vector(1 downto 0);
    signal BVALID_sim : std_logic;
        
    -- AXI READ RESPONSE CHANNEL
    signal RREADY_sim : std_logic;
    signal RDATA_sim : std_logic_vector(31 downto 0);
    signal RRESP_sim : std_logic_vector(1 downto 0);
    signal RVALID_sim : std_logic;
        
    -- >PRIVREMENO!< BUFFER IZLAZI
    signal flit_in_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal flit_in_valid_sim : std_logic;
        
    signal full_sim : std_logic;
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: MNA_resp_flow
    
        generic map(
            flit_size => const_flit_size,
            buffer_size => const_buffer_size
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
                
            -- AXI WRITE ADDRESS CHANNEL           
            BREADY => BREADY_sim,
            BRESP => BRESP_sim,
            BVALID => BVALID_sim,
            
            -- AXI WRITE DATA CHANNEL
            RREADY => RREADY_sim,
            RDATA => RDATA_sim,
            RRESP => RRESP_sim,
            RVALID => RVALID_sim,
            
            -- AXI WRITE AUXILIARY SIGNALS
            flit_in => flit_in_sim,
            flit_in_valid => flit_in_valid_sim,
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
    
        -- inicijalizacija ulaza
        BREADY_sim <= '0';
        RREADY_sim <= '0';
        
        flit_in_sim <= (others => '0');
        flit_in_valid_sim <= '0';
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (2.1 * clk_period);
        
        flit_in_sim <= X"91100000007";
        flit_in_valid_sim <= '1';
        
        wait for clk_period;
        
        flit_in_sim <= X"51187654321";
        
        wait for clk_period;
        
        flit_in_sim <= (others => '0');
        flit_in_valid_sim <= '0';
        
        wait for (4 * clk_period);
        
        RREADY_sim <= '1';
        
        wait for clk_period;
        
        RREADY_sim <= '0';
        
        wait for clk_period;
       
        BREADY_sim <= '1';
        
        wait for (2 * clk_period);
        
        flit_in_sim <= X"D1100000004";
        flit_in_valid_sim <= '1';
        
        wait for clk_period;
        
        flit_in_sim <= (others => '0');
        flit_in_valid_sim <= '0';
        
        wait for (3 * clk_period);
        
        BREADY_sim <= '0';
        
        wait;
    
    end process;
    
end Simulation;
