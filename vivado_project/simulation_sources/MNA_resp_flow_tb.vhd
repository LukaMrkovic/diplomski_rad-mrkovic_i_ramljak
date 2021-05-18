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
    signal int_clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    signal BRESP_sim : std_logic_vector(1 downto 0);
    signal BVALID_sim : std_logic;
    signal BREADY_sim : std_logic;
    
    signal RDATA_sim : std_logic_vector(31 downto 0);
    signal RRESP_sim : std_logic_vector(1 downto 0);
    signal RVALID_sim : std_logic;
    signal RREADY_sim : std_logic;
    
    signal noc_AXI_data_sim : std_logic_vector(const_flit_size - 1 downto 0);        
    signal noc_AXI_data_valid_sim : std_logic;
        
    signal AXI_noc_vc_busy_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal AXI_noc_vc_credits_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: MNA_resp_flow
    
        generic map(
            vc_num => const_vc_num,
            flit_size => const_flit_size,
            buffer_size => const_buffer_size,
            clock_divider => const_clock_divider
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
            
            -- AXI WRITE ADDRESS CHANNEL
            BRESP => BRESP_sim,
            BVALID => BVALID_sim,
            BREADY => BREADY_sim,
            
            -- AXI WRITE DATA CHANNEL
            RDATA => RDATA_sim,
            RRESP => RRESP_sim,
            RVALID => RVALID_sim,
            RREADY => RREADY_sim,
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data => noc_AXI_data_sim,   
            noc_AXI_data_valid => noc_AXI_data_valid_sim,
            
            AXI_noc_vc_busy => AXI_noc_vc_busy_sim,
            AXI_noc_vc_credits => AXI_noc_vc_credits_sim
        );
        
    -- clk proces
    clk_process : process
    
    begin
    
        clk_sim <= '1';
        wait for clk_period / 2;
        clk_sim <= '0';
        wait for clk_period / 2;
        
    end process;
    
    -- simulacija sporog takta
    int_clk_process : process (clk_sim) is 
        
        variable clk_counter : integer;
        
    begin
    
        if rising_edge(clk_sim) then
            if rst_sim = '0' then
                
                -- POSTAVI BROJILO NA 0
                clk_counter := const_clock_divider - 1;
                
                -- POSTAVI INTERNI TAKT NA 0
                int_clk_sim <= '0';
            
            else
            
                -- POVECAJ BROJILO ZA 1
                clk_counter := (clk_counter + 1) mod const_clock_divider;
                
                -- PROMIJENI FAZU INTERNOG TAKTA
                if (clk_counter = 0) then
                    int_clk_sim <= not int_clk_sim;
                end if;  
                        
            end if;
        end if;
        
    end process;
    
    -- stimulirajuci proces
    stim_process : process
    
    begin
    
        -- > Inicijalne postavke ulaznih signala
        BREADY_sim <= '0';
        
        RREADY_sim <= '0';
        
        noc_AXI_data_sim <= (others => '0');
        noc_AXI_data_valid_sim <= '0';
        -- < Inicijalne postavke ulaznih signala
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (4.1 * clk_period);
        
        noc_AXI_data_sim <= X"A1100000007";
        noc_AXI_data_valid_sim <= '1';
        
        wait for clk_period;
        
        noc_AXI_data_sim <= (others => '0');
        noc_AXI_data_valid_sim <= '0';
        
        wait for (3 * clk_period);
        
        noc_AXI_data_sim <= X"61187654321";
        noc_AXI_data_valid_sim <= '1';
        
        wait for clk_period;
        
        noc_AXI_data_sim <= (others => '0');
        noc_AXI_data_valid_sim <= '0';
        
        wait for (5 * clk_period);
        
        RREADY_sim <= '1';
        
        wait for clk_period;
        
        RREADY_sim <= '0';
        
        wait for (3 * clk_period);
       
        BREADY_sim <= '1';
        
        wait for (2 * clk_period);
        
        noc_AXI_data_sim <= X"D1100000004";
        noc_AXI_data_valid_sim <= '1';
        
        wait for clk_period;
        
        noc_AXI_data_sim <= (others => '0');
        noc_AXI_data_valid_sim <= '0';
        
        wait for (3 * clk_period);
        
        BREADY_sim <= '0';
        
        wait;
    
    end process;
    
end Simulation;