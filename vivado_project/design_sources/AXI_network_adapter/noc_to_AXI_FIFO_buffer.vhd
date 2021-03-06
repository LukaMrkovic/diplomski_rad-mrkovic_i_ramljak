----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/03/2021 01:50:07 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: noc_to_AXI_FIFO_buffer - Behavioral
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
-- Additional Comments: Prva verzija noc_to_AXI_FIFO_buffera
-- Revision 0.2 - 2021-05-17 - Mrkovic
-- Additional Comments: Dotjerana verzija noc_to_AXI_FIFO_buffera
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library noc_lib;
use noc_lib.router_config.ALL;
use noc_lib.AXI_network_adapter_config.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity noc_to_AXI_FIFO_buffer is

    Generic (
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size
    );
                  
    Port (
        clk : in std_logic;
        rst : in std_logic; 
                   
        flit_in : in std_logic_vector(flit_size - 1 downto 0);
        flit_in_valid : in std_logic;
        
        flit_out : out std_logic_vector(flit_size - 1 downto 0);
        has_tail : out std_logic;
                
        right_shift : in std_logic;
        
        full : out std_logic
    );

end noc_to_AXI_FIFO_buffer;

architecture Behavioral of noc_to_AXI_FIFO_buffer is

    -- POLJE FLITOVA
    type buffer_array is array (buffer_size - 1 downto 0) of std_logic_vector(flit_size - 1 downto 0);
    -- POKAZIVACI NA POLJE FLITOVA
    subtype array_pointer is integer range 0 to buffer_size - 1;
    -- BROJAC ZAPUNJENOSTI POLJA FLITOVA
    subtype array_counter is integer range 0 to buffer_size; 
    
    -- > TESTNI SIGNALI
    signal head_test : array_pointer;
    signal tail_test : array_pointer;
    signal counter_test : array_counter;
    signal FIFO_array_test : buffer_array;
    -- < TESTNI SIGNALI

begin

    noc_to_AXI_FIFO_buffer : process (clk) is
    
        variable FIFO_array_var : buffer_array;
        
        variable head_var : array_pointer;
        variable tail_var : array_pointer;
        variable counter_var : array_counter;
        variable has_tail_var : std_logic;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                -- POLJE U 00... 0
                FIFO_array_var := (others => (others => '0'));
                
                -- INTERNE VARIJABLE U 0
                head_var := 0;
                tail_var := 0;
                counter_var := 0;
                has_tail_var := '0';
                
                -- IZLAZNI SIGNALI U 00... 0
                flit_out <= (others => '0');
                has_tail <= '0';
                full <= '0';
                
            else
            
                -- AKO JE flit_in_valid POSTAVLJEN
                -- POHRANI flit_in U POLJE I UVECAJ tail_var
                -- UVECAJ counter_var
                -- AKO JE flit_in TAIL, postavi has_tail_var
                if flit_in_valid = '1' then
                
                    FIFO_array_var(tail_var) := flit_in;
                    tail_var := (tail_var + 1) mod buffer_size;
                    counter_var := counter_var + 1;
                    
                    if flit_in(flit_size - 2) = '1' then
                        has_tail_var := '1';
                    end if;
                    
                end if;
                
                -- AKO JE right_shift POSTAVLJEN
                -- AKO JE FIFO_array_var(head_var) TAIL, spusti has_tail_var
                -- PREBRISI FIFO_array_var(head_var) I UVECAJ head_var
                -- SMANJI counter_var
                if right_shift = '1' then
                
                    if FIFO_array_var(head_var)(flit_size - 2) = '1' then
                        has_tail_var := '0';
                    end if;
                    
                    FIFO_array_var(head_var) := (others => '0');
                    head_var := (head_var + 1) mod buffer_size;
                    counter_var := counter_var - 1;
                    
                end if;
                
                -- OVISNO O VRIJEDNOSTI counter_var, POSTAVI full SIGNAL
                if counter_var = buffer_size then
                    full <= '1';
                else
                    full <= '0';
                end if;
                
                -- PROPUSTI VRIJEDNOSTI NA IZLAZ
                flit_out <= FIFO_array_var(head_var);
                has_tail <= has_tail_var;
                
                -- > TESTNI SIGNALI
                FIFO_array_test <= FIFO_array_var;
                head_test <= head_var;
                tail_test <= tail_var;
                counter_test <= counter_var;
                -- < TESTNI SIGNALI
                
            end if;
        end if;
    
    end process;

end Behavioral;