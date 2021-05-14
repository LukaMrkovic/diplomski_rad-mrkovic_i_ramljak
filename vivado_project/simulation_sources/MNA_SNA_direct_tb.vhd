----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/14/2021 11:45:20 AM
-- Design Name: AXI_Network_Adapter
-- Module Name: MNA_SNA_direct_tb - Simulation
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
-- Revision 0.1 - 2021-05-14 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija simulacije MNA_SNA_direct
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

entity MNA_SNA_direct_tb is
--  Port ( );
end MNA_SNA_direct_tb;

architecture Simulation of MNA_SNA_direct_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal int_clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    -- AXI WRITE ADDRESS CHANNEL           
    signal AWADDR_MNA_sim : std_logic_vector(31 downto 0);
    signal AWVALID_MNA_sim : std_logic;
    signal AWREADY_MNA_sim : std_logic;
    
    -- AXI WRITE DATA CHANNEL
    signal WDATA_MNA_sim : std_logic_vector(31 downto 0);
    signal WVALID_MNA_sim : std_logic;
    signal WREADY_MNA_sim : std_logic;
    
    -- AXI WRITE AUXILIARY SIGNALS
    signal AWPROT_MNA_sim : std_logic_vector(2 downto 0);
    signal WSTRB_MNA_sim : std_logic_vector(3 downto 0);
    
    -- AXI READ ADDRESS CHANNEL
    signal ARADDR_MNA_sim : std_logic_vector(31 downto 0);
    signal ARVALID_MNA_sim : std_logic;
    signal ARREADY_MNA_sim : std_logic;
            
    -- AXI READ AUXILIARY SIGNALS
    signal ARPROT_MNA_sim : std_logic_vector(2 downto 0);
    
    -- AXI WRITE RESPONSE CHANNEL   
    signal BREADY_MNA_sim : std_logic;
    signal BRESP_MNA_sim : std_logic_vector(1 downto 0);
    signal BVALID_MNA_sim : std_logic;
        
    -- AXI READ RESPONSE CHANNEL
    signal RREADY_MNA_sim : std_logic;
    signal RDATA_MNA_sim : std_logic_vector(31 downto 0);
    signal RRESP_MNA_sim : std_logic_vector(1 downto 0);
    signal RVALID_MNA_sim : std_logic;
    
    -- AXI WRITE ADDRESS CHANNEL 
    signal AWADDR_SNA_sim : std_logic_vector(31 downto 0);
    signal AWPROT_SNA_sim : std_logic_vector(2 downto 0);
    signal AWVALID_SNA_sim : std_logic;
    signal AWREADY_SNA_sim : std_logic;

    -- AXI WRITE DATA CHANNEL
    signal WDATA_SNA_sim : std_logic_vector(31 downto 0);
    signal WSTRB_SNA_sim : std_logic_vector(3 downto 0);
    signal WVALID_SNA_sim : std_logic;
    signal WREADY_SNA_sim : std_logic;

    -- AXI READ ADDRESS CHANNEL
    signal ARADDR_SNA_sim : std_logic_vector(31 downto 0);
    signal ARPROT_SNA_sim : std_logic_vector(2 downto 0);
    signal ARVALID_SNA_sim : std_logic;
    signal ARREADY_SNA_sim : std_logic;

    -- AXI WRITE RESPONSE CHANNEL
    signal BRESP_SNA_sim : std_logic_vector(1 downto 0);
    signal BVALID_SNA_sim : std_logic;
    signal BREADY_SNA_sim : std_logic;

    -- AXI READ RESPONSE CHANNEL
    signal RDATA_SNA_sim : std_logic_vector(31 downto 0);
    signal RRESP_SNA_sim : std_logic_vector(1 downto 0);
    signal RVALID_SNA_sim : std_logic;
    signal RREADY_SNA_sim : std_logic;
    
    -- NOC INTERFACE - REQ FLOW
    signal AXI_noc_data_REQ_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal AXI_noc_data_valid_REQ_sim : std_logic;
           
    signal noc_AXI_vc_busy_REQ_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal noc_AXI_vc_credits_REQ_sim : std_logic_vector(const_vc_num - 1 downto 0);

    
    -- NOC INTERFACE - RESP FLOW 
    signal noc_AXI_data_RESP_sim : std_logic_vector(const_flit_size - 1 downto 0);        
    signal noc_AXI_data_valid_RESP_sim : std_logic;
        
    signal AXI_noc_vc_busy_RESP_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal AXI_noc_vc_credits_RESP_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- Period takta
    constant clk_period : time := 200ns;
    
