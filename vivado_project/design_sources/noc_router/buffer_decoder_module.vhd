----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 03/24/2021 09:42:22 PM
-- Design Name: NoC_Router
-- Module Name: buffer_decoder_module - Behavioral
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
-- Revision 0.1 - 2021-03-24 - Ramljak
-- Additional Comments: Pocetak razvoja
-- Revision 0.2 - 2021-03-26 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija modula
-- Revision 0.3 - 2021-03-29 - Mrkovic, Ramljak
-- Additional Comments: Dodan output_process (preimenuj ga)
-- Revision 0.5 - 2021-03-30 - Mrkovic, Ramljak
-- Additional Comments: output_process i clock_diveder_process kombinirani u clock_transfer_process, sreden timing protocne strukture
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library noc_lib;
use noc_lib.router_config.ALL;
use noc_lib.component_declarations.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity buffer_decoder_module is
    
    Generic (
        vc_num : integer := const_vc_num;
        mesh_size_x : integer := const_mesh_size_x;
        mesh_size_y : integer := const_mesh_size_y;
        address_size : integer := const_address_size;
        payload_size : integer := const_payload_size;
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size;
        local_address_x : std_logic_vector(const_mesh_size_x - 1 downto 0) := const_default_address_x;
        local_address_y : std_logic_vector(const_mesh_size_y - 1 downto 0) := const_default_address_y;
        clock_divider : integer := const_clock_divider;
        diagonal_pref : routing_axis := const_default_diagonal_pref
    );
    
    Port (
        clk : in std_logic;
        rst : in std_logic; 
           
        int_data_in : in std_logic_vector(flit_size - 1 downto 0);
        int_data_in_valid : in std_logic_vector(vc_num - 1 downto 0);
        
        buffer_vc_credits : out std_logic_vector(vc_num - 1 downto 0);
        
        req : out destination_dir_vector(vc_num - 1 downto 0);
        head : out std_logic_vector (vc_num - 1 downto 0 );
        tail : out std_logic_vector (vc_num - 1 downto 0 );
        
        grant : in std_logic_vector (vc_num - 1 downto 0);
        vc_downstream : in std_logic_vector (vc_num - 1 downto 0);
        
        crossbar_data : out std_logic_vector (flit_size - 1 downto 0);
        crossbar_data_valid : out std_logic        
    );
    
end buffer_decoder_module;

architecture Behavioral of buffer_decoder_module is

    -- POLJE FLITOVA IZMEDU BUFFERA I DEKODERA
    type flit_array is
        array (integer range vc_num - 1 downto 0) of std_logic_vector(flit_size - 1 downto 0);

    -- INTERNI TAKT ROUTERA (TAKT RAZMJENE FLITOVA)
    signal int_clk : std_logic;
    
    -- INTERNI SIGNALI
    signal vc_shift : std_logic_vector (vc_num - 1 downto 0);
    
    -- INTERFACE IZMEDU BUFFERA I DEKODERA
    signal buffer_out : flit_array;
    signal buffer_next : flit_array;
    signal buffer_empty : std_logic_vector(vc_num - 1 downto 0);
    signal buffer_almost_empty : std_logic_vector(vc_num - 1 downto 0);
    
    -- INTERFACE IZMEDU DEKODERA I OUTPUTA
    signal dec_data : std_logic_vector(flit_size - 1 downto 0);
    signal dec_data_valid : std_logic;
    
    -- TESTNI SIGNALI
    signal clk_counter_test : integer;
    signal output_counter_test : integer; 
    
    signal enable_output : std_logic_vector(flit_size - 1 downto 0);
    signal enable_credits : std_logic_vector(flit_size - 1 downto 0);
    
