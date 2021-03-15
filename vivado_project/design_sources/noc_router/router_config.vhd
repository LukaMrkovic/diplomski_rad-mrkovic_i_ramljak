----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic & Ramljak
-- 
-- Create Date: 03/11/2021 01:08:29 PM
-- Design Name: NoC_Router
-- Module Name: router_config - Behavioral
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
-- Additional Comments: First three contants (vc_num, payload_size, buffer_size) defined, flit size constant not finished
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

package router_config is
    
    constant vc_num : integer;
    constant payload_size : integer;
    constant buffer_size : integer;
    constant flit_size : integer;
    
end package router_config;

package body router_config is

    -- Number of virtual channels on each router to router interface
    constant vc_num : integer := 2;
    -- Number of payload bits in a flit
    constant payload_size : integer := 32;
    -- Size of a buffer for a single virtual channel
    constant buffer_size : integer := 8;
    -- Size of a complete flit TODO
    constant flit_size : integer := 2 + payload_size;

end package body router_config;