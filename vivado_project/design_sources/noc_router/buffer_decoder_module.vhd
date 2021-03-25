----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2021 09:42:22 PM
-- Design Name: 
-- Module Name: buffer_decoder_module - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity buffer_decoder_module is
    
     Generic (
        vc_num : integer := 2;
        flit_size : integer := 44;
        payload_size : integer := 32;
        buffer_size : integer := 8;
        mesh_size : integer := 8;
        clock_divider : integer := 3
    );
    
    Port (
        clk : in std_logic;
        rst : in std_logic; 
           
        int_data_in : in std_logic_vector(flit_size - 1 downto 0);
        int_data_in_valid : in std_logic;
        
        buffer_vc_credits : out std_logic_vector(vc_num - 1 downto 0);
        
        req : out std_logic_vector (vc_num - 1 downto 0);
        head : out std_logic_vector (vc_num - 1 downto 0 );
        tail : out std_logic_vector (vc_num - 1 downto 0 );
        
        grant : in std_logic_vector (vc_num - 1 downto 0);
        vc_downstream : in std_logic_vector (vc_num - 1 downto 0);
        
        crossbar_data : out std_logic_vector (flit_size - 1 downto 0);
        crossbar_data_valid : out std_logic        
    );
    
end buffer_decoder_module;

architecture Behavioral of buffer_decoder_module is

    signal int_clk : std_logic;
    
    signal vc_shift : std_logic_vector (vc_num - 1 downto 0) := (others => '0');
    
    type one_vc_buffer is array (buffer_size - 1 downto 0) of std_logic_vector(flit_size - 1 downto 0);
    type all_in_one_buffer is array (vc_num - 1 downto 0) of one_vc_buffer;
    -- Boga pitaj kako se po ovome iterira
    

begin    

    clock_divider_proces: process (clk) is 
        
        variable clk_counter : integer := 0;
        
    begin
        if rising_edge(clk) then
            if rst = '0' then
                
                clk_counter := 0;
                int_clk <= '0';     
            
            else
               
                clk_counter := clk_counter + 1;
                
                if (clk_counter mod clock_divider = 0) then
                    clk_counter := 0;
                    int_clk <= not int_clk;
                end if;                
            end if;
        end if;
    end process;
    
    buffer_input_proces: process (clk) is 
             
    begin    
        if rising_edge(clk) then
            if rst = '0' then
                buffer_vc_credits <= (others => '0');
                
                    
            
            else
                if int_data_in_valid = '1' then
                
                end if;
                
                for i in (vc_num - 1) downto 0 loop 
                    if vc_shift(i) = '1' then
                        
                    end if;
                end loop;          
            end if;
        end if;
    end process;
    
    
end Behavioral;
