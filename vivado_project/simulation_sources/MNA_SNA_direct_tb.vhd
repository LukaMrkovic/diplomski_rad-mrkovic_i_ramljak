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
    
    -- > MNA
        -- AXI WRITE ADDRESS CHANNEL
        signal MNA_AWADDR : std_logic_vector(31 downto 0);
        signal MNA_AWPROT : std_logic_vector(2 downto 0);
        signal MNA_AWVALID : std_logic;
        signal MNA_AWREADY : std_logic;
        
        -- AXI WRITE DATA CHANNEL
        signal MNA_WDATA : std_logic_vector(31 downto 0);
        signal MNA_WSTRB : std_logic_vector(3 downto 0);
        signal MNA_WVALID : std_logic;
        signal MNA_WREADY : std_logic;
        
        -- AXI READ ADDRESS CHANNEL
        signal MNA_ARADDR : std_logic_vector(31 downto 0);
        signal MNA_ARPROT : std_logic_vector(2 downto 0);
        signal MNA_ARVALID : std_logic;
        signal MNA_ARREADY : std_logic;
        
        -- AXI WRITE RESPONSE CHANNEL
        signal MNA_BRESP : std_logic_vector(1 downto 0);
        signal MNA_BVALID : std_logic;
        signal MNA_BREADY : std_logic;
            
        -- AXI READ RESPONSE CHANNEL
        signal MNA_RDATA : std_logic_vector(31 downto 0);
        signal MNA_RRESP : std_logic_vector(1 downto 0);
        signal MNA_RVALID : std_logic;
        signal MNA_RREADY : std_logic;
    -- < MNA
    
    -- > SNA
        -- AXI WRITE ADDRESS CHANNEL
        signal SNA_AWADDR : std_logic_vector(31 downto 0);
        signal SNA_AWPROT : std_logic_vector(2 downto 0);
        signal SNA_AWVALID : std_logic;
        signal SNA_AWREADY : std_logic;
        
        -- AXI WRITE DATA CHANNEL
        signal SNA_WDATA : std_logic_vector(31 downto 0);
        signal SNA_WSTRB : std_logic_vector(3 downto 0);
        signal SNA_WVALID : std_logic;
        signal SNA_WREADY : std_logic;
        
        -- AXI READ ADDRESS CHANNEL
        signal SNA_ARADDR : std_logic_vector(31 downto 0);
        signal SNA_ARPROT : std_logic_vector(2 downto 0);
        signal SNA_ARVALID : std_logic;
        signal SNA_ARREADY : std_logic;
        
        -- AXI WRITE RESPONSE CHANNEL
        signal SNA_BRESP : std_logic_vector(1 downto 0);
        signal SNA_BVALID : std_logic;
        signal SNA_BREADY : std_logic;
            
        -- AXI READ RESPONSE CHANNEL
        signal SNA_RDATA : std_logic_vector(31 downto 0);
        signal SNA_RRESP : std_logic_vector(1 downto 0);
        signal SNA_RVALID : std_logic;
        signal SNA_RREADY : std_logic;
    -- < SNA
    
    -- NOC INTERFACE - FLIT MNA -> SNA
    signal MNA_to_SNA_data: std_logic_vector(const_flit_size - 1 downto 0);
    signal MNA_to_SNA_data_valid : std_logic;
    
    signal SNA_to_MNA_vc_busy : std_logic_vector(const_vc_num - 1 downto 0);
    signal SNA_to_MNA_vc_credits : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- NOC INTERFACE - FLIT MNA <- SNA
    signal SNA_to_MNA_data : std_logic_vector(const_flit_size - 1 downto 0);        
    signal SNA_to_MNA_data_valid : std_logic;
    
    signal MNA_to_SNA_vc_busy : std_logic_vector(const_vc_num - 1 downto 0);
    signal MNA_to_SNA_vc_credits : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- Period takta
    constant clk_period : time := 200ns;
    
