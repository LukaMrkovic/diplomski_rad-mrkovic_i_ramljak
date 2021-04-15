----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 04/15/2021 11:18:25 AM
-- Design Name: NoC Router
-- Module Name: arbiter - Behavioral
-- Project Name: NoC Router
-- Target Devices: zc706
-- Tool Versions: 2020.2
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Revision 0.1 - 2021-04-15 - Mrkovic, Ramljak
-- Additional Comments: Kostur fsm-a
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

entity arbiter is

    Generic (
        vc_num : integer := const_vc_num
    );
    
    Port (
        clk : in std_logic;
        rst : in std_logic;
        
        vc_busy_local : in std_logic_vector(vc_num - 1 downto 0);
        vc_busy_north : in std_logic_vector(vc_num - 1 downto 0);
        vc_busy_east : in std_logic_vector(vc_num - 1 downto 0);
        vc_busy_south : in std_logic_vector(vc_num - 1 downto 0);
        vc_busy_west : in std_logic_vector(vc_num - 1 downto 0);
        
        credit_counter_local : in credit_counter_vector(vc_num - 1 downto 0);
        credit_counter_north : in credit_counter_vector(vc_num - 1 downto 0);
        credit_counter_east : in credit_counter_vector(vc_num - 1 downto 0);
        credit_counter_south : in credit_counter_vector(vc_num - 1 downto 0);
        credit_counter_west : in credit_counter_vector(vc_num - 1 downto 0);
        
        req_local : in destination_dir_vector(vc_num - 1 downto 0);
        req_north : in destination_dir_vector(vc_num - 1 downto 0);
        req_east : in destination_dir_vector(vc_num - 1 downto 0);
        req_south : in destination_dir_vector(vc_num - 1 downto 0);
        req_west : in destination_dir_vector(vc_num - 1 downto 0);
        
        head_local : in std_logic_vector (vc_num - 1 downto 0 );
        head_north : in std_logic_vector (vc_num - 1 downto 0 );
        head_east : in std_logic_vector (vc_num - 1 downto 0 );
        head_south : in std_logic_vector (vc_num - 1 downto 0 );
        head_west : in std_logic_vector (vc_num - 1 downto 0 );
        
        tail_local : in std_logic_vector (vc_num - 1 downto 0 );
        tail_north : in std_logic_vector (vc_num - 1 downto 0 );
        tail_east : in std_logic_vector (vc_num - 1 downto 0 );
        tail_south : in std_logic_vector (vc_num - 1 downto 0 );
        tail_west : in std_logic_vector (vc_num - 1 downto 0 );
        
        grant_local : out std_logic_vector (vc_num - 1 downto 0);
        grant_north : out std_logic_vector (vc_num - 1 downto 0);
        grant_east : out std_logic_vector (vc_num - 1 downto 0);
        grant_south : out std_logic_vector (vc_num - 1 downto 0);
        grant_west : out std_logic_vector (vc_num - 1 downto 0);
        
        vc_downstream_local : out std_logic_vector (vc_num - 1 downto 0);
        vc_downstream_north : out std_logic_vector (vc_num - 1 downto 0);
        vc_downstream_east : out std_logic_vector (vc_num - 1 downto 0);
        vc_downstream_south : out std_logic_vector (vc_num - 1 downto 0);
        vc_downstream_west : out std_logic_vector (vc_num - 1 downto 0);
        
        select_vector_local : out std_logic_vector(4 downto 0);
        select_vector_north : out std_logic_vector(4 downto 0);
        select_vector_east : out std_logic_vector(4 downto 0);
        select_vector_south : out std_logic_vector(4 downto 0);
        select_vector_west : out std_logic_vector(4 downto 0)
    );
    
end arbiter;

architecture Behavioral of arbiter is

    -- ENUMERACIJA STANJA fsm-a
    type state_type is (state_1, state_2, state_3, state_4);
    -- TRENUTNO STANJE
    signal current_state : state_type;
    -- SLJEDECE STANJE
    signal next_state : state_type;
    -- POCETNO STANJE
    constant initial_state : state_type := state_4;
    
    -- enable SIGNALI PROCESA INDIVIDUALNIH STANJA
    signal state_1_enable : std_logic;
    signal state_2_enable : std_logic;
    signal state_3_enable : std_logic;
    signal state_4_enable : std_logic;
    
    -- ARRAY ZA GRUPIRANJE ULAZA OBLIKA std_logic_vector (vc_num - 1 downto 0)
    type vc_num_length_array is
        array (4 downto 0) of std_logic_vector (vc_num - 1 downto 0);
    -- ARRAY ZA GRUPIRANJE ULAZA OBLIKA std_logic_vector (4 downto 0) 
    type IO_num_length_array is
        array (4 downto 0) of std_logic_vector(4 downto 0);
    -- ARRAY ZA GRUPIRANJE credit_counter
    type credit_counter_vector_array is
        array (4 downto 0) of credit_counter_vector(vc_num - 1 downto 0);
    -- ARRAY ZA GRUPIRANJE req
    type destination_dir_vector_array is 
        array (4 downto 0) of destination_dir_vector(vc_num - 1 downto 0);
    
    -- ULAZNA POLJA
    signal vc_busy_array : vc_num_length_array;
    signal credit_counter_array : credit_counter_vector_array;
    signal req_array : destination_dir_vector_array;
    signal head_array : vc_num_length_array;
    signal tail_array : vc_num_length_array;
    
    -- IZLAZNA POLJA
    signal grant_array : vc_num_length_array;
    signal vc_downstream_array : vc_num_length_array;
    signal select_vector_array : IO_num_length_array;
    
    -- > TESTNI SIGNALI
    signal counter_1_test : integer;
    signal counter_2_test : integer;
    signal counter_3_test : integer;
    signal counter_4_test : integer;
    -- <

