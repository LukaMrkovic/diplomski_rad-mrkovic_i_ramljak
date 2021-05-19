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
-- Revision 0.8 - 2021-05-01 - Mrkovic
-- Additional Comments: Potpuna verzija arbitera
-- Revision 0.9 - 2021-05-02 - Mrkovic
-- Additional Comments: Dotjerana potpuna verzija arbitera
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library noc_lib;
use noc_lib.router_config.ALL;
use noc_lib.router_functions.ALL;

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
    type state_type is (state_4, state_3, state_2, state_1);
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
    -- ARRAY VELICINE IO integera
    type IO_x_1_integer_array is
        array (4 downto 0) of integer;
    -- ARRAY VELICINE (IO * vc_num) std_logic_vectora DULJINE (IO * vc_num)
    type IO_vc_num_x_IO_vc_num_std_array is
        array ((5 * vc_num) - 1 downto 0) of std_logic_vector((5 * vc_num) - 1 downto 0);
    -- ARRAY VELICINE IO vc_mask_or_priority_vectora
    type IO_x_1_vc_mask_or_priority_vector_array is
        array (4 downto 0) of vc_mask_or_priority_vector;
    -- ARRAY VELICINE IO UZLAZNIH std_logic_vectora DULJINE vc_num
    type IO_x_vc_num_asc_std_array is
        array (4 downto 0) of std_logic_vector (0 to vc_num - 1);
    
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
    -- MATRICA ZAHTJEVA ULAZA NA IZLAZE
    signal IO_req_matrix : IO_x_IO_std_array;
    -- ARBITRIRANI VIRTUALNI KANALI
    signal arbitrated_vc_priority_index_array : IO_x_1_integer_array;
    
    -- VEKTOR INDEKSA ULAZA POREDANIH PO PRIORITERU
    signal input_priority_vector : input_mask_or_priority_vector;
    -- VEKTOR ULAZA OBRADJENIH U PRIJASNJEM CIKLUSU (ULAZI POREDANI JEDNAKO KAO I U input_priority_vector)
    signal processed_inputs_vector : std_logic_vector(0 to 4);
    -- MASKA ZA GENERIRANJE OSVJEZENOG input_priority_vector
    signal input_mask_vector : input_mask_or_priority_vector;
    
    -- POLJE VEKTORA INDEKSA VIRTUALNIH KANALA POREDANIH PO PRIORITETU
    signal vc_priority_vector_array : IO_x_1_vc_mask_or_priority_vector_array;
    -- POLJE VEKTORA VIRTUALNIH KANALA OBRADJENIH U PRIJASNJEM CIKLUSU (VIRTUALNI KANALI POREDANI JEDNAKO KAO I U vc_priority_vector_array)
    signal processed_vcs_vector_array : IO_x_vc_num_asc_std_array;
    -- POLJE MASKI ZA GENERIRANJE OSVJEZENOG vc_priority_vector_array
    signal vc_mask_vector_array : IO_x_1_vc_mask_or_priority_vector_array;

