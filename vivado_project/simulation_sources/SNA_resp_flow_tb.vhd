----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/12/2021 01:13:16 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: SNA_resp_flow_tb - Simulation
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
-- Revision 0.1 - 2021-05-12 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija simulacije SNA_resp_flowa 
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

entity SNA_resp_flow_tb is
--  Port ( );
end SNA_resp_flow_tb;

architecture Simulation of SNA_resp_flow_tb is

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
    
    signal AXI_noc_data_sim : std_logic_vector(const_flit_size - 1 downto 0);        
    signal AXI_noc_data_valid_sim : std_logic;
    
    signal noc_AXI_vc_busy_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal noc_AXI_vc_credits_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal buffer_write_ready_sim : std_logic;
    signal buffer_read_ready_sim : std_logic;
    
    signal resp_write_sim : std_logic;
    signal resp_read_sim : std_logic;
    
    signal r_addr_sim : std_logic_vector(const_address_size - 1 downto 0);
    signal r_vc_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal t_end_sim : std_logic;
    
    -- Period takta
    constant clk_period : time := 200ns;
    
begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: SNA_resp_flow
    
        generic map(
            vc_num => const_vc_num,
            address_size => const_address_size,
            flit_size => const_flit_size,
            buffer_size => const_buffer_size,
            clock_divider => const_clock_divider,
            
            write_threshold => const_SNA_write_threshold,
            read_threshold => const_SNA_read_threshold
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
            
            -- AXI WRITE ADDRESS CHANNEL           
            BRESP => BRESP_sim,
            BVALID => BVALID_sim,
            BREADY => BREADY_sim,
            
            -- AXI READ ADDRESS CHANNEL
            RDATA => RDATA_sim,
            RRESP => RRESP_sim,
            RVALID => RVALID_sim,
            RREADY => RREADY_sim,
            
            -- NOC INTERFACE - FLIT AXI -> NOC
            AXI_noc_data => AXI_noc_data_sim,
            AXI_noc_data_valid => AXI_noc_data_valid_sim,
                    
            noc_AXI_vc_busy => noc_AXI_vc_busy_sim,
            noc_AXI_vc_credits => noc_AXI_vc_credits_sim,
            
            -- req_flow (SNA_req_AXI_handshake_controller)
            buffer_write_ready => buffer_write_ready_sim,
            buffer_read_ready => buffer_read_ready_sim,
            
            -- req_flow (SNA_req_buffer_controller)
            resp_write => resp_write_sim,
            resp_read => resp_read_sim,
            
            r_addr => r_addr_sim,
            r_vc => r_vc_sim,
            
            -- t_monitor
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
        BRESP_sim <= (others => '0');
        BVALID_sim <= '0';
        
        RDATA_sim <= (others => '0');
        RRESP_sim <= (others => '0');
        RVALID_sim <= '0';
        
        noc_AXI_vc_busy_sim <= (others => '0');
        noc_AXI_vc_credits_sim <= (others => '0');
        
        resp_write_sim <= '0';
        resp_read_sim <= '0';
        
        r_addr_sim <= (others => '0');
        r_vc_sim <= (others => '0');
        -- < Inicijalne postavke ulaznih signala
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (4.1 * clk_period);
        
        resp_read_sim <= '1';
        
        r_addr_sim <= X"24";
        r_vc_sim <= "10";
        
        wait for clk_period;
        
        resp_read_sim <= '0';
        
        wait for (2 * clk_period);
        
        RDATA_sim <= X"12345678";
        RRESP_sim <= "11";
        RVALID_sim <= '1';
        
        wait for clk_period;
        
        RVALID_sim <= '0';
        
        wait for (5 * clk_period);
        
        noc_AXI_vc_busy_sim <= "10";
        
        wait for (4 * clk_period);
        
        noc_AXI_vc_busy_sim <= (others => '0');
        
        wait for (3 * clk_period);
        
        noc_AXI_vc_credits_sim <= "10";
        
        wait for clk_period;
        
        noc_AXI_vc_credits_sim <= (others => '0');
        
        wait for (3 * clk_period);
        
        noc_AXI_vc_credits_sim <= "10";
        
        wait for clk_period;
        
        noc_AXI_vc_credits_sim <= (others => '0');
        
        wait for (5 * clk_period);
        
        resp_write_sim <= '1';
        
        r_addr_sim <= X"18";
        r_vc_sim <= "01";
        
        wait for clk_period;
        
        resp_write_sim <= '0';
        
        wait for (2 * clk_period);
        
        BRESP_sim <= "01";
        BVALID_sim <= '1';
        
        wait for clk_period;
        
        BVALID_sim <= '0';
        
        wait for (14 * clk_period);
        
        noc_AXI_vc_credits_sim <= "01";
        
        wait for clk_period;
        
        noc_AXI_vc_credits_sim <= (others => '0');        
    
        wait;
    
    end process;

end Simulation;