begin

    -- komponenta AXI_master_network_adapter
    uut_MNA: AXI_master_network_adapter
    
        generic map ( 
            vc_num => const_vc_num,
            mesh_size_x => const_mesh_size_x,
            mesh_size_y => const_mesh_size_y,
            address_size => const_address_size,
            payload_size => const_payload_size,
            flit_size => const_flit_size,
            buffer_size => const_buffer_size,
            local_address_x => "0001",
            local_address_y => "0001",
            clock_divider => const_clock_divider,
            
            write_threshold => const_MNA_write_threshold,
            read_threshold => const_MNA_read_threshold,
            injection_vc => 1,
            node_address_size => const_node_address_size
        )
        
        port map (
            clk => clk_sim,
            rst => rst_sim,
                
            -- AXI WRITE ADDRESS CHANNEL           
            AWADDR => MNA_AWADDR,
            AWPROT => MNA_AWPROT,
            AWVALID => MNA_AWVALID,
            AWREADY => MNA_AWREADY,
            
            -- AXI WRITE DATA CHANNEL
            WDATA => MNA_WDATA,
            WSTRB => MNA_WSTRB,
            WVALID => MNA_WVALID,
            WREADY => MNA_WREADY,
            
            -- AXI READ ADDRESS CHANNEL
            ARADDR => MNA_ARADDR,
            ARPROT => MNA_ARPROT,
            ARVALID => MNA_ARVALID,
            ARREADY => MNA_ARREADY,
            
            -- AXI WRITE RESPONSE CHANNEL
            BRESP => MNA_BRESP,
            BVALID => MNA_BVALID,
            BREADY => MNA_BREADY,
            
            -- AXI READ RESPONSE CHANNEL
            RDATA => MNA_RDATA,
            RRESP => MNA_RRESP,
            RVALID => MNA_RVALID,
            RREADY => MNA_RREADY,
            
            -- NOC INTERFACE - FLIT AXI -> NOC
            AXI_noc_data => MNA_to_SNA_data,
            AXI_noc_data_valid => MNA_to_SNA_data_valid,
                    
            noc_AXI_vc_busy => SNA_to_MNA_vc_busy,
            noc_AXI_vc_credits => SNA_to_MNA_vc_credits,
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data => SNA_to_MNA_data,
            noc_AXI_data_valid => SNA_to_MNA_data_valid,
            
            AXI_noc_vc_busy => MNA_to_SNA_vc_busy,
            AXI_noc_vc_credits => MNA_to_SNA_vc_credits
        );
    
    -- komponenta AXI_slave_network_adapter
    uut_SNA: AXI_slave_network_adapter
    
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
            AWADDR => SNA_AWADDR,
            AWPROT => SNA_AWPROT,
            AWVALID => SNA_AWVALID,
            AWREADY => SNA_AWREADY,
            
            -- AXI WRITE DATA CHANNEL
            WDATA => SNA_WDATA,
            WSTRB => SNA_WSTRB,
            WVALID => SNA_WVALID,
            WREADY => SNA_WREADY,
            
            -- AXI READ ADDRESS CHANNEL
            ARADDR => SNA_ARADDR,
            ARPROT => SNA_ARPROT,
            ARVALID => SNA_ARVALID,
            ARREADY => SNA_ARREADY,
            
            -- AXI WRITE RESPONSE CHANNEL
            BRESP => SNA_BRESP,
            BVALID => SNA_BVALID,
            BREADY => SNA_BREADY,
            
            -- AXI READ RESPONSE CHANNEL
            RDATA => SNA_RDATA,
            RRESP => SNA_RRESP,
            RVALID => SNA_RVALID,
            RREADY => SNA_RREADY,
            
            -- NOC INTERFACE - FLIT AXI > NOC
            AXI_noc_data => SNA_to_MNA_data,
            AXI_noc_data_valid => SNA_to_MNA_data_valid,
            
            noc_AXI_vc_busy => MNA_to_SNA_vc_busy,
            noc_AXI_vc_credits => MNA_to_SNA_vc_credits,
            
            -- NOC INTERFACE - FLIT NOC > AXI
            noc_AXI_data => MNA_to_SNA_data,
            noc_AXI_data_valid => MNA_to_SNA_data_valid,
            
            AXI_noc_vc_busy => SNA_to_MNA_vc_busy,
            AXI_noc_vc_credits => SNA_to_MNA_vc_credits
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
        MNA_AWADDR <= (others => '0');
        MNA_AWPROT <= (others => '0');
        MNA_AWVALID <= '0';
        
        MNA_WDATA <= (others => '0');
        MNA_WSTRB <= (others => '0');
        MNA_WVALID <= '0';
        
        MNA_ARADDR <= (others => '0');
        MNA_ARPROT <= (others => '0');
        MNA_ARVALID <= '0';
        
        MNA_BREADY <= '0';
        
        MNA_RREADY <= '0';
        
        SNA_AWREADY <= '0';
        
        SNA_WREADY <= '0';
        
        SNA_ARREADY <= '0';
        
        SNA_BRESP <= (others => '0');
        SNA_BVALID <= '0';
        
        SNA_RDATA <= (others => '0');
        SNA_RRESP <= (others => '0');
        SNA_RVALID <= '0';
        -- < Inicijalne postavke ulaznih signala
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (4.1 * clk_period);
        
        -- > WRITE
        -- > REQUEST
        MNA_AWADDR <= X"87654321";
        MNA_AWPROT <= "101";
        MNA_AWVALID <= '1';
        
        MNA_WDATA <= X"12344321";
        MNA_WSTRB <= "1111";
        MNA_WVALID <= '1';
        
        MNA_BREADY <= '1';
        
        wait for (2 * clk_period);
        
        MNA_AWADDR <= (others => '0');
        MNA_AWPROT <= (others => '0');
        MNA_AWVALID <= '0';
        
        MNA_WDATA <= (others => '0');
        MNA_WSTRB <= (others => '0');
        MNA_WVALID <= '0';
        
        wait for (16 * clk_period);
        
        SNA_AWREADY <= '1';
        
        SNA_WREADY <= '1';
        
        wait for clk_period;
        
        SNA_AWREADY <= '0';
        
        SNA_WREADY <= '0';
        -- < REQUEST
        
        -- > RESPONSE
        SNA_BRESP <= "11";
        SNA_BVALID <= '1';
        
        wait for clk_period;
        
        SNA_BVALID <= '0';
        
        wait for (8 * clk_period);
        
        MNA_BREADY <= '0';
        -- < RESPONSE
        -- < WRITE
        
        wait for (6 * clk_period);
        
        -- > READ
        -- > REQUEST
        MNA_ARADDR <= X"E1234567";
        MNA_ARPROT <= "010";
        MNA_ARVALID <= '1';
        
        MNA_RREADY <= '1';
        
        wait for (2 * clk_period);
        
        MNA_ARADDR <= (others => '0');
        MNA_ARPROT <= (others => '0');
        MNA_ARVALID <= '0';
        
        wait for (13 * clk_period);
        
        SNA_ARREADY <= '1';
        
        wait for clk_period;
        
        SNA_ARREADY <= '0';
        -- < REQUEST
        
        -- > RESPONSE
        SNA_RDATA <= X"12345678";
        SNA_RRESP <= "01";
        SNA_RVALID <= '1';
        
        wait for clk_period;
        
        SNA_RVALID <= '0';
        
        wait for (14 * clk_period);
        
        MNA_RREADY <= '0';
        -- < RESPONSE
        -- < READ
        
        wait;
    
    end process;

end Simulation;