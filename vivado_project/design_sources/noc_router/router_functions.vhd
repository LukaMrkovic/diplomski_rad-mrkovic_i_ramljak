----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 29.04.2021 16:20:52
-- Design Name: NoC_Router
-- Module Name: router_functions - Behavioral
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
-- Revision 0.1 - 2021-04-29 - Mrkovic
-- Additional Comments: Funkcije potrebne za generiranje maski prioriteta za ulaze i virtualne kanale
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library noc_lib;
use noc_lib.router_config.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

package router_functions is

    -- uzlazan array int duljine IO
    type IO_x_1_asc_integer_array is
        array (0 to 4) of integer;
        
    -- uzlazan array int duljine vc_num
    type vc_num_x_1_asc_integer_array is
        array (0 to const_vc_num - 1) of integer;
        
    function IO_mask_function (
        processed_inputs_array : in std_logic_vector(0 to 4)
    )
    return IO_x_1_asc_integer_array;
    
    function vc_mask_function (
        processed_vc_array : in std_logic_vector(0 to 4)
    )
    return vc_num_x_1_asc_integer_array;

end package router_functions;



package body router_functions is

    function IO_mask_function (
        processed_inputs_array : in std_logic_vector(0 to 4)
    )
    return IO_x_1_asc_integer_array is
    
        variable index : integer;
        variable IO_mask : IO_x_1_asc_integer_array;
    
    begin
    
        index := 0;
        IO_mask := (others => 0);
        
        loop_1a : for i in 0 to 4 loop
        
            if processed_inputs_array(i) = '0' then
            
                IO_mask(index) := i;
                index := index + 1;
            
            end if;
        
        end loop;
        
        loop_1b : for i in 0 to 4 loop
        
            if processed_inputs_array(i) = '1' then
            
                IO_mask(index) := i;
                index := index + 1;
            
            end if;
        
        end loop;
        
        return IO_mask;
    
    end;
    
    function vc_mask_function (
        processed_vc_array : in std_logic_vector(0 to 4)
    )
    return vc_num_x_1_asc_integer_array is
    
        variable index : integer;
        variable vc_mask : vc_num_x_1_asc_integer_array;
    
    begin
    
        index := 0;
        vc_mask := (others => 0);
        
        loop_1a : for i in 0 to 4 loop
        
            if processed_vc_array(i) = '0' then
            
                vc_mask(index) := i;
                index := index + 1;
            
            end if;
        
        end loop;
        
        loop_1b : for i in 0 to 4 loop
        
            if processed_vc_array(i) = '1' then
            
                vc_mask(index) := i;
                index := index + 1;
            
            end if;
        
        end loop;
        
        return vc_mask;
    
    end;    

end package body router_functions;
