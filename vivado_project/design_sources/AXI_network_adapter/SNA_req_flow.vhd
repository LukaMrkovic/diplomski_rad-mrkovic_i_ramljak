----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 12.05.2021 11:31:30
-- Design Name: AXI_Network_Adapter
-- Module Name: SNA_req_flow - Behavioral
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
-- Revision 0.1 - 2021-05-12 - Mrkovic
-- Additional Comments: Prva verzija SNA_req_flow-a - sadrzi SNA_req_AXI_handshake_controller, SNA_req_buffer_controller, noc_to_AXI_FIFO_buffer i noc_receiver
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

entity SNA_req_flow is

    Generic (
        vc_num : integer := const_vc_num;
        address_size : integer := const_address_size;
        payload_size : integer := const_payload_size;
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size;
        clock_divider : integer := const_clock_divider
    );
    
    Port (
        clk : in std_logic;
        rst : in std_logic; 

        -- AXI WRITE ADDRESS CHANNEL 
        AWADDR : out std_logic_vector(31 downto 0);
        AWVALID : out std_logic;
        AWREADY : in std_logic;

        -- AXI WRITE DATA CHANNEL
        WDATA : out std_logic_vector(31 downto 0);
        WVALID : out std_logic;
        WREADY : in std_logic;
        
        -- AXI WRITE AUXILIARY SIGNALS
        AWPROT : out std_logic_vector(2 downto 0);
        WSTRB : out std_logic_vector(3 downto 0);

        -- AXI READ ADDRESS CHANNEL
        ARADDR : out std_logic_vector(31 downto 0);
        ARVALID : out std_logic;
        ARREADY : in std_logic;

        -- AXI READ AUXILIARY SIGNALS
        ARPROT : out std_logic_vector(2 downto 0);

        -- NOC INTERFACE
        noc_AXI_data : in std_logic_vector(flit_size - 1 downto 0);        
        noc_AXI_data_valid : in std_logic;
        
        AXI_noc_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
        AXI_noc_vc_credits : out std_logic_vector(vc_num - 1 downto 0);
        
        -- RESP FLOW INTERFACE
        SNA_ready : in std_logic;
        t_begun : out std_logic;
        
        resp_write : out std_logic;
        resp_read : out std_logic;
        
        r_addr : out std_logic_vector(address_size - 1 downto 0);
        r_vc : out std_logic_vector(vc_num - 1 downto 0);
        
        buffer_read_ready : in std_logic;
        buffer_write_ready : in std_logic
    );

end SNA_req_flow;

architecture Behavioral of SNA_req_flow is

    -- INTERNI SIGNALI

    -- NOC RECEIVER - BUFFER
    signal flit_in : std_logic_vector(flit_size - 1 downto 0);
    signal flit_in_valid : std_logic;
    
    signal full : std_logic;
    
    -- NOC RECEIVER - BUFFER CONTROLLER
    signal 
vc_credits : std_logic_vector(vc_num - 1 downto 0);
    
    -- BUFFER - BUFFER CONTROLLER
    signal flit_out : std_logic_vector(flit_size - 1 downto 0);
    signal has_tail : std_logic;
    signal right_shift : std_logic;
    
    -- BUFFER CONTROLLER - HANDSHAKE CONTROLLER
    signal op_write : std_logic;
    signal op_read : std_logic;
    signal addr : std_logic_vector(31 downto 0);
    signal data : std_logic_vector(31 downto 0);
    signal prot : std_logic_vector(2 downto 0);
    signal strb : std_logic_vector(3 downto 0);

begin

    -- SNA_req_AXI_handshake_controller KOMPONENTA
    handshake_controller : SNA_req_AXI_handshake_controller
    
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
    
    -- SNA_req_buffer_controller KOMPONENTA
    buffer_controller : SNA_req_buffer_controller
    
        generic map(
            vc_num => vc_num,
            flit_size => flit_size,
            address_size => address_size,
            payload_size => payload_size
        )
        
        port map(
            clk => clk,
            rst => rst, 
           
            flit_out => flit_out,
            has_tail => has_tail,
            
            right_shift => right_shift,
            vc_credits => vc_credits,
            
            op_write => op_write,
            op_read => op_read,
            
            addr => addr,
            data => data,
            prot => prot,
            strb => strb,
            
            SNA_ready => SNA_ready,
            t_begun => t_begun,
            
            resp_write => resp_write,
            resp_read => resp_read,
            
            r_addr => r_addr,
            r_vc => r_vc
        );
    
    -- noc_to_AXI_FIFO_buffer KOMPONENTA
    FIFO_buffer : noc_to_AXI_FIFO_buffer
    
        generic map(
            flit_size => flit_size,
            buffer_size => buffer_size
        )
        
        port map(
            clk => clk,
            rst => rst, 
           
            flit_in => flit_in,
            flit_in_valid => flit_in_valid,
            
            flit_out => flit_out,
            has_tail => has_tail,
            
            right_shift => right_shift,
            
            full => full
        );
    
    -- noc_receiver KOMPONENTA
    receiver : noc_receiver 
    
        generic map(
            vc_num => vc_num,
            flit_size => flit_size,
            clock_divider => clock_divider
        )
        
        port map(
            clk => clk,
            rst => rst, 
            
            noc_AXI_data => noc_AXI_data,   
            noc_AXI_data_valid => noc_AXI_data_valid,
            
            AXI_noc_vc_busy => AXI_noc_vc_busy,
            AXI_noc_vc_credits => AXI_noc_vc_credits,
            
            flit_in => flit_in,
            flit_in_valid => flit_in_valid,
            
            vc_credits => vc_credits
        );

end Behavioral;
