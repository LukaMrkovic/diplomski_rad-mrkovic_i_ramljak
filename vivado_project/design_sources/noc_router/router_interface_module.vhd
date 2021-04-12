----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 11.03.2021 12:52:50
-- Design Name: NoC_Router
-- Module Name: router_interface_module - Behavioral
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
-- Additional Comments: Ulazi, izlazi i flow controller proces definirani 
-- Revision 0.2 - 2021-03-15 - Ramljak
-- Additional Comments: Prva verzija modula
-- Revision 0.3 - 2021-03-16 - Mrkovic i Ramljak
-- Additional Comments: Defaultne vrijednosti genericnih varijabli postavljene
-- Revision 0.4 - 2021-03-17 - Mrkovic i Ramljak
-- Additional Comments: Razne dorade
-- Revision 0.45 - 2021-03-18 - Mrkovic
-- Additional Comments: Testni signali
-- Revision 0.5 - 2021-03-25 - Mrkovic i Ramljak
-- Additional Comments: Dorade (varijable/signali)
-- Revision 0.6 - 2021-03-26 - Mrkovic i Ramljak
-- Additional Comments: int_data_in_valid promijenjen iz jednog bita u vektor zbog bolje, lakse i brze komunikacije s buffer_decoder_module
-- Revision 0.65 - 2021-04-06 - Mrkovic
-- Additional Comments: Dodani signali od flow_controllera prema arbiteru
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 

library noc_lib;
use noc_lib.router_config.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity router_interface_module is 

    Generic (
        vc_num : integer := const_vc_num;
        address_size : integer := const_address_size;
        payload_size : integer := const_payload_size;
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size
    );
              
    Port (
        clk : in std_logic;
        rst : in std_logic; 
           
        data_in : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid : in std_logic;
        data_in_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits : out std_logic_vector(vc_num - 1 downto 0);
           
        data_out : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid : out std_logic;
        data_out_vc_busy : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits : in std_logic_vector(vc_num - 1 downto 0);
           
        int_data_in : out std_logic_vector(flit_size - 1 downto 0);
        int_data_in_valid : out std_logic_vector(vc_num - 1 downto 0);
           
        int_data_out : in std_logic_vector(flit_size - 1 downto 0);
        int_data_out_valid : in std_logic;
           
        buffer_vc_credits : in std_logic_vector(vc_num - 1 downto 0);
        
        arb_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
        arb_credit_counter : out credit_counter_vector(vc_num - 1 downto 0)
    );
           
end router_interface_module;

architecture Behavioral of router_interface_module is

    -- TESTNI SIGNALI - IZBRISATI IZ ZAVRSNE VERZIJE MODULA!
    -- >
    signal vc_index_snd_test : std_logic_vector(vc_num - 1 downto 0);
    signal vc_index_rcv_test : std_logic_vector(vc_num - 1 downto 0);
    signal head_test : std_logic;
    signal tail_test : std_logic;
    -- <

