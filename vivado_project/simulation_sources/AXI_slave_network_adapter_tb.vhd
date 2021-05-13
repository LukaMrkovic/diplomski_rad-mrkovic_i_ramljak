----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 13.05.2021 11:34:23
-- Design Name: AXI_Network_Adapter
-- Module Name: AXI_slave_network_adapter_tb - Simulation
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
-- Additional Comments: Prva verzija simulacije AXI_slave_network_adaptera
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

entity AXI_slave_network_adapter_tb is
--  Port ( );
end AXI_slave_network_adapter_tb;

architecture Simulation of AXI_slave_network_adapter_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal int_clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    -- AXI WRITE ADDRESS CHANNEL 
    signal AWADDR_sim : std_logic_vector(31 downto 0);
    signal AWPROT_sim : std_logic_vector(2 downto 0);
    signal AWVALID_sim : std_logic;
    signal AWREADY_sim : std_logic;

    -- AXI WRITE DATA CHANNEL
    signal WDATA_sim : std_logic_vector(31 downto 0);
    signal WSTRB_sim : std_logic_vector(3 downto 0);
    signal WVALID_sim : std_logic;
    signal WREADY_sim : std_logic;

    -- AXI READ ADDRESS CHANNEL
    signal ARADDR_sim : std_logic_vector(31 downto 0);
    signal ARPROT_sim : std_logic_vector(2 downto 0);
    signal ARVALID_sim : std_logic;
    signal ARREADY_sim : std_logic;

    -- AXI WRITE RESPONSE CHANNEL
    signal BRESP_sim : std_logic_vector(1 downto 0);
    signal BVALID_sim : std_logic;
    signal BREADY_sim : std_logic;

    -- AXI READ RESPONSE CHANNEL
    signal RDATA_sim : std_logic_vector(31 downto 0);
    signal RRESP_sim : std_logic_vector(1 downto 0);
    signal RVALID_sim : std_logic;
    signal RREADY_sim : std_logic;

    -- NOC INTERFACE - FLIT AXI > NOC
    signal AXI_noc_data_sim : std_logic_vector(const_flit_size - 1 downto 0);        
    signal AXI_noc_data_valid_sim : std_logic;

    signal noc_AXI_vc_busy_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal noc_AXI_vc_credits_sim : std_logic_vector(const_vc_num - 1 downto 0);

    -- NOC INTERFACE - FLIT NOC > AXI
    signal noc_AXI_data_sim : std_logic_vector(const_flit_size - 1 downto 0);        
    signal noc_AXI_data_valid_sim : std_logic;

    signal AXI_noc_vc_busy_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal AXI_noc_vc_credits_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: AXI_slave_network_adapter
    
        generic map(
            vc_num => const_vc_num,
            address_size => const_address_size,
            payload_size => const_payload_size,
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
            AWADDR => AWADDR_sim,
            AWPROT => AWPROT_sim,
            AWVALID => AWVALID_sim,
            AWREADY => AWREADY_sim,
            
            -- AXI WRITE DATA CHANNEL
            WDATA => WDATA_sim,
            WSTRB => WSTRB_sim,
            WVALID => WVALID_sim,
            WREADY => WREADY_sim,
            
            -- AXI READ ADDRESS CHANNEL
            ARADDR => ARADDR_sim,
            ARPROT => ARPROT_sim,
            ARVALID => ARVALID_sim,
            ARREADY => ARREADY_sim,
            
            -- AXI WRITE RESPONSE CHANNEL
            BRESP => BRESP_sim,
            BVALID => BVALID_sim,
            BREADY => BREADY_sim,
            
            -- AXI READ RESPONSE CHANNEL
            RDATA => RDATA_sim,
            RRESP => RRESP_sim,
            RVALID => RVALID_sim,
            RREADY => RREADY_sim,
            
            -- NOC INTERFACE - FLIT AXI > NOC
            AXI_noc_data => AXI_noc_data_sim,
            AXI_noc_data_valid => AXI_noc_data_valid_sim,
            
            noc_AXI_vc_busy => noc_AXI_vc_busy_sim,
            noc_AXI_vc_credits => noc_AXI_vc_credits_sim,
            
            -- NOC INTERFACE - FLIT NOC > AXI
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
    
        -- AXI WRITE ADDRESS CHANNEL
        AWREADY_sim <= '0';
        
        -- AXI WRITE DATA CHANNEL
        WREADY_sim <= '0';
        
        -- AXI READ ADDRESS CHANNEL
        ARREADY_sim <= '0';
    
        -- AXI WRITE RESPONSE CHANNEL
        BRESP_sim <= (others => '0');
        BVALID_sim <= '0';
        
        -- AXI READ RESPONSE CHANNEL
        RDATA_sim <= (others => '0');
        RRESP_sim <= (others => '0');
        RVALID_sim <= '0';
        
        -- NOC INTERFACE - FLIT AXI > NOC
        noc_AXI_vc_busy_sim <= (others => '0');
        noc_AXI_vc_credits_sim <= (others => '0');
        
        -- NOC INTERFACE - FLIT NOC > AXI
        noc_AXI_data_sim <= (others => '0');
        noc_AXI_data_valid_sim <= '0';
    
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (4.1 * clk_period);
        
        -- > WRITE REQ
        noc_AXI_data_sim <= X"914110000fa";
        noc_AXI_data_valid_sim <= '1';
        
        wait for clk_period;
        
        noc_AXI_data_sim <= (others => '0');
        noc_AXI_data_valid_sim <= '0';
        
        wait for (3 * clk_period);
        
        noc_AXI_data_sim <= X"11487654321";
        noc_AXI_data_valid_sim <= '1';
        
        wait for clk_period;
        
        noc_AXI_data_sim <= (others => '0');
        noc_AXI_data_valid_sim <= '0';
        
        wait for (3 * clk_period);
        
        noc_AXI_data_sim <= X"51412344321";
        noc_AXI_data_valid_sim <= '1';
        
        wait for clk_period;
        
        noc_AXI_data_sim <= (others => '0');
        noc_AXI_data_valid_sim <= '0';
        
        wait for (5 * clk_period);
        
        AWREADY_sim <= '1';
        WREADY_sim <= '1';
        
        wait for clk_period;
        
        AWREADY_sim <= '0';
        WREADY_sim <= '0';
        -- < WRITE REQ
        
        -- > WRITE RESP
        BRESP_sim <= "11";
        BVALID_sim <= '1';
        
        wait for clk_period;
        
        BVALID_sim <= '0';
        
        wait for (12 * clk_period);
        
        noc_AXI_vc_credits_sim <= "01";
        
        wait for clk_period;
        
        noc_AXI_vc_credits_sim <= (others => '0');
        -- < WRITE RESP
        
        -- > READ REQ
        wait for (3 * clk_period);
        
        noc_AXI_data_sim <= X"A4822000005";
        noc_AXI_data_valid_sim <= '1';
        
        wait for clk_period;
        
        noc_AXI_data_sim <= (others => '0');
        noc_AXI_data_valid_sim <= '0';
        
        wait for (3 * clk_period);
        
        noc_AXI_data_sim <= X"648E1234567";
        noc_AXI_data_valid_sim <= '1';
        
        wait for clk_period;
        
        noc_AXI_data_sim <= (others => '0');
        noc_AXI_data_valid_sim <= '0';
        
        wait for (5 * clk_period);
        
        ARREADY_sim <= '1';
        
        wait for clk_period;
        
        ARREADY_sim <= '0';
        -- < READ REQ
        
        -- > READ RESP
        RDATA_sim <= X"12345678";
        RRESP_sim <= "01";
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
        -- < READ RESP
    
        wait;
    
    end process;

end Simulation;
