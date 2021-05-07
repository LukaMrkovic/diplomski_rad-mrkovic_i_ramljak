----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 06.05.2021 12:42:43
-- Design Name: AXI_Network_Adapter
-- Module Name: MNA_req_flow_tb - Simulation
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
-- Additional Comments: Prva verzija simulacije MNA_req_flowa
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

entity MNA_req_flow_tb is
--  Port ( );
end MNA_req_flow_tb;

architecture Simulation of MNA_req_flow_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal int_clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    -- AXI WRITE ADDRESS CHANNEL           
    signal AWADDR_sim : std_logic_vector(31 downto 0);
    signal AWVALID_sim : std_logic;
    signal AWREADY_sim : std_logic;
    
    -- AXI WRITE DATA CHANNEL
    signal WDATA_sim : std_logic_vector(31 downto 0);
    signal WVALID_sim : std_logic;
    signal WREADY_sim : std_logic;
    
    -- AXI WRITE AUXILIARY SIGNALS
    signal AWPROT_sim : std_logic_vector(2 downto 0);
    signal WSTRB_sim : std_logic_vector(3 downto 0);
    
    -- AXI READ ADDRESS CHANNEL
    signal ARADDR_sim : std_logic_vector(31 downto 0);
    signal ARVALID_sim : std_logic;
    signal ARREADY_sim : std_logic;
            
    -- AXI READ AUXILIARY SIGNALS
    signal ARPROT_sim : std_logic_vector(2 downto 0);
    
    -- NOC INTERFACE
    signal AXI_noc_data_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal AXI_noc_data_valid_sim : std_logic;
           
    signal noc_AXI_vc_busy_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal noc_AXI_vc_credits_sim : std_logic_vector(const_vc_num - 1 downto 0);

    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: MNA_req_flow
    
        generic map(
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
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
                
            -- AXI WRITE ADDRESS CHANNEL           
            AWADDR => AWADDR_sim,
            AWVALID => AWVALID_sim,
            AWREADY => AWREADY_sim,
            
            -- AXI WRITE DATA CHANNEL
            WDATA => WDATA_sim,
            WVALID => WVALID_sim,
            WREADY => WREADY_sim,
            
            -- AXI WRITE AUXILIARY SIGNALS
            AWPROT => AWPROT_sim,
            WSTRB => WSTRB_sim,
            
            -- AXI READ ADDRESS CHANNEL
            ARADDR => ARADDR_sim,
            ARVALID => ARVALID_sim,
            ARREADY => ARREADY_sim,
            
            -- AXI READ AUXILIARY SIGNALS
            ARPROT => ARPROT_sim,
            
            -- NOC INTERFACE
            AXI_noc_data => AXI_noc_data_sim,
            AXI_noc_data_valid => AXI_noc_data_valid_sim,
                    
            noc_AXI_vc_busy => noc_AXI_vc_busy_sim,
            noc_AXI_vc_credits => noc_AXI_vc_credits_sim
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
    
        -- inicijalizacija ulaza
        AWADDR_sim <= (others => '0');
        AWVALID_sim <= '0';
        
        WDATA_sim <= (others => '0');
        WVALID_sim <= '0';
        
        AWPROT_sim <= (others => '0');
        WSTRB_sim <= (others => '0');
        
        ARADDR_sim <= (others => '0');
        ARVALID_sim <= '0';
        
        ARPROT_sim <= (others => '0');
        
        noc_AXI_vc_busy_sim <= (others => '0');
        noc_AXI_vc_credits_sim <= (others => '0');
    
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (2.1 * clk_period);
        
        -- > WRITE
        AWADDR_sim <= X"87654321";
        AWVALID_sim <= '1';
        
        WDATA_sim <= X"12344321";
        WVALID_sim <= '1';
        
        AWPROT_sim <= "101";
        WSTRB_sim <= "1111";
        
        wait for (2 * clk_period);
        
        AWADDR_sim <= (others => '0');
        AWVALID_sim <= '0';
        
        WDATA_sim <= (others => '0');
        WVALID_sim <= '0';
        
        AWPROT_sim <= (others => '0');
        WSTRB_sim <= (others => '0');
        
        wait for (5 * clk_period);
        
        noc_AXI_vc_busy_sim <= (0 => '1', others => '0');
        
        wait for (7 * clk_period);
        
        noc_AXI_vc_credits_sim <= (0 => '1', others => '0');
        
        wait for clk_period;
        
        noc_AXI_vc_busy_sim <= (others => '0');
        noc_AXI_vc_credits_sim <= (others => '0');
        
        wait for (3 * clk_period);
        
        noc_AXI_vc_credits_sim <= (0 => '1', others => '0');
        
        wait for clk_period;
        
        noc_AXI_vc_credits_sim <= (others => '0');
        
        wait for (3 * clk_period);
        
        noc_AXI_vc_credits_sim <= (0 => '1', others => '0');
        
        wait for clk_period;
        
        noc_AXI_vc_credits_sim <= (others => '0');
        
        wait for (5 * clk_period);
        -- <
        
        -- > READ
        ARADDR_sim <= X"E1234567";
        ARVALID_sim <= '1';
        
        ARPROT_sim <= "010";
        
        wait for (2 * clk_period);
        
        ARADDR_sim <= (others => '0');
        ARVALID_sim <= '0';
        
        ARPROT_sim <= (others => '0');
        
        wait for (5 * clk_period);
        
        noc_AXI_vc_busy_sim <= (0 => '1', others => '0');
        
        wait for (4 * clk_period);
        
        noc_AXI_vc_busy_sim <= (others => '0');
        
        wait for (3 * clk_period);
        
        noc_AXI_vc_credits_sim <= (0 => '1', others => '0');
        
        wait for clk_period;
        
        noc_AXI_vc_credits_sim <= (others => '0');
        
        wait for (3 * clk_period);
        
        noc_AXI_vc_credits_sim <= (0 => '1', others => '0');
        
        wait for clk_period;
        
        noc_AXI_vc_credits_sim <= (others => '0');
        -- <
        
        wait;
    
    end process;

end Simulation;