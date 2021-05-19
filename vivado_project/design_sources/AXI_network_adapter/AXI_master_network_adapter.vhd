----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/12/2021 08:51:54 PM
-- Design Name: AXI_Network_Adapter 
-- Module Name: AXI_master_network_adapter - Behavioral
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
-- Revision 0.1 - 2021-05-12 - Ramljak
-- Additional Comments: Prva verzija potpunog AXI_master_network_adaptera
-- Revision 0.2 - 2021-05-19 - Mrkovic
-- Additional Comments: Dotjerana verzija AXI_master_network_adaptera
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

entity AXI_master_network_adapter is

    Generic (
        vc_num : integer := const_vc_num;
        mesh_size_x : integer := const_mesh_size_x;
        mesh_size_y : integer := const_mesh_size_y;
        address_size : integer := const_address_size;
        payload_size : integer := const_payload_size;
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size;
        local_address_x : std_logic_vector(const_mesh_size_x - 1 downto 0) := const_default_address_x;
        local_address_y : std_logic_vector(const_mesh_size_y - 1 downto 0) := const_default_address_y;
        clock_divider : integer := const_clock_divider;
        
        write_threshold : integer := const_MNA_write_threshold;
        read_threshold : integer := const_MNA_read_threshold;
        injection_vc : integer := const_default_injection_vc;
        node_address_size : integer := const_node_address_size
    );
    
    Port (
        clk : in std_logic;
        rst : in std_logic; 
        
        -- AXI WRITE ADDRESS CHANNEL           
        AWADDR : in std_logic_vector(31 downto 0);
        AWPROT : in std_logic_vector(2 downto 0);
        AWVALID : in std_logic;
        AWREADY : out std_logic;
        
        -- AXI WRITE DATA CHANNEL
        WDATA : in std_logic_vector(31 downto 0);
        WSTRB : in std_logic_vector(3 downto 0);
        WVALID : in std_logic;
        WREADY : out std_logic;
        
        -- AXI READ ADDRESS CHANNEL
        ARADDR : in std_logic_vector(31 downto 0);
        ARPROT : in std_logic_vector(2 downto 0);
        ARVALID : in std_logic;
        ARREADY : out std_logic;
        
        -- AXI WRITE RESPONSE CHANNEL   
        BRESP : out std_logic_vector(1 downto 0);
        BVALID : out std_logic;
        BREADY : in std_logic;
        
        -- AXI READ RESPONSE CHANNEL
        RDATA : out std_logic_vector(31 downto 0);
        RRESP : out std_logic_vector(1 downto 0);
        RVALID : out std_logic;
        RREADY : in std_logic;
        
        -- NOC INTERFACE - FLIT AXI -> NOC
        AXI_noc_data : out std_logic_vector(flit_size - 1 downto 0);
        AXI_noc_data_valid : out std_logic;
                
        noc_AXI_vc_busy : in std_logic_vector(vc_num - 1 downto 0);
        noc_AXI_vc_credits : in std_logic_vector(vc_num - 1 downto 0);
        
        -- NOC INTERFACE - FLIT AXI <- NOC
        noc_AXI_data : in std_logic_vector(flit_size - 1 downto 0);        
        noc_AXI_data_valid : in std_logic;
        
        AXI_noc_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
        AXI_noc_vc_credits : out std_logic_vector(vc_num - 1 downto 0)
    );

end AXI_master_network_adapter;

architecture Behavioral of AXI_master_network_adapter is

begin

    -- MNA_req_flow KOMPONENTA
    req_flow: MNA_req_flow
    
        generic map(
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => local_address_x,
            local_address_y => local_address_y,
            clock_divider => clock_divider,
            
            write_threshold => write_threshold,
            read_threshold => read_threshold,
            injection_vc => injection_vc,
            node_address_size => node_address_size
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- AXI WRITE ADDRESS CHANNEL           
            AWADDR => AWADDR,
            AWPROT => AWPROT,
            AWVALID => AWVALID,
            AWREADY => AWREADY,
            
            -- AXI WRITE DATA CHANNEL
            WDATA => WDATA,
            WSTRB => WSTRB,
            WVALID => WVALID,
            WREADY => WREADY,
            
            -- AXI READ ADDRESS CHANNEL
            ARADDR => ARADDR,
            ARPROT => ARPROT,
            ARVALID => ARVALID,
            ARREADY => ARREADY,
            
            -- NOC INTERFACE - FLIT AXI -> NOC
            AXI_noc_data => AXI_noc_data,
            AXI_noc_data_valid => AXI_noc_data_valid,
            
            noc_AXI_vc_busy => noc_AXI_vc_busy,
            noc_AXI_vc_credits => noc_AXI_vc_credits
        );
        
    -- MNA_resp_flow KOMPONENTA
    resp_flow: MNA_resp_flow
    
        generic map(
            vc_num => vc_num,
            flit_size => flit_size,
            buffer_size => buffer_size,
            clock_divider => clock_divider
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- AXI WRITE ADDRESS CHANNEL           
            BRESP => BRESP,
            BVALID => BVALID,
            BREADY => BREADY,
            
            -- AXI WRITE DATA CHANNEL
            RDATA => RDATA,
            RRESP => RRESP,
            RVALID => RVALID,
            RREADY => RREADY,
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data => noc_AXI_data,   
            noc_AXI_data_valid => noc_AXI_data_valid,
        
            AXI_noc_vc_busy => AXI_noc_vc_busy,
            AXI_noc_vc_credits => AXI_noc_vc_credits
        );

end Behavioral;