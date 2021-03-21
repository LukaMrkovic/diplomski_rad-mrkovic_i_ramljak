----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 11.03.2021 13:08:29
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
-- Additional Comments: Prvih pet konstanti (vc_num, payload_size, buffer_size, flit_size, mesh_size) definirano, flit_size i mesh_size nedovrsene
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

package router_config is
    
    constant const_vc_num : integer;
    constant const_payload_size : integer;
    constant const_buffer_size : integer;
    constant const_flit_size : integer;
    constant const_mesh_size : integer;
    
end package router_config;

package body router_config is

    -- Broj virtualnih kanala na svakom router-to-router interfaceu
    constant const_vc_num : integer := 2;
    -- Broj payload bitova u flitu
    constant const_payload_size : integer := 32;
    -- Velicina buffera za pojedini virtualni kanal
    constant const_buffer_size : integer := 8;
    -- Velicina cijelog flita TODO
    constant const_flit_size : integer := 44;
    -- Velicina NoC mreze TODO
    constant const_mesh_size : integer := 8;

end package body router_config;