begin

    -- PREPISIVANJE I/O SIGNALA U/IZ POLJA
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
    
        variable input_mask_vector_var : input_mask_or_priority_vector;
        variable vc_mask_vector_array_var : IO_x_1_vc_mask_or_priority_vector_array;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                -- IZLAZNI SIGNALI
                input_mask_vector <= (0, 1, 2, 3, 4);
                vc_mask_vector_array <= (others => reset_vc_order);
                
                -- INTERNE VARIJABLE
                input_mask_vector_var := (0, 1, 2, 3, 4);
                vc_mask_vector_array_var := (others => reset_vc_order);
                
            else
                
                -- AKO JE POSTAVLJEN SIGNAL state_1_enable
                if state_1_enable = '1' then
                
                    -- GENERIRAJ input_mask_vector NA OSNOVU processed_inputs_vector VRIJEDNOSTI
                    input_mask_vector_var := generate_input_mask(processed_inputs_vector);
                    
                    -- PARALELAN IZRACUN vc_mask_vector SVAKOG ULAZA
                    loop_1 : for i in 4 downto 0 loop
                    
                        -- ODREDI vc_mask_vector NA OSNOVU processed_vcs_vector VRIJEDNOSTI
                        vc_mask_vector_array_var(i) := generate_vc_mask(processed_vcs_vector_array(i));
                    
                    end loop;
                
                end if;
                
                -- PROSLIJEDI INTERNE VARIJABLE NA SIGNALE
                input_mask_vector <= input_mask_vector_var;
                vc_mask_vector_array <=  vc_mask_vector_array_var;
                
            end if;
        end if;
    
    end process;
    
    -- PROCES STANJA 2
    state_2_process : process (clk) is
    
        variable input_priority_vector_var : input_mask_or_priority_vector;
        variable vc_priority_vector_array_var : IO_x_1_vc_mask_or_priority_vector_array;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                -- IZLAZNI SIGNALI
                input_priority_vector <= (0, 1, 2, 3, 4);
                vc_priority_vector_array <= (others => reset_vc_order);
                
                -- INTERNE VARIJABLE
                input_priority_vector_var := (0, 1, 2, 3, 4);
                vc_priority_vector_array_var := (others => reset_vc_order);
            
            else
                
                -- AKO JE POSTAVLJEN SIGNAL state_2_enable
                if state_2_enable = '1' then
                
                    -- PARALELNA OBRADA SVAKOG BITA input_priority_vectora
                    loop_1a : for i in 0 to 4 loop
                    
                        input_priority_vector_var(i) := input_priority_vector(input_mask_vector(i));
                    
                    end loop;
                    
                    -- PARALELNA OBRADA SVAKOG vc_priority_vectora U vc_priority_vector_arrayu
                    loop_1b : for i in 4 downto 0 loop
                    
                        -- PARALELNA OBRADA SVAKOG BITA vc_priority
                        loop_2 : for j in 0 to (vc_num - 1) loop
                        
                            vc_priority_vector_array_var(i)(j) := vc_priority_vector_array(i)(vc_mask_vector_array(i)(j));
                        
                        end loop;
                    
                    end loop;
                
                end if;
                
                -- PROSLIJEDI INTERNE VARIJABLE NA SIGNALE
                input_priority_vector <= input_priority_vector_var;
                vc_priority_vector_array <= vc_priority_vector_array_var;
                
            end if;
        end if;
    
    end process;
    
    -- PROCES STANJA 3
    state_3_process : process (clk) is
    
        variable ds_index : integer;
        variable vc_index : integer;
        
        variable req_parsed : destination_dir_vector(vc_num - 1 downto 0);
        
        variable IO_req_matrix_var : IO_x_IO_std_array;
        variable arbitrated_vc_priority_index_array_var : IO_x_1_integer_array; 
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                -- IZLAZNI SIGNALI
                IO_req_matrix <= (others => (others => '0'));
                arbitrated_vc_priority_index_array <= (others => 0);
                
                -- INTERNE VARIJABLE
                ds_index := 0;
                vc_index := 0;
                
                req_parsed := (others => EMPTY);
                
                IO_req_matrix_var := (others => (others => '0'));
                arbitrated_vc_priority_index_array_var := (others => 0);
            
            else
            
                -- AKO JE POSTAVLJEN SIGNAL state_3_enable
                if state_3_enable = '1' then
                
                    -- RESETIRAJ IO_req_matrix_var I arbitrated_vc_priority_index_array_var U 00... 0
                    IO_req_matrix_var := (others => (others => '0'));
                    arbitrated_vc_priority_index_array_var := (others => 0);
                
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
                                
                                -- AKO SIGNAL head_array(i)(j) JE POSTAVLJEN I SIGNAL vc_busy_array(ds_index)(j) NIJE POSTAVLJEN [novi paket]
                                -- ILI
                                -- AKO SIGNAL head_array(i)(j) NIJE POSTAVLJEN I SIGNAL connection_array((vc_num * i) + j)((vc_num * ds_index) + j) JE POSTAVLJEN [paket u tijeku]
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
                        
                            vc_index := vc_priority_vector_array(i)(j);
                        
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
                                -- POHRANI INDEX U POLJU vc_priority_vector ARBITRIRANOG VIRTUALNOG KANALA U arbitrated_vc_priority_index_array_var(i)
                                arbitrated_vc_priority_index_array_var(i) := j;
                                
                                -- IZADJI IZ PETLJE
                                exit loop_2b;
                                
                            end if;
                        
                        end loop;
                    
                    end loop;
                
                end if;
            
                -- PROSLIJEDI INTERNE VARIJABLE NA SIGNALE
                IO_req_matrix <= IO_req_matrix_var;
                arbitrated_vc_priority_index_array <= arbitrated_vc_priority_index_array_var;
            
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
        variable processed_inputs_vector_var : std_logic_vector(0 to 4);
        variable processed_vcs_vector_array_var : IO_x_vc_num_asc_std_array;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                -- IZLAZNI SIGNALI
                grant_array <= (others => (others => '0'));
                vc_downstream_array <= (others => (others => '0'));
                select_vector_array <= (others => (others => '0'));
                
                connection_array <= (others => (others => '0'));
                processed_inputs_vector <= (others => '0');
                processed_vcs_vector_array <= (others => (others => '0'));
                
                -- INTERNE VARIJABLE
                
                rr_index := 0;
                vc_index := 0;
                
                grant_array_var := (others => (others => '0'));
                vc_downstream_array_var := (others => (others => '0'));
                select_vector_array_var := (others => (others => '0'));
                
                connection_array_var := (others => (others => '0'));
                processed_inputs_vector_var := (others => '0');
                processed_vcs_vector_array_var := (others => (others => '0'));
                
            else
                
                -- AKO JE POSTAVLJEN SIGNAL state_4_enable
                if state_4_enable = '1' then
                
                    grant_array_var := (others => (others => '0'));
                    vc_downstream_array_var := (others => (others => '0'));
                    select_vector_array_var := (others => (others => '0'));
                    
                    processed_inputs_vector_var := (others => '0');
                    processed_vcs_vector_array_var := (others => (others => '0'));
                
                    -- PARALELNO ARBITRIRANJE SVAKOG IZLAZA
                    loop_1 : for i in 4 downto 0 loop
                    
                        -- ODABERI ULAZ S POSTAVLJENIM ZAHTJEVOM NAJVISEG PRIORITETA ZA SVAKI IZLAZ (PO ROUND ROBINU)
                        loop_2 : for j in 0 to 4 loop
                        
                            rr_index := input_priority_vector(j);
                        
                            -- AKO JE BIT IO_req_matrix(i)(rr_index) POSTAVLJEN
                            if IO_req_matrix(i)(rr_index) = '1' then
                            
                                vc_index := vc_priority_vector_array(rr_index)(arbitrated_vc_priority_index_array(rr_index));
                            
                                -- GENERIRAJ ODGOVARAJUCI grant SIGNAL
                                grant_array_var(rr_index) := (others => '0');
                                grant_array_var(rr_index)(vc_index) := '1';
                                -- GENERIRAJ ODGOVARAJUCI vc_downstream SIGNAL
                                vc_downstream_array_var(rr_index) := (others => '0');
                                vc_downstream_array_var(rr_index)(vc_index) := '1';
                                -- GENERIRAJ ODGOVARAJUCI select_vector SIGNAL
                                select_vector_array_var(i) := (others => '0');
                                select_vector_array_var(i)(rr_index) := '1';
                                
                                -- AKO JE POSTAVLJEN head SIGNAL POHRANI KONEKCIJU UZVODNOG I NIZVODNOG VIRTUALNOG KANALA
                                if head_array(rr_index)(vc_index) = '1' then
                                    connection_array_var((vc_num * rr_index) + vc_index)((vc_num * i) + vc_index) := '1';
                                end if;
                                -- AKO JE POSTAVLJEN tail SIGNAL OBRIŠI KONEKCIJU UZVODNOG I NIZVODNOG VIRTUALNOG KANALA
                                if tail_array(rr_index)(vc_index) = '1' then
                                    connection_array_var((vc_num * rr_index) + vc_index)((vc_num * i) + vc_index) := '0';
                                    processed_inputs_vector_var(j) := '1';
                                    processed_vcs_vector_array_var(rr_index)(arbitrated_vc_priority_index_array(rr_index)) := '1';
                                end if;
                               
                                -- IZADJI IZ PETLJE
                                exit loop_2;
                            
                            end if;
                        
                        end loop;
                    
                    end loop;
                
                end if;
                
                -- PROSLIJEDI INTERNE VARIJABLE NA SIGNALE
                grant_array <= grant_array_var;
                vc_downstream_array <= vc_downstream_array_var;
                select_vector_array <= select_vector_array_var;
                
                connection_array <= connection_array_var;
                processed_inputs_vector <= processed_inputs_vector_var;
                processed_vcs_vector_array <= processed_vcs_vector_array_var;
                
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