begin

    -- FLOW CONTROLLER
    flow_controller_process : process (clk) is
    
        variable vc_index_snd : std_logic_vector(vc_num - 1 downto 0);
        variable vc_index_rcv : std_logic_vector(vc_num - 1 downto 0);
        variable head : std_logic;
        variable tail : std_logic;
        
        variable vc_busy : std_logic_vector(vc_num - 1 downto 0) := (others => '0');
        
        variable credit_counter : credit_counter_vector(vc_num - 1 downto 0) := (others => 0);
        
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                -- INTERNE VARIJABLE U 00... 0
                vc_index_snd := (others => '0'); 
                vc_index_rcv := (others => '0');
                head := '0';
                tail := '0';
            
                -- SVA BROJILA KREDITA POSTAVLJAJU SE NA MAKSIMALNU VRIJEDNOST (buff_size)
                credit_counter := (others => buffer_size);
                
                -- SVI VIRTUALNI KANALI SLOBODNI
                vc_busy := (others => '0');
                
                -- SVI IZLAZI NA 00... 0
                data_in_vc_busy <= (others => '0');
                data_in_vc_credits <= (others => '0');
                arb_credit_counter <= (others => buffer_size);
                
            else
                
                -- AKO JE VEKTOR data_out_vc_credits RAZLICIT OD 00... 0 => POVECAJ ODGOVARAJUCA BROJILA KREDITA ZA 1
                for i in (vc_num - 1) downto 0 loop 
                    if data_out_vc_credits(i) = '1' then
                        credit_counter(i) := credit_counter(i) + 1;
                    end if;
                end loop;
                
                -- AKO JE int_data_out_valid PODIGNUT => SMANJI ODGOVARAJUCE BROJILO KREDITA ZA 1
                if int_data_out_valid = '1' then
                    vc_index_snd := int_data_out((payload_size + address_size + vc_num - 1) downto (payload_size + address_size));
                    for i in (vc_num - 1) downto 0 loop
                        if vc_index_snd(i) = '1' then
                            credit_counter(i) := credit_counter(i) - 1;
                        end if;
                    end loop;
                end if;  
                
                -- AKO JE data_in_valid PODIGNUT => POSTAVI ODGOVARAJUCE VARIJABLE
                if data_in_valid = '1' then
                    vc_index_rcv := data_in((payload_size + address_size + vc_num - 1) downto (payload_size + address_size));
                    head := data_in(flit_size-1);
                    tail := data_in(flit_size-2);
                end if;
                
                -- AKO JE data_in_valid PODIGNUT I data_in JE header FLIT => ODGOVARAJUCI VIRTUALNI KANAL ZAUZET
                if data_in_valid = '1' and head = '1' then
                    for i in (vc_num - 1) downto 0 loop
                        if vc_index_rcv(i) = '1' then
                            vc_busy(i) := '1';
                        end if;
                    end loop;
                end if;
                    
                -- AKO JE data_in_valid PODIGNUT I data_in JE tail FLIT => ODGOVARAJUCI VIRTUALNI KANAL JE SLOBODAN
                if data_in_valid = '1' and tail = '1' then
                    for i in (vc_num - 1) downto 0 loop
                        if vc_index_rcv(i) = '1' then
                            vc_busy(i) := '0';
                        end if;
                    end loop;
                end if;
                
                -- PROSLIJEDI ULAZ VEKTOR buffer_vc_credits NA IZLAZ data_in_vc_credits
                data_in_vc_credits <= buffer_vc_credits;
                -- PROSLIJEDI VARIJABLU VEKTOR vc_busy NA IZLAZ data_in_vc_busy
                data_in_vc_busy <= vc_busy;
                
                -- PROSLIJEDI VARIJABLU VEKTOR credit_counter NA IZLAZ arb_credit_counter
                arb_credit_counter <= credit_counter;
                
                -- TESTNI SIGNALI
                -- >
                vc_index_snd_test <= vc_index_snd;
                vc_index_rcv_test <= vc_index_rcv;
                head_test <= head;
                tail_test <= tail;
                -- <
                
            end if;
        end if;
        
    end process;
    
    -- LINK CONTROLLER INPUT
    link_controller_input_process : process (clk) is
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                int_data_in <= (others => '0');
                int_data_in_valid <= (others => '0');
                
            else
                
                int_data_in <= data_in;
                
                if data_in_valid = '1' then
                    int_data_in_valid <= data_in((payload_size + address_size + vc_num - 1) downto (payload_size + address_size));
                else
                    int_data_in_valid <= (others => '0');
                end if;
                
            end if;
        end if;
            
    end process;
    
    -- LINK CONTROLLER OUTPUT
    data_out <= int_data_out;
    data_out_valid <= int_data_out_valid;
    
    -- PROSLIJEDI VARIJABLU VEKTOR vc_busy NA IZLAZ arb_vc_busy
    arb_vc_busy <= data_out_vc_busy;

end Behavioral;