begin    

    -- GENERIRAJ POTREBAN BROJ FIFO_buffer_module OVISNO O vc_num
    generate_buffer_input : for i in vc_num - 1 downto 0 generate
    
    begin
    
        FIFO_buffer : component FIFO_buffer_module
        
        generic map(
            flit_size => flit_size,
            buffer_size => buffer_size
        )
        
        port map(
            clk => clk,
            rst => rst, 
           
            data_in => int_data_in,
            data_in_valid => int_data_in_valid(i),
           
            right_shift => vc_shift(i),
            
            data_out => buffer_out(i),
            data_next => buffer_next(i),
           
            empty => buffer_empty(i),
            almost_empty => buffer_almost_empty(i)
        );
    
    end generate;

    -- DEKODER
    decoder_process : process(int_clk) is
    
        -- LOOP 1
        variable data : std_logic_vector(flit_size - 1 downto 0);
        variable data_valid : std_logic := '0';
        
        -- LOOP 2
        variable req_flit : std_logic_vector(flit_size - 1 downto 0);
        
        variable head_temp : std_logic_vector(vc_num - 1 downto 0);
        variable tail_temp : std_logic_vector(vc_num - 1 downto 0);
        
        variable local_x : integer;
        variable local_y : integer;
        variable dest_x : integer;
        variable dest_y : integer;
        
        variable dir_x : destination_dir;
        variable dir_y : destination_dir;
        variable dir : destination_dir;
        
        variable req_temp : destination_dir_vector(vc_num - 1 downto 0);
    
    begin
    
        if rising_edge(int_clk) then
            if rst = '0' then
            
                -- IZLAZNI SIGNALI
                dec_data <= (others => '0');
                dec_data_valid <= '0';
                
                req <= (others => EMPTY);
                head <= (others => '0');
                tail <= (others => '0');
                
                -- INTERNE VARIJABLE
                    -- LOOP 1
                data := (others => '0');
                data_valid := '0';
                
                    -- LOOP 2
                req_flit := (others => '0');
                
                head_temp := (others => '0');
                tail_temp := (others => '0');
                
                local_x := 0;
                local_y := 0;
                dest_x := 0;
                dest_y := 0;
                
                dir_x := EMPTY;
                dir_y := EMPTY;
                dir := EMPTY;
                
                req_temp := (others => EMPTY);
            
            else
            
                -- PROSLIJEDI ODGOVARAJUCI flit S BUFFERA OVISNO O grant ULAZU
                for i in (vc_num - 1) downto 0 loop
                    
                    data := (others => '0');
                    data_valid := '0';
                    if grant(i) = '1' then
                        -- PROSLIJEDI flit ODGOVARAJUCEG VIRTUALNOG KALA NA crossbar_data
                        data := buffer_out(i);
                        -- ZAMIJENI SEGMENT flita IDENTIFIKACIJSKE OZNAKE VIRTUALNOG KANALA S vc_downstream
                        data(flit_size - 3 downto flit_size - 3 - vc_num + 1) := vc_downstream;
                        -- POSTAVI crossbar_data_valid U 1
                        data_valid := '1';
                        exit;
                    end if;
                    
                end loop;
                
                -- GENERIRAJ NOVI req SIGNAL
                for i in (vc_num - 1) downto 0 loop
                    
                    -- AKO JE grant SIGNAL PROSLIJEDIO flit NA VRHU BUFFERA VIRTUALNOG KANALA i NA crossbar_data I BUFFER SADRZI JOS BAREM JEDAN flit
                    if grant(i) = '1' and buffer_almost_empty(i) = '0' then
                        -- req(i) CE BITI GENERIRAN IZ buffer_next(i)
                        req_flit := buffer_next(i);
                    -- AKO grant SIGNAL NIJE PROSLIJEDIO flit NA VRHU BUFFERA VIRTUALNOG KANALA i NA crossbar_data I BUFFER NIJE PRAZAN
                    elsif grant(i) = '0' and buffer_empty(i) = '0' then
                        -- req(i) CE BITI GENERIRAN IZ buffer_out(i)
                        req_flit := buffer_out(i);
                    else
                        req_flit := (others => '0');
                    end if;
                    
                    -- GENERIRAJ head I tail VEKTORE
                    head_temp(i) := req_flit(flit_size - 1);
                    tail_temp(i) := req_flit(flit_size - 2);
                    
                    -- PRETVORI ADRESE (LOKALNE I DESTINACIJSKE) U INTEGERE
                    local_x := conv_integer(local_address_x);
                    local_y := conv_integer(local_address_y);
                    dest_x := conv_integer(req_flit(flit_size - 1 - 2 - vc_num downto flit_size - 1 - 2 - vc_num - mesh_size_x + 1));
                    dest_y := conv_integer(req_flit(flit_size - 1 - 2 - vc_num - mesh_size_x downto flit_size - 1 - 2 - vc_num - mesh_size_x - mesh_size_y + 1));
                    
                    -- OVSINO O PREFERENCI DIJAGONALNOG USMJERAVANJA, IZRACUNAJ PRVO HOR ILI VER KOMPONENTU
                    -- AKO SU ADRESE DESTINACIJE 0
                    if dest_x = 0 and dest_y = 0 then
                        
                        -- BUFFER VIRTUALNOG KANALA i PRAZAN
                        dir := EMPTY;
                        
                    else
                    
                        -- USPOREDI X KOMPONENTU
                        if local_x > dest_x then
                            dir_x := WEST;
                        elsif local_x < dest_x then
                            dir_x := EAST;
                        else
                            dir_x := LOCAL;
                        end if;
                         
                        -- USPOREDI Y KOMPONENETU
                        if local_y > dest_y then
                            dir_y := NORTH;
                        elsif local_y < dest_y then
                            dir_y := SOUTH;
                        else
                            dir_y := LOCAL;
                        end if;
                        
                        -- ODREDI KONACAN SMJER    
                        if dir_x = LOCAL and dir_y = LOCAL then
                            dir := LOCAL;
                        elsif dir_x = LOCAL and dir_y /= LOCAL then
                            dir := dir_y;
                        elsif dir_x /= LOCAL and dir_y = LOCAL then
                            dir := dir_x;
                        else
                            if diagonal_pref = HOR then
                                dir := dir_x;
                            else
                                dir := dir_y;
                            end if;
                        end if; 
                        
                    end if;
                    
                    req_temp(i) := dir;
                    
                end loop;
                
                -- PROSLIJEDI VARIJABLE NA VIRTUALNE KANALE
                dec_data <= data;
                dec_data_valid <= data_valid;
                
                req <= req_temp;
                head <= head_temp;
                tail <= tail_temp;
                
            end if;
        end if;
        
    end process;
    
    -- TRANSFER TAKTA
    clock_transfer_process : process (clk) is 
        
        variable clk_counter : integer;
        variable output_counter : integer;
        
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                -- POSTAVI BROJILO NA 0
                clk_counter := clock_divider - 1;
                output_counter := (clock_divider * 2) - 1;
                
                -- POSTAVI INTERNI TAKT NA 0
                int_clk <= '0';
                enable_output <= (others => '0');
                enable_credits <= (others => '0');
            
            else
            
                -- POVECAJ BROJILO ZA 1
                clk_counter := (clk_counter + 1) mod clock_divider;
                output_counter := (output_counter + 1) mod (clock_divider * 2);
                
                -- PROMIJENI FAZU INTERNOG TAKTA
                if (clk_counter = 0) then
                    int_clk <= not int_clk;
                end if;  
                
                -- PROPUSTI UBRZANE IZLAZE
                if (output_counter = 0) then 
                    enable_output <= (others => '1');
                else
                    enable_output <= (others => '0');
                end if;
                
                -- PROPUSTI KREDIT PREMA INTERFACEU
                if (output_counter = (clock_divider * 2) - 1) then 
                    enable_credits <= (others => '1');
                else
                    enable_credits <= (others => '0');
                end if;
                
                clk_counter_test <= clk_counter;
                output_counter_test <= output_counter;
                             
            end if;
        end if;
        
    end process;
    
    -- PROSLIJEDI IZLAZE DEKODERA NA CROSSBAR
    crossbar_data <= dec_data and enable_output;
    crossbar_data_valid <= dec_data_valid and enable_output(0);
    -- PROSLIJEDI grant NA IZLAZ buffer_vc_credits (PREMA router_interface_module)
    buffer_vc_credits <= grant and enable_credits(vc_num - 1 downto 0);
    -- PROSLIJEDI grant NA vc_shift
    vc_shift <= grant and enable_output(vc_num - 1 downto 0);
             
end Behavioral;