begin

    -- > PREPISIVANJE I/O SIGNALA U/IZ POLJA
    vc_busy_array(0) <= vc_busy_local;
    vc_busy_array(1) <= vc_busy_north;
    vc_busy_array(2) <= vc_busy_east;
    vc_busy_array(3) <= vc_busy_south;
    vc_busy_array(4) <= vc_busy_west;
    
    credit_counter_array(0) <= credit_counter_local;
    credit_counter_array(1) <= credit_counter_north;
    credit_counter_array(2) <= credit_counter_east;
    credit_counter_array(3) <= credit_counter_south;
    credit_counter_array(4) <= credit_counter_west;
    
    req_array(0) <= req_local;
    req_array(1) <= req_north;
    req_array(2) <= req_east;
    req_array(3) <= req_south;
    req_array(4) <= req_west;
    
    head_array(0) <= head_local;
    head_array(1) <= head_north;
    head_array(2) <= head_east;
    head_array(3) <= head_south;
    head_array(4) <= head_west;
    
    tail_array(0) <= tail_local;
    tail_array(1) <= tail_north;
    tail_array(2) <= tail_east;
    tail_array(3) <= tail_south;
    tail_array(4) <= tail_west;
    
    grant_local <= grant_array(0);
    grant_north <= grant_array(1);
    grant_east <= grant_array(2);
    grant_south <= grant_array(3);
    grant_west <= grant_array(4);
    
    vc_downstream_local <= vc_downstream_array(0);
    vc_downstream_north <= vc_downstream_array(1);
    vc_downstream_east <= vc_downstream_array(2);
    vc_downstream_south <= vc_downstream_array(3);
    vc_downstream_west <= vc_downstream_array(4);
    
    select_vector_local <= select_vector_array(0);
    select_vector_north <= select_vector_array(1);
    select_vector_east <= select_vector_array(2);
    select_vector_south <= select_vector_array(3);
    select_vector_west <= select_vector_array(4);
    -- <

    -- PROCES KOJI KOORDINIRA PROCESE POJEDINIH STANJA
    trigger_process : process (current_state) is
    
    begin
    
        state_1_enable <= '0';
        state_2_enable <= '0';
        state_3_enable <= '0';
        state_4_enable <= '0';
    
        case current_state is
        
            when state_1 =>
            
                state_2_enable <= '1';
                next_state <= state_2;
            
            when state_2 =>
            
                state_3_enable <= '1';
                next_state <= state_3;
            
            when state_3 =>
            
                state_4_enable <= '1';
                next_state <= state_4;
            
            when state_4 =>
            
                state_1_enable <= '1';
                next_state <= state_1;
            
        end case;
    
    end process;
    
    -- PROCES STANJA 1
    state_1_process : process (clk) is
    
        variable counter_1 : integer;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                counter_1 := 0;
                counter_1_test <= 0;
                
            elsif state_1_enable = '1' then
                
                counter_1 := counter_1 + 1;
                counter_1_test <= counter_1;
                
            end if;
        end if;
    
    end process;
    
    -- PROCES STANJA 2
    state_2_process : process (clk) is
    
        variable counter_2 : integer;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                counter_2 := 0;
                counter_2_test <= 0;
                
            elsif state_2_enable = '1' then
                
                counter_2 := counter_2 + 1;
                counter_2_test <= counter_2;
                
            end if;
        end if;
    
    end process;
    
    -- PROCES STANJA 3
    state_3_process : process (clk) is
    
        variable counter_3 : integer;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                counter_3 := 0;
                counter_3_test <= 0;
                
            elsif state_3_enable = '1' then
                
                counter_3 := counter_3 + 1;
                counter_3_test <= counter_3;
                
            end if;
        end if;
    
    end process;
    
    -- PROCES STANJA 4
    state_4_process : process (clk) is
    
        variable counter_4 : integer;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                grant_array <= (others => (others => '0'));
                vc_downstream_array <= (others => (others => '0'));
                select_vector_array <= (others => (others => '0'));
                counter_4 := 0;
                counter_4_test <= 0;
                
            elsif state_4_enable = '1' then
                
                counter_4 := counter_4 + 1;
                counter_4_test <= counter_4;
                
                if (counter_4 mod 2) = 0 then
                    grant_array <= (others => (others => '0'));
                    vc_downstream_array <= (others => (others => '0'));
                    select_vector_array <= (others => (others => '0'));
                else
                    grant_array <= (others => (others => '1'));
                    vc_downstream_array <= (others => (others => '1'));
                    select_vector_array <= (others => (others => '1'));
                end if;
                
            end if;
        end if;
    
    end process;
    
    -- PROCES KOJI IZRACUNAVA TRENUTNO STANJE
    current_state_calculation_process : process (clk) is
    
    begin
        
        if rising_edge(clk) then
            if rst = '0' then
                current_state <= initial_state;
            else
                current_state <= next_state;
            end if;
        end if;    
        
    end process;

end Behavioral;