begin

    -- Komponenta MNA_req_flow
    AXI_MNA: AXI_master_network_adapter
    
        generic map ( 
        vc_num => const_vc_num,
        mesh_size_x => const_mesh_size_x,
        mesh_size_y => const_mesh_size_y,
        address_size => const_address_size,
        payload_size => const_payload_size,
        flit_size => const_flit_size,
        node_address_size => const_node_address_size,
        buffer_size => const_buffer_size,
        write_threshold => const_MNA_write_threshold,
        read_threshold => const_MNA_read_threshold,
        clock_divider => const_clock_divider,
        
        injection_vc => const_default_injection_vc,
        local_address_x => const_default_address_x,
        local_address_y => const_default_address_y
    )
    
    port map (
        clk => clk_sim,
        rst => rst_sim,
            
        -- AXI WRITE ADDRESS CHANNEL           
        AWADDR => AWADDR_MNA_sim,
        AWVALID => AWVALID_MNA_sim,
        AWREADY => AWREADY_MNA_sim,
        
        -- AXI WRITE DATA CHANNEL
        WDATA => WDATA_MNA_sim,
        WVALID => WVALID_MNA_sim,
        WREADY => WREADY_MNA_sim,
        
        -- AXI WRITE AUXILIARY SIGNALS
        AWPROT => AWPROT_MNA_sim,
        WSTRB => WSTRB_MNA_sim,
        
        -- AXI READ ADDRESS CHANNEL
        ARADDR => ARADDR_MNA_sim,
        ARVALID => ARVALID_MNA_sim, 
        ARREADY => ARREADY_MNA_sim,
        
        -- AXI READ AUXILIARY SIGNALS
        ARPROT => ARPROT_MNA_sim,
    
        -- AXI WRITE RESPONSE CHANNEL   
        BREADY => BREADY_MNA_sim,
        BRESP => BRESP_MNA_sim,
        BVALID => BVALID_MNA_sim,
        
        -- AXI READ RESPONSE CHANNEL
        RREADY => RREADY_MNA_sim,
        RDATA => RDATA_MNA_sim,
        RRESP => RRESP_MNA_sim,
        RVALID => RVALID_MNA_sim,
        
        -- NOC INTERFACE - FLIT AXI > NOC
        AXI_noc_data => AXI_noc_data_REQ_sim, 
        AXI_noc_data_valid => AXI_noc_data_valid_REQ_sim,
                
        noc_AXI_vc_busy => noc_AXI_vc_busy_REQ_sim,
        noc_AXI_vc_credits => noc_AXI_vc_credits_REQ_sim,
        
        -- NOC INTERFACE - FLIT NOC > AXI 
        noc_AXI_data => noc_AXI_data_RESP_sim,     
        noc_AXI_data_valid => noc_AXI_data_valid_RESP_sim,
        
        AXI_noc_vc_busy => AXI_noc_vc_busy_RESP_sim,
        AXI_noc_vc_credits => AXI_noc_vc_credits_RESP_sim
    );
    
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
            AWADDR => AWADDR_SNA_sim,
            AWPROT => AWPROT_SNA_sim,
            AWVALID => AWVALID_SNA_sim,
            AWREADY => AWREADY_SNA_sim,
            
            -- AXI WRITE DATA CHANNEL
            WDATA => WDATA_SNA_sim,
            WSTRB => WSTRB_SNA_sim,
            WVALID => WVALID_SNA_sim,
            WREADY => WREADY_SNA_sim,
            
            -- AXI READ ADDRESS CHANNEL
            ARADDR => ARADDR_SNA_sim,
            ARPROT => ARPROT_SNA_sim,
            ARVALID => ARVALID_SNA_sim,
            ARREADY => ARREADY_SNA_sim,
            
            -- AXI WRITE RESPONSE CHANNEL
            BRESP => BRESP_SNA_sim,
            BVALID => BVALID_SNA_sim,
            BREADY => BREADY_SNA_sim,
            
            -- AXI READ RESPONSE CHANNEL
            RDATA => RDATA_SNA_sim,
            RRESP => RRESP_SNA_sim,
            RVALID => RVALID_SNA_sim,
            RREADY => RREADY_SNA_sim,
            
            -- NOC INTERFACE - FLIT AXI > NOC
            AXI_noc_data => noc_AXI_data_RESP_sim,
            AXI_noc_data_valid => noc_AXI_data_valid_RESP_sim,
            
            noc_AXI_vc_busy => AXI_noc_vc_busy_RESP_sim,
            noc_AXI_vc_credits => AXI_noc_vc_credits_RESP_sim,
            
            -- NOC INTERFACE - FLIT NOC > AXI
            noc_AXI_data => AXI_noc_data_REQ_sim,
            noc_AXI_data_valid => AXI_noc_data_valid_REQ_sim,
            
            AXI_noc_vc_busy => noc_AXI_vc_busy_REQ_sim,
            AXI_noc_vc_credits => noc_AXI_vc_credits_REQ_sim
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
    
        -- master_network_adapter
        -- inicijalizacija ulaza
        AWADDR_MNA_sim <= (others => '0');
        AWVALID_MNA_sim <= '0';
        
        WDATA_MNA_sim <= (others => '0');
        WVALID_MNA_sim <= '0';
        
        AWPROT_MNA_sim <= (others => '0');
        WSTRB_MNA_sim <= (others => '0');
        
        ARADDR_MNA_sim <= (others => '0');
        ARVALID_MNA_sim <= '0';
        
        ARPROT_MNA_sim <= (others => '0');
        
        -- inicijalizacija ulaza
        BREADY_MNA_sim <= '0';
        RREADY_MNA_sim <= '0';
        
        -- slave_network_adapter
        -- AXI WRITE ADDRESS CHANNEL
        AWREADY_SNA_sim <= '0';
        
        -- AXI WRITE DATA CHANNEL
        WREADY_SNA_sim <= '0';
        
        -- AXI READ ADDRESS CHANNEL
        ARREADY_SNA_sim <= '0';
    
        -- AXI WRITE RESPONSE CHANNEL
        BRESP_SNA_sim <= (others => '0');
        BVALID_SNA_sim <= '0';
        
        -- AXI READ RESPONSE CHANNEL
        RDATA_SNA_sim <= (others => '0');
        RRESP_SNA_sim <= (others => '0');
        RVALID_SNA_sim <= '0';
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (4.1 * clk_period);
        
        -- > WRITE
        AWADDR_MNA_sim <= X"87654321";
        AWVALID_MNA_sim <= '1';
        
        WDATA_MNA_sim <= X"12344321";
        WVALID_MNA_sim <= '1';
        
        AWPROT_MNA_sim <= "101";
        WSTRB_MNA_sim <= "1111";
        
        wait for (2 * clk_period);
        
        AWADDR_MNA_sim <= (others => '0');
        AWVALID_MNA_sim <= '0';
        
        WDATA_MNA_sim <= (others => '0');
        WVALID_MNA_sim <= '0';
        
        AWPROT_MNA_sim <= (others => '0');
        WSTRB_MNA_sim <= (others => '0');
        
        wait for (16 * clk_period);
        
        AWREADY_SNA_sim <= '1';
        WREADY_SNA_sim <= '1';
        
        wait for clk_period;
        
        AWREADY_SNA_sim <= '0';
        WREADY_SNA_sim <= '0';
        
        -- > WRITE RESP
        BRESP_SNA_sim <= "11";
        BVALID_SNA_sim <= '1';
        
        wait for clk_period;
        
        BVALID_SNA_sim <= '0';
        
        wait for (8 * clk_period);
        
        BREADY_MNA_sim <= '1';
        
        wait for clk_period;
        
        BREADY_MNA_sim <= '0';
        -- <
        
        wait for (5 * clk_period);
        
        -- > READ REQ
        ARADDR_MNA_sim <= X"E1234567";
        ARVALID_MNA_sim <= '1';
        
        ARPROT_MNA_sim <= "010";
        
        wait for (2 * clk_period);
        
        ARADDR_MNA_sim <= (others => '0');
        ARVALID_MNA_sim <= '0';
        
        ARPROT_MNA_sim <= (others => '0');
        
        wait for (13 * clk_period);
        
        ARREADY_SNA_sim <= '1';
        
        wait for clk_period;
        
        ARREADY_SNA_sim <= '0';
        -- < READ REQ
        
        -- > READ RESP
        RDATA_SNA_sim <= X"12345678";
        RRESP_SNA_sim <= "01";
        RVALID_SNA_sim <= '1';
        
        wait for clk_period;
        
        RVALID_SNA_sim <= '0';
        
        wait for (14 * clk_period);
        
        RREADY_MNA_sim <= '1';
        
        wait for clk_period;
        
        RREADY_MNA_sim <= '0';
        
        wait;
    
    end process;


end Simulation;
