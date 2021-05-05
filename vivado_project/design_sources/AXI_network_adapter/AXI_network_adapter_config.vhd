----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/03/2021 12:12:06 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: AXI_network_adapter_config - Package
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
-- Revision 0.1 - 2021-05-03 - Mrkovic, Ramljak
-- Additional Comments: Definicija konstanti za buffere
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

package AXI_network_adapter_config is

    constant const_MNA_write_threshold : integer;
    constant const_MNA_read_threshold : integer;
    constant const_SNA_write_threshold : integer;
    constant const_SNA_read_threshold : integer;
    constant const_default_injection_vc : integer;
    constant const_node_address_size : integer;
    
end package AXI_network_adapter_config;

package body AXI_network_adapter_config is
    
    -- Broj potrebnih slobodnih mjesta u MNA bufferu za pokretanje operacije pisanja
    constant const_MNA_write_threshold : integer := 3;
    -- Broj potrebnih slobodnih mjesta u MNA bufferu za pokretanje operacije citanja
    constant const_MNA_read_threshold : integer := 2;
    -- Broj potrebnih slobodnih mjesta u SNA bufferu za pokretanje operacije pisanja
    constant const_SNA_write_threshold : integer := 1;
    -- Broj potrebnih slobodnih mjesta u SNA bufferu za pokretanje operacije citanja
    constant const_SNA_read_threshold : integer := 2;
    -- Virtualni kanal u koji AXI network adapter salje flitove
    constant const_default_injection_vc : integer := 0;
    -- Broj gornjih bitova u AXI adresi koji identificiraju node u mrezi
    constant const_node_address_size : integer := 4;

end package body AXI_network_adapter_config;