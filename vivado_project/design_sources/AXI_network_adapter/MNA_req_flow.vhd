----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 06.05.2021 12:10:18
-- Design Name: AXI_Network_Adapter
-- Module Name: MNA_req_flow - Behavioral
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
-- Additional Comments: Prva verzija MNA_req_flow-a - sadrzi MNA_req_AXI_handshake_controller, MNA_req_buffer_controller i AXI_to_noc_FIFO_buffer
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

entity MNA_req_flow is

    Generic (
        vc_num : integer := const_vc_num;
        mesh_size_x : integer := const_mesh_size_x;
        mesh_size_y : integer := const_mesh_size_y;
        address_size : integer := const_address_size;
        payload_size : integer := const_payload_size;
        flit_size : integer := const_flit_size;
        node_address_size : integer := const_node_address_size;
        buffer_size : integer := const_buffer_size;
        write_threshold : integer := const_MNA_write_threshold;
        read_threshold : integer := const_MNA_read_threshold;
        clock_divider : integer := const_clock_divider;
        
        injection_vc : integer := const_default_injection_vc;
        local_address_x : std_logic_vector(const_mesh_size_x - 1 downto 0) := const_default_address_x;
        local_address_y : std_logic_vector(const_mesh_size_y - 1 downto 0) := const_default_address_y
    );
    
    Port (
        clk : in std_logic;
        rst : in std_logic; 
            
        -- AXI WRITE ADDRESS CHANNEL           
        AWADDR : in std_logic_vector(31 downto 0);
        AWVALID : in std_logic;
        AWREADY : out std_logic;
        
        -- AXI WRITE DATA CHANNEL
        WDATA : in std_logic_vector(31 downto 0);
        WVALID : in std_logic;
        WREADY : out std_logic;
        
        -- AXI WRITE AUXILIARY SIGNALS
        AWPROT : in std_logic_vector(2 downto 0);
        WSTRB : in std_logic_vector(3 downto 0);
        
        -- AXI READ ADDRESS CHANNEL
        ARADDR : in std_logic_vector(31 downto 0);
        ARVALID : in std_logic;
        ARREADY : out std_logic;
        
        -- AXI READ AUXILIARY SIGNALS
        ARPROT : in std_logic_vector(2 downto 0);
        
        -- NOC INTERFACE
        AXI_noc_data : out std_logic_vector(flit_size - 1 downto 0);
        AXI_noc_data_valid : out std_logic;
                
        noc_AXI_vc_busy : in std_logic_vector(vc_num - 1 downto 0);
        noc_AXI_vc_credits : in std_logic_vector(vc_num - 1 downto 0)
    );

end MNA_req_flow;

architecture Behavioral of MNA_req_flow is

    -- INTERNI SIGNALI
    
    -- HANDSHAKE CONTROLLER - BUFFER CONTROLLER
    signal op_write : std_logic;
    signal op_read : std_logic;
    
    signal addr : std_logic_vector(31 downto 0);
    signal data : std_logic_vector(31 downto 0);
    signal prot : std_logic_vector(2 downto 0);
    signal strb : std_logic_vector(3 downto 0);
    
    -- HANDSHAKE CONTROLLER - BUFFER
    signal buffer_read_ready : std_logic;
    signal buffer_write_ready : std_logic;
    
    -- BUFFER CONTROLLER - BUFFER
    signal flit_in : std_logic_vector(flit_size - 1 downto 0);
    signal flit_in_valid : std_logic;
    
    -- BUFFER - NOC_INJECTOR
    signal flit_out : std_logic_vector(flit_size - 1 downto 0);
    signal empty : std_logic;
                
    signal right_shift : std_logic;

begin

    -- MNA_req_AXI_handshake_controller KOMPONENTA
    handshake_controller : MNA_req_AXI_handshake_controller
    
        port map(
            clk => clk,
            rst => rst, 
              
            AWADDR => AWADDR,
            AWVALID => AWVALID,
            AWREADY => AWREADY,
            
            WDATA => WDATA,
            WVALID => WVALID,
            WREADY => WREADY,
            
            AWPROT => AWPROT,
            WSTRB => WSTRB,
            
            ARADDR => ARADDR,
            ARVALID => ARVALID,
            ARREADY => ARREADY,
            
            ARPROT => ARPROT,
            
            op_write => op_write,
            op_read => op_read,
            
            buffer_read_ready => buffer_read_ready,
            buffer_write_ready => buffer_write_ready,
            
            addr => addr,
            data => data,
            prot => prot,
            strb => strb
        );

    -- MNA_req_buffer_controller KOMPONENTA
    buffer_controller : MNA_req_buffer_controller
    
        generic map(
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            node_address_size => node_address_size,
            injection_vc => injection_vc,
            local_address_x => local_address_x,
            local_address_y => local_address_y
        )
        
        port map(
            clk => clk,
            rst => rst, 
           
            flit_in => flit_in,
            flit_in_valid => flit_in_valid,
            
            op_write => op_write,
            op_read => op_read,
            
            addr => addr,
            data => data,
            prot => prot,
            strb => strb
        );

    -- AXI_to_noc_FIFO_buffer KOMPONENTA
    FIFO_buffer : AXI_to_noc_FIFO_buffer
    
        generic map(
            flit_size => flit_size,
            buffer_size => buffer_size,
            write_threshold => write_threshold,
            read_threshold => read_threshold
        )
        
        port map(
            clk => clk,
            rst => rst, 
           
            flit_in => flit_in,
            flit_in_valid => flit_in_valid,
            
            flit_out => flit_out,
            empty => empty,
            
            right_shift => right_shift,
            
            buffer_write_ready => buffer_write_ready,
            buffer_read_ready => buffer_read_ready
        );

    -- noc_injector KOMPONENTA
    injector : noc_injector
    
        generic map(
            vc_num => vc_num,
            flit_size => flit_size,
            buffer_size => buffer_size,
            clock_divider => clock_divider,
            
            injection_vc => injection_vc
        )
        
        port map(
            clk => clk,
            rst => rst,
                       
            flit_out => flit_out,
            empty => empty,
                    
            right_shift => right_shift,
            
            AXI_noc_data => AXI_noc_data,
            AXI_noc_data_valid => AXI_noc_data_valid,
            
            noc_AXI_vc_busy => noc_AXI_vc_busy,
            noc_AXI_vc_credits => noc_AXI_vc_credits
        );

end Behavioral;