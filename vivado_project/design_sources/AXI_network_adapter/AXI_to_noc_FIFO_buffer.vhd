----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/03/2021 12:24:08 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: AXI_to_noc_FIFO_buffer - Behavioral
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
-- Additional Comments: Prva verzija AXI_to_noc_FIFO_buffera
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

entity AXI_to_noc_FIFO_buffer is

    Generic (
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size;
        write_threshold : integer := const_MNA_write_threshold;
        read_threshold : integer := const_MNA_read_threshold
    );
                  
    Port (
        clk : in std_logic;
        rst : in std_logic; 
                   
        flit_in : in std_logic_vector(flit_size - 1 downto 0);
        flit_in_valid : in std_logic;
        
        flit_out : out std_logic_vector(flit_size - 1 downto 0);
        empty : out std_logic;
                
        right_shift : in std_logic;
        
        buffer_write_ready : out std_logic;        
        buffer_read_ready : out std_logic
    );
    
end AXI_to_noc_FIFO_buffer;

architecture Behavioral of AXI_to_noc_FIFO_buffer is

    -- POLJE FLITOVA
    type buffer_array is array (buffer_size - 1 downto 0) of std_logic_vector(flit_size - 1 downto 0);
    -- POKAZIVACI NA POLJE FLITOVA
    subtype array_pointer is integer range 0 to buffer_size - 1;
    -- BROJAC ZAPUNJENOSTI POLJA FLITOVA
    subtype array_counter is integer range 0 to buffer_size; 
    
    -- TESTNI SIGNALI - IZBRISATI IZ ZAVRSNE VERZIJE MODULA!
    signal head_test : array_pointer;
    signal tail_test : array_pointer;
    signal counter_test : array_counter;
    signal FIFO_array_test : buffer_array;
    
begin

    AXI_to_noc_FIFO_buffer : process (clk) is
    
        variable FIFO_array : buffer_array := (others => (others => '0'));
        
        variable head : array_pointer := 0;
        variable tail : array_pointer := 0; 
        
        variable counter : array_counter := 0;
        
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                -- POLJE U 00... 0
                FIFO_array := (others => (others => '0'));
                
                -- INTERNE VARIJABLE U 0
                head := 0;
                tail := 0;
                counter := 0;
                
                -- IZLAZNI SIGNALI U 00... 0
                flit_out <= (others => '0');
                empty <= '1';
                buffer_write_ready <= '1';
                buffer_read_ready <= '1'; 
                
            else 
            
                -- AKO JE flit_in_valid POSTAVLJEN
                -- POHRANI flit_in U POLJE I UVECAJ tail
                -- UVECAJ counter
                if flit_in_valid = '1' then
                    FIFO_array(tail) := flit_in;
                    tail := (tail + 1) mod buffer_size;
                    counter := counter + 1;
                end if;
                
                -- AKO JE right_shift POSTAVLJEN
                -- PREBRISI FIFO_array(head) I UVECAJ head
                -- SMANJI counter
                if right_shift = '1' then
                    FIFO_array(head) := (others => '0');
                    head := (head + 1) mod buffer_size;
                    counter := counter - 1;
                end if;
                
                -- OVISNO O VRIJEDNOSTI counter, POSTAVI empty SIGNAL
                if counter = 0 then
                    empty <= '1';
                else
                    empty <= '0';
                end if;
                
                -- OVISNO O VRIJEDNOSTI counter, POSTAVI buffer_write_ready SIGNAL
                if (buffer_size - counter) >= write_threshold then
                    buffer_write_ready <= '1';
                else
                    buffer_write_ready <= '0';
                end if;
                
                -- OVISNO O VRIJEDNOSTI counter, POSTAVI buffer_read_ready SIGNAL
                if (buffer_size - counter) >= read_threshold then
                    buffer_read_ready <= '1';
                else
                    buffer_read_ready <= '0';
                end if;
                
                -- PROPUSTI VRIJEDNOSTI NA IZLAZ
                flit_out <= FIFO_array(head);
                
                -- TESTNI SIGNALI
                FIFO_array_test <= FIFO_array;
                head_test <= head;
                tail_test <= tail;
                counter_test <= counter;
                
            end if;    
        end if;
    
    end process;


end Behavioral;