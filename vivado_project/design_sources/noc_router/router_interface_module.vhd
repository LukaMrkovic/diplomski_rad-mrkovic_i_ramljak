----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic & Ramljak
-- 
-- Create Date: 03/11/2021 12:52:50 PM
-- Design Name: NoC_Router
-- Module Name: router_interface_module - Behavioral
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
-- Revision 0.1 - 2021-03-11
-- Additional Comments: Inputs, outputs, and flow controller process defined
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity router_interface_module is 

    Generic ( vc_num : integer;
              flit_size : integer);
              
    Port ( clk : in std_logic;
           rst : in std_logic; 
           
           data_in : in std_logic_vector(flit_size downto 0);
           data_in_valid : in std_logic;
           data_in_vc_free : out std_logic_vector(vc_num downto 0);
           data_in_vc_credits : out std_logic_vector(vc_num downto 0);
           
           data_out : out std_logic_vector(flit_size downto 0);
           data_out_valid : out std_logic;
           data_out_vc_free : in std_logic_vector(vc_num downto 0);
           data_out_vc_credits : in std_logic_vector(vc_num downto 0);
           
           int_data_in : out std_logic_vector(flit_size downto 0);
           int_data_in_valid : out std_logic;
           
           int_data_out : in std_logic_vector(flit_size downto 0);
           int_data_out_valid : in std_logic;
           
           buffer_vc_credits : in std_logic_vector(vc_num downto 0));
           
end router_interface_module;

architecture Behavioral of router_interface_module is

begin

    -- FLOW CONTROLLER
    flow_controller : process (clk) is
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                --TODO
            else
                --TODO
            end if;
        end if;
        
    end process;

end Behavioral;