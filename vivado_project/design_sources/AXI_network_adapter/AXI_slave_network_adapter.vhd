----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 12.05.2021 16:19:39
-- Design Name: AXI_Network_Adapter
-- Module Name: AXI_slave_network_adapter - Behavioral
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
-- Additional Comments: Prva verzija potpunog AXI_slave_network_adaptera
-- Revision 0.2 - 2021-05-19 - Mrkovic
-- Additional Comments: Dotjerana verzija AXI_slave_network_adaptera
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

entity AXI_slave_network_adapter is

    Generic (
        vc_num : integer := const_vc_num;
        address_size : integer := const_address_size;
        payload_size : integer := const_payload_size;
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size;
        clock_divider : integer := const_clock_divider;
        
        write_threshold : integer := const_SNA_write_threshold;
        read_threshold : integer := const_SNA_read_threshold
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
        
        -- AXI WRITE RESPONSE CHANNEL
        BRESP : in std_logic_vector(1 downto 0);
        BVALID : in std_logic;
        BREADY : out std_logic;
        
        -- AXI READ RESPONSE CHANNEL
        RDATA : in std_logic_vector(31 downto 0);
        RRESP : in std_logic_vector(1 downto 0);
        RVALID : in std_logic;
        RREADY : out std_logic;
        
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

end AXI_slave_network_adapter;

architecture Behavioral of AXI_slave_network_adapter is

    -- INTERNI SIGNALI
    
    -- SNA_req_buffer_controller -> SNA_resp_AXI_handshake_controller
    signal resp_write : std_logic;
    signal resp_read : std_logic;
    
    -- SNA_req_buffer_controller -> SNA_resp_buffer_controller
    signal r_addr : std_logic_vector(address_size - 1 downto 0);
    signal r_vc : std_logic_vector(vc_num - 1 downto 0);
    
    -- AXI_to_noc_FIFO_buffer -> SNA_req_AXI_handshake_controller
    signal buffer_write_ready : std_logic;
    signal buffer_read_ready : std_logic;
    
    -- t_monitor
    signal SNA_ready : std_logic;
    signal t_begun : std_logic;
    signal t_end : std_logic;

begin

    -- SNA_req_flow KOMPONENTA
    req_flow : SNA_req_flow

        generic map(
            vc_num => vc_num,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            clock_divider => clock_divider
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
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data => noc_AXI_data,
            noc_AXI_data_valid => noc_AXI_data_valid,
            
            AXI_noc_vc_busy => AXI_noc_vc_busy,
            AXI_noc_vc_credits => AXI_noc_vc_credits,
            
            -- resp_flow (SNA_resp_AXI_handshake_controller)
            resp_write => resp_write,
            resp_read => resp_read,
            
            -- resp_flow (SNA_resp_buffer_controller)
            r_addr => r_addr,
            r_vc => r_vc,
            
            -- resp_flow (AXI_to_noc_FIFO_buffer)
            buffer_write_ready => buffer_write_ready,
            buffer_read_ready => buffer_read_ready,
            
            -- t_monitor
            SNA_ready => SNA_ready,
            t_begun => t_begun
        );

    -- SNA_resp_flow KOMPONENTA
    resp_flow : SNA_resp_flow

        generic map(
            vc_num => vc_num,
            address_size => address_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            clock_divider => clock_divider,
            
            write_threshold => write_threshold,
            read_threshold => read_threshold
        )
        
        port map(
            clk => clk,
            rst => rst,
                
            -- AXI WRITE RESPONSE CHANNEL
            BRESP => BRESP,
            BVALID => BVALID,
            BREADY => BREADY,
            
            -- AXI READ RESPONSE CHANNEL
            RDATA => RDATA,
            RRESP => RRESP,
            RVALID => RVALID,
            RREADY => RREADY,
            
            -- NOC INTERFACE - FLIT AXI -> NOC
            AXI_noc_data => AXI_noc_data,
            AXI_noc_data_valid => AXI_noc_data_valid,
            
            noc_AXI_vc_busy => noc_AXI_vc_busy,
            noc_AXI_vc_credits => noc_AXI_vc_credits,
            
            -- req_flow (SNA_req_AXI_handshake_controller)
            buffer_write_ready => buffer_write_ready,
            buffer_read_ready => buffer_read_ready,
            
            -- req_flow (SNA_req_buffer_controller)
            resp_write => resp_write,
            resp_read => resp_read,
            
            r_addr => r_addr,
            r_vc => r_vc,
            
            -- t_monitor
            t_end => t_end
        );

    -- TRANSACTION MONITOR PROCES
    t_monitor : process (clk) is
    
        variable SNA_ready_var : std_logic;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                SNA_ready_var := '1';
                
                SNA_ready <= '1';
                
            else
            
                if t_end = '1' then
                
                    SNA_ready_var := '1';
                
                end if;
                
                if t_begun = '1' then
                
                    SNA_ready_var := '0';
                
                end if;
            
                SNA_ready <= SNA_ready_var;
            
            end if;
        end if;
    
    end process;

end Behavioral;