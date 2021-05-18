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
-- Additional Comments: Prva verzija SNA_req_flowa - sadrzi SNA_req_AXI_handshake_controller, SNA_req_buffer_controller, noc_to_AXI_FIFO_buffer i noc_receiver
-- Revision 0.2 - 2021-05-18 - Mrkovic
-- Additional Comments: Dotjerana verzija SNA_req_flowa
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
        AWPROT : out std_logic_vector(2 downto 0);
        AWVALID : out std_logic;
        AWREADY : in std_logic;
        
        -- AXI WRITE DATA CHANNEL
        WDATA : out std_logic_vector(31 downto 0);
        WSTRB : out std_logic_vector(3 downto 0);
        WVALID : out std_logic;
        WREADY : in std_logic;
        
        -- AXI READ ADDRESS CHANNEL
        ARADDR : out std_logic_vector(31 downto 0);
        ARPROT : out std_logic_vector(2 downto 0);
        ARVALID : out std_logic;
        ARREADY : in std_logic;
        
        -- NOC INTERFACE - FLIT AXI <- NOC
        noc_AXI_data : in std_logic_vector(flit_size - 1 downto 0);        
        noc_AXI_data_valid : in std_logic;
        
        AXI_noc_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
        AXI_noc_vc_credits : out std_logic_vector(vc_num - 1 downto 0);
        
        -- resp_flow (SNA_resp_AXI_handshake_controller)
        resp_write : out std_logic;
        resp_read : out std_logic;
        
        -- resp_flow (SNA_resp_buffer_controller)
        r_addr : out std_logic_vector(address_size - 1 downto 0);
        r_vc : out std_logic_vector(vc_num - 1 downto 0);
        
        -- resp_flow (AXI_to_noc_FIFO_buffer)
        buffer_write_ready : in std_logic;
        buffer_read_ready : in std_logic;
        
        -- t_monitor
        SNA_ready : in std_logic;
        t_begun : out std_logic
    );

end SNA_req_flow;

architecture Behavioral of SNA_req_flow is

    -- INTERNI SIGNALI

    -- HANDSHAKE CONTROLLER - BUFFER CONTROLLER
    signal op_write : std_logic;
    signal op_read : std_logic;
    
    signal addr : std_logic_vector(31 downto 0);
    signal data : std_logic_vector(31 downto 0);
    signal prot : std_logic_vector(2 downto 0);
    signal strb : std_logic_vector(3 downto 0);
    
    -- BUFFER CONTROLLER - FIFO BUFFER
    signal flit_out : std_logic_vector(flit_size - 1 downto 0);
    signal has_tail : std_logic;
    
    signal right_shift : std_logic;
    
    -- BUFFER CONTROLLER - NOC RECEIVER
    signal vc_credits : std_logic_vector(vc_num - 1 downto 0);

    -- FIFO BUFFER - NOC RECEIVER
    signal flit_in : std_logic_vector(flit_size - 1 downto 0);
    signal flit_in_valid : std_logic;
    
    signal full : std_logic;
    
begin

    -- SNA_req_AXI_handshake_controller KOMPONENTA
    handshake_controller : SNA_req_AXI_handshake_controller
    
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
            
            -- SNA_req_buffer_controller
            op_write => op_write,
            op_read => op_read,
            
            addr => addr,
            data => data,
            prot => prot,
            strb => strb,
            
            -- resp_flow (AXI_to_noc_FIFO_buffer)
            buffer_write_ready => buffer_write_ready,
            buffer_read_ready => buffer_read_ready
        );
    
    -- SNA_req_buffer_controller KOMPONENTA
    buffer_controller : SNA_req_buffer_controller
    
        generic map(
            vc_num => vc_num,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size
        )
        
        port map(
            clk => clk,
            rst => rst, 
            
            -- SNA_req_AXI_handshake_controller
            op_write => op_write,
            op_read => op_read,
            
            addr => addr,
            data => data,
            prot => prot,
            strb => strb,
            
            -- noc_to_AXI_FIFO_buffer
            flit_out => flit_out,
            has_tail => has_tail,
            
            right_shift => right_shift,
            
            -- noc_receiver
            vc_credits => vc_credits,
            
            -- resp_flow (SNA_resp_AXI_handshake_controller)
            resp_write => resp_write,
            resp_read => resp_read,
            
            -- resp_flow (SNA_resp_buffer_controller)
            r_addr => r_addr,
            r_vc => r_vc,
            
            -- t_monitor
            SNA_ready => SNA_ready,
            t_begun => t_begun
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