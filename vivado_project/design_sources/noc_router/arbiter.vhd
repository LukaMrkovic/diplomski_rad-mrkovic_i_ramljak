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
-- Revision 0.2 - 2021-04-16 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija arbitera
-- Revision 0.3 - 2021-04-19 - Mrkovic, Ramljak
-- Additional Comments: Testna verzija arbitera
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
    type IO_x_vc_num_std_array is
        array (4 downto 0) of std_logic_vector (vc_num - 1 downto 0);
    -- ARRAY ZA GRUPIRANJE ULAZA OBLIKA std_logic_vector (4 downto 0) 
    type IO_x_IO_std_array is
        array (4 downto 0) of std_logic_vector(4 downto 0);
    -- ARRAY ZA GRUPIRANJE ULAZA OBLIKA credit_counter_vector(vc_num - 1 downto 0)
    type IO_x_vc_num_credit_counter_array is
        array (4 downto 0) of credit_counter_vector(vc_num - 1 downto 0);
    -- ARRAY ZA GRUPIRANJE ULAZA OBLIKA destination_dir_vector(vc_num - 1 downto 0)
    type IO_x_vc_num_destination_dir_array is 
        array (4 downto 0) of destination_dir_vector(vc_num - 1 downto 0);
    -- ARRAY INTEGERA
    type IO_x_1_integer_array is
        array (4 downto 0) of integer;
    -- ARRAY VELICINE IO * vc_num VEKTORA DULJINE IO * vc_num
    type IO_vc_num_x_IO_vc_num_std_array is
        array ((5 * vc_num) - 1 downto 0) of std_logic_vector((5 * vc_num) - 1 downto 0);
    
    -- ULAZNA POLJA
    signal vc_busy_array : IO_x_vc_num_std_array;
    signal credit_counter_array : IO_x_vc_num_credit_counter_array;
    signal req_array : IO_x_vc_num_destination_dir_array;
    signal head_array : IO_x_vc_num_std_array;
    signal tail_array : IO_x_vc_num_std_array;
    
    -- IZLAZNA POLJA
    signal grant_array : IO_x_vc_num_std_array;
    signal vc_downstream_array : IO_x_vc_num_std_array;
    signal select_vector_array : IO_x_IO_std_array;
    
    -- INTERNI SIGNALI
    -- POLJE KONEKCIJA UZVODNIH I NIZVODNIH VIRTUALNIH KANALA
    signal connection_array : IO_vc_num_x_IO_vc_num_std_array;
    -- ROUND ROBIN COUNTERI ZA VIRTUALNE KANALE PO ULAZIMA
    signal vc_rr_counter_array : IO_x_1_integer_array;
    -- MATRICA ZAHTJEVA ULAZA NA IZLAZE
    signal IO_req_matrix : IO_x_IO_std_array;
    -- ARBITRIRANI VIRTUALNI KANALI
    signal arbitrated_vc_array : IO_x_1_integer_array;
    
    -- DODATNA POLJA I INTERNI SIGNALI (DODANI PRILIKOM UNAPRIJEDJENJA ROUND ROBIN IMPLEMENTACIJE)
    -- UZLAZAN ARRAY INTEGERA
    type IO_x_1_integer_rising_array is
        array (0 to 4) of integer;
    -- POLJE INDEKSA ULAZA POREDANO PO PRIORITERU ULAZA
    signal input_priority_array : IO_x_1_integer_rising_array;
    -- POLJE ULAZA OBRADJENIH U PRIJASNJEM CIKLUSU (ULAZI POREDANI JEDNAKO KAO I U input_priority_array)
    signal processed_inputs_array : std_logic_vector(0 to 4);
    -- MASKA ZA GENERIRANJE OSVJEZENOG input_priority_array
    signal io_mask_array : IO_x_1_integer_rising_array;
    
    

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
    
        variable io_mask_array_var : IO_x_1_integer_rising_array;
        variable vc_rr_counter_array_var : IO_x_1_integer_array;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                -- IZLAZNI SIGNALI
                io_mask_array <= (0, 1, 2, 3, 4);
                vc_rr_counter_array <= (others => 0);
                
                -- INTERNE VARIJABLE
                io_mask_array_var := (0, 1, 2, 3, 4);
                vc_rr_counter_array_var := (others => (vc_num - 1));
                
            else
                
                -- AKO JE POSTAVLJEN SIGNAL state_1_enable
                if state_1_enable = '1' then
                
                    -- >DODANO PRILIKOM UNAPRIJEDJENJA ROUND ROBIN IMPLEMENTACIJE
                    -- ODREDI io_mask_array NA OSNOVU processed_inputs_array VRIJEDNOSTI
                    case processed_inputs_array is
                        when "00000" => io_mask_array_var := (0, 1, 2, 3, 4);
                        when "00001" => io_mask_array_var := (0, 1, 2, 3, 4);
                        when "00010" => io_mask_array_var := (0, 1, 2, 4, 3);
                        when "00011" => io_mask_array_var := (0, 1, 2, 3, 4);
                                        
                        when "00100" => io_mask_array_var := (0, 1, 3, 4, 2);
                        when "00101" => io_mask_array_var := (0, 1, 3, 2, 4);
                        when "00110" => io_mask_array_var := (0, 1, 4, 2, 3);
                        when "00111" => io_mask_array_var := (0, 1, 2, 3, 4);
                                        
                        when "01000" => io_mask_array_var := (0, 2, 3, 4, 1);
                        when "01001" => io_mask_array_var := (0, 2, 3, 1, 4);
                        when "01010" => io_mask_array_var := (0, 2, 4, 1, 3);
                        when "01011" => io_mask_array_var := (0, 2, 1, 3, 4);
                                        
                        when "01100" => io_mask_array_var := (0, 3, 4, 1, 2);
                        when "01101" => io_mask_array_var := (0, 3, 1, 2, 4);
                        when "01110" => io_mask_array_var := (0, 4, 1, 2, 3);
                        when "01111" => io_mask_array_var := (0, 1, 2, 3, 4);
                                        
                        when "10000" => io_mask_array_var := (1, 2, 3, 4, 0);
                        when "10001" => io_mask_array_var := (1, 2, 3, 0, 4);
                        when "10010" => io_mask_array_var := (1, 2, 4, 0, 3);
                        when "10011" => io_mask_array_var := (1, 2, 0, 3, 4);
                                        
                        when "10100" => io_mask_array_var := (1, 3, 4, 0, 2);
                        when "10101" => io_mask_array_var := (1, 3, 0, 2, 4);
                        when "10110" => io_mask_array_var := (1, 4, 0, 2, 3);
                        when "10111" => io_mask_array_var := (1, 0, 2, 3, 4);
                                        
                        when "11000" => io_mask_array_var := (2, 3, 4, 0, 1);
                        when "11001" => io_mask_array_var := (2, 3, 0, 1, 4);
                        when "11010" => io_mask_array_var := (2, 4, 0, 1, 3);
                        when "11011" => io_mask_array_var := (2, 0, 1, 3, 4);
                                        
                        when "11100" => io_mask_array_var := (3, 4, 0, 1, 2);
                        when "11101" => io_mask_array_var := (3, 0, 1, 2, 4);
                        when "11110" => io_mask_array_var := (4, 0, 1, 2, 3);
                        when "11111" => io_mask_array_var := (0, 1, 2, 3, 4);
                                        
                        when others  => io_mask_array_var := (0, 1, 2, 3, 4);
                    end case;
                    -- <
                    
                    -- PARALELNA OBRADA ROUND ROBIN BROJILA SVAKOG ULAZA
                    loop_1 : for i in 4 downto 0 loop
                    
                        -- AKO KONEKCIJA ULAZNOG VIRTUALNOG KANALA NE POSTOJI NITI S JEDNIM IZLAZNIM VIRTUALNIM KANALOM
                        if unsigned(connection_array((vc_num * i) + vc_rr_counter_array_var(i))) = 0 then
                        
                            vc_rr_counter_array_var(i) := (vc_rr_counter_array_var(i) + 1) mod vc_num;
                        
                        end if;
                    
                    end loop;
                
                end if;
                
                io_mask_array <= io_mask_array_var;
                vc_rr_counter_array <= vc_rr_counter_array_var;
                
            end if;
        end if;
    
    end process;
    
    -- PROCES STANJA 2
    state_2_process : process (clk) is
    
        variable input_priority_array_var : IO_x_1_integer_rising_array;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                -- IZLAZNI SIGNALI
                input_priority_array <= (0, 1, 2, 3, 4);
                
                -- INTERNE VARIJABLE
                input_priority_array_var := (0, 1, 2, 3, 4);
            
            else
                
                -- AKO JE POSTAVLJEN SIGNAL state_2_enable
                if state_2_enable = '1' then
                
                    -- PARALELNA OBRADA SVAKOG BITA input_priority_array
                    loop_1 : for i in 0 to 4 loop
                    
                        input_priority_array_var(i) := input_priority_array(io_mask_array(i));
                    
                    end loop;
                
                end if;
                
                input_priority_array <= input_priority_array_var;
                
            end if;
        end if;
    
    end process;
    
    -- PROCES STANJA 3
    state_3_process : process (clk) is
    
        variable ds_index : integer;
        variable vc_index : integer;
        
        variable req_parsed : destination_dir_vector(vc_num - 1 downto 0);
        variable IO_req_matrix_var : IO_x_IO_std_array;
        variable arbitrated_vc_array_var : IO_x_1_integer_array; 
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                -- IZLAZNI SIGNALI
                IO_req_matrix <= (others => (others => '0'));
                arbitrated_vc_array <= (others => 0);
                
                -- INTERNE VARIJABLE
                ds_index := 0;
                vc_index := 0;
                
                req_parsed := (others => EMPTY);
                IO_req_matrix_var := (others => (others => '0'));
                
                arbitrated_vc_array_var := (others => 0);
            
            else
            
                -- AKO JE POSTAVLJEN SIGNAL state_3_enable
                if state_3_enable = '1' then
                
                    -- RESETIRAJ IO_req_matrix_var I arbitrated_vc_array_var U 00... 0
                    IO_req_matrix_var := (others => (others => '0'));
                    arbitrated_vc_array_var := (others => 0);
                
                    -- PARALELNA OBRADA I ARBITRIRANJE SVAKOG ULAZA
                    loop_1 : for i in 4 downto 0 loop
                    
                        -- RESETIRAJ req_parsed U EMPTY, EMPTY,... EMPTY
                        req_parsed := (others => EMPTY);
                    
                        -- PROCISTI ZAHTJEV SVAKOG VIRTUALNOG KANALA ULAZA
                        loop_2a : for j in (vc_num - 1) downto 0 loop
                        
                            -- AKO JE ZAHTJEV U req_array(i)(j) RAZLICIT OD EMPTY
                            if req_array(i)(j) /= EMPTY then
                            
                                -- ODREEDI INDEKS NIZVODNOG vc_busy SIGNALA
                                case req_array(i)(j) is
                                    when NORTH => ds_index := 1;
                                    when EAST => ds_index := 2;
                                    when SOUTH => ds_index := 3;
                                    when WEST => ds_index := 4;
                                    when others => ds_index := 0;
                                end case;
                                
                                -- AKO SIGNAL head_array(i)(j) JE POSTAVLJEN I SIGNAL vc_busy_array(ds_index)(j) NIJE POSTAVLJEN
                                -- ILI
                                -- AKO SIGNAL head_array(i)(j) NIJE POSTAVLJEN I SIGNAL connection_array((vc_num * i) + j)((vc_num * ds_index) + j) JE POSTAVLJEN
                                if (head_array(i)(j) = '1' and vc_busy_array(ds_index)(j) = '0') or
                                   (head_array(i)(j) = '0' and connection_array((vc_num * i) + j)((vc_num * ds_index) + j) = '1') then
                                   
                                    -- AKO SIGNAL credit_counter_array(ds_index)(j) VECI OD 0 
                                    if credit_counter_array(ds_index)(j) > 0 then
                                    
                                        -- PREPISI ZAHTJEV IZ req_array(i)(j) U req_parsed(j)
                                        req_parsed(j) := req_array(i)(j);
                                    
                                    end if;
                                   
                                end if;
                            
                            end if;
                        
                        end loop;
                        
                        -- ODABERI POSTAVLJEN ZAHTJEV NAJVISEG PRIORITETA (PO ROUND ROBINU)
                        loop_2b : for j in 0 to (vc_num - 1) loop
                        
                            vc_index := (j + vc_rr_counter_array(i)) mod vc_num;
                        
                            -- AKO JE ZAHTJEV U req_parsed(vc_index) POSTAVLJEN
                            if req_parsed(vc_index) /= EMPTY then
                                
                                -- ODREEDI INDEKS ZAHTJEVANOG IZLAZA
                                case req_parsed(vc_index) is
                                    when NORTH => ds_index := 1;
                                    when EAST => ds_index := 2;
                                    when SOUTH => ds_index := 3;
                                    when WEST => ds_index := 4;
                                    when others => ds_index := 0;
                                end case;
                                
                                -- POSTAVI IO_req_matrix_var(ds_index)(i) U 1
                                IO_req_matrix_var(ds_index)(i) := '1';
                                -- POHRANI ARBITRIRANI VIRTUALNI KANAL U arbitrated_vc_array_var(i)
                                arbitrated_vc_array_var(i) := vc_index;
                                
                                -- IZADJI IZ PETLJE
                                exit loop_2b;
                                
                            end if;
                        
                        end loop;
                    
                    end loop;
                
                end if;
            
                -- PROSLIJEDI INTERNE VARIJABLE NA SIGNALE
                IO_req_matrix <= IO_req_matrix_var;
                arbitrated_vc_array <= arbitrated_vc_array_var;
            
            end if;
        end if;
    
    end process;
    
    -- PROCES STANJA 4
    state_4_process : process (clk) is
    
        variable rr_index : integer;
        variable vc_index : integer;
        
        variable grant_array_var : IO_x_vc_num_std_array;
        variable vc_downstream_array_var : IO_x_vc_num_std_array;
        variable select_vector_array_var : IO_x_IO_std_array;
        
        variable connection_array_var : IO_vc_num_x_IO_vc_num_std_array;
        variable processed_inputs_array_var : std_logic_vector(0 to 4);
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                -- IZLAZNI SIGNALI
                grant_array <= (others => (others => '0'));
                vc_downstream_array <= (others => (others => '0'));
                select_vector_array <= (others => (others => '0'));
                
                connection_array <= (others => (others => '0'));
                processed_inputs_array <= (others => '0');
                
                -- INTERNE VARIJABLE
                
                rr_index := 0;
                vc_index := 0;
                
                grant_array_var := (others => (others => '0'));
                vc_downstream_array_var := (others => (others => '0'));
                select_vector_array_var := (others => (others => '0'));
                
                connection_array_var := (others => (others => '0'));
                processed_inputs_array_var := (others => '0');
                
            else
                
                -- AKO JE POSTAVLJEN SIGNAL state_4_enable
                if state_4_enable = '1' then
                
                    grant_array_var := (others => (others => '0'));
                    vc_downstream_array_var := (others => (others => '0'));
                    select_vector_array_var := (others => (others => '0'));
                    processed_inputs_array_var := (others => '0');
                
                    -- PARALELNO ARBITRIRANJE SVAKOG IZLAZA
                    loop_1 : for i in 4 downto 0 loop
                    
                        -- ODABERI ULAZ S POSTAVLJENIM ZAHTJEVOM NAJVISEG PRIORITETA ZA SVAKI IZLAZ (PO ROUND ROBINU)
                        loop_2 : for j in 0 to 4 loop
                        
                            rr_index := input_priority_array(j);
                        
                            -- AKO JE BIT IO_req_matrix(i)(rr_index) POSTAVLJEN
                            if IO_req_matrix(i)(rr_index) = '1' then
                            
                                vc_index := arbitrated_vc_array(rr_index);
                            
                                -- GENERIRAJ ODGOVARAJUCI grant SIGNAL
                                grant_array_var(rr_index) := (vc_index => '1', others => '0');
                                -- GENERIRAJ ODGOVARAJUCI vc_downstream SIGNAL
                                vc_downstream_array_var(rr_index) := (vc_index => '1', others => '0');
                                -- GENERIRAJ ODGOVARAJUCI select_vector SIGNAL
                                select_vector_array_var(i) := (rr_index => '1', others => '0');
                                
                                -- AKO JE POSTAVLJEN head SIGNAL POHRANI KONEKCIJU UZVODNOG I NIZVODNOG VIRTUALNOG KANALA
                                if head_array(rr_index)(vc_index) = '1' then
                                    connection_array_var((vc_num * rr_index) + vc_index)((vc_num * i) + vc_index) := '1';
                                end if;
                                -- AKO JE POSTAVLJEN tail SIGNAL OBRIŠI KONEKCIJU UZVODNOG I NIZVODNOG VIRTUALNOG KANALA
                                if tail_array(rr_index)(vc_index) = '1' then
                                    connection_array_var((vc_num * rr_index) + vc_index)((vc_num * i) + vc_index) := '0';
                                    processed_inputs_array_var(j) := '1';
                                end if;
                               
                                -- IZADJI IZ PETLJE
                                exit loop_2;
                            
                            end if;
                        
                        end loop;
                    
                    end loop;
                
                end if;
                
                grant_array <= grant_array_var;
                vc_downstream_array <= vc_downstream_array_var;
                select_vector_array <= select_vector_array_var;
                
                connection_array <= connection_array_var;
                processed_inputs_array <= processed_inputs_array_var;
                
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