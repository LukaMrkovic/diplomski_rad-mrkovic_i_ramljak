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
-- Additional Comments: Prva verzija MNA_resp_flow-a - sadrzi MNA_resp_AXI_handshake_controller, MNA_resp_buffer_controller i noc_to_AXI_FIFO_buffer
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
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size
    );
    
    Port (
        clk : in std_logic;
        rst : in std_logic; 
        
        -- AXI WRITE RESPONSE CHANNEL   
        BREADY : in std_logic;
        BRESP : out std_logic_vector(1 downto 0);
        BVALID : out std_logic;
        
        -- AXI READ RESPONSE CHANNEL
        RREADY : in std_logic;
        RDATA : out std_logic_vector(31 downto 0);
        RRESP : out std_logic_vector(1 downto 0);
        RVALID : out std_logic;
        
        -- >PRIVREMENO!< BUFFER IZLAZI
        flit_in : in std_logic_vector(flit_size - 1 downto 0);
        flit_in_valid : in std_logic;
        
        full : out std_logic
    );

end MNA_resp_flow;

architecture Behavioral of MNA_resp_flow is

    -- INTERNI SIGNALI
    
    -- HANDSHAKE CONTROLLER - BUFFER CONTROLLER
    signal op_write : std_logic;
    signal op_read : std_logic;
        
    signal data : std_logic_vector(31 downto 0);
    signal resp : std_logic_vector(1 downto 0);
    
    -- BUFFER CONTROLLER - BUFFER
    signal flit_out : std_logic_vector(flit_size - 1 downto 0);
    signal has_tail : std_logic;
                
    signal right_shift : std_logic;
    
begin

    -- MNA_resp_AXI_handshake_controller KOMPONENTA
    handshake_controller : MNA_resp_AXI_handshake_controller
    
        port map (
            clk => clk,
            rst => rst, 
              
            BREADY => BREADY,
            BRESP => BRESP,
            BVALID => BVALID,
            
            RREADY => RREADY,
            RDATA => RDATA,
            RRESP => RRESP,
            RVALID => RVALID,
            
            op_write => op_write,
            op_read => op_read,
            
            data => data,
            resp => resp

        );
        
    -- MNA_resp_buffer_controller KOMPONENTA
    buffer_controller : MNA_resp_buffer_controller 
    
        generic map(
            flit_size => flit_size
        )
        
        port map(
            clk => clk,
            rst => rst, 
           
            flit_out => flit_out,
            has_tail => has_tail,
            
            right_shift => right_shift,
            
            op_write => op_write,
            op_read => op_read,
            
            data => data,
            resp => resp
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
        
end Behavioral;