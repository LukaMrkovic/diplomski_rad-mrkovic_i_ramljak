----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 21.04.2021 12:15:08
-- Design Name: NoC Router
-- Module Name: noc_router_tb - Simulation
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
-- Revision 0.1 - 2021-04-21 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija simulacije noc_routera
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

entity noc_router_tb is
--  Port ( );
end noc_router_tb;

architecture Simulation of noc_router_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;

    -- ROUTER TO ROUTER INTERFACE
    -- LOCAL
    signal data_in_local_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_local_sim : std_logic;
    signal data_in_vc_busy_local_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_local_sim : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_local_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_local_sim : std_logic;
    signal data_out_vc_busy_local_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_local_sim : std_logic_vector(const_vc_num - 1 downto 0);

    -- ROUTER TO ROUTER INTERFACE
    -- NORTH
    signal data_in_north_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_north_sim : std_logic;
    signal data_in_vc_busy_north_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_north_sim : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_north_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_north_sim : std_logic;
    signal data_out_vc_busy_north_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_north_sim : std_logic_vector(const_vc_num - 1 downto 0);

    -- ROUTER TO ROUTER INTERFACE
    -- EAST
    signal data_in_east_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_east_sim : std_logic;
    signal data_in_vc_busy_east_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_east_sim : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_east_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_east_sim : std_logic;
    signal data_out_vc_busy_east_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_east_sim : std_logic_vector(const_vc_num - 1 downto 0);

    -- ROUTER TO ROUTER INTERFACE
    -- SOUTH
    signal data_in_south_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_south_sim : std_logic;
    signal data_in_vc_busy_south_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_south_sim : std_logic_vector(const_vc_num - 1 downto 0);
        
    signal data_out_south_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_south_sim : std_logic;
    signal data_out_vc_busy_south_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_south_sim : std_logic_vector(const_vc_num - 1 downto 0);

    -- ROUTER TO ROUTER INTERFACE
    -- WEST
    signal data_in_west_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_west_sim : std_logic;
    signal data_in_vc_busy_west_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_west_sim : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_west_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_west_sim : std_logic;
    signal data_out_vc_busy_west_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_west_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- Period takta
    constant clk_period : time := 200ns;
    
    -- Spori clk za usporedbu
    signal int_clk_sim : std_logic;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: noc_router
    
        generic map (
            vc_num => const_vc_num,
            mesh_size_x => const_mesh_size_x,
            mesh_size_y => const_mesh_size_y,
            address_size => const_address_size,
            payload_size => const_payload_size,
            flit_size => const_flit_size,
            buffer_size => const_buffer_size,
            local_address_x => const_default_address_x,
            local_address_y => const_default_address_y,
            clock_divider => const_clock_divider,
            diagonal_pref => const_default_diagonal_pref
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
               
            data_in_local => data_in_local_sim,
            data_in_valid_local => data_in_valid_local_sim,
            data_in_vc_busy_local => data_in_vc_busy_local_sim,
            data_in_vc_credits_local => data_in_vc_credits_local_sim,
            
            data_out_local => data_out_local_sim,
            data_out_valid_local => data_out_valid_local_sim,
            data_out_vc_busy_local => data_out_vc_busy_local_sim,
            data_out_vc_credits_local => data_out_vc_credits_local_sim,
            
            data_in_north => data_in_north_sim,
            data_in_valid_north => data_in_valid_north_sim,
            data_in_vc_busy_north => data_in_vc_busy_north_sim,
            data_in_vc_credits_north => data_in_vc_credits_north_sim,
            
            data_out_north => data_out_north_sim,
            data_out_valid_north => data_out_valid_north_sim,
            data_out_vc_busy_north => data_out_vc_busy_north_sim,
            data_out_vc_credits_north => data_out_vc_credits_north_sim,
            
            data_in_east => data_in_east_sim,
            data_in_valid_east => data_in_valid_east_sim,
            data_in_vc_busy_east => data_in_vc_busy_east_sim,
            data_in_vc_credits_east => data_in_vc_credits_east_sim,
            
            data_out_east => data_out_east_sim,
            data_out_valid_east => data_out_valid_east_sim,
            data_out_vc_busy_east => data_out_vc_busy_east_sim,
            data_out_vc_credits_east => data_out_vc_credits_east_sim,
            
            data_in_south => data_in_south_sim,
            data_in_valid_south => data_in_valid_south_sim,
            data_in_vc_busy_south => data_in_vc_busy_south_sim,
            data_in_vc_credits_south => data_in_vc_credits_south_sim,
            
            data_out_south => data_out_south_sim,
            data_out_valid_south => data_out_valid_south_sim,
            data_out_vc_busy_south => data_out_vc_busy_south_sim,
            data_out_vc_credits_south => data_out_vc_credits_south_sim,
            
            data_in_west => data_in_west_sim,
            data_in_valid_west => data_in_valid_west_sim,
            data_in_vc_busy_west => data_in_vc_busy_west_sim,
            data_in_vc_credits_west => data_in_vc_credits_west_sim,
            
            data_out_west => data_out_west_sim,
            data_out_valid_west => data_out_valid_west_sim,
            data_out_vc_busy_west => data_out_vc_busy_west_sim,
            data_out_vc_credits_west => data_out_vc_credits_west_sim
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
    
        -- Inicijalne postavke ulaznih signala        
        data_out_vc_busy_local_sim <= (others => '0');
        data_out_vc_credits_local_sim <= (others => '0');
        data_in_local_sim <= (others => '0');
        data_in_valid_local_sim <= '0';
        
        data_out_vc_busy_north_sim <= (others => '0');
        data_out_vc_credits_north_sim <= (others => '0');
        data_in_north_sim <= (others => '0');
        data_in_valid_north_sim <= '0';
        
        data_out_vc_busy_east_sim <= (others => '0');
        data_out_vc_credits_east_sim <= (others => '0');
        data_in_east_sim <= (others => '0');
        data_in_valid_east_sim <= '0';
        
        data_out_vc_busy_south_sim <= (others => '0');
        data_out_vc_credits_south_sim <= (others => '0');
        data_in_south_sim <= (others => '0');
        data_in_valid_south_sim <= '0';
        
        data_out_vc_busy_west_sim <= (others => '0');
        data_out_vc_credits_west_sim <= (others => '0');
        data_in_west_sim <= (others => '0');
        data_in_valid_west_sim <= '0';
    
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (4.1 * clk_period);
        
        -- Local, head, vc0, dest: 0010-0010
        data_in_local_sim <= X"92211111111";
        data_in_valid_local_sim <= '1';
        -- North, head, vc1, dest: 0010-0010
        data_in_north_sim <= X"A2244444444";
        data_in_valid_north_sim <= '1';
        
        wait for clk_period;
        
        -- Smireni ulazni signal
        data_in_local_sim <= (others => '0');
        data_in_valid_local_sim <= '0';
        data_in_north_sim <= (others => '0');
        data_in_valid_north_sim <= '0';
        
        wait for (3 * clk_period);
        
        -- Local, body, vc0, dest: 0010-0010
        data_in_local_sim <= X"12222222222";
        data_in_valid_local_sim <= '1';
        -- North, tail, vc1, dest: 0010-0010
        data_in_north_sim <= X"62255555555";
        data_in_valid_north_sim <= '1';
        -- South, headtail, vc0, dest: 0010-0010
        data_in_south_sim <= X"D2266666666";
        data_in_valid_south_sim <= '1';
        
        wait for clk_period;
        
        -- Smireni ulazni signal
        data_in_local_sim <= (others => '0');
        data_in_valid_local_sim <= '0';
        data_in_north_sim <= (others => '0');
        data_in_valid_north_sim <= '0';
        data_in_south_sim <= (others => '0');
        data_in_valid_south_sim <= '0';
        
        wait for (3 * clk_period);
        
        -- Local, tail, vc0, dest: 0010-0010
        data_in_local_sim <= X"52233333333";
        data_in_valid_local_sim <= '1';
        
        wait for clk_period;
        
        -- Smireni ulazni signal
        data_in_local_sim <= (others => '0');
        data_in_valid_local_sim <= '0';
    
        wait;
    
    end process;

end Simulation;