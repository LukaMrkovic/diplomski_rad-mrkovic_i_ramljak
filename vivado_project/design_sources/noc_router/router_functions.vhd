----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 29.04.2021 16:20:52
-- Design Name: NoC_Router
-- Module Name: router_functions - Package
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
-- Revision 0.2 - 2021-05-02 - Mrkovic
-- Additional Comments: Dodana funkcija za resetiranje prioriteta virtualnih kanala, neki nazivi promijenjeni
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

    -- uzlazan integer vektor duljine IO
    type input_mask_or_priority_vector is
        array (0 to 4) of integer;
        
    -- uzlazan integer vektor duljine const_vc_num
    type vc_mask_or_priority_vector is
        array (0 to const_vc_num - 1) of integer;
    
    -- funkcija koja generira input_mask_vector na osnovu processed_inputs_vector    
    function generate_input_mask (
        processed_inputs_vector : in std_logic_vector(0 to 4)
    )
    return input_mask_or_priority_vector;
    
    -- funkcija koja generira vc_mask_vector na osnovu processed_vcs_vector
    function generate_vc_mask (
        processed_vcs_vector : in std_logic_vector(0 to const_vc_num - 1)
    )
    return vc_mask_or_priority_vector;
    
    -- funkcija koja generira inicijalan vc_mask_vector ili vc_priority_vector
    function reset_vc_order
    return vc_mask_or_priority_vector;

end package router_functions;



package body router_functions is

    function generate_input_mask (
        processed_inputs_vector : in std_logic_vector(0 to 4)
    )
    return input_mask_or_priority_vector is
    
        variable index : integer;
        variable input_mask_vector : input_mask_or_priority_vector;
    
    begin
    
        index := 0;
        input_mask_vector := (others => 0);
        
        loop_1a : for i in 0 to 4 loop
        
            if processed_inputs_vector(i) = '0' then
            
                input_mask_vector(index) := i;
                index := index + 1;
            
            end if;
        
        end loop;
        
        loop_1b : for i in 0 to 4 loop
        
            if processed_inputs_vector(i) = '1' then
            
                input_mask_vector(index) := i;
                index := index + 1;
            
            end if;
        
        end loop;
        
        return input_mask_vector;
    
    end;
    
    function generate_vc_mask (
        processed_vcs_vector : in std_logic_vector(0 to const_vc_num - 1)
    )
    return vc_mask_or_priority_vector is
    
        variable index : integer;
        variable vc_mask_vector : vc_mask_or_priority_vector;
    
    begin
    
        index := 0;
        vc_mask_vector := (others => 0);
        
        loop_1a : for i in 0 to (const_vc_num - 1) loop
        
            if processed_vcs_vector(i) = '0' then
            
                vc_mask_vector(index) := i;
                index := index + 1;
            
            end if;
        
        end loop;
        
        loop_1b : for i in 0 to (const_vc_num - 1) loop
        
            if processed_vcs_vector(i) = '1' then
            
                vc_mask_vector(index) := i;
                index := index + 1;
            
            end if;
        
        end loop;
        
        return vc_mask_vector;
    
    end;    
    
    function reset_vc_order
    return vc_mask_or_priority_vector is
    
        variable vc_vector : vc_mask_or_priority_vector;
    
    begin
    
        vc_vector := (others => 0);
        
        loop_1 : for i in 0 to (const_vc_num - 1) loop

            vc_vector(i) := i;

        end loop;
        
        return vc_vector;
    
    end;

end package body router_functions;