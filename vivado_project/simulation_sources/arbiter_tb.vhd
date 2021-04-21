----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 04/15/2021 02:22:08 PM
-- Design Name: NoC Router
-- Module Name: arbiter_tb - Simulation
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
-- Additional Comments: Prva verzija simulacije arbitera
-- Revision 0.2 - 2021-04-19 - Mrkovic, Ramljak
-- Additional Comments: Druga verzija simulacije arbitera
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

entity arbiter_tb is
--  Port ( );
end arbiter_tb;

architecture Simulation of arbiter_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    signal vc_busy_local_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_busy_north_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_busy_east_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_busy_south_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_busy_west_sim : std_logic_vector(const_vc_num - 1 downto 0);

    signal credit_counter_local_sim : credit_counter_vector(const_vc_num - 1 downto 0);
    signal credit_counter_north_sim : credit_counter_vector(const_vc_num - 1 downto 0);
    signal credit_counter_east_sim : credit_counter_vector(const_vc_num - 1 downto 0);
    signal credit_counter_south_sim : credit_counter_vector(const_vc_num - 1 downto 0);
    signal credit_counter_west_sim : credit_counter_vector(const_vc_num - 1 downto 0);

    signal req_local_sim : destination_dir_vector(const_vc_num - 1 downto 0);
    signal req_north_sim : destination_dir_vector(const_vc_num - 1 downto 0);
    signal req_east_sim : destination_dir_vector(const_vc_num - 1 downto 0);
    signal req_south_sim : destination_dir_vector(const_vc_num - 1 downto 0);
    signal req_west_sim : destination_dir_vector(const_vc_num - 1 downto 0);

    signal head_local_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    signal head_north_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    signal head_east_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    signal head_south_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    signal head_west_sim : std_logic_vector (const_vc_num - 1 downto 0 );

    signal tail_local_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    signal tail_north_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    signal tail_east_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    signal tail_south_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    signal tail_west_sim : std_logic_vector (const_vc_num - 1 downto 0 );

    signal grant_local_sim : std_logic_vector (const_vc_num - 1 downto 0);
    signal grant_north_sim : std_logic_vector (const_vc_num - 1 downto 0);
    signal grant_east_sim : std_logic_vector (const_vc_num - 1 downto 0);
    signal grant_south_sim : std_logic_vector (const_vc_num - 1 downto 0);
    signal grant_west_sim : std_logic_vector (const_vc_num - 1 downto 0);

    signal vc_downstream_local_sim : std_logic_vector (const_vc_num - 1 downto 0);
    signal vc_downstream_north_sim : std_logic_vector (const_vc_num - 1 downto 0);
    signal vc_downstream_east_sim : std_logic_vector (const_vc_num - 1 downto 0);
    signal vc_downstream_south_sim : std_logic_vector (const_vc_num - 1 downto 0);
    signal vc_downstream_west_sim : std_logic_vector (const_vc_num - 1 downto 0);

    signal select_vector_local_sim : std_logic_vector(4 downto 0);
    signal select_vector_north_sim : std_logic_vector(4 downto 0);
    signal select_vector_east_sim : std_logic_vector(4 downto 0);
    signal select_vector_south_sim : std_logic_vector(4 downto 0);
    signal select_vector_west_sim : std_logic_vector(4 downto 0);

    -- Period takta
    constant clk_period : time := 200ns;
    
    -- Spori clk za usporedbu
    signal int_clk_sim : std_logic;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: arbiter
    
        generic map (
            vc_num => const_vc_num
        )
        
        port map (
            clk => clk_sim, 
            rst => rst_sim, 
            
            vc_busy_local => vc_busy_local_sim,  
            vc_busy_north => vc_busy_north_sim,  
            vc_busy_east => vc_busy_east_sim,  
            vc_busy_south => vc_busy_south_sim, 
            vc_busy_west => vc_busy_west_sim,  
            
            credit_counter_local => credit_counter_local_sim,  
            credit_counter_north => credit_counter_north_sim,  
            credit_counter_east => credit_counter_east_sim,  
            credit_counter_south => credit_counter_south_sim,  
            credit_counter_west => credit_counter_west_sim,  
            
            req_local => req_local_sim,  
            req_north => req_north_sim,  
            req_east => req_east_sim, 
            req_south => req_south_sim,  
            req_west => req_west_sim, 
            
            head_local => head_local_sim,  
            head_north => head_north_sim,  
            head_east => head_east_sim,  
            head_south => head_south_sim, 
            head_west => head_west_sim, 
            
            tail_local => tail_local_sim,  
            tail_north=> tail_north_sim,  
            tail_east => tail_east_sim, 
            tail_south => tail_south_sim,  
            tail_west => tail_west_sim,  
            
            grant_local => grant_local_sim,  
            grant_north => grant_north_sim, 
            grant_east => grant_east_sim,  
            grant_south => grant_south_sim,  
            grant_west => grant_west_sim,  
            
            vc_downstream_local => vc_downstream_local_sim,  
            vc_downstream_north => vc_downstream_north_sim, 
            vc_downstream_east => vc_downstream_east_sim,  
            vc_downstream_south => vc_downstream_south_sim, 
            vc_downstream_west => vc_downstream_west_sim,  
            
            select_vector_local => select_vector_local_sim,  
            select_vector_north => select_vector_north_sim,  
            select_vector_east => select_vector_east_sim, 
            select_vector_south => select_vector_south_sim,  
            select_vector_west => select_vector_west_sim  
        );
        
    -- clk proces
    clk_process : process
    
    begin
    
        clk_sim <= '1';
        wait for clk_period / 2;
        clk_sim <= '0';
        wait for clk_period / 2;
        
    end process;
    
    -- simulacija sporog takta
    int_clk_process : process (clk_sim) is 
        
        variable clk_counter : integer;
        
    begin
    
        if rising_edge(clk_sim) then
            if rst_sim = '0' then
                
                -- POSTAVI BROJILO NA 0
                clk_counter := const_clock_divider - 1;
                
                -- POSTAVI INTERNI TAKT NA 0
                int_clk_sim <= '0';
            
            else
            
                -- POVECAJ BROJILO ZA 1
                clk_counter := (clk_counter + 1) mod const_clock_divider;
                
                -- PROMIJENI FAZU INTERNOG TAKTA
                if (clk_counter = 0) then
                    int_clk_sim <= not int_clk_sim;
                end if;  
                        
            end if;
        end if;
        
    end process;
    
    -- stimulirajuci proces
    stim_process : process
    
    begin
    
        vc_busy_local_sim <= (others => '0');
        vc_busy_north_sim <= (others => '0');
        vc_busy_east_sim <= (others => '0');
        vc_busy_south_sim <= (others => '0');
        vc_busy_west_sim <= (others => '0');
    
        credit_counter_local_sim <= (others => const_buffer_size);
        credit_counter_north_sim <= (others => const_buffer_size);
        credit_counter_east_sim <= (others => const_buffer_size);
        credit_counter_south_sim <= (others => const_buffer_size);
        credit_counter_west_sim <= (others => const_buffer_size);
    
        req_local_sim <= (others => EMPTY);
        req_north_sim <= (others => EMPTY);
        req_east_sim <= (others => EMPTY);
        req_south_sim <= (others => EMPTY);
        req_west_sim <= (others => EMPTY);
    
        head_local_sim <= (others => '0');
        head_north_sim <= (others => '0');
        head_east_sim <= (others => '0');
        head_south_sim <= (others => '0');
        head_west_sim <= (others => '0');
    
        tail_local_sim <= (others => '0');
        tail_north_sim <= (others => '0');
        tail_east_sim <= (others => '0');
        tail_south_sim <= (others => '0');
        tail_west_sim <= (others => '0');
    
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (4.1 * clk_period);
        
        -- LOCAL > EAST (vc1, head)
        -- LOCAL > WEST (vc0, head)
        req_local_sim <= (1 => EAST, 0 => WEST);
        head_local_sim <= (1 => '1', 0 => '1');
        
        -- WEST > SOUTH (vc0, head)
        -- req_west_sim <= (1 => EMPTY, 0 => SOUTH);
        -- head_west_sim <= (1 => '0', 0 => '1');
        
        -- NORTH > EAST (vc1, headtail)
        -- req_north_sim <= (1 => EAST, 0 => EMPTY);
        -- head_north_sim <= (1 => '1', 0 => '0');
        -- tail_north_sim <= (1 => '1', 0 => '0');
        
        wait for clk_period;
        
        -- NADA
        
        wait for (3 * clk_period);
        
        -- LOCAL > EAST (vc1, tail)
        -- LOCAL > WEST (vc0, tail)
        head_local_sim <= (1 => '0', 0 => '1');
        tail_local_sim <= (1 => '1', 0 => '0');
        
        -- WEST > SOUTH (vc0, body)
        -- head_west_sim <= (others => '0');
        
        wait for clk_period;
        
        -- credit_counter_east_sim <= (1 => (const_buffer_size - 1), 0 => const_buffer_size);
        credit_counter_east_sim <= (1 => (const_buffer_size - 1), 0 => const_buffer_size);
        -- vc_busy_east_sim <= (1 => '1', 0 => '0');
        vc_busy_east_sim <= (1 => '1', 0 => '0');
        
        wait for (3 * clk_period);
        
        -- LOCAL > EAST (vc1)
        req_local_sim <= (1 => EMPTY, 0 => WEST);
        tail_local_sim <= (others => '0');
        
        -- WEST > SOUTH (vc0, tail)
        -- tail_west_sim <= (1 => '0', 0 => '1');
        
        wait for clk_period;
        
        -- credit_counter_east_sim <= (1 => (const_buffer_size - 2), 0 => const_buffer_size);
        credit_counter_east_sim <= (1 => (const_buffer_size - 2), 0 => const_buffer_size);
        -- vc_busy_east_sim <= (others => '0');
        vc_busy_east_sim <= (others => '0');
        
        wait for (3 * clk_period);
        
        -- WEST > SOUTH (vc0)
        -- req_west_sim <= (others => EMPTY);
        -- tail_west_sim <= (others => '0');
        
        -- LOCAL > EAST (vc1)
        head_local_sim <= (others => '0');
        tail_local_sim <= (1 => '0', 0 => '1');
        
        -- NORTH > EAST (vc1)
        -- req_north_sim <= (others => EMPTY);
        -- head_north_sim <= (others => '0');
        -- tail_north_sim <= (others => '0');
        
        wait for clk_period;
        
        credit_counter_west_sim <= (1 => const_buffer_size, 0 => (const_buffer_size - 1));
        -- credit_counter_south_sim <= (1 => const_buffer_size, 0 => (const_buffer_size - 3));
        vc_busy_west_sim <= (1 => '0', 0 => '1');
        -- vc_busy_south_sim <= (others => '1');
        
        wait for (3 * clk_period);
        
        req_local_sim <= (others => EMPTY);
        head_local_sim <= (others => '0');
        tail_local_sim <= (others => '0');
        
        wait for clk_period;
        
        credit_counter_west_sim <= (1 => const_buffer_size, 0 => (const_buffer_size - 2));
        vc_busy_west_sim <= (others => '0');
        
        
        -- wait for (5 * clk_period);
        
        -- vc_busy_local_sim <= B"01";
        -- vc_busy_north_sim <= B"10";
        -- vc_busy_east_sim <= B"01";
        -- vc_busy_south_sim <= B"10";
        -- vc_busy_west_sim <= B"01";
    
        -- credit_counter_local_sim <= (others => 7);
        -- credit_counter_north_sim <= (others => 6);
        -- credit_counter_east_sim <= (others => 5);
        -- credit_counter_south_sim <= (others => 4);
        -- credit_counter_west_sim <= (others => 3);
    
        -- req_local_sim <= (others => LOCAL);
        -- req_north_sim <= (others => NORTH);
        -- req_east_sim <= (others => EAST);
        -- req_south_sim <= (others => SOUTH);
        -- req_west_sim <= (others => WEST);
    
        -- head_local_sim <= B"10";
        -- head_north_sim <= B"01";
        -- head_east_sim <= B"10";
        -- head_south_sim <= B"01";
        -- head_west_sim <= B"10";
    
        -- tail_local_sim <= B"01";
        -- tail_north_sim <= B"10";
        -- tail_east_sim <= B"01";
        -- tail_south_sim <= B"10";
        -- tail_west_sim <= B"01";
    
        wait;
    
    end process;

end Simulation;
