----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic & Ramljak
-- 
-- Create Date: 03/11/2021 12:52:50 PM
-- Design Name: NoC_Router
-- Module Name: router_interface_module - Behavioral
-- Project Name: NoC_Router
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Revision 0.1 - 2021-03-11
-- Additional Comments: Inputs, outputs, and flow controller process defined
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

entity router_interface_module is 

    Generic ( vc_num : integer;
              flit_size : integer;
              payload_size : integer;
              buffer_size : integer);
              
    Port ( clk : in std_logic;
           reset : in std_logic; 
           
           data_in : in std_logic_vector(flit_size downto 0);
           data_in_valid : in std_logic;
           data_in_vc_busy : out std_logic_vector(vc_num downto 0);
           data_in_vc_credits : out std_logic_vector(vc_num downto 0);
           
           data_out : out std_logic_vector(flit_size downto 0);
           data_out_valid : out std_logic;
           data_out_vc_busy : in std_logic_vector(vc_num downto 0);
           data_out_vc_credits : in std_logic_vector(vc_num downto 0);
           
           int_data_in : out std_logic_vector(flit_size downto 0);
           int_data_in_valid : out std_logic;
           
           int_data_out : in std_logic_vector(flit_size downto 0);
           int_data_out_valid : in std_logic;
           
           buffer_vc_credits : in std_logic_vector(vc_num downto 0));
           
end router_interface_module;

architecture Behavioral of router_interface_module is

type vc_array is array (vc_num downto 0) of integer;



begin

    -- FLOW CONTROLLER
    process (clk)
        variable vc_index_send: std_logic_vector(vc_num downto 0);
        variable vc_index_recive: std_logic_vector(vc_num downto 0);
        variable head: std_logic;
        variable tail: std_logic;
        variable credit_counter : vc_array := (others => 0);
        
        
    begin
        if rising_edge(clk) then
            if reset = '0' then
                --SVA BROJILA KREDITA POSTAVLJAJU SE NA MAKSIMALNU VRIJEDNOST (buff_size)
                for i in vc_num downto 0 loop 
                    credit_counter(i) := buffer_size;
                end loop;
                --SVI VIRTUALNI KANALI SLOBODNI
                data_in_vc_busy <= (others => '0');
                --SVI IZLAZNI SIGNALI 00...0
                data_in_vc_credits <= (others => '0');
                
                data_out <= (others => '0');
                data_out_valid <= '0';
                
                int_data_in <= (others => '0');
                int_data_in_valid <= '0';
                
            else
                --PROSLIJEDI VEKTOR buffer_vc_credits NA IZLAZ data_in_vc_credits
                data_in_vc_credits <= buffer_vc_credits;
                
                -- AKO JE VEKTOR data_out_vc_credits RAZLIÈIT OD 00...0 =>
                -- POVEÆAJ ODGOVARAJUÆA BROJILA KREDITA ZA 1
                for i in vc_num downto 0 loop 
                    if data_out_vc_credits(i) = '1' then
                        credit_counter(i) := credit_counter(i) + 1; -- ne znam jel se ovo moze sintetizirat
                    end if;
                end loop;
                
                -- AKO JE int_data_out_valid PODIGNUT =>
                -- SMANJI ODGOVARAJUÆE BROJILO KREDITA ZA 1
                if int_data_out_valid = '1' then
                    vc_index_send := int_data_out((payload_size + 8 + vc_num - 1) downto (payload_size + 8 - 1));
                    for i in vc_num downto 0 loop
                        if vc_index_send(i) = '1' then
                            credit_counter(i) := credit_counter(i) - 1;
                        end if;
                    end loop;
                end if;  
                
                -- AKO JE data_in_valid PODIGNUT I data_in JE header FLIT =>
                --ODGOVARAJUÆI VIRTUALNI KANAL ZAUZET
                if data_in_valid = '1' then
                    vc_index_recive := data_in((payload_size + 8 + vc_num - 1) downto (payload_size + 8 - 1));
                    head := data_in(flit_size-1);
                    tail := data_in(flit_size-2);
                    
                    if head = '1' then
                        for i in vc_num downto 0 loop
                            if vc_index_recive(i) = '1' then
                                data_in_vc_busy(i) <= '1';
                            end if;
                        end loop;
                    end if;
                    
                    --AKO JE data_in_valid PODIGNUT I data_in JE tail FLIT =>
                    --ODGOVARAJUÆI VIRTUALNI KANAL JE SLOBODAN 
                    --Nisam siguran jel ovo stvara latcheve
                    if tail = '1' then
                        for i in vc_num downto 0 loop
                            if vc_index_recive(i) = '1' then
                                data_in_vc_busy(i) <= '0';
                            end if;
                        end loop;
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
