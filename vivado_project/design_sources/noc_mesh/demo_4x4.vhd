----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/31/2021 10:56:51 AM
-- Design Name: NoC_Mesh
-- Module Name: demo_4x4 - Behavioral
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
-- Revision 0.1 - 2021-05-31 - Ramljak
-- Additional Comments: 4x4 noc mreza s 2 MNA i 2 SNA sklopa - namijenjena demonstraciji
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity demo_4x4 is

    Generic (
        vc_num : integer := 2;
        mesh_size_x : integer := 4;
        mesh_size_y : integer := 4;
        address_size : integer := 8;
        payload_size : integer := 32;
        flit_size : integer := 44;
        buffer_size : integer := 8;
        clock_divider : integer := 2;
        
        MNA_write_threshold : integer := 3;
        MNA_read_threshold : integer := 2;
        SNA_write_threshold : integer := 1;
        SNA_read_threshold : integer := 2;
        node_address_size : integer := 4
    );
    
    Port (
        clk : in std_logic;
        rst : in std_logic;
        
        -- > MNA_0
            -- AXI WRITE ADDRESS CHANNEL           
            MNA_0_AWADDR : in std_logic_vector(31 downto 0);
            MNA_0_AWPROT : in std_logic_vector(2 downto 0);
            MNA_0_AWVALID : in std_logic;
            MNA_0_AWREADY : out std_logic;
            
            -- AXI WRITE DATA CHANNEL
            MNA_0_WDATA : in std_logic_vector(31 downto 0);
            MNA_0_WSTRB : in std_logic_vector(3 downto 0);
            MNA_0_WVALID : in std_logic;
            MNA_0_WREADY : out std_logic;
            
            -- AXI READ ADDRESS CHANNEL
            MNA_0_ARADDR : in std_logic_vector(31 downto 0);
            MNA_0_ARPROT : in std_logic_vector(2 downto 0);
            MNA_0_ARVALID : in std_logic;
            MNA_0_ARREADY : out std_logic;
            
            -- AXI WRITE RESPONSE CHANNEL   
            MNA_0_BRESP : out std_logic_vector(1 downto 0);
            MNA_0_BVALID : out std_logic;
            MNA_0_BREADY : in std_logic;
            
            -- AXI READ RESPONSE CHANNEL
            MNA_0_RDATA : out std_logic_vector(31 downto 0);
            MNA_0_RRESP : out std_logic_vector(1 downto 0);
            MNA_0_RVALID : out std_logic;
            MNA_0_RREADY : in std_logic;
        -- < MNA_0
        
        -- > MNA_1
            -- AXI WRITE ADDRESS CHANNEL           
            MNA_1_AWADDR : in std_logic_vector(31 downto 0);
            MNA_1_AWPROT : in std_logic_vector(2 downto 0);
            MNA_1_AWVALID : in std_logic;
            MNA_1_AWREADY : out std_logic;
            
            -- AXI WRITE DATA CHANNEL
            MNA_1_WDATA : in std_logic_vector(31 downto 0);
            MNA_1_WSTRB : in std_logic_vector(3 downto 0);
            MNA_1_WVALID : in std_logic;
            MNA_1_WREADY : out std_logic;
            
            -- AXI READ ADDRESS CHANNEL
            MNA_1_ARADDR : in std_logic_vector(31 downto 0);
            MNA_1_ARPROT : in std_logic_vector(2 downto 0);
            MNA_1_ARVALID : in std_logic;
            MNA_1_ARREADY : out std_logic;
            
            -- AXI WRITE RESPONSE CHANNEL   
            MNA_1_BRESP : out std_logic_vector(1 downto 0);
            MNA_1_BVALID : out std_logic;
            MNA_1_BREADY : in std_logic;
            
            -- AXI READ RESPONSE CHANNEL
            MNA_1_RDATA : out std_logic_vector(31 downto 0);
            MNA_1_RRESP : out std_logic_vector(1 downto 0);
            MNA_1_RVALID : out std_logic;
            MNA_1_RREADY : in std_logic;
        -- < MNA_1
        
        -- > SNA_0
            -- AXI WRITE ADDRESS CHANNEL 
            SNA_0_AWADDR : out std_logic_vector(31 downto 0);
            SNA_0_AWPROT : out std_logic_vector(2 downto 0);
            SNA_0_AWVALID : out std_logic;
            SNA_0_AWREADY : in std_logic;
            
            -- AXI WRITE DATA CHANNEL
            SNA_0_WDATA : out std_logic_vector(31 downto 0);
            SNA_0_WSTRB : out std_logic_vector(3 downto 0);
            SNA_0_WVALID : out std_logic;
            SNA_0_WREADY : in std_logic;
            
            -- AXI READ ADDRESS CHANNEL
            SNA_0_ARADDR : out std_logic_vector(31 downto 0);
            SNA_0_ARPROT : out std_logic_vector(2 downto 0);
            SNA_0_ARVALID : out std_logic;
            SNA_0_ARREADY : in std_logic;
            
            -- AXI WRITE RESPONSE CHANNEL
            SNA_0_BRESP : in std_logic_vector(1 downto 0);
            SNA_0_BVALID : in std_logic;
            SNA_0_BREADY : out std_logic;
            
            -- AXI READ RESPONSE CHANNEL
            SNA_0_RDATA : in std_logic_vector(31 downto 0);
            SNA_0_RRESP : in std_logic_vector(1 downto 0);
            SNA_0_RVALID : in std_logic;
            SNA_0_RREADY : out std_logic;
        -- < SNA_0
        
        -- > SNA_1
            -- AXI WRITE ADDRESS CHANNEL 
            SNA_1_AWADDR : out std_logic_vector(31 downto 0);
            SNA_1_AWPROT : out std_logic_vector(2 downto 0);
            SNA_1_AWVALID : out std_logic;
            SNA_1_AWREADY : in std_logic;
            
            -- AXI WRITE DATA CHANNEL
            SNA_1_WDATA : out std_logic_vector(31 downto 0);
            SNA_1_WSTRB : out std_logic_vector(3 downto 0);
            SNA_1_WVALID : out std_logic;
            SNA_1_WREADY : in std_logic;
            
            -- AXI READ ADDRESS CHANNEL
            SNA_1_ARADDR : out std_logic_vector(31 downto 0);
            SNA_1_ARPROT : out std_logic_vector(2 downto 0);
            SNA_1_ARVALID : out std_logic;
            SNA_1_ARREADY : in std_logic;
            
            -- AXI WRITE RESPONSE CHANNEL
            SNA_1_BRESP : in std_logic_vector(1 downto 0);
            SNA_1_BVALID : in std_logic;
            SNA_1_BREADY : out std_logic;
            
            -- AXI READ RESPONSE CHANNEL
            SNA_1_RDATA : in std_logic_vector(31 downto 0);
            SNA_1_RRESP : in std_logic_vector(1 downto 0);
            SNA_1_RVALID : in std_logic;
            SNA_1_RREADY : out std_logic
        -- < SNA_1
    );
    
end demo_4x4;

architecture Behavioral of demo_4x4 is

    -- ROUTER A (11) INJECTION (MNA_0)
    signal data_MNA_0_to_rA : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_MNA_0_to_rA : std_logic;
    signal vc_busy_rA_to_MNA_0 : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_rA_to_MNA_0 : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_rA_to_MNA_0 : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_rA_to_MNA_0 : std_logic;
    signal vc_busy_MNA_0_to_rA : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_MNA_0_to_rA : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- ROUTER H (82) INJECTION (SNA_0)
    signal data_SNA_0_to_rH : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_SNA_0_to_rH : std_logic;
    signal vc_busy_rH_to_SNA_0 : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_rH_to_SNA_0 : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_rH_to_SNA_0 : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_rH_to_SNA_0 : std_logic;
    signal vc_busy_SNA_0_to_rH : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_SNA_0_to_rH : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- ROUTER M (12) INJECTION (MNA_1)
    signal data_MNA_1_to_rM : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_MNA_1_to_rM : std_logic;
    signal vc_busy_rM_to_MNA_1 : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_rM_to_MNA_1 : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_rM_to_MNA_1 : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_rM_to_MNA_1 : std_logic;
    signal vc_busy_MNA_1_to_rM : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_MNA_1_to_rM : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- ROUTER P (88) INJECTION (SNA_1)
    signal data_SNA_1_to_rP : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_SNA_1_to_rP : std_logic;
    signal vc_busy_rP_to_SNA_1 : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_rP_to_SNA_1 : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_rP_to_SNA_1 : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_rP_to_SNA_1 : std_logic;
    signal vc_busy_SNA_1_to_rP : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_SNA_1_to_rP : std_logic_vector(const_vc_num - 1 downto 0);

begin

    -- noc_mesh_2x2 KOMPONENTA
    noc_mesh: noc_mesh_4x4
    
        generic map (
        vc_num => vc_num,
        mesh_size_x => mesh_size_x,
        mesh_size_y => mesh_size_y,
        address_size => address_size,
        payload_size => payload_size,
        flit_size => flit_size,
        buffer_size => buffer_size,
        clock_divider => clock_divider
    )
    
    port map (
        clk => clk,
        rst => rst,
        
        -- MESH INJECTION INTERFACES
        
        -- ROUTER A (11)
        data_in_A => data_MNA_0_to_rA,
        data_in_valid_A => data_valid_MNA_0_to_rA,
        data_in_vc_busy_A => vc_busy_rA_to_MNA_0,
        data_in_vc_credits_A => vc_credits_rA_to_MNA_0,
            
        data_out_A => data_rA_to_MNA_0,
        data_out_valid_A => data_valid_rA_to_MNA_0,
        data_out_vc_busy_A => vc_busy_MNA_0_to_rA,
        data_out_vc_credits_A => vc_credits_MNA_0_to_rA,
        
        -- ROUTER B (21)
        data_in_B => (others => '0'),
        data_in_valid_B => '0',
        data_in_vc_busy_B => open,
        data_in_vc_credits_B => open,
        
        data_out_B  => open,
        data_out_valid_B => open,
        data_out_vc_busy_B => (others => '0'),
        data_out_vc_credits_B => (others => '0'),
        
        -- ROUTER C (41)
        data_in_C => (others => '0'),
        data_in_valid_C => '0',
        data_in_vc_busy_C => open,
        data_in_vc_credits_C => open,
        
        data_out_C  => open,
        data_out_valid_C => open,
        data_out_vc_busy_C => (others => '0'),
        data_out_vc_credits_C => (others => '0'),
        
        -- ROUTER D (81)
        data_in_D => (others => '0'),
        data_in_valid_D => '0',
        data_in_vc_busy_D => open,
        data_in_vc_credits_D => open,
        
        data_out_D  => open,
        data_out_valid_D => open,
        data_out_vc_busy_D => (others => '0'),
        data_out_vc_credits_D => (others => '0'),
    
        -- ROUTER E (12)
        data_in_E => (others => '0'),
        data_in_valid_E => '0',
        data_in_vc_busy_E => open,
        data_in_vc_credits_E => open,
        
        data_out_E  => open,
        data_out_valid_E => open,
        data_out_vc_busy_E => (others => '0'),
        data_out_vc_credits_E => (others => '0'),
        
        -- ROUTER F (22)
        data_in_F => (others => '0'),
        data_in_valid_F => '0',
        data_in_vc_busy_F => open,
        data_in_vc_credits_F => open,
        
        data_out_F  => open,
        data_out_valid_F => open,
        data_out_vc_busy_F => (others => '0'),
        data_out_vc_credits_F => (others => '0'),
        
        -- ROUTER G (42)
        data_in_G => (others => '0'),
        data_in_valid_G => '0',
        data_in_vc_busy_G => open,
        data_in_vc_credits_G => open,
        
        data_out_G  => open,
        data_out_valid_G => open,
        data_out_vc_busy_G => (others => '0'),
        data_out_vc_credits_G => (others => '0'),
        
        -- ROUTER H (82)
        data_in_H => data_SNA_0_to_rH,
        data_in_valid_H => data_valid_SNA_0_to_rH,
        data_in_vc_busy_H => vc_busy_rH_to_SNA_0,
        data_in_vc_credits_H => vc_credits_rH_to_SNA_0,
            
        data_out_H => data_rH_to_SNA_0,
        data_out_valid_H => data_valid_rH_to_SNA_0,
        data_out_vc_busy_H => vc_busy_SNA_0_to_rH,
        data_out_vc_credits_H => vc_credits_SNA_0_to_rH,
        
        -- ROUTER I (14)
        data_in_I => (others => '0'),
        data_in_valid_I => '0',
        data_in_vc_busy_I => open,
        data_in_vc_credits_I => open,
        
        data_out_I  => open,
        data_out_valid_I => open,
        data_out_vc_busy_I => (others => '0'),
        data_out_vc_credits_I => (others => '0'),
        
        -- ROUTER J (24)
        data_in_J => (others => '0'),
        data_in_valid_J => '0',
        data_in_vc_busy_J => open,
        data_in_vc_credits_J => open,
        
        data_out_J  => open,
        data_out_valid_J => open,
        data_out_vc_busy_J => (others => '0'),
        data_out_vc_credits_J => (others => '0'),
        
        -- ROUTER K (44)
        data_in_K => (others => '0'),
        data_in_valid_K => '0',
        data_in_vc_busy_K => open,
        data_in_vc_credits_K => open,
        
        data_out_K  => open,
        data_out_valid_K => open,
        data_out_vc_busy_K => (others => '0'),
        data_out_vc_credits_K => (others => '0'),
        
        -- ROUTER L (84)
        data_in_L => (others => '0'),
        data_in_valid_L => '0',
        data_in_vc_busy_L => open,
        data_in_vc_credits_L => open,
        
        data_out_L  => open,
        data_out_valid_L => open,
        data_out_vc_busy_L => (others => '0'),
        data_out_vc_credits_L => (others => '0'),
        
        -- ROUTER M (18)
        data_in_M => data_MNA_1_to_rM,
        data_in_valid_M => data_valid_MNA_1_to_rM,
        data_in_vc_busy_M => vc_busy_rM_to_MNA_1,
        data_in_vc_credits_M => vc_credits_rM_to_MNA_1,
                    
        data_out_M => data_rM_to_MNA_1,
        data_out_valid_M => data_valid_rM_to_MNA_1,
        data_out_vc_busy_M => vc_busy_MNA_1_to_rM,
        data_out_vc_credits_M => vc_credits_MNA_1_to_rM,
        
        -- ROUTER N (28)
        data_in_N => (others => '0'),
        data_in_valid_N => '0',
        data_in_vc_busy_N => open,
        data_in_vc_credits_N => open,
        
        data_out_N  => open,
        data_out_valid_N => open,
        data_out_vc_busy_N => (others => '0'),
        data_out_vc_credits_N => (others => '0'),
        
        -- ROUTER O (48)
        data_in_O => (others => '0'),
        data_in_valid_O => '0',
        data_in_vc_busy_O => open,
        data_in_vc_credits_O => open,
        
        data_out_O  => open,
        data_out_valid_O => open,
        data_out_vc_busy_O => (others => '0'),
        data_out_vc_credits_O => (others => '0'),
        
        -- ROUTER P (88)
        data_in_P => data_SNA_1_to_rP,
        data_in_valid_P => data_valid_SNA_1_to_rP,
        data_in_vc_busy_P => vc_busy_rP_to_SNA_1,
        data_in_vc_credits_P => vc_credits_rP_to_SNA_1,
        
        data_out_P => data_rP_to_SNA_1,
        data_out_valid_P => data_valid_rP_to_SNA_1,
        data_out_vc_busy_P => vc_busy_SNA_1_to_rP,
        data_out_vc_credits_P => vc_credits_SNA_1_to_rP
    );
    
    -- AXI_master_network_adapter KOMPONENTA
    MNA_0: AXI_master_network_adapter
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0001",
            local_address_y => "0001",
            clock_divider => clock_divider,
            
            write_threshold => MNA_write_threshold,
            read_threshold => MNA_read_threshold,
            injection_vc => 0,
            node_address_size => node_address_size
        )
        
        port map (
            clk => clk,
            rst => rst,
                
            -- AXI WRITE ADDRESS CHANNEL 
            AWADDR => MNA_0_AWADDR,
            AWPROT => MNA_0_AWPROT,
            AWVALID => MNA_0_AWVALID,
            AWREADY => MNA_0_AWREADY,
            
            -- AXI WRITE DATA CHANNEL
            WDATA => MNA_0_WDATA,
            WSTRB => MNA_0_WSTRB,
            WVALID => MNA_0_WVALID,
            WREADY => MNA_0_WREADY,
            
            -- AXI READ ADDRESS CHANNEL
            ARADDR => MNA_0_ARADDR,
            ARPROT => MNA_0_ARPROT,
            ARVALID => MNA_0_ARVALID,
            ARREADY => MNA_0_ARREADY,
            
            -- AXI WRITE RESPONSE CHANNEL
            BRESP => MNA_0_BRESP,
            BVALID => MNA_0_BVALID,
            BREADY => MNA_0_BREADY,
            
            -- AXI READ RESPONSE CHANNEL
            RDATA => MNA_0_RDATA,
            RRESP => MNA_0_RRESP,
            RVALID => MNA_0_RVALID,
            RREADY => MNA_0_RREADY,
            
            -- NOC INTERFACE - FLIT AXI -> NOC
            AXI_noc_data => data_MNA_0_to_rA, 
            AXI_noc_data_valid => data_valid_MNA_0_to_rA,
                    
            noc_AXI_vc_busy => vc_busy_rA_to_MNA_0,
            noc_AXI_vc_credits => vc_credits_rA_to_MNA_0,
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data => data_rA_to_MNA_0,     
            noc_AXI_data_valid => data_valid_rA_to_MNA_0,
            
            AXI_noc_vc_busy => vc_busy_MNA_0_to_rA,
            AXI_noc_vc_credits => vc_credits_MNA_0_to_rA
        );
        
    -- AXI_master_network_adapter KOMPONENTA
    MNA_1: AXI_master_network_adapter
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0001",
            local_address_y => "1000",
            clock_divider => clock_divider,
            
            write_threshold => MNA_write_threshold,
            read_threshold => MNA_read_threshold,
            injection_vc => 0,
            node_address_size => node_address_size
        )
        
        port map (
            clk => clk,
            rst => rst,
                
            -- AXI WRITE ADDRESS CHANNEL 
            AWADDR => MNA_1_AWADDR,
            AWPROT => MNA_1_AWPROT,
            AWVALID => MNA_1_AWVALID,
            AWREADY => MNA_1_AWREADY,
            
            -- AXI WRITE DATA CHANNEL
            WDATA => MNA_1_WDATA,
            WSTRB => MNA_1_WSTRB,
            WVALID => MNA_1_WVALID,
            WREADY => MNA_1_WREADY,
            
            -- AXI READ ADDRESS CHANNEL
            ARADDR => MNA_1_ARADDR,
            ARPROT => MNA_1_ARPROT,
            ARVALID => MNA_1_ARVALID,
            ARREADY => MNA_1_ARREADY,
            
            -- AXI WRITE RESPONSE CHANNEL
            BRESP => MNA_1_BRESP,
            BVALID => MNA_1_BVALID,
            BREADY => MNA_1_BREADY,
            
            -- AXI READ RESPONSE CHANNEL
            RDATA => MNA_1_RDATA,
            RRESP => MNA_1_RRESP,
            RVALID => MNA_1_RVALID,
            RREADY => MNA_1_RREADY,
            
            -- NOC INTERFACE - FLIT AXI -> NOC
            AXI_noc_data => data_MNA_1_to_rM, 
            AXI_noc_data_valid => data_valid_MNA_1_to_rM,
                    
            noc_AXI_vc_busy => vc_busy_rM_to_MNA_1,
            noc_AXI_vc_credits => vc_credits_rM_to_MNA_1,
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data => data_rM_to_MNA_1,     
            noc_AXI_data_valid => data_valid_rM_to_MNA_1,
            
            AXI_noc_vc_busy => vc_busy_MNA_1_to_rM,
            AXI_noc_vc_credits => vc_credits_MNA_1_to_rM
        );
        
    -- AXI_slave_network_adapter KOMPONENTA
    SNA_0: AXI_slave_network_adapter
    
        generic map (
            vc_num => vc_num,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            clock_divider => clock_divider,
            
            write_threshold => SNA_write_threshold,
            read_threshold => SNA_read_threshold
        )
        
        port map (
            clk => clk,
            rst => rst,
            
            -- AXI WRITE ADDRESS CHANNEL 
            AWADDR => SNA_0_AWADDR,
            AWPROT => SNA_0_AWPROT,
            AWVALID => SNA_0_AWVALID,
            AWREADY => SNA_0_AWREADY,
            
            -- AXI WRITE DATA CHANNEL
            WDATA => SNA_0_WDATA,
            WSTRB => SNA_0_WSTRB,
            WVALID => SNA_0_WVALID,
            WREADY => SNA_0_WREADY,
            
            -- AXI READ ADDRESS CHANNEL
            ARADDR => SNA_0_ARADDR,
            ARPROT => SNA_0_ARPROT,
            ARVALID => SNA_0_ARVALID,
            ARREADY => SNA_0_ARREADY,
            
            -- AXI WRITE RESPONSE CHANNEL
            BRESP => SNA_0_BRESP,
            BVALID => SNA_0_BVALID,
            BREADY => SNA_0_BREADY,
            
            -- AXI READ RESPONSE CHANNEL
            RDATA => SNA_0_RDATA,
            RRESP => SNA_0_RRESP,
            RVALID => SNA_0_RVALID,
            RREADY => SNA_0_RREADY,
            
            -- NOC INTERFACE - FLIT AXI -> NOC
            AXI_noc_data => data_SNA_0_to_rH,
            AXI_noc_data_valid => data_valid_SNA_0_to_rH,
            
            noc_AXI_vc_busy => vc_busy_rH_to_SNA_0,
            noc_AXI_vc_credits => vc_credits_rH_to_SNA_0,
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data => data_rH_to_SNA_0,
            noc_AXI_data_valid => data_valid_rH_to_SNA_0,
            
            AXI_noc_vc_busy => vc_busy_SNA_0_to_rH,
            AXI_noc_vc_credits => vc_credits_SNA_0_to_rH
        );
        
    -- AXI_slave_network_adapter KOMPONENTA
    SNA_1: AXI_slave_network_adapter
    
        generic map (
            vc_num => vc_num,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            clock_divider => clock_divider,
            
            write_threshold => SNA_write_threshold,
            read_threshold => SNA_read_threshold
        )
        
        port map (
            clk => clk,
            rst => rst,
            
            -- AXI WRITE ADDRESS CHANNEL 
            AWADDR => SNA_1_AWADDR,
            AWPROT => SNA_1_AWPROT,
            AWVALID => SNA_1_AWVALID,
            AWREADY => SNA_1_AWREADY,
            
            -- AXI WRITE DATA CHANNEL
            WDATA => SNA_1_WDATA,
            WSTRB => SNA_1_WSTRB,
            WVALID => SNA_1_WVALID,
            WREADY => SNA_1_WREADY,
            
            -- AXI READ ADDRESS CHANNEL
            ARADDR => SNA_1_ARADDR,
            ARPROT => SNA_1_ARPROT,
            ARVALID => SNA_1_ARVALID,
            ARREADY => SNA_1_ARREADY,
            
            -- AXI WRITE RESPONSE CHANNEL
            BRESP => SNA_1_BRESP,
            BVALID => SNA_1_BVALID,
            BREADY => SNA_1_BREADY,
            
            -- AXI READ RESPONSE CHANNEL
            RDATA => SNA_1_RDATA,
            RRESP => SNA_1_RRESP,
            RVALID => SNA_1_RVALID,
            RREADY => SNA_1_RREADY,
            
            -- NOC INTERFACE - FLIT AXI -> NOC
            AXI_noc_data => data_SNA_1_to_rP,
            AXI_noc_data_valid => data_valid_SNA_1_to_rP,
            
            noc_AXI_vc_busy => vc_busy_rP_to_SNA_1,
            noc_AXI_vc_credits => vc_credits_rP_to_SNA_1,
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data => data_rP_to_SNA_1,
            noc_AXI_data_valid => data_valid_rP_to_SNA_1,
            
            AXI_noc_vc_busy => vc_busy_SNA_1_to_rP,
            AXI_noc_vc_credits => vc_credits_SNA_1_to_rP
        );
    
end Behavioral;
