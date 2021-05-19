----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 14.05.2021 11:48:17
-- Design Name: NoC_Router + AXI_Network_Adapter
-- Module Name: noc_mesh_2x2_AXI_tb - Simulation
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
-- Additional Comments: Prva verzija simulacije noc mreze 2x2 s AXI adapterima
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

entity noc_mesh_2x2_AXI_tb is
--  Port ( );
end noc_mesh_2x2_AXI_tb;

architecture Simulation of noc_mesh_2x2_AXI_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal int_clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    -- > ROUTER A
        -- LOCAL (MNA)
        signal data_MNA_to_rA : std_logic_vector(const_flit_size - 1 downto 0);
        signal data_valid_MNA_to_rA : std_logic;
        signal vc_busy_rA_to_MNA : std_logic_vector(const_vc_num - 1 downto 0);
        signal vc_credits_rA_to_MNA : std_logic_vector(const_vc_num - 1 downto 0);
    
        signal data_rA_to_MNA : std_logic_vector(const_flit_size - 1 downto 0);
        signal data_valid_rA_to_MNA : std_logic;
        signal vc_busy_MNA_to_rA : std_logic_vector(const_vc_num - 1 downto 0);
        signal vc_credits_MNA_to_rA : std_logic_vector(const_vc_num - 1 downto 0);
    -- < ROUTER A
    
    -- > ROUTER B
        -- LOCAL
        signal data_in_B_local : std_logic_vector(const_flit_size - 1 downto 0);
        signal data_in_valid_B_local : std_logic;
        signal data_in_vc_busy_B_local : std_logic_vector(const_vc_num - 1 downto 0);
        signal data_in_vc_credits_B_local : std_logic_vector(const_vc_num - 1 downto 0);
    
        signal data_out_B_local : std_logic_vector(const_flit_size - 1 downto 0);
        signal data_out_valid_B_local : std_logic;
        signal data_out_vc_busy_B_local : std_logic_vector(const_vc_num - 1 downto 0);
        signal data_out_vc_credits_B_local : std_logic_vector(const_vc_num - 1 downto 0);
    -- < ROUTER B
    
    -- > ROUTER C
        -- LOCAL
        signal data_in_C_local : std_logic_vector(const_flit_size - 1 downto 0);
        signal data_in_valid_C_local : std_logic;
        signal data_in_vc_busy_C_local : std_logic_vector(const_vc_num - 1 downto 0);
        signal data_in_vc_credits_C_local : std_logic_vector(const_vc_num - 1 downto 0);
    
        signal data_out_C_local : std_logic_vector(const_flit_size - 1 downto 0);
        signal data_out_valid_C_local : std_logic;
        signal data_out_vc_busy_C_local : std_logic_vector(const_vc_num - 1 downto 0);
        signal data_out_vc_credits_C_local : std_logic_vector(const_vc_num - 1 downto 0);
    -- < ROUTER C
    
    -- > ROUTER D
        -- LOCAL (SNA)
        signal data_SNA_to_rD : std_logic_vector(const_flit_size - 1 downto 0);
        signal data_valid_SNA_to_rD : std_logic;
        signal vc_busy_rD_to_SNA : std_logic_vector(const_vc_num - 1 downto 0);
        signal vc_credits_rD_to_SNA : std_logic_vector(const_vc_num - 1 downto 0);
    
        signal data_rD_to_SNA : std_logic_vector(const_flit_size - 1 downto 0);
        signal data_valid_rD_to_SNA : std_logic;
        signal vc_busy_SNA_to_rD : std_logic_vector(const_vc_num - 1 downto 0);
        signal vc_credits_SNA_to_rD : std_logic_vector(const_vc_num - 1 downto 0);
    -- < ROUTER D
    
    -- MEDUKONEKCIJE ROUTER A - ROUTER B
    signal data_A_to_B : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_A_to_B : std_logic;
    signal vc_busy_B_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_B_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_B_to_A : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_B_to_A : std_logic;
    signal vc_busy_A_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_A_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER A - ROUTER C
    signal data_A_to_C : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_A_to_C : std_logic;
    signal vc_busy_C_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_C_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_C_to_A : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_C_to_A : std_logic;
    signal vc_busy_A_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_A_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER B - ROUTER D
    signal data_B_to_D : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_B_to_D : std_logic;
    signal vc_busy_D_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_D_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_D_to_B : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_D_to_B : std_logic;
    signal vc_busy_B_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_B_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER C - ROUTER D
    signal data_C_to_D : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_C_to_D : std_logic;
    signal vc_busy_D_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_D_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_D_to_C : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_D_to_C : std_logic;
    signal vc_busy_C_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_C_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- > MNA AXI SIGNALI
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
    -- < MNA AXI SIGNALI
    
    -- > SNA AXI SIGNALI
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
    -- < SNA AXI SIGNALI

    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut_router_A: noc_router
    
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
            diagonal_pref => const_default_diagonal_pref
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
               
            data_in_local => data_MNA_to_rA,
            data_in_valid_local => data_valid_MNA_to_rA,
            data_in_vc_busy_local => vc_busy_rA_to_MNA,
            data_in_vc_credits_local => vc_credits_rA_to_MNA,
            
            data_out_local => data_rA_to_MNA,
            data_out_valid_local => data_valid_rA_to_MNA,
            data_out_vc_busy_local => vc_busy_MNA_to_rA,
            data_out_vc_credits_local =>  vc_credits_MNA_to_rA,
            
            data_in_north => (others => '0'),
            data_in_valid_north => '0',
            data_in_vc_busy_north => open,
            data_in_vc_credits_north => open,
            
            data_out_north => open,
            data_out_valid_north => open,
            data_out_vc_busy_north => (others => '0'),
            data_out_vc_credits_north => (others => '0'),
            
            data_in_east => data_B_to_A,
            data_in_valid_east => data_valid_B_to_A,
            data_in_vc_busy_east => vc_busy_A_to_B,
            data_in_vc_credits_east => vc_credits_A_to_B,
            
            data_out_east => data_A_to_B,
            data_out_valid_east => data_valid_A_to_B,
            data_out_vc_busy_east => vc_busy_B_to_A,
            data_out_vc_credits_east => vc_credits_B_to_A,
            
            data_in_south => data_C_to_A,
            data_in_valid_south => data_valid_C_to_A,
            data_in_vc_busy_south => vc_busy_A_to_C,
            data_in_vc_credits_south => vc_credits_A_to_C,
            
            data_out_south => data_A_to_C,
            data_out_valid_south => data_valid_A_to_C,
            data_out_vc_busy_south => vc_busy_C_to_A,
            data_out_vc_credits_south => vc_credits_C_to_A,
            
            data_in_west => (others => '0'),
            data_in_valid_west => '0',
            data_in_vc_busy_west => open,
            data_in_vc_credits_west => open,
            
            data_out_west => open,
            data_out_valid_west => open,
            data_out_vc_busy_west => (others => '0'),
            data_out_vc_credits_west => (others => '0')
        );

    -- Komponenta koja se testira (Unit Under Test)
    uut_router_B: noc_router
    
        generic map (
            vc_num => const_vc_num,
            mesh_size_x => const_mesh_size_x,
            mesh_size_y => const_mesh_size_y,
            address_size => const_address_size,
            payload_size => const_payload_size,
            flit_size => const_flit_size,
            buffer_size => const_buffer_size,
            local_address_x => "0010",
            local_address_y => "0001",
            clock_divider => const_clock_divider,
            diagonal_pref => const_default_diagonal_pref
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
               
            data_in_local => data_in_B_local,
            data_in_valid_local => data_in_valid_B_local,
            data_in_vc_busy_local => data_in_vc_busy_B_local,
            data_in_vc_credits_local => data_in_vc_credits_B_local,
            
            data_out_local => data_out_B_local,
            data_out_valid_local => data_out_valid_B_local,
            data_out_vc_busy_local => data_out_vc_busy_B_local,
            data_out_vc_credits_local =>  data_out_vc_credits_B_local,
            
            data_in_north => (others => '0'),
            data_in_valid_north => '0',
            data_in_vc_busy_north => open,
            data_in_vc_credits_north => open,
            
            data_out_north => open,
            data_out_valid_north => open,
            data_out_vc_busy_north => (others => '0'),
            data_out_vc_credits_north => (others => '0'),
            
            data_in_east => (others => '0'),
            data_in_valid_east => '0',
            data_in_vc_busy_east => open,
            data_in_vc_credits_east => open,
            
            data_out_east => open,
            data_out_valid_east => open,
            data_out_vc_busy_east => (others => '0'),
            data_out_vc_credits_east => (others => '0'),
            
            data_in_south => data_D_to_B,
            data_in_valid_south => data_valid_D_to_B,
            data_in_vc_busy_south => vc_busy_B_to_D,
            data_in_vc_credits_south => vc_credits_B_to_D,
            
            data_out_south => data_B_to_D,
            data_out_valid_south => data_valid_B_to_D,
            data_out_vc_busy_south => vc_busy_D_to_B,
            data_out_vc_credits_south => vc_credits_D_to_B,
            
            data_in_west => data_A_to_B,
            data_in_valid_west => data_valid_A_to_B,
            data_in_vc_busy_west => vc_busy_B_to_A,
            data_in_vc_credits_west => vc_credits_B_to_A,
            
            data_out_west => data_B_to_A,
            data_out_valid_west => data_valid_B_to_A,
            data_out_vc_busy_west => vc_busy_A_to_B,
            data_out_vc_credits_west => vc_credits_A_to_B
        );

    -- Komponenta koja se testira (Unit Under Test)
    uut_router_C: noc_router
    
        generic map (
            vc_num => const_vc_num,
            mesh_size_x => const_mesh_size_x,
            mesh_size_y => const_mesh_size_y,
            address_size => const_address_size,
            payload_size => const_payload_size,
            flit_size => const_flit_size,
            buffer_size => const_buffer_size,
            local_address_x => "0001",
            local_address_y => "0010",
            clock_divider => const_clock_divider,
            diagonal_pref => const_default_diagonal_pref
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
               
            data_in_local => data_in_C_local,
            data_in_valid_local => data_in_valid_C_local,
            data_in_vc_busy_local => data_in_vc_busy_C_local,
            data_in_vc_credits_local => data_in_vc_credits_C_local,
            
            data_out_local => data_out_C_local,
            data_out_valid_local => data_out_valid_C_local,
            data_out_vc_busy_local => data_out_vc_busy_C_local,
            data_out_vc_credits_local =>  data_out_vc_credits_C_local,
            
            data_in_north => data_A_to_C,
            data_in_valid_north => data_valid_A_to_C,
            data_in_vc_busy_north => vc_busy_C_to_A,
            data_in_vc_credits_north => vc_credits_C_to_A,
            
            data_out_north => data_C_to_A,
            data_out_valid_north => data_valid_C_to_A,
            data_out_vc_busy_north => vc_busy_A_to_C,
            data_out_vc_credits_north => vc_credits_A_to_C,
            
            data_in_east => data_D_to_C,
            data_in_valid_east => data_valid_D_to_C,
            data_in_vc_busy_east => vc_busy_C_to_D,
            data_in_vc_credits_east => vc_credits_C_to_D,
            
            data_out_east => data_C_to_D,
            data_out_valid_east => data_valid_C_to_D,
            data_out_vc_busy_east => vc_busy_D_to_C,
            data_out_vc_credits_east => vc_credits_D_to_C,
            
            data_in_south => (others => '0'),
            data_in_valid_south => '0',
            data_in_vc_busy_south => open,
            data_in_vc_credits_south => open,
            
            data_out_south => open,
            data_out_valid_south => open,
            data_out_vc_busy_south => (others => '0'),
            data_out_vc_credits_south => (others => '0'),
            
            data_in_west => (others => '0'),
            data_in_valid_west => '0',
            data_in_vc_busy_west => open,
            data_in_vc_credits_west => open,
            
            data_out_west => open,
            data_out_valid_west => open,
            data_out_vc_busy_west => (others => '0'),
            data_out_vc_credits_west => (others => '0')
        );

    -- Komponenta koja se testira (Unit Under Test)
    uut_router_D: noc_router
    
        generic map (
            vc_num => const_vc_num,
            mesh_size_x => const_mesh_size_x,
            mesh_size_y => const_mesh_size_y,
            address_size => const_address_size,
            payload_size => const_payload_size,
            flit_size => const_flit_size,
            buffer_size => const_buffer_size,
            local_address_x => "0010",
            local_address_y => "0010",
            clock_divider => const_clock_divider,
            diagonal_pref => const_default_diagonal_pref
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
               
            data_in_local => data_SNA_to_rD,
            data_in_valid_local => data_valid_SNA_to_rD,
            data_in_vc_busy_local => vc_busy_rD_to_SNA,
            data_in_vc_credits_local => vc_credits_rD_to_SNA,
            
            data_out_local => data_rD_to_SNA,
            data_out_valid_local => data_valid_rD_to_SNA,
            data_out_vc_busy_local => vc_busy_SNA_to_rD,
            data_out_vc_credits_local => vc_credits_SNA_to_rD,
            
            data_in_north => data_B_to_D,
            data_in_valid_north => data_valid_B_to_D,
            data_in_vc_busy_north => vc_busy_D_to_B,
            data_in_vc_credits_north => vc_credits_D_to_B,
            
            data_out_north => data_D_to_B,
            data_out_valid_north => data_valid_D_to_B,
            data_out_vc_busy_north => vc_busy_B_to_D,
            data_out_vc_credits_north => vc_credits_B_to_D,
            
            data_in_east => (others => '0'),
            data_in_valid_east => '0',
            data_in_vc_busy_east => open,
            data_in_vc_credits_east => open,
            
            data_out_east => open,
            data_out_valid_east => open,
            data_out_vc_busy_east => (others => '0'),
            data_out_vc_credits_east => (others => '0'),
            
            data_in_south => (others => '0'),
            data_in_valid_south => '0',
            data_in_vc_busy_south => open,
            data_in_vc_credits_south => open,
            
            data_out_south => open,
            data_out_valid_south => open,
            data_out_vc_busy_south => (others => '0'),
            data_out_vc_credits_south => (others => '0'),
            
            data_in_west => data_C_to_D,
            data_in_valid_west => data_valid_C_to_D,
            data_in_vc_busy_west => vc_busy_D_to_C,
            data_in_vc_credits_west => vc_credits_D_to_C,
            
            data_out_west => data_D_to_C,
            data_out_valid_west => data_valid_D_to_C,
            data_out_vc_busy_west => vc_busy_C_to_D,
            data_out_vc_credits_west => vc_credits_C_to_D
        );
        
    -- Komponenta koja se testira (Unit Under Test)
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
            AXI_noc_data => data_MNA_to_rA, 
            AXI_noc_data_valid => data_valid_MNA_to_rA,
                    
            noc_AXI_vc_busy => vc_busy_rA_to_MNA,
            noc_AXI_vc_credits => vc_credits_rA_to_MNA,
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data => data_rA_to_MNA,     
            noc_AXI_data_valid => data_valid_rA_to_MNA,
            
            AXI_noc_vc_busy => vc_busy_MNA_to_rA,
            AXI_noc_vc_credits => vc_credits_MNA_to_rA
        );

    -- Komponenta koja se testira (Unit Under Test)
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
            
            -- NOC INTERFACE - FLIT AXI -> NOC
            AXI_noc_data => data_SNA_to_rD,
            AXI_noc_data_valid => data_valid_SNA_to_rD,
            
            noc_AXI_vc_busy => vc_busy_rD_to_SNA,
            noc_AXI_vc_credits => vc_credits_rD_to_SNA,
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data => data_rD_to_SNA,
            noc_AXI_data_valid => data_valid_rD_to_SNA,
            
            AXI_noc_vc_busy => vc_busy_SNA_to_rD,
            AXI_noc_vc_credits => vc_credits_SNA_to_rD
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
        -- > ROUTER B
            -- LOCAL
            data_in_B_local <= (others => '0');
            data_in_valid_B_local <= '0';
            data_out_vc_busy_B_local <= (others => '0');
            data_out_vc_credits_B_local <= (others => '0');
        -- < ROUTER B
        
        -- > ROUTER C
            -- LOCAL
            data_in_C_local <= (others => '0');
            data_in_valid_C_local <= '0';
            data_out_vc_busy_C_local <= (others => '0');
            data_out_vc_credits_C_local <= (others => '0');
        -- < ROUTER C
        
        -- > MNA
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
        -- < MNA
        
        -- > SNA
            SNA_AWREADY <= '0';
            
            SNA_WREADY <= '0';
            
            SNA_ARREADY <= '0';
            
            SNA_BRESP <= (others => '0');
            SNA_BVALID <= '0';
            
            SNA_RDATA <= (others => '0');
            SNA_RRESP <= (others => '0');
            SNA_RVALID <= '0';
        -- < SNA
        -- > Inicijalne postavke ulaznih signala
    
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';       

        wait for (2.1 * clk_period);
        
        -- > WRITE
        -- > REQUEST
        MNA_AWADDR <= X"51111111";
        MNA_AWPROT <= "101";
        MNA_AWVALID <= '1';
        
        MNA_WDATA <= X"87654321";
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
        -- < REQUEST
        
        wait for (42 * clk_period);
        
        -- > RESPONSE
        SNA_AWREADY <= '1';
        
        SNA_WREADY <= '1';
        
        wait for clk_period;
        
        SNA_AWREADY <= '0';
        
        SNA_WREADY <= '0';
        
        SNA_BRESP <= "11";
        SNA_BVALID <= '1';
        
        wait for clk_period;
        
        SNA_BVALID <= '0';
        
        wait for (32 * clk_period);
        
        MNA_BREADY <= '0';
        -- < RESPONSE
        -- < WRITE
        
        wait for (2 * clk_period);
        
        -- > READ
        -- > REQUEST
        MNA_ARADDR <= X"52222222";
        MNA_ARPROT <= "010";
        MNA_ARVALID <= '1';
        
        MNA_RREADY <= '1';
        
        wait for (2 * clk_period);
        
        MNA_ARADDR <= (others => '0');
        MNA_ARPROT <= (others => '0');
        MNA_ARVALID <= '0';
        -- < REQUEST
        
        wait for (37 * clk_period);
        
        -- > RESPONSE
        SNA_ARREADY <= '1';
        
        wait for clk_period;
        
        SNA_ARREADY <= '0';
        
        SNA_RDATA <= X"12345678";
        SNA_RRESP <= "01";
        SNA_RVALID <= '1';
        
        wait for clk_period;
        
        SNA_RVALID <= '0';
        
        wait for (38 * clk_period);
        
        MNA_RREADY <= '0';
        -- < RESPONSE
        -- < READ
        
        wait;
    
    end process;

end Simulation;