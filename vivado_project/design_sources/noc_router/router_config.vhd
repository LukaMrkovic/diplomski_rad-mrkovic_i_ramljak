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
-- Revision 0.1 - 2021-03-11 - Mrkovic i Ramljak
-- Additional Comments: Prvih pet konstanti (vc_num, payload_size, buffer_size, flit_size, mesh_size) definirano, flit_size i mesh_size nedovrsene
-- Revision 0.2 - 2021-03-24 - Ramljak
-- Additional Comments: Dodane konstante i enumeracije potrebne za buffer_decoder_module
-- Revision 0.3 - 2021-03-26 - Mrkovic i Ramljak
-- Additional Comments: Dovrsene TODO konstanti, dodane konstante
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
    constant const_mesh_size_x : integer;
    constant const_mesh_size_y : integer;
    constant const_mesh_size : integer;
    constant const_payload_size : integer;
    constant const_flit_size : integer;
    constant const_buffer_size : integer;
    constant const_default_address_x : std_logic_vector(const_mesh_size_x - 1 downto 0);
    constant const_default_address_y : std_logic_vector(const_mesh_size_y - 1 downto 0);
    constant const_clock_divider : integer;
    
    type routing_axis is (HOR, VER);
    constant const_default_diagonal_pref : routing_axis;
    
    type destination_dir is (EMPTY, LOCAL, NORTH, SOUTH, EAST, WEST);
    type req_array is
        array (integer range const_vc_num - 1 downto 0) of destination_dir;
    
end package router_config;

package body router_config is

    -- Broj virtualnih kanala na svakom router-to-router interfaceu
    constant const_vc_num : integer := 2;
    
    -- Broj routera u x dimenziji mreze
    constant const_mesh_size_x : integer := 4;
    -- Broj routera u y dimenziji mreze
    constant const_mesh_size_y : integer := 4;
    -- Broj adresnih bitova unutar flita
    constant const_mesh_size : integer := const_mesh_size_x + const_mesh_size_y;
    
    -- Broj payload bitova u flitu
    constant const_payload_size : integer := 32;
    
    -- Velicina cijelog flita
    constant const_flit_size : integer := 2 + const_vc_num + const_mesh_size + const_payload_size;
    
    -- Velicina buffera za pojedini virtualni kanal
    constant const_buffer_size : integer := 8;
    
    -- Defaultna lokalna adresa (x)
    constant const_default_address_x : std_logic_vector(const_mesh_size_x - 1 downto 0) := "0001";
    -- Defaultna lokalna adresa (y)
    constant const_default_address_y : std_logic_vector(const_mesh_size_y - 1 downto 0) := "0001";
    
    -- Koliko se usporava globalni clock (podijeljeno s 2)
    constant const_clock_divider : integer := 2;
    
    -- Preferenca sljedeceg koraka ukoliko je potrebno flit usmjeriti dijagonalno
    constant const_default_diagonal_pref : routing_axis := HOR;

end package body router_config;