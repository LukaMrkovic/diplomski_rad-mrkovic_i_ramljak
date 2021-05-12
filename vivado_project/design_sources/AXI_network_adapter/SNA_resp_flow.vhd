----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/12/2021 11:24:31 AM
-- Design Name: AXI_Network_Adapter
-- Module Name: SNA_resp_flow - Behavioral
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
-- Revision 0.1 - 2021-05-12 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija SNA_resp_flow-a - sadrzi SNA_resp_AXI_handshake_controller, SNA_resp_buffer_controller i AXI_to_noc_FIFO_buffer
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

entity SNA_resp_flow is

    Generic (
        vc_num : integer := const_vc_num;
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size;
        address_size : integer := const_address_size;
        write_threshold : integer := const_MNA_write_threshold;
        read_threshold : integer := const_MNA_read_threshold;
        clock_divider : integer := const_clock_divider
    );
    
    Port (
        clk : in std_logic;
        rst : in std_logic;
        
        -- AXI WRITE RESPONSE
        BREADY : out std_logic;
        BRESP : in std_logic_vector(1 downto 0);
        BVALID : in std_logic;
        
        -- AXI READ RESPONSE
        RREADY : out std_logic;
        RDATA : in std_logic_vector(31 downto 0);
        RRESP : in std_logic_vector(1 downto 0);
        RVALID : in std_logic;
        
        -- SNA REQ FLOW
        resp_write : in std_logic;
        resp_read : in std_logic;
        r_addr : in std_logic_vector(address_size - 1 downto 0);
        r_vc : in std_logic_vector(vc_num - 1 downto 0);
        
        buffer_read_ready : out std_logic;
        buffer_write_ready : out std_logic;
        
        -- T_MONITOR
        t_end : out std_logic;
        
        -- NOC INTERFACE
        AXI_noc_data : out std_logic_vector(flit_size - 1 downto 0);        
        AXI_noc_data_valid : out std_logic;
        
        noc_AXI_vc_busy : in std_logic_vector(vc_num - 1 downto 0);
        noc_AXI_vc_credits : in std_logic_vector(vc_num - 1 downto 0)
    );

end SNA_resp_flow;

architecture Behavioral of SNA_resp_flow is

    -- INTERNI SIGNALI
    
    -- HANDSHAKE CONTROLLER - BUFFER CONTROLLER
    signal op_write : std_logic;
    signal op_read : std_logic;
    
    signal data : std_logic_vector(31 downto 0);
    signal resp : std_logic_vector(1 downto 0);
    
    -- HANDSHAKE CONTROLLER - FIFO BUFFER
    signal buffer_read_ready_int : std_logic;
    signal buffer_write_ready_int : std_logic;
    
    -- BUFFER CONTROLLER - FIFO BUFFER
    signal flit_in : std_logic_vector(flit_size - 1 downto 0);
    signal flit_in_valid : std_logic;
    
    -- FIFO BUFFER - NOC INJECTOR
    signal flit_out : std_logic_vector(flit_size - 1 downto 0);
    signal empty : std_logic;
                
    signal right_shift : std_logic;

begin

    -- SNA_resp_AXI_handshake_controller KOMPONENTA
    handshake_controller : SNA_resp_AXI_handshake_controller
    
        port map(
            clk => clk,
            rst => rst,
            
            BREADY => BREADY,
            BRESP => BRESP,
            BVALID => BVALID,
            
            RREADY => RREADY,
            RDATA => RDATA,
            RRESP => RRESP,
            RVALID => RVALID,
            
            resp_write => resp_write,
            resp_read => resp_read,
            
            op_write => op_write,
            op_read => op_read,
            
            buffer_read_ready => buffer_read_ready_int,
            buffer_write_ready => buffer_write_ready_int,
            
            data => data,
            resp => resp
        );

    -- SNA_resp_buffer_controller KOMPONENTA
    buffer_controller : SNA_resp_buffer_controller

        generic map (
            flit_size => flit_size,
            vc_num => vc_num,
            address_size => address_size
        )
                      
        port map (
            clk => clk,
            rst => rst,
                       
            flit_in => flit_in,
            flit_in_valid => flit_in_valid,
            
            op_write => op_write,
            op_read => op_read,
            
            data => data,
            resp => resp,

            r_addr => r_addr,
            r_vc => r_vc,
            
            t_end => t_end
        );
        
    -- AXI_to_noc_FIFO_buffer KOMPONENTA
    FIFO_buffer : AXI_to_noc_FIFO_buffer
    
        generic map(
            flit_size => flit_size,
            buffer_size => buffer_size,
            write_threshold => const_SNA_write_threshold,
            read_threshold => const_SNA_read_threshold
        )
        
        port map(
            clk => clk,
            rst => rst, 
           
            flit_in => flit_in,
            flit_in_valid => flit_in_valid,
            
            flit_out => flit_out,
            empty => empty,
            
            right_shift => right_shift,
            
            buffer_write_ready => buffer_write_ready_int,
            buffer_read_ready => buffer_read_ready_int
        );
        
    -- noc_injector KOMPONENTA
    injector : noc_injector
    
        generic map(
            vc_num => vc_num,
            flit_size => flit_size,
            buffer_size => buffer_size,
            clock_divider => clock_divider
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
        
    buffer_write_ready <= buffer_write_ready_int;
    buffer_read_ready <= buffer_read_ready_int;    

end Behavioral;
