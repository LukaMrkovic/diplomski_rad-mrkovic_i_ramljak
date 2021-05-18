----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/06/2021 01:38:24 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: MNA_resp_flow - Behavioral
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
-- Additional Comments: Prva verzija MNA_resp_flowa - sadrzi MNA_resp_AXI_handshake_controller, MNA_resp_buffer_controller i noc_to_AXI_FIFO_buffer
-- Revision 0.2 - 2021-05-18 - Mrkovic
-- Additional Comments: Dotjerana verzija MNA_resp_flowa
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

entity MNA_resp_flow is

    Generic (
        vc_num : integer := const_vc_num;
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size;
        clock_divider : integer := const_clock_divider
    );
    
    Port (
        clk : in std_logic;
        rst : in std_logic; 
        
        -- AXI WRITE RESPONSE CHANNEL
        BRESP : out std_logic_vector(1 downto 0);
        BVALID : out std_logic;
        BREADY : in std_logic;
        
        -- AXI READ RESPONSE CHANNEL
        RDATA : out std_logic_vector(31 downto 0);
        RRESP : out std_logic_vector(1 downto 0);
        RVALID : out std_logic;
        RREADY : in std_logic;
        
        -- NOC INTERFACE - FLIT AXI <- NOC
        noc_AXI_data : in std_logic_vector(flit_size - 1 downto 0);        
        noc_AXI_data_valid : in std_logic;
        
        AXI_noc_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
        AXI_noc_vc_credits : out std_logic_vector(vc_num - 1 downto 0)
    );

end MNA_resp_flow;

architecture Behavioral of MNA_resp_flow is

    -- INTERNI SIGNALI
    
    -- HANDSHAKE CONTROLLER - BUFFER CONTROLLER
    signal op_write : std_logic;
    signal op_read : std_logic;
        
    signal data : std_logic_vector(31 downto 0);
    signal resp : std_logic_vector(1 downto 0);
    
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

    -- MNA_resp_AXI_handshake_controller KOMPONENTA
    handshake_controller : MNA_resp_AXI_handshake_controller
    
        port map (
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
            
            -- MNA_resp_buffer_controller
            op_write => op_write,
            op_read => op_read,
            
            data => data,
            resp => resp

        );
        
    -- MNA_resp_buffer_controller KOMPONENTA
    buffer_controller : MNA_resp_buffer_controller 
    
        generic map(
            vc_num => vc_num,
            flit_size => flit_size
        )
        
        port map(
            clk => clk,
            rst => rst, 
            
            -- MNA_resp_AXI_handshake_controller
            op_write => op_write,
            op_read => op_read,
            
            data => data,
            resp => resp,
            
            -- noc_to_AXI_FIFO_buffer
            flit_out => flit_out,
            has_tail => has_tail,
            
            right_shift => right_shift,
            
            -- noc_receiver
            vc_credits => vc